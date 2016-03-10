From: Adrien Schildknecht <adrien+dev@schischi.me>
Subject: [PATCH] compat.h: add SHM_NORESERVE flag
Date: Thu, 10 Mar 2016 14:56:55 -0800
Message-ID: <1457650615-5679-1-git-send-email-adrien+dev@schischi.me>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schischi-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=NjW6yYRjcYycQYtF0/qzIirA6mh9YLIjRayta8OXnn4=;
        b=INRT4mNQKlFRbIP6qBV5GnqscA861eGjLA6S7Q1TgHgEyDb/kbNP25XTysRXY+J+Hu
         4ClE7ARVF6j1U1hAf2cNh1gTpToH/l5LbIjMWeb6ZkFENoESoI5Y6ck0R3AGpJ9E68Lf
         9lJg0W8/pl2LUDHss7f+xO3e7CEou7e38sUL5Ol3iPGLTXcehPjT5uTr8N+0UWhNSakh
         ElQNVDXQeenYGpZfyxNJN17VJDTpEFXDXLmDqnvi3nsumDjVREQdf3c7+t1N87cvLb47
         dO1pXZB+P6JDnTBBgZxPOGJ8djqupXuxG5YSrE5BlQl8teVR3NWmHmABjsjtlZq1x7qh
         AhWw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>

Debian jessie MIPS build fix.
sysv-shm.c:22:3: error: 'SHM_NORESERVE' undeclared (first use in this function)
   SHM_NORESERVE,

https://sourceware.org/bugzilla/show_bug.cgi?id=17930

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
---
 include/compat.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 2a89744..367fed6 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -1097,3 +1097,8 @@ struct kvm_get_htab_fd {
 #define SHM_HUGE_2MB	(21 << SHM_HUGE_SHIFT)
 #define SHM_HUGE_1GB	(30 << SHM_HUGE_SHIFT)
 #endif
+
+/* bits/shm.h */
+#ifndef SHM_NORESERVE
+# define SHM_NORESERVE 010000
+#endif
-- 
2.7.2
