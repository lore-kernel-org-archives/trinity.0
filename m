From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] compat: define more ETH_P_ constants
Date: Tue, 14 Jan 2014 16:57:06 +0100
Message-ID: <1389715026-26386-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>

Otherwise for 3.0, we see:
net/ether.c:23: error: 'ETH_P_TDLS' undeclared here (not in a function)
net/ether.c:24: error: 'ETH_P_AF_IUCV' undeclared here (not in a function)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/compat.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 0985b8e109fb..2c81d4ba9213 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -832,6 +832,9 @@ struct kvm_get_htab_fd {
 #ifndef ETH_P_PRP
 #define ETH_P_PRP	0x88FB
 #endif
+#ifndef ETH_P_TDLS
+#define ETH_P_TDLS	0x890D
+#endif
 #ifndef ETH_P_QINQ1
 #define ETH_P_QINQ1	0x9100
 #endif
@@ -841,3 +844,6 @@ struct kvm_get_htab_fd {
 #ifndef ETH_P_QINQ3
 #define ETH_P_QINQ3	0x9300
 #endif
+#ifndef ETH_P_AF_IUCV
+#define ETH_P_AF_IUCV	0xFBFB
+#endif
-- 
1.8.5.2
