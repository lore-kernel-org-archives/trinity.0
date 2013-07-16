From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] improved perf_event_open() sysfs parser
Date: Tue, 16 Jul 2013 00:27:48 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307160023130.7733@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org


The following updates the perf_event_open() sysfs parser to fully
implement the ABI as described in the kernel ABI documentation.

This includes non-contiguous format field values, as well as support
for the config2 attribute.

This should fix the warning about commas in the format field.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 5127231..0415d25 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -23,15 +23,14 @@ struct generic_event_type {
 	char *value;
 	long long config;
 	long long config1;
+	long long config2;
 };
 
 struct format_type {
 	char *name;
 	char *value;
 	int field;
-	int bits;
-	unsigned long long  mask;
-	int shift;
+	unsigned long long mask;
 };
 
 struct pmu_type {
@@ -51,16 +50,21 @@ static struct pmu_type *pmus=NULL;
 #define FIELD_UNKNOWN	0
 #define FIELD_CONFIG	1
 #define FIELD_CONFIG1	2
+#define FIELD_CONFIG2	3
+#define MAX_FIELDS	4
 
-#define MAX_FIELDS	3
 
+static int parse_format(char *string, int *field_type, unsigned long long *mask) {
 
-static int parse_format(char *string, int *field_type, int *shift, int *bits) {
-
-	int i,firstnum,secondnum;
+	int i,firstnum,secondnum,shift,bits;
 	char format_string[BUFSIZ];
 
+	*mask=0;
+
 	/* get format */
+	/* according to Documentation/ABI/testing/sysfs-bus-event_source-devices-format */
+	/* the format is something like config1:1,6-10,44 */
+
 	i=0;
 	while(1) {
 		format_string[i]=string[i];
@@ -76,79 +80,121 @@ static int parse_format(char *string, int *field_type, int *shift, int *bits) {
 		*field_type=FIELD_CONFIG;
 	} else if (!strcmp(format_string,"config1")) {
 		*field_type=FIELD_CONFIG1;
-	} else {
+	} else if (!strcmp(format_string,"config2")) {
+		*field_type=FIELD_CONFIG2;
+	}
+	else {
 		*field_type=FIELD_UNKNOWN;
 	}
 
-	/* Read first number */
-	i++;
-	firstnum=0;
 	while(1) {
-		if (string[i]==0) break;
-		if (string[i]=='-') break;
-		if ((string[i]<'0') || (string[i]>'9')) {
-			fprintf(stderr,"Unknown format char %c\n",string[i]);
-			return -1;
-		}
-		firstnum*=10;
-		firstnum+=(string[i])-'0';
+
+		/* Read first number */
 		i++;
-	}
-	*shift=firstnum;
+		firstnum=0;
+		while(1) {
+			if (string[i]==0) break;
+			if (string[i]=='-') break;
+			if (string[i]==',') break;
+			if ((string[i]<'0') || (string[i]>'9')) {
+				fprintf(stderr,"Unknown format char %c\n",string[i]);
+				return -1;
+			}
+			firstnum*=10;
+			firstnum+=(string[i])-'0';
+			i++;
+		}
+		shift=firstnum;
 
-	/* check if no second num */
-	if (string[i]==0) {
-		*bits=1;
-		return 0;
-	}
+		/* check if no second num */
+		if ((string[i]==0) || (string[i]==',')) {
+			bits=1;
+		}
+		else {
+			/* Read second number */
+			i++;
+			secondnum=0;
+			while(1) {
+				if (string[i]==0) break;
+				if (string[i]=='-') break;
+				if (string[i]==',') break;
+				if ((string[i]<'0') || (string[i]>'9')) {
+					fprintf(stderr,"Unknown format char %c\n",string[i]);
+					return -1;
+				}
+				secondnum*=10;
+				secondnum+=(string[i])-'0';
+				i++;
+			}
+			bits=(secondnum-firstnum)+1;
+		}
 
-	/* Read second number */
-	i++;
-	secondnum=0;
-	while(1) {
-		if (string[i]==0) break;
-		if (string[i]=='-') break;
-		if ((string[i]<'0') || (string[i]>'9')) {
-			fprintf(stderr,"Unknown format char %c\n",string[i]);
-			return -1;
+		if (bits==64) {
+			*mask|=0xffffffffffffffffULL;
+		} else {
+			*mask|=((1ULL<<bits)-1)<<shift;
 		}
-		secondnum*=10;
-		secondnum+=(string[i])-'0';
-		i++;
-	}
 
-	*bits=(secondnum-firstnum)+1;
+		if (string[i]==0) break;
 
+	}
 	return 0;
 }
 
+static unsigned long long separate_bits(unsigned long long value,
+					unsigned long long mask) {
+
+	int value_bit=0,i;
+	unsigned long long result=0;
+
+	for(i=0;i<64;i++) {
+		if ((1ULL<<i)&mask) {
+			result|=((value>>value_bit)&1)<<i;
+			value_bit++;
+		}
+	}
+
+	return result;
+}
+
 static int update_configs(int pmu, char *field,
-			long long value, long long *c, long long *c1) {
+			long long value,
+			long long *c,
+			long long *c1,
+			long long *c2) {
 
 	int i;
 
 	for(i=0;i<pmus[pmu].num_formats;i++) {
 		if (!strcmp(field,pmus[pmu].formats[i].name)) {
 			if (pmus[pmu].formats[i].field==FIELD_CONFIG) {
-				*c|=( (value&pmus[pmu].formats[i].mask)
-					<<pmus[pmu].formats[i].shift);
+				*c|=separate_bits(value,
+						pmus[pmu].formats[i].mask);
 				return 0;
 			}
 
 			if (pmus[pmu].formats[i].field==FIELD_CONFIG1) {
-				*c1|=( (value&pmus[pmu].formats[i].mask)
-					<<pmus[pmu].formats[i].shift);
+				*c1|=separate_bits(value,
+						pmus[pmu].formats[i].mask);
 				return 0;
 			}
+
+			if (pmus[pmu].formats[i].field==FIELD_CONFIG2) {
+				*c2|=separate_bits(value,
+						pmus[pmu].formats[i].mask);
+				return 0;
+			}
+
 		}
 	}
 
 	return 0;
 }
 
-static int parse_generic(int pmu,char *value, long long *config, long long *config1) {
+static int parse_generic(int pmu, char *value,
+			long long *config, long long *config1, long long *config2) {
 
-	long long c=0,c1=0,temp;
+	long long c=0,c1=0,c2=0,temp;
 	char field[BUFSIZ];
 	int i,ptr=0;
 	int base=10;
@@ -205,12 +251,13 @@ static int parse_generic(int pmu,char *value, long long *config, long long *conf
 				ptr++;
 			}
 		}
-		update_configs(pmu,field,temp,&c,&c1);
+		update_configs(pmu,field,temp,&c,&c1,&c2);
 		if (value[ptr]==0) break;
 		ptr++;
 	}
 	*config=c;
 	*config1=c1;
+	*config2=c2;
 	return 0;
 }
 
@@ -277,7 +324,7 @@ static int init_pmus(void) {
 		}
 		else {
 			result=fscanf(fff,"%d",&type);
-			pmus[pmu_num].type=type;
+			if (result==1) pmus[pmu_num].type=type;
 			fclose(fff);
 		}
 
@@ -326,20 +373,15 @@ static int init_pmus(void) {
 				fff=fopen(temp_name,"r");
 				if (fff!=NULL) {
 					result=fscanf(fff,"%s",format_value);
-					pmus[pmu_num].formats[format_num].value=
+					if (result==1) { 
+						pmus[pmu_num].formats[format_num].value=
 						strdup(format_value);
+					}
 					fclose(fff);
 
 					parse_format(format_value,
 						&pmus[pmu_num].formats[format_num].field,
-						&pmus[pmu_num].formats[format_num].shift,
-						&pmus[pmu_num].formats[format_num].bits);
-					if (pmus[pmu_num].formats[format_num].bits==64) {
-						pmus[pmu_num].formats[format_num].mask=0xffffffffffffffffULL;
-					} else {
-						pmus[pmu_num].formats[format_num].mask=
-							(1ULL<<pmus[pmu_num].formats[format_num].bits)-1;
-					}
+						&pmus[pmu_num].formats[format_num].mask);
 					format_num++;
 				}
 			}
@@ -392,13 +434,16 @@ static int init_pmus(void) {
 				fff=fopen(temp_name,"r");
 				if (fff!=NULL) {
 					result=fscanf(fff,"%s",event_value);
-					pmus[pmu_num].generic_events[generic_num].value=
-						strdup(event_value);
+					if (result==1) {
+						pmus[pmu_num].generic_events[generic_num].value=
+							strdup(event_value);
+					}
 					fclose(fff);
 				}
 				parse_generic(pmu_num,event_value,
 						&pmus[pmu_num].generic_events[generic_num].config,
-						&pmus[pmu_num].generic_events[generic_num].config1);
+						&pmus[pmu_num].generic_events[generic_num].config1,
+						&pmus[pmu_num].generic_events[generic_num].config2);
 				generic_num++;
 			}
 			closedir(event_dir);
