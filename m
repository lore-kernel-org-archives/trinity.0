From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Added parameter that controls which taint flag causes trinity
 to stop.
Date: Mon, 23 Sep 2013 19:41:14 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309231938120.18899@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=gcHlpZn0WsM+xGlJEFwo/XgpA+aPXmkIfAWXIV1mpvI=;
        b=J5CNVJxAoUrwJJzXFQdNYlkTU1lY94Y+9mwPg8Ab7RiTiTUX9YQilhPNnxTkAdUhAr
         vApHa3Y7fqo9kY028uifc0KIqzZqJNz0hk/gzi+VJ1Vrlb+69tKBFewLCtAOOohwapGi
         60eZdB3z6vZuluW63UYA0WdAfLJgIGhw11SJxxnlE8IuL3GDR7HPq12idOxWuQgqV0pZ
         VOciGIlD1WsoKPt9nok8myF8MaQneyRRFD5/Ta6kqa6QzoLQuip3ctabX5zMPA4HG7+Q
         ja9Yw6IK3wkMa/TVULnLqQWBA/gAWeqy11azBGsfWW6pzn3wPfjnd9hwNrOOKbgyYn3l
         D2lw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


Hello Everyone,

This is reworked patch for the parameter that allows to control which 
kernel taint flags causes trinity to stop. In particular, now the short 
parameter is -T (instead of -t) and flags has to be specified as literals 
(e.g., DIE, WARN, USER, etc.). All 13 supported flags are specified in 
README.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

From c27f6ed0693a9d874b0adaf2f268a65ccd9ac80b Mon Sep 17 00:00:00 2001
From: Ildar Muslukhov <ildarm@google.com>
Date: Mon, 23 Sep 2013 19:34:14 -0700
Subject: [PATCH] Added parameter to mask kernel taint flags

---
 README            |  6 ++++
 include/params.h  | 18 ++++++++++++
 include/trinity.h |  1 -
 main.c            | 10 +++----
 params.c          | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 trinity.c         | 10 +++++--
 watchdog.c        | 10 +++----
 7 files changed, 124 insertions(+), 15 deletions(-)

diff --git a/README b/README
index 05a1ec3..4a29f80 100644
--- a/README
+++ b/README
@@ -72,6 +72,12 @@ tmp directory. (Handy for cleaning up any garbage named files; just rm -rf tmp a
   Note: There are currently a few bugs that mean no two runs are necessary 100%
   identical with the same seed. See the TODO for details.
 
+ --kernel_taint/-T: controls which kernel taint flags should be considered.
+	The following flag names are supported: PROPRIETARY_MODULE, FORCED_MODULE, UNSAFE_SMP,
+	FORCED_RMMOD, MACHINE_CHECK, BAD_PAGE, USER, DIE, OVERRIDDEN_ACPI_TABLE, WARN, CRAP,
+	FIRMWARE_WORKAROUND, and OOT_MODULE. For instance, to set trinity to monitor only BAD,
+	WARN and MACHINE_CHECK flags one should specify "-T BAD,WARN,MACHINE_CHECK" parameter.
+
  --list/-L: list known syscalls and their offsets
 
  --monochrome/-m: Don't output ANSI control codes
diff --git a/include/params.h b/include/params.h
index 53776bd..159ea60 100644
--- a/include/params.h
+++ b/include/params.h
@@ -3,6 +3,20 @@
 
 #include "types.h"
 
+#define TAINT_PROPRIETARY_MODULE        0
+#define TAINT_FORCED_MODULE             1
+#define TAINT_UNSAFE_SMP                2
+#define TAINT_FORCED_RMMOD              3
+#define TAINT_MACHINE_CHECK             4
+#define TAINT_BAD_PAGE                  5
+#define TAINT_USER                      6
+#define TAINT_DIE                       7
+#define TAINT_OVERRIDDEN_ACPI_TABLE     8
+#define TAINT_WARN                      9
+#define TAINT_CRAP                      10
+#define TAINT_FIRMWARE_WORKAROUND       11
+#define TAINT_OOT_MODULE                12
+
 /* command line args. */
 void parse_args(int argc, char *argv[]);
 
@@ -32,4 +46,8 @@ extern bool no_files;
 extern bool random_selection;
 extern unsigned int random_selection_num;
 
+extern int kernel_taint_initial;
+extern int kernel_taint_mask;
+extern bool kernel_taint_param_occured;
+
 #endif	/* _PARAMS_H */
diff --git a/include/trinity.h b/include/trinity.h
index 9367539..6118de7 100644
--- a/include/trinity.h
+++ b/include/trinity.h
@@ -18,7 +18,6 @@ void do_main_loop(void);
 
 extern bool biarch;
 
-extern bool ignore_tainted;
 int check_tainted(void);
 
 void init_watchdog(void);
diff --git a/main.c b/main.c
index fefc4bf..99ae03c 100644
--- a/main.c
+++ b/main.c
@@ -48,18 +48,18 @@ static void regenerate(void)
 	shm->regenerating = FALSE;
 }
 
