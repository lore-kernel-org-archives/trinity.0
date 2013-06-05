From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] compat: define NETLINK_CRYPTO constant
Date: Wed,  5 Jun 2013 17:51:25 +0800
Message-ID: <1370425885-24383-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=99P1LX9xiyaGp2YQi1vdEWbaT/cuqy3/GC/xocyL0mQ=;
        b=Ob/29wcjEBgv2lzSGsO3mLdPuYkgUmLXLQ409zY179zt+9yKvVst21I3CZ7sBpc71A
         8tn8KoV3pe6tsksoCTiZF4WXM+/ohrxpBP8u/9EwPZ9kf5ThRU7y1jZ72ndSiNgihweN
         fFFEJJ/M2e5HSK+9IlG9wrfIBNyNDQ3HRZKQRgZ8Voelqyq9ScEjr1ddoSd5TPDweAV/
         tCzF2N9ht4oxsBX+/x4MQts3KQGAwtN48BZFkQkQqXHL44SiIKvEG5DnUHg3U0ih+ZDu
         UvEyni+PW3yKPX6cHb0/XCwTUsWjFlAXObGAbOe55YU7LPR7rvHvGgV5PZn2uguiwO2D
         kqhQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/compat.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 20455f3..cef29f7 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -180,6 +180,11 @@ enum {
 #define SYS_SENDMMSG 20
 #endif
 
+/* linux/netlink.h */
+#ifndef NETLINK_CRYPTO
+#define NETLINK_CRYPTO 21
+#endif
+
 /* linux/rds.h */
 #ifndef RDS_CANCEL_SENT_TO
 #define RDS_CANCEL_SENT_TO              1
-- 
1.8.1.4
