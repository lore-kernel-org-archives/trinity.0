From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Expected 0x
Date: Wed, 3 Jul 2013 17:07:38 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307031701440.14644@vincent-weaver-1.um.maine.edu>
References: <20130703182141.GA13149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130703182141.GA13149@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org


The following patch should properly handle decimal values in
   /sys/bus/event_source/devices/cpu/events/
files.

Feel free to run lindent on the whole perf_event_open.c sometime.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index ef8cb4f..5c8decd 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -16,6 +16,7 @@
 #include "maps.h"
 #include "shm.h"
 
+#define SYSFS "/sys/bus/event_source/devices/"
 
 struct generic_event_type {
 	char *name;
@@ -150,6 +151,7 @@ static int parse_generic(int pmu,char *value, long long *config, long long *conf
 	long long c=0,c1=0,temp;
 	char field[BUFSIZ];
 	int i,ptr=0;
+	int base=10;
 
 	while(1) {
 		i=0;
@@ -165,18 +167,24 @@ static int parse_generic(int pmu,char *value, long long *config, long long *conf
 		}
 
 		/* if at end, was parameter w/o value */
+		/* So it is a flag with a value of 1  */
 		if ((value[ptr]==',') || (value[ptr]==0)) {
 			temp=0x1;
 		}
 		else {
 			/* get number */
 
-			ptr++;
+			base=10;
 
-			if (value[ptr]!='0') fprintf(stderr,"Expected 0x\n");
-			ptr++;
-			if (value[ptr]!='x') fprintf(stderr,"Expected 0x\n");
 			ptr++;
+
+			if (value[ptr]=='0') {
+				if (value[ptr+1]=='x') {
+					ptr++;
+					ptr++;
+					base=16;
+				}
+			}
 			temp=0x0;
 			while(1) {
 
@@ -186,7 +194,7 @@ static int parse_generic(int pmu,char *value, long long *config, long long *conf
                    			|| ((value[ptr]>='a') && (value[ptr]<='f'))) ) {
 					fprintf(stderr,"Unexpected char %c\n",value[ptr]);
 				}
-				temp*=16;
+				temp*=base;
 				if ((value[ptr]>='0') && (value[ptr]<='9')) {
 					temp+=value[ptr]-'0';
 				}
@@ -221,7 +229,7 @@ static int init_pmus(void) {
 	/* Count number of PMUs */
 	/* This may break if PMUs are ever added/removed on the fly? */
 
-	dir=opendir("/sys/bus/event_source/devices");
+	dir=opendir(SYSFS);
 	if (dir==NULL) {
 		return -1;
 	}
@@ -255,7 +263,7 @@ static int init_pmus(void) {
 
 		/* read name */
 		pmus[pmu_num].name=strdup(entry->d_name);
-		sprintf(dir_name,"/sys/bus/event_source/devices/%s",
+		sprintf(dir_name,SYSFS"/%s",
 			entry->d_name);
 
 		/* read type */
