From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] fix build prctl.h header on RHEL6.7
Date: Mon, 31 Aug 2015 17:18:37 +0800
Message-ID: <1441012717-20482-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=RjZg2gMxpOPc9ORSrmh6lEJ7hFB1pPLWZhC05W2PTaA=;
        b=he3C3RrRt7MQ4gNMzSsukXwVbjQo/T1jG6N9gy9tyzqARD5cWvaVz3Y+x+/bLQC/3z
         MhYZkJZcgQ65EVMsRPIGB5eOouw38ugbRw6uiER9HOzXhLKrDOzyAUNcfvuW3YtEjnkY
         2nd2r+J9/cABBiufw+xOOuLek6c6xI7mIsPuinDqv9KK98LQqRMC/sRkkzxaZejJQpDX
         CIg3qrPJ/8HzY8Jx2F8fBV10kqy6U3TN8+IzxHZUYin1zeApC2HwLzxIh6wOsdUMCQcX
         RHiAuNljfPDu7FXQMzdhNbE41mTWQK1riEqpl+WLAwL2p2A1YUyJalO3XrGYmrDySUEG
         2vMA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Trinity <trinity@vger.kernel.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>

latest RHEL6.7 kernel headers only defined PR_SET/GET_NO_NEW_PRIVS, which
lead to 'PR_GET_TID_ADDRESS' undeclared build error.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/compat.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 0e0f30e..1f1ad9c 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -280,6 +280,9 @@ enum {
 #ifndef PR_SET_NO_NEW_PRIVS
 #define PR_SET_NO_NEW_PRIVS     38
 #define PR_GET_NO_NEW_PRIVS     39
+#endif
+
+#ifndef PR_GET_TID_ADDRESS
 #define PR_GET_TID_ADDRESS      40
 #endif
 
-- 
1.9.3
