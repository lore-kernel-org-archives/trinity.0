From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] handle SIGABRT similar to SIGSEGV
Date: Mon, 20 Jan 2014 22:45:51 +0100
Message-ID: <1390254351-24457-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>

Sometimes, glibc aborts when some assertion is not met. In that case,
we want to have a coredump, so do not ignore that signal when
debugging is enabled.
---
 child.c   | 1 +
 signals.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/child.c b/child.c
index 74c72e124a86..8351d8eb6706 100644
--- a/child.c
+++ b/child.c
@@ -35,6 +35,7 @@ static void disable_coredumps(void)
 	struct rlimit limit;
 
 	if (debug == TRUE) {
+		(void)signal(SIGABRT, SIG_DFL);
 		(void)signal(SIGSEGV, SIG_DFL);
 		return;
 	}
diff --git a/signals.c b/signals.c
index 94c690bc6ffc..a6cac95aa2ba 100644
--- a/signals.c
+++ b/signals.c
@@ -82,8 +82,10 @@ void mask_signals_child(void)
 		(void)signal(i, SIG_IGN);
 
 	/* If we are in debug mode, we want segfaults and core dumps */
-	if (debug == TRUE)
+	if (debug == TRUE) {
+		(void)signal(SIGABRT, SIG_DFL);
 		(void)signal(SIGSEGV, SIG_DFL);
+	}
 
 	/* trap ctrl-c */
 	(void)signal(SIGINT, ctrlc_handler);
-- 
1.8.5.2
