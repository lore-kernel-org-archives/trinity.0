From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Enabling masking of unimportant kernel taint falgs.
Date: Tue, 17 Sep 2013 17:11:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309171706510.10505@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=Oywnv1oIOG4+SOSkR0a1i9Y0Kqj4U4oq8JlMdCjKUFg=;
        b=GmXmSlSSmu5E17A2vrsFZBmjGBJXy1ccVDcja729+QIJrH7FiJ3nxppVr+qwJbXEKV
         EYS1SEsJdhPMhEtEN2RRPbYnDp/SMMHJatsHxhoj48AOTnCQIdcNbfKvltm9cZk7dxdV
         Z9cFTD68yV/Y6t2RQBlDHqduVHKWfpt5zv3sbN5o3MvZ8TV9UZN9f5PoZxtn/b+wcyMt
         2P4Qv2kuTATEccELo7kSBP+tl+fcRxYYx0DN/loZsjqacUVaqS69Yx8Ca4H8zrDXN71j
         9W3/Ja9QaBgdwamiQUm5g6JUhRUNl+DCtPCij0wYHTFOTX5inQen16JnJMbgeRXH7my7
         O8fw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch introduces a new parameter to mask unimportant kernel taint 
flags.
Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 README            |  4 +++-
 include/params.h  |  3 +++
 include/trinity.h |  1 -
 main.c            | 10 +++++-----
 params.c          | 12 +++++++++++-
 trinity.c         | 10 +++++++---
 watchdog.c        | 10 +++++-----
 7 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/README b/README
index 05a1ec3..34b3e1d 100644
--- a/README
+++ b/README
@@ -72,12 +72,14 @@ tmp directory. (Handy for cleaning up any garbage named files; just rm -rf tmp a
   Note: There are currently a few bugs that mean no two runs are necessary 100%
   identical with the same seed. See the TODO for details.
 
+ --kernel_taint/-t: controls which kernel taint flags should be considered (provide value as an int in dec format, will be used as a mask) 
+
  --list/-L: list known syscalls and their offsets
 
  --monochrome/-m: Don't output ANSI control codes
 
  --proto/-P: For network sockets, only use a specific packet family.
-
+		
  --victims/-V: Victim file/dirs.  By default, on startup trinity tree-walks /dev, /sys and /proc.
      Using this option you can specify a different path.
      (Currently limited to just one path)
diff --git a/include/params.h b/include/params.h
index 53776bd..ceec651 100644
--- a/include/params.h
+++ b/include/params.h
@@ -32,4 +32,7 @@ extern bool no_files;
 extern bool random_selection;
 extern unsigned int random_selection_num;
 
+extern int kernel_taint_initial;
+extern int kernel_taint_mask;
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
index e234cf8..63901dd 100644
--- a/params.c
+++ b/params.c
@@ -46,12 +46,16 @@ char *specific_proto_optarg;
 
 char *victim_path;
 
+int kernel_taint_initial = 0;
+int kernel_taint_mask = 0xFFFFFFFF;
+
 static void usage(void)
 {
 	fprintf(stderr, "%s\n", progname);
 	fprintf(stderr, " --children,-C: specify number of child processes\n");
 	fprintf(stderr, " --exclude,-x: don't call a specific syscall\n");
 	fprintf(stderr, " --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
+	fprintf(stderr, " --kernel_taint, -t: controls which kernel taint flags should be considered (provide as int, will be used in &)\n");
 	fprintf(stderr, " --list,-L: list all syscalls known on this architecture.\n");
 	fprintf(stderr, " --ioctls,-I: list all ioctls.\n");
 	fprintf(stderr, " --logging,-l: (off=disable logging).\n");
@@ -78,6 +82,7 @@ static const struct option longopts[] = {
 	{ "debug", no_argument, NULL, 'D' },
 	{ "exclude", required_argument, NULL, 'x' },
 	{ "group", required_argument, NULL, 'g' },
+	{ "kernel_taint", required_argument, NULL, 't' },
 	{ "help", no_argument, NULL, 'h' },
 	{ "list", no_argument, NULL, 'L' },
 	{ "ioctls", no_argument, NULL, 'I' },
@@ -98,7 +103,7 @@ void parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:pqr:s:SV:vx:", longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:pqr:s:t:SV:vx:", longopts, NULL)) != -1) {
 		switch (opt) {
 		default:
 			if (opt == '?')
@@ -148,6 +153,11 @@ void parse_args(int argc, char *argv[])
 				desired_group = GROUP_VFS;
 			break;
 
+		case 't':
+			//Load mask for kernel taint flags.
+			kernel_taint_mask = atoi(optarg);
+			break;
+
 		/* Show help */
 		case 'h':
 			usage();
diff --git a/trinity.c b/trinity.c
index f09b36a..84d86ca 100644
--- a/trinity.c
+++ b/trinity.c
@@ -196,6 +196,10 @@ int main(int argc, char* argv[])
 	parse_args(argc, argv);
 	printf("Done parsing arguments.\n");
 
+	if (kernel_taint_mask != (int)0xFFFFFFFF) {
+		printf("Custom kernel taint mask has been specified: 0x%08x\n", kernel_taint_mask);
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
