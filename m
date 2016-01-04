From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/2] compat.h: add more RTNLGRP_ macros
Date: Mon,  4 Jan 2016 12:06:06 +0100
Message-ID: <1451905567-17034-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>

Some more RTNLGRP macros are not defined on SLE11 yet. So define them
in compat.h.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/compat.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index fda51b529b4d..2705b93534a3 100644
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
-- 
2.6.4
