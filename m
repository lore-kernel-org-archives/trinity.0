From: Artem Savkov <asavkov@redhat.com>
Subject: [PATCH] Fix logging logic in output().
Date: Wed, 17 Feb 2016 17:20:39 +0100
Message-ID: <1455726039-5525-1-git-send-email-asavkov@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Artem Savkov <asavkov@redhat.com>

Commit "preparation for different forms of logging." contained a typo that
broke logging to mainlogfile.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/log.c b/log.c
index dbac844..aee5a67 100644
--- a/log.c
+++ b/log.c
@@ -103,7 +103,7 @@ void output(unsigned char level, const char *fmt, ...)
 	}
 
 	/* go on with file logs only if enabled */
-	if (logging == LOGGING_FILES)
+	if (logging == LOGGING_DISABLED)
 		return;
 
 	handle = find_logfile_handle();
-- 
2.5.0
