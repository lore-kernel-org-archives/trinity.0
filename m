From: "Praveen K. Pandey" <praveen@linux.vnet.ibm.com>
Subject: [PATCH] remove this param as it not adds any value any more
Date: Thu, 29 Oct 2015 14:26:13 +0530
Message-ID: <1446108973-10833-1-git-send-email-praveen@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: "Praveen K. Pandey" <praveen@linux.vnet.ibm.com>

Signed-off-by: Praveen K. Pandey <praveen@linux.vnet.ibm.com>
---
 Documentation/TODO         | 1 -
 children/random-syscalls.c | 8 --------
 include/params.h           | 1 -
 params.c                   | 9 +--------
 4 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/Documentation/TODO b/Documentation/TODO
index 73ea04a..25b2b5d 100644
--- a/Documentation/TODO
+++ b/Documentation/TODO
@@ -228,7 +228,6 @@
   - if we find a blocking fd, check if it's a socket, and shutdown() it.
     (tricky: we need to do the shutdown in the main process, and then tell other children)
 
-* make -p take an arg for seconds
 
 * things to check.
   - execve occasionally returns -ESRCH. Why ?
diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 697661b..eae4c55 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -12,7 +12,6 @@
 #include "debug.h"
 #include "locks.h"
 #include "log.h"
-#include "params.h"	// dopause
 #include "pids.h"
 #include "random.h"
 #include "shm.h"
@@ -129,10 +128,6 @@ retry:
 	 */
 	len = strlen(rec->prebuffer);
 
-	/* If we're going to pause, might as well sync pre-syscall */
-	if (dopause == TRUE)
-		synclogs();
-
 	old = rec->tv.tv_sec;
 	do_syscall(rec);
 
@@ -172,9 +167,6 @@ retry:
 	/* Output the syscall result, and clean up */
 	output_syscall_postfix(rec);
 
-	if (dopause == TRUE)
-		sleep(1);
-
 	handle_syscall_ret(rec);
 
 	return TRUE;
diff --git a/include/params.h b/include/params.h
index 7244a2f..1c04f40 100644
--- a/include/params.h
+++ b/include/params.h
@@ -31,7 +31,6 @@ extern unsigned int specific_domain;
 extern bool do_specific_domain;
 extern char *specific_domain_optarg;
 extern bool no_domains[TRINITY_PF_MAX];
-extern bool dopause;
 extern bool show_syscall_list;
 extern bool show_ioctl_list;
 extern unsigned char quiet_level;
diff --git a/params.c b/params.c
index 8b1cd3b..0a33e2d 100644
--- a/params.c
+++ b/params.c
@@ -31,7 +31,6 @@ unsigned int user_specified_children = 0;
 bool do_specific_domain = FALSE;
 bool no_domains[TRINITY_PF_MAX];
 
-bool dopause = FALSE;
 bool show_syscall_list = FALSE;
 bool show_ioctl_list = FALSE;
 unsigned char quiet_level = 0;
@@ -92,12 +91,11 @@ static void usage(void)
 	outputerr("\n");
 	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
 	outputerr(" -N#: do # syscalls then exit.\n");
-	outputerr(" -p:  pause after syscall.\n");
 	outputerr(" -s#: use # as random seed.\n");
 	exit(EXIT_SUCCESS);
 }
 
-static const char paramstr[] = "a:b:c:C:dDE:g:hIl:LmN:P:pqr:s:ST:V:vx:X";
+static const char paramstr[] = "a:b:c:C:dDE:g:hIl:LmN:P:qr:s:ST:V:vx:X";
 
 static const struct option longopts[] = {
 	{ "arch", required_argument, NULL, 'a' },
@@ -234,11 +232,6 @@ void parse_args(int argc, char *argv[])
 			syscalls_todo = strtoll(optarg, NULL, 10);
 			break;
 
-		/* Pause after each syscall */
-		case 'p':
-			dopause = TRUE;
-			break;
-
 		case 'P':
 			do_specific_domain = TRUE;
 			specific_domain = strtol(optarg, NULL, 10);
-- 
1.9.3
