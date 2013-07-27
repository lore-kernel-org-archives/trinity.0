From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/2] Do not busy loop child processes on startup
Date: Sat, 27 Jul 2013 17:35:16 +0300
Message-ID: <1374935716-26961-3-git-send-email-tt.rantala@gmail.com>
References: <1374935716-26961-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=hYf+GiRH3oF6qCx4MvjodI/uEg+7ElOiN78JXocMgA4=;
        b=WhdmeZswji2LwGUMoRvr0dmQH4NpxOrtG7D1ulKDJSXOjG4HotjdwQiN4hzf9TzfSX
         y3ZQqu228wMylshZ4QmvUWlGrJGHpXHbrqwVxCn94mfOV72F6qsOUDD9zkv77hy8N+0C
         Kk6j2P2N7fO3InK2AJTeGrtBhkGdse5BSH+1Swr9Y/fQ+8LcRndJPZiFvWMCutHjKQKH
         EzOSBhAOFo1DBXY1VDOXFVzs6DhYHX0oXO1QjzVFPrCOJiyMVhfPPk1YF3fhvbA2/TG7
         iHqjHgvElZYTjXufnnm+w4GOrWGTTJfA3H9wyOMUN1/GkV98qThD1xPwBHmdSKl1N3Qt
         ND5g==
In-Reply-To: <1374935716-26961-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Stop busy looping the child processes on trinity startup, so that they
do not compete with the main process for CPU time.
---
 main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/main.c b/main.c
index 1401de7..fefc4bf 100644
--- a/main.c
+++ b/main.c
@@ -143,7 +143,8 @@ static void fork_children(void)
 			}
 
 			/* Wait for all the children to start up. */
-			while (shm->ready == FALSE);
+			while (shm->ready == FALSE)
+				sleep(1);
 
 			init_child(pidslot);
 
-- 
1.8.1.2