@@ -415,10 +460,12 @@ out:
 }
 
 
-static long long random_sysfs_config(__u32 *type, __u64 *config1) {
+static long long random_sysfs_config(__u32 *type,
+				__u64 *config1,
+				__u64 *config2) {
 
 	int i,j;
-	long long c=0,c1=0;
+	long long c=0,c1=0,c2=0;
 
 	if (num_pmus==0) {
 		/* For some reason we didn't get initialized */
@@ -438,13 +485,13 @@ static long long random_sysfs_config(__u32 *type, __u64 *config1) {
 			if (pmus[i].num_formats==0) goto out;
 			for(j=0;j<pmus[i].num_formats;j++) {
 				/* 50% chance of having field set */
-				if (rand_bool()) {
+				if (rand()%2) {
 					if (pmus[i].formats[j].field==FIELD_CONFIG) {
-						c|=(rand64()&pmus[i].formats[j].mask)<<
-							pmus[i].formats[j].shift;
+						c|=(rand64()&pmus[i].formats[j].mask);
+					} else if (pmus[i].formats[j].field==FIELD_CONFIG1) {
+						c1|=(rand64()&pmus[i].formats[j].mask);
 					} else {
-						c1|=(rand64()&pmus[i].formats[j].mask)<<
-							pmus[i].formats[j].shift;
+						c2|=(rand64()&pmus[i].formats[j].mask);
 					}
 				}
 			}
@@ -457,6 +504,11 @@ static long long random_sysfs_config(__u32 *type, __u64 *config1) {
 			j=rand()%pmus[i].num_generic_events;
 			c=pmus[i].generic_events[j].config;
 			c1=pmus[i].generic_events[j].config1;
+			c2=pmus[i].generic_events[j].config2;
+			break;
+
+		case 2:
+			goto out;
 			break;
 
 		default:
@@ -464,6 +516,7 @@ static long long random_sysfs_config(__u32 *type, __u64 *config1) {
 			break;
 	}
 	*config1=c1;
+	*config2=c2;
 	return c;
 out:
 	*config1=rand()%64;
@@ -581,7 +634,9 @@ static int random_event_type(void)
 	return type;
 }
 
-static long long random_event_config(__u32 *event_type, __u64 *config1)
+static long long random_event_config(__u32 *event_type,
+					__u64 *config1,
+					__u64 *config2)
 {
 	unsigned long long config=0;
 
@@ -686,12 +741,13 @@ static long long random_event_config(__u32 *event_type, __u64 *config1)
 		break;
 
 	case PERF_TYPE_READ_FROM_SYSFS:
-		config = random_sysfs_config(event_type,config1);
+		config = random_sysfs_config(event_type,config1,config2);
 		break;
 
 	default:
 		config = rand64();
 		*config1 = rand64();
+		*config2 = rand64();
 		break;
 	}
 	return config;
@@ -843,7 +899,9 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 
 	attr->type = random_event_type();
 	attr->size = random_attr_size();
-	attr->config = random_event_config(&attr->type,&attr->config1);
+	attr->config = random_event_config(&attr->type,
+					&attr->config1,
+					&attr->config2);
 
 	/* no freq for counting event */
 	/* no sample type for counting event */
@@ -894,7 +952,9 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 
 	attr->type = random_event_type();
 	attr->size = random_attr_size();
-	attr->config = random_event_config(&attr->type,&attr->config1);
+	attr->config = random_event_config(&attr->type,
+					&attr->config1,
+					&attr->config2);
 
 	/* low values more likely to have "interesting" results */
 	attr->sample_period = rand64();
@@ -950,7 +1010,9 @@ static void create_random_event(struct perf_event_attr *attr)
 
 	attr->size = random_attr_size();
 
-	attr->config = random_event_config(&attr->type,&attr->config1);
+	attr->config = random_event_config(&attr->type,
+					&attr->config1,
+					&attr->config2);
 
 	attr->sample_period = rand64();
 	attr->sample_type = random_sample_type();
