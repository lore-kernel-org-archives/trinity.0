From: Praveen Pandey <praveen@linux.vnet.ibm.com>
Subject: [PATCH] Patch : enable  tool as make -p take an arg for seconds
Date: Wed, 29 Jul 2015 14:15:49 +0530
Message-ID: <1438159549-4119-1-git-send-email-praveen@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: sachinp@in.ibm.com, Praveen Pandey <praveen@linux.vnet.ibm.com>

Signed-off-by: Praveen Pandey <praveen@linux.vnet.ibm.com>
---
 Documentation/TODO         |  2 +-
 children/random-syscalls.c |  2 +-
 include/params.h           |  1 +
 params.c                   | 16 +++++++++++++---
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/TODO b/Documentation/TODO
index 73ea04a..108ee9c 100644
--- a/Documentation/TODO
+++ b/Documentation/TODO
@@ -228,7 +228,7 @@
   - if we find a blocking fd, check if it's a socket, and shutdown() it.
     (tricky: we need to do the shutdown in the main process, and then tell other children)
 
-* make -p take an arg for seconds
+* make -p take an arg for seconds --- DONE
 
 * things to check.
   - execve occasionally returns -ESRCH. Why ?
diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 807b2ec..e3f87f9 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -171,7 +171,7 @@ retry:
 	output_syscall_postfix(rec);
 
 	if (dopause == TRUE)
-		sleep(1);
+		sleep(userspecified_pausetime);
 
 	handle_syscall_ret(rec);
 
diff --git a/include/params.h b/include/params.h
index 7244a2f..7cbab01 100644
--- a/include/params.h
+++ b/include/params.h
@@ -32,6 +32,7 @@ extern bool do_specific_domain;
 extern char *specific_domain_optarg;
 extern bool no_domains[TRINITY_PF_MAX];
 extern bool dopause;
+extern unsigned int userspecified_pausetime;
 extern bool show_syscall_list;
 extern bool show_ioctl_list;
 extern unsigned char quiet_level;
diff --git a/params.c b/params.c
index 01b4df5..5ca40ae 100644
--- a/params.c
+++ b/params.c
@@ -30,8 +30,11 @@ unsigned int user_specified_children = 0;
 
 bool do_specific_domain = FALSE;
 bool no_domains[TRINITY_PF_MAX];
-
+//variables used for system call pause
 bool dopause = FALSE;
+unsigned int userspecified_pausetime = 0 ;
+
+
 bool show_syscall_list = FALSE;
 bool show_ioctl_list = FALSE;
 unsigned char quiet_level = 0;
@@ -92,12 +95,12 @@ static void usage(void)
 	outputerr("\n");
 	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
 	outputerr(" -N#: do # syscalls then exit.\n");
-	outputerr(" -p:  pause after syscall.\n");
+	outputerr(" -p: specify number of second or seconds for  pause after syscall .\n");
 	outputerr(" -s#: use # as random seed.\n");
 	exit(EXIT_SUCCESS);
 }
 
-static const char paramstr[] = "a:b:c:C:dDg:hIl:LN:mP:E:pqr:s:T:SV:vx:X";
+static const char paramstr[] = "a:b:c:C:p:dDg:hIl:LN:mP:E:qr:s:T:SV:vx:X";
 
 static const struct option longopts[] = {
 	{ "arch", required_argument, NULL, 'a' },
@@ -237,6 +240,13 @@ void parse_args(int argc, char *argv[])
 		/* Pause after each syscall */
 		case 'p':
 			dopause = TRUE;
+			userspecified_pausetime=strtoll(optarg, NULL, 10);
+			if (userspecified_pausetime == 0) {
+                outputerr("zero pause time ? WAT?\n");
+                exit(EXIT_FAILURE);
+            }
+
+			outputstd("time pass for pause %ld",userspecified_pausetime);
 			break;
 
 		case 'P':
-- 
1.9.3
