From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/3] compat: define some net constants
Date: Sat,  5 Oct 2013 09:33:46 +0200
Message-ID: <1380958428-9611-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>

To be able to build for 3.0.
---
 include/compat.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index bb77e3b..e8d6b9a 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -418,9 +418,21 @@ enum kcmp_type {
 #ifndef IP_TRANSPARENT
 #define IP_TRANSPARENT		19
 #endif
+#ifndef IP_MINTTL
+#define IP_MINTTL		21
+#endif
+#ifndef IP_ORIGDSTADDR
+#define IP_ORIGDSTADDR		20
+#endif
+#ifndef IP_RECVORIGDSTADDR
+#define IP_RECVORIGDSTADDR	IP_ORIGDSTADDR
+#endif
 #ifndef IP_NODEFRAG
 #define IP_NODEFRAG		22
 #endif
+#ifndef IP_MULTICAST_ALL
+#define IP_MULTICAST_ALL	49
+#endif
 #ifndef IP_UNICAST_IF
 #define IP_UNICAST_IF		50
 #endif
@@ -754,6 +766,9 @@ struct kvm_get_htab_fd {
 #endif
 
 /* linux/mroute.h */
+#ifndef MRT_TABLE
+#define MRT_TABLE		(MRT_BASE+9)
+#endif
 #ifndef MRT_ADD_MFC_PROXY
 #define MRT_ADD_MFC_PROXY	(MRT_BASE+10)
 #endif
-- 
1.8.4

