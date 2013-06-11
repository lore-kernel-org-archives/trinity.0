From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open enable sysfs exported events
Date: Tue, 11 Jun 2013 00:33:23 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


perf_event exports a bunch of event info via /sys under
/sys/bus/event_source/devices

By parsing these files it's possible to generate more likely valid
(and almost-valid) events.  It also makes exercising expanded PMUs
(such as uncore events on recent Intel machines) possible.

The included somewhat ugly patch enables generating events based
on the sysfs files (1 time out of 9).  It sets up a table of all
possible event fields and generalized events for all detected event
types the first time such an event is requested, then uses this table
to generate events subsequent times.

The parser is possibly fragile.  The perf tool actually has a full
lexer to handle the parsing of these files.  I've tested on a core2
and sandybridge machine but it might possibly fail on more obscure
machines, especially if any have non-contiguous event fields.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 5250d1e..32c11cf 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -6,6 +6,9 @@
 
 #include <stdlib.h>
 #include <string.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <errno.h>
 #include "perf_event.h"
 #include "random.h"
 #include "sanitise.h"
@@ -13,6 +16,442 @@
 #include "maps.h"
 #include "shm.h"
 
+
+struct generic_event_type {
+	char *name;
+	char *value;
+	long long config;
+	long long config1;
+};
+
+struct format_type {
+	char *name;
+	char *value;
+	int field;
+	int bits;
+	unsigned long long  mask;
+	int shift;
+};
+
+struct pmu_type {
+	char *name;
+	int type;
+	int num_formats;
+	int num_generic_events;
+	struct format_type *formats;
+	struct generic_event_type *generic_events;
+};
+
+static int num_pmus=0;
+
+static struct pmu_type *pmus=NULL;
+
+
+#define FIELD_UNKNOWN	0
+#define FIELD_CONFIG	1
+#define FIELD_CONFIG1	2
+
+#define MAX_FIELDS	3
+
+
+static int parse_format(char *string, int *field_type, int *shift, int *bits) {
+
+	int i,firstnum,secondnum;
+	char format_string[BUFSIZ];
+
+	/* get format */
+	i=0;
+	while(1) {
+		format_string[i]=string[i];
+		if (string[i]==':') {
+			format_string[i]=0;
+			break;
+		}
+		if (string[i]==0) break;
+		i++;
+	}
+
+	if (!strcmp(format_string,"config")) {
+		*field_type=FIELD_CONFIG;
+	} else if (!strcmp(format_string,"config1")) {
+		*field_type=FIELD_CONFIG1;
+	} else {
+		*field_type=FIELD_UNKNOWN;
+	}
+
+	/* Read first number */
+	i++;
+	firstnum=0;
+	while(1) {
+		if (string[i]==0) break;
+		if (string[i]=='-') break;
+		if ((string[i]<'0') || (string[i]>'9')) {
+			fprintf(stderr,"Unknown format char %c\n",string[i]);
+			return -1;
+		}
+		firstnum*=10;
+		firstnum+=(string[i])-'0';
+		i++;
+	}
+	*shift=firstnum;
+
+	/* check if no second num */
+	if (string[i]==0) {
+		*bits=1;
+		return 0;
+	}
+
+	/* Read second number */
+	i++;
+	secondnum=0;
+	while(1) {
+		if (string[i]==0) break;
+		if (string[i]=='-') break;
+		if ((string[i]<'0') || (string[i]>'9')) {
+			fprintf(stderr,"Unknown format char %c\n",string[i]);
+			return -1;
+		}
+		secondnum*=10;
+		secondnum+=(string[i])-'0';
+		i++;
+	}
+
+	*bits=(secondnum-firstnum)+1;
+
+	return 0;
+}
+
+static int update_configs(int pmu, char *field,
+			long long value, long long *c, long long *c1) {
+
+	int i;
+
+	for(i=0;i<pmus[pmu].num_formats;i++) {
+		if (!strcmp(field,pmus[pmu].formats[i].name)) {
+			if (pmus[pmu].formats[i].field==FIELD_CONFIG) {
+				*c|=( (value&pmus[pmu].formats[i].mask)
+					<<pmus[pmu].formats[i].shift);
+				return 0;
+			}
+
+			if (pmus[pmu].formats[i].field==FIELD_CONFIG1) {
+				*c1|=( (value&pmus[pmu].formats[i].mask)
+					<<pmus[pmu].formats[i].shift);
+				return 0;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int parse_generic(int pmu,char *value, long long *config, long long *config1) {
+
+	long long c=0,c1=0,temp;
+	char field[BUFSIZ];
+	int i,ptr=0;
+
+	while(1) {
+		i=0;
+		while(1) {
+			field[i]=value[ptr];
+			if (value[ptr]==0) break;
+			if ((value[ptr]=='=') || (value[ptr]==',')) {
+				field[i]=0;
+				break;
+			}
+			i++;
+			ptr++;
+		}
+
+		/* if at end, was parameter w/o value */
+		if ((value[ptr]==',') || (value[ptr]==0)) {
+			temp=0x1;
+		}
+		else {
+			/* get number */
+
+			ptr++;
+
+			if (value[ptr]!='0') fprintf(stderr,"Expected 0x\n");
+			ptr++;
+			if (value[ptr]!='x') fprintf(stderr,"Expected 0x\n");
+			ptr++;
+			temp=0x0;
+			while(1) {
+
+				if (value[ptr]==0) break;
+				if (value[ptr]==',') break;
+				if (! ( ((value[ptr]>='0') && (value[ptr]<='9'))
+                   			|| ((value[ptr]>='a') && (value[ptr]<='f'))) ) {
+					fprintf(stderr,"Unexpected char %c\n",value[ptr]);
+				}
+				temp*=16;
+				if ((value[ptr]>='0') && (value[ptr]<='9')) {
+					temp+=value[ptr]-'0';
+				}
+				else {
+					temp+=(value[ptr]-'a')+10;
+				}
+				i++;
+				ptr++;
+			}
+		}
+		update_configs(pmu,field,temp,&c,&c1);
+		if (value[ptr]==0) break;
+		ptr++;
+	}
+	*config=c;
+	*config1=c1;
+	return 0;
+}
+
+
+static int init_pmus(void) {
+
+	DIR *dir,*event_dir,*format_dir;
+	struct dirent *entry,*event_entry,*format_entry;
+	char dir_name[BUFSIZ],event_name[BUFSIZ],event_value[BUFSIZ],
+		temp_name[BUFSIZ],format_name[BUFSIZ],format_value[BUFSIZ];
+	int type,pmu_num=0,format_num=0,generic_num=0;
+	FILE *fff;
+	int result;
+
+
+	/* Count number of PMUs */
+	/* This may break if PMUs are ever added/removed on the fly? */
+
+	dir=opendir("/sys/bus/event_source/devices");
+	if (dir==NULL) {
+		fprintf(stderr,"Unable to opendir "
+			"/sys/bus/event_source/devices : %s\n",
+			strerror(errno));
+		return -1;
+	}
+
+	while(1) {
+		entry=readdir(dir);
+		if (entry==NULL) break;
+		if (!strcmp(".",entry->d_name)) continue;
+		if (!strcmp("..",entry->d_name)) continue;
+		num_pmus++;
+	}
+
+	if (num_pmus<1) return -1;
+
+	pmus=calloc(num_pmus,sizeof(struct pmu_type));
+	if (pmus==NULL) {
+		return -1;
+	}
+
+	/****************/
+	/* Add each PMU */
+	/****************/
+
+	rewinddir(dir);
+
+	while(1) {
+		entry=readdir(dir);
+		if (entry==NULL) break;
+		if (!strcmp(".",entry->d_name)) continue;
+		if (!strcmp("..",entry->d_name)) continue;
+
+		/* read name */
+		pmus[pmu_num].name=strdup(entry->d_name);
+		sprintf(dir_name,"/sys/bus/event_source/devices/%s",
+			entry->d_name);
+
+		/* read type */
+		sprintf(temp_name,"%s/type",dir_name);
+		fff=fopen(temp_name,"r");
+		if (fff==NULL) {
+		}
+		else {
+			result=fscanf(fff,"%d",&type);
+			pmus[pmu_num].type=type;
+			fclose(fff);
+		}
+
+		/***********************/
+		/* Scan format strings */
+		/***********************/
+		sprintf(format_name,"%s/format",dir_name);
+		format_dir=opendir(format_name);
+		if (format_dir==NULL) {
+			/* Can be normal to have no format strings */
+		}
+		else {
+			/* Count format strings */
+			while(1) {
+				format_entry=readdir(format_dir);
+				if (format_entry==NULL) break;
+				if (!strcmp(".",format_entry->d_name)) continue;
+				if (!strcmp("..",format_entry->d_name)) continue;
+				pmus[pmu_num].num_formats++;
+			}
+
+			/* Allocate format structure */
+			pmus[pmu_num].formats=calloc(pmus[pmu_num].num_formats,
+							sizeof(struct format_type));
+			if (pmus[pmu_num].formats==NULL) {
+				pmus[pmu_num].num_formats=0;
+				return -1;
+			}
+
+			/* Read format string info */
+			rewinddir(format_dir);
+			format_num=0;
+			while(1) {
+				format_entry=readdir(format_dir);
+
+				if (format_entry==NULL) break;
+				if (!strcmp(".",format_entry->d_name)) continue;
+				if (!strcmp("..",format_entry->d_name)) continue;
+
+				pmus[pmu_num].formats[format_num].name=
+					strdup(format_entry->d_name);
+				sprintf(temp_name,"%s/format/%s",
+					dir_name,format_entry->d_name);
+				fff=fopen(temp_name,"r");
+				if (fff!=NULL) {
+					result=fscanf(fff,"%s",format_value);
+					pmus[pmu_num].formats[format_num].value=
+						strdup(format_value);
+					fclose(fff);
+				}
+				parse_format(format_value,
+						&pmus[pmu_num].formats[format_num].field,
+						&pmus[pmu_num].formats[format_num].shift,
+						&pmus[pmu_num].formats[format_num].bits);
+				if (pmus[pmu_num].formats[format_num].bits==64) {
+					pmus[pmu_num].formats[format_num].mask=0xffffffffffffffffULL;
+				} else {
+					pmus[pmu_num].formats[format_num].mask=
+						(1ULL<<pmus[pmu_num].formats[format_num].bits)-1;
+				}
+				format_num++;
+			}
+			closedir(format_dir);
+		}
+
+		/***********************/
+		/* Scan generic events */
+		/***********************/
+		sprintf(event_name,"%s/events",dir_name);
+		event_dir=opendir(event_name);
+		if (event_dir==NULL) {
+			/* It's sometimes normal to have no generic events */
+		}
+		else {
+
+			/* Count generic events */
+			while(1) {
+				event_entry=readdir(event_dir);
+				if (event_entry==NULL) break;
+				if (!strcmp(".",event_entry->d_name)) continue;
+				if (!strcmp("..",event_entry->d_name)) continue;
+				pmus[pmu_num].num_generic_events++;
+			}
+
+			/* Allocate generic events */
+			pmus[pmu_num].generic_events=calloc(
+				pmus[pmu_num].num_generic_events,
+				sizeof(struct generic_event_type));
+			if (pmus[pmu_num].generic_events==NULL) {
+				pmus[pmu_num].num_generic_events=0;
+				return -1;
+			}
+
+			/* Read in generic events */
+			rewinddir(event_dir);
+			generic_num=0;
+			while(1) {
+				event_entry=readdir(event_dir);
+				if (event_entry==NULL) break;
+				if (!strcmp(".",event_entry->d_name)) continue;
+				if (!strcmp("..",event_entry->d_name)) continue;
+
+				pmus[pmu_num].generic_events[generic_num].name=
+					strdup(event_entry->d_name);
+				sprintf(temp_name,"%s/events/%s",
+					dir_name,event_entry->d_name);
+				fff=fopen(temp_name,"r");
+				if (fff!=NULL) {
+					result=fscanf(fff,"%s",event_value);
+					pmus[pmu_num].generic_events[generic_num].value=
+						strdup(event_value);
+					fclose(fff);
+				}
+				parse_generic(pmu_num,event_value,
+						&pmus[pmu_num].generic_events[generic_num].config,
+						&pmus[pmu_num].generic_events[generic_num].config1);
+				generic_num++;
+			}
+			closedir(event_dir);
+		}
+		pmu_num++;
+	}
+
+	closedir(dir);
+
+	(void)result;
+
+	return 0;
+
+}
+
+
+static long long random_sysfs_config(__u32 *type, __u64 *config1) {
+
+	int i,j;
+	long long c=0,c1=0;
+
+	i=rand()%num_pmus;
+
+	*type=pmus[i].type;
+
+	switch(rand()%3) {
+		/* Random by Format */
+		case 0:
+			if (pmus[i].num_formats==0) goto out;
+			for(j=0;j<pmus[i].num_formats;j++) {
+				/* 50% chance of having field set */
+				if (rand_bool()) {
+					if (pmus[i].formats[j].field==FIELD_CONFIG) {
+						c|=(rand64()&pmus[i].formats[j].mask)<<
+							pmus[i].formats[j].shift;
+					} else {
+						c1|=(rand64()&pmus[i].formats[j].mask)<<
+							pmus[i].formats[j].shift;
+					}
+				}
+			}
+			break;
+
+
+		/* Random by generic event */
+		case 1:
+			if (pmus[i].num_generic_events==0) goto out;
+			j=rand()%pmus[i].num_generic_events;
+			c=pmus[i].generic_events[j].config;
+			c1=pmus[i].generic_events[j].config1;
+			break;
+
+		default:
+			goto out;
+			break;
+	}
+	*config1=c1;
+	return c;
+out:
+	*config1=rand()%64;
+	return rand()%64;
+}
+
+/* arbitrary high number unlikely to be used by perf_event */
+#define PERF_TYPE_READ_FROM_SYSFS 1027
+
+
 static long long random_cache_config(void)
 {
 
@@ -80,7 +519,7 @@ static int random_event_type(void)
 
 	int type;
 
-	switch (rand() % 6) {
+	switch (rand() % 8) {
 	case 0:
 		type = PERF_TYPE_HARDWARE;
 		break;
@@ -99,6 +538,9 @@ static int random_event_type(void)
 	case 5:
 		type = PERF_TYPE_BREAKPOINT;
 		break;
+	case 6:
+		type = PERF_TYPE_READ_FROM_SYSFS;
+		break;
 	default:
 		type = rand();
 		break;
@@ -106,11 +548,11 @@ static int random_event_type(void)
 	return type;
 }
 
-static long long random_event_config(long long event_type)
+static long long random_event_config(__u32 *event_type, __u64 *config1)
 {
 	unsigned long long config;
 
-	switch (event_type) {
+	switch (*event_type) {
 	case PERF_TYPE_HARDWARE:
 		switch (rand() % 11) {
 		case 0:
@@ -205,8 +647,10 @@ static long long random_event_config(long long event_type)
 			config = 0;
 		break;
 
-/* FIXME: value can also be one of the ones found in */
-/* /sys/bus/event_source/devices                     */
+	case PERF_TYPE_READ_FROM_SYSFS:
+		if (pmus==NULL) init_pmus();
+		config = random_sysfs_config(event_type,config1);
+		break;
 
 	default:
 		config = rand64();
@@ -329,10 +773,10 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr)
 	attr->type = random_event_type();
 
 	attr->size = sizeof(struct perf_event_attr);
-	/* FIXME: can typically be 64,72,80,96 depending on kernel */
+	/* FIXME: can typically be 64,72,80,or 96 depending on kernel */
 	/* Other values will likely not create a valid event       */
 
-	attr->config = random_event_config(attr->type);
+	attr->config = random_event_config(&attr->type,&attr->config1);
 	if (attr->type == PERF_TYPE_BREAKPOINT) {
 		setup_breakpoints(attr);
 	}
@@ -379,7 +823,7 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr)
 
 	attr->type = random_event_type();
 	attr->size = sizeof(struct perf_event_attr);
-	attr->config = random_event_config(attr->type);
+	attr->config = random_event_config(&attr->type,&attr->config1);
 	if (attr->type == PERF_TYPE_BREAKPOINT) {
 		setup_breakpoints(attr);
 	}
@@ -427,7 +871,7 @@ static void create_random_event(struct perf_event_attr *attr)
 {
 
 	attr->type = random_event_type();
-	attr->config = random_event_config(attr->type);
+	attr->config = random_event_config(&attr->type,&attr->config1);
 	setup_breakpoints(attr);
 
 	switch (rand_bool()) {