-bool ignore_tainted;
-
 int check_tainted(void)
 {
 	int fd;
-	int ret;
-	char buffer[4];
+	unsigned int ret;
+	char buffer[11];
+
+	buffer[10] = 0; //make sure that we can fit the whole int.
 
 	fd = open("/proc/sys/kernel/tainted", O_RDONLY);
 	if (fd < 0)
 		return -1;
-	ret = read(fd, buffer, 3);
+	ret = read(fd, buffer, 10);
 	close(fd);
 
 	if (ret > 0)
diff --git a/params.c b/params.c
index e234cf8..f975eea 100644
--- a/params.c
+++ b/params.c
@@ -12,6 +12,8 @@
 #include "log.h"
 #include "params.h"
 
+#define TAINT_NAME_LEN 32
+
 bool debug = FALSE;
 
 bool do_specific_syscall = FALSE;
@@ -46,12 +48,17 @@ char *specific_proto_optarg;
 
 char *victim_path;
 
+int kernel_taint_initial = 0;
+int kernel_taint_mask = 0xFFFFFFFF;
+bool kernel_taint_param_occured = FALSE;
+
 static void usage(void)
 {
 	fprintf(stderr, "%s\n", progname);
 	fprintf(stderr, " --children,-C: specify number of child processes\n");
 	fprintf(stderr, " --exclude,-x: don't call a specific syscall\n");
 	fprintf(stderr, " --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
+	fprintf(stderr, " --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. \n");
 	fprintf(stderr, " --list,-L: list all syscalls known on this architecture.\n");
 	fprintf(stderr, " --ioctls,-I: list all ioctls.\n");
 	fprintf(stderr, " --logging,-l: (off=disable logging).\n");
@@ -78,6 +85,7 @@ static const struct option longopts[] = {
 	{ "debug", no_argument, NULL, 'D' },
 	{ "exclude", required_argument, NULL, 'x' },
 	{ "group", required_argument, NULL, 'g' },
+	{ "kernel_taint", required_argument, NULL, 'T' },
 	{ "help", no_argument, NULL, 'h' },
 	{ "list", no_argument, NULL, 'L' },
 	{ "ioctls", no_argument, NULL, 'I' },
@@ -93,12 +101,81 @@ static const struct option longopts[] = {
 	{ "arch", required_argument, NULL, 'a' },
 	{ NULL, 0, NULL, 0 } };
 
+static void toggle_taint_flag(int bit) {
+	kernel_taint_mask |= (1 << bit);
+}
+
+static void toggle_taint_flag_by_name(char *beg, char *end) {
+	char flagname[TAINT_NAME_LEN];
+	char *name;
+	int maxlen;
+
+	if (end == NULL) {
+		name = beg;
+	} else {
+		name = flagname;
+		maxlen = end - beg;
+		if (maxlen > (TAINT_NAME_LEN - 1))
+			maxlen = TAINT_NAME_LEN - 1;
+		strncpy(flagname, beg, maxlen);
+		flagname[maxlen] = 0;
+	}
+
+	if (strcmp(name,"PROPRIETARY_MODULE") == 0)
+		toggle_taint_flag(TAINT_PROPRIETARY_MODULE);
+	else if (strcmp(name,"FORCED_MODULE") == 0)
+                toggle_taint_flag(TAINT_FORCED_MODULE);
+	else if (strcmp(name,"UNSAFE_SMP") == 0)
+                toggle_taint_flag(TAINT_UNSAFE_SMP);
+	else if (strcmp(name,"FORCED_RMMOD") == 0)
+                toggle_taint_flag(TAINT_FORCED_RMMOD);
+	else if (strcmp(name,"MACHINE_CHECK") == 0)
+                toggle_taint_flag(TAINT_MACHINE_CHECK);
+	else if (strcmp(name,"BAD_PAGE") == 0)
+                toggle_taint_flag(TAINT_BAD_PAGE);
+	else if (strcmp(name,"USER") == 0)
+                toggle_taint_flag(TAINT_USER);
+	else if (strcmp(name,"DIE") == 0)
+                toggle_taint_flag(TAINT_DIE);
+	else if (strcmp(name,"OVERRIDDEN_ACPI_TABLE") == 0)
+                toggle_taint_flag(TAINT_OVERRIDDEN_ACPI_TABLE);
+	else if (strcmp(name,"WARN") == 0)
+                toggle_taint_flag(TAINT_WARN);
+	else if (strcmp(name,"CRAP") == 0)
+                toggle_taint_flag(TAINT_CRAP);
+	else if (strcmp(name,"FIRMWARE_WORKAROUND") == 0)
+                toggle_taint_flag(TAINT_FIRMWARE_WORKAROUND);
+	else if (strcmp(name,"OOT_MODULE") == 0)
+                toggle_taint_flag(TAINT_OOT_MODULE);
+	else {
+		printf("Unrecognizable kernel taint flag \"%s\".\n", name);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void process_taint_arg(char *taintarg) {
+	char *beg, *end;
+
+	if (kernel_taint_param_occured == FALSE) {
+		kernel_taint_param_occured = TRUE;
+		kernel_taint_mask = 0; //We now only care about flags that user specified.
+	}
+
+	beg = taintarg;
+	end = strchr(beg, ',');
+	while(end != NULL) {
+		toggle_taint_flag_by_name(beg,end);
+		beg = end + 1;
+		end = strchr(beg, ',');
+	}
+	toggle_taint_flag_by_name(beg,end);
+}
 
 void parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:pqr:s:SV:vx:", longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:pqr:s:T:SV:vx:", longopts, NULL)) != -1) {
 		switch (opt) {
 		default:
 			if (opt == '?')
@@ -214,6 +291,11 @@ void parse_args(int argc, char *argv[])
 			do_syslog = TRUE;
 			break;
 
+		case 'T':
+			//Load mask for kernel taint flags.
+			process_taint_arg(optarg);
+			break;
+
 		case 'v':
 			verbose = TRUE;
 			break;
diff --git a/trinity.c b/trinity.c
index f09b36a..a72484e 100644
--- a/trinity.c
+++ b/trinity.c
@@ -196,6 +196,10 @@ int main(int argc, char* argv[])
 	parse_args(argc, argv);
 	printf("Done parsing arguments.\n");
 
+	if (kernel_taint_mask != (int)0xFFFFFFFF) {
+		printf("Custom kernel taint mask has been specified: 0x%08x (%d).\n", kernel_taint_mask, kernel_taint_mask);
+	}
+
 	setup_shm_postargs();
 
 	if (logging == TRUE)
@@ -246,9 +250,9 @@ int main(int argc, char* argv[])
 
 	setup_main_signals();
 
-	if (check_tainted() != 0) {
-		output(0, "Kernel was tainted on startup. Will keep running if trinity causes an oops.\n");
-		ignore_tainted = TRUE;
+	kernel_taint_initial = check_tainted();
+	if (kernel_taint_initial != 0) {
+		output(0, "Kernel was tainted on startup. Will ignore flags that are already set.\n");
 	}
 
 	change_tmp_dir();
diff --git a/watchdog.c b/watchdog.c
index 5c813db..c90d5a5 100644
--- a/watchdog.c
+++ b/watchdog.c
@@ -11,7 +11,7 @@
 #include <sys/wait.h>
 #include <sys/ptrace.h>
 
-#include "trinity.h"	// ignore_tainted
+#include "trinity.h" //check_taint and biarch
 #include "shm.h"
 #include "files.h"
 #include "syscall.h"
@@ -302,11 +302,11 @@ static void watchdog(void)
 			}
 		}
 
-		/* Only check taint if it was zero on startup */
-		if (ignore_tainted == FALSE) {
+		/* Only check taint if it mask allows it */
+		if (kernel_taint_mask != 0) {
 			ret = check_tainted();
-			if (ret != 0) {
-				output(0, "[watchdog] kernel became tainted! (%d) Last seed was %u\n", ret, shm->seed);
+			if (((ret & kernel_taint_mask) & (~kernel_taint_initial)) != 0) {
+				output(0, "[watchdog] kernel became tainted! (%d/%d) Last seed was %u\n", ret, kernel_taint_initial, shm->seed);
 				shm->exit_reason = EXIT_KERNEL_TAINTED;
 			}
 		}
-- 
1.8.4
