From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2 1/2] compat.h: add more macros
Date: Mon,  4 Jan 2016 12:21:30 +0100
Message-ID: <1451906491-20710-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>

Some more RTNLGRP macros are not defined on SLE11 yet.

[v2]: NVME_IOCTL_RESET is not defined on openSUSE 42.1. Include
compat.h in ioctls/nvme.c.

So define them in compat.h.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/compat.h | 17 +++++++++++++++++
 ioctls/nvme.c    |  1 +
 2 files changed, 18 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index fda51b529b4d..65e5e3c3cc08 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -268,6 +268,18 @@ enum {
 #ifndef NETLINK_SOCK_DIAG
 #define NETLINK_SOCK_DIAG 4
 #endif
+#ifndef RTNLGRP_DCB
+#define RTNLGRP_DCB 23
+#endif
+#ifndef RTNLGRP_IPV4_NETCONF
+#define RTNLGRP_IPV4_NETCONF 24
+#endif
+#ifndef RTNLGRP_IPV6_NETCONF
+#define RTNLGRP_IPV6_NETCONF 25
+#endif
+#ifndef RTNLGRP_MDB
+#define RTNLGRP_MDB 26
+#endif
 #ifndef RTNLGRP_MPLS_ROUTE
 #define RTNLGRP_MPLS_ROUTE 27
 #endif
@@ -1055,3 +1067,8 @@ struct kvm_get_htab_fd {
 #ifndef POLL_BUSY_LOOP
 #define POLL_BUSY_LOOP 0x8000
 #endif
+
+/* linux/nvme_ioctl.h */
+#ifndef NVME_IOCTL_RESET
+#define NVME_IOCTL_RESET _IO('N', 0x44)
+#endif
diff --git a/ioctls/nvme.c b/ioctls/nvme.c
index 406ec6bc2254..2cc9f1f9d366 100644
--- a/ioctls/nvme.c
+++ b/ioctls/nvme.c
@@ -3,6 +3,7 @@
 #include <linux/ioctl.h>
 #include <linux/nvme.h>
 
+#include "compat.h"
 #include "utils.h"
 #include "ioctls.h"
 
-- 
2.6.4
