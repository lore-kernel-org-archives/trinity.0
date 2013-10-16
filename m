From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 08/12] Define IP_MULTICAST_ALL if header files don't have it
Date: Wed, 16 Oct 2013 13:43:26 +0300
Message-ID: <1381920210-23329-8-git-send-email-mikko.rapeli@iki.fi>
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

Older systems have it defined in <linux/in.h> which conflicts with
<netinet/in.h>.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 net/ip_setsockopt.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ip_setsockopt.c b/net/ip_setsockopt.c
index 3d7c126..af4b873 100644
--- a/net/ip_setsockopt.c
+++ b/net/ip_setsockopt.c
@@ -12,6 +12,11 @@
 #include "random.h"
 #include "trinity.h"	// ARRAY_SIZE
 
+/* workaround for <linux/in.h> vs. <netinet/in.h> */
+#ifndef IP_MULTICAST_ALL
+#define IP_MULTICAST_ALL 49
+#endif
+
 #define NR_SOL_IP_OPTS ARRAY_SIZE(ip_opts)
 static const unsigned int ip_opts[] = { IP_TOS, IP_TTL, IP_HDRINCL, IP_OPTIONS,
 	IP_ROUTER_ALERT, IP_RECVOPTS, IP_RETOPTS, IP_PKTINFO,
-- 
1.7.9.5
