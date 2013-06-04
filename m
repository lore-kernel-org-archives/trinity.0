From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/3] compat: define some more
Date: Tue,  4 Jun 2013 11:56:10 +0200
Message-ID: <1370339770-26823-1-git-send-email-jslaby@suse.cz>
References: <1370339304-26492-3-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1370339304-26492-3-git-send-email-jslaby@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>

syscalls/prctl.c:27: error: 'PR_MCE_KILL_GET' undeclared here (not in a function)
syscalls/socket.c:178: error: 'NETLINK_CRYPTO' undeclared (first use in this function)

[v2]
 - include compat.h at the end, otherwise we fail to build on some
   configs
---
 include/compat.h | 10 ++++++++++
 syscalls/prctl.c |  1 +
 2 files changed, 11 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 20455f3..bb2fae4 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -180,6 +180,16 @@ enum {
 #define SYS_SENDMMSG 20
 #endif
 
+/* linux/netlink.h */
+#ifndef NETLINK_CRYPTO
+#define NETLINK_CRYPTO 21
+#endif
+
+/* linux/prctl.h */
+#ifndef PR_MCE_KILL_GET
+#define PR_MCE_KILL_GET 34
+#endif
+
 /* linux/rds.h */
 #ifndef RDS_CANCEL_SENT_TO
 #define RDS_CANCEL_SENT_TO              1
diff --git a/syscalls/prctl.c b/syscalls/prctl.c
index d837a65..bb7bd32 100644
--- a/syscalls/prctl.c
+++ b/syscalls/prctl.c
@@ -15,6 +15,7 @@
 #include "net.h"
 #include "maps.h"
 #include "shm.h"
+#include "compat.h"
 
 #define NR_PRCTL_OPTS 28
 static int prctl_opts[NR_PRCTL_OPTS] = {
-- 
1.8.3
