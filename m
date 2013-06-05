From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 1/2] gitignore: ignore cscope files
Date: Wed,  5 Jun 2013 17:41:23 +0800
Message-ID: <1370425284-18808-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=wA0irRyz9I5cJdpinjp3N4dQ0THogOFOgKKzdr3gudA=;
        b=mAMcO9ACtN08vdlOX9ZIjMHHSUAk6GxuakIoZbhu4wQQ/D74LwHWHZIBvv43PyzUsT
         YkOhq7Z4SEqDfrUD/VPX8dvff9RBKcWb1Y2FslMF/bx3q7+Qza0+tOPlTo/E+34DiNid
         tO57RKYMrX26rmZJgjKepYlP11ylMVLOeOxzYUXLrPnBvQmxTMzjIOqMKlcJB21CskWc
         qgeivhpTPV9gQE2sWU/WlchVHTD4CmAhiDwbQNNE94rDU8B4UmpKMxTFIGuWXPDO5h6G
         hEmFvJnZP9YS9mlQajZWFF8ZFJjlUyQq7UX19eQuWvcggyVihLKeYbv9b9CjUwuJraq4
         5GPg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 25f8a38..156f787 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,3 +10,5 @@ trinity-*.tgz
 victims
 tags
 config.h
+cscope.*
+ncscope.*
-- 
1.8.1.4
