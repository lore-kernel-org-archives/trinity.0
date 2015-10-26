From: "Praveen K. Pandey" <praveen@linux.vnet.ibm.com>
Subject: [PATCH] remove this param as it not adds any value any more
Date: Mon, 26 Oct 2015 11:20:09 +0530
Message-ID: <1445838609-14504-1-git-send-email-praveen@linux.vnet.ibm.com>
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
 Documentation/TODO | 2 --
 params.c           | 1 -
 2 files changed, 3 deletions(-)

diff --git a/Documentation/TODO b/Documentation/TODO
index 73ea04a..c5af727 100644
--- a/Documentation/TODO
+++ b/Documentation/TODO
@@ -228,8 +228,6 @@
   - if we find a blocking fd, check if it's a socket, and shutdown() it.
     (tricky: we need to do the shutdown in the main process, and then tell other children)
 
-* make -p take an arg for seconds
-
 * things to check.
   - execve occasionally returns -ESRCH. Why ?
   - disappearing processes. 'oom killed maybe' when no oom.
diff --git a/params.c b/params.c
index 8b1cd3b..9aa6109 100644
--- a/params.c
+++ b/params.c
@@ -92,7 +92,6 @@ static void usage(void)
 	outputerr("\n");
 	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
 	outputerr(" -N#: do # syscalls then exit.\n");
-	outputerr(" -p:  pause after syscall.\n");
 	outputerr(" -s#: use # as random seed.\n");
 	exit(EXIT_SUCCESS);
 }
-- 
1.9.3
