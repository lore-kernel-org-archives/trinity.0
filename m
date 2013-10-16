From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 11/12] net/netlink_setsockopt.c: workaround for old headers
Date: Wed, 16 Oct 2013 13:43:29 +0300
Message-ID: <1381920210-23329-11-git-send-email-mikko.rapeli@iki.fi>
References: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: mikko.rapeli@iki.fi

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 net/netlink_setsockopt.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netlink_setsockopt.c b/net/netlink_setsockopt.c
index 549c3f0..76e458f 100644
--- a/net/netlink_setsockopt.c
+++ b/net/netlink_setsockopt.c
@@ -1,5 +1,9 @@
 #include <stdlib.h>
 #include <sys/socket.h> /* old netlink.h is broken */
+
+/* For sa_family_t needed by <linux/netlink.h> */
+#include <netinet/in.h>
+
 #include <linux/netlink.h>
 #include "net.h"
 #include "maps.h"	// page_rand
-- 
1.7.9.5
