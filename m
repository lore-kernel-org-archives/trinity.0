From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 10/12] net/netlink.c: support older kernels and headers
Date: Wed, 16 Oct 2013 13:43:28 +0300
Message-ID: <1381920210-23329-10-git-send-email-mikko.rapeli@iki.fi>
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
 net/netlink.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netlink.c b/net/netlink.c
index 6192184..4b7eed8 100644
--- a/net/netlink.c
+++ b/net/netlink.c
@@ -8,6 +8,17 @@
 #include "net.h"
 #include "random.h"
 
+/* Current highest netlink socket. Supports some older kernels. */
+#ifdef NETLINK_CRYPTO
+#define _NETLINK_MAX NETLINK_CRYPTO
+#else
+	#ifdef NETLINK_RDMA
+	#define _NETLINK_MAX NETLINK_RDMA
+	#else
+		#define _NETLINK_MAX NETLINK_ECRYPTFS
+	#endif /* NETLINK_RDMA */
+#endif /* NETLINK_CRYPTO */
+
 void netlink_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_nl *nl;
@@ -30,5 +41,5 @@ void netlink_rand_socket(struct socket_triplet *st)
 	else
 		st->type = SOCK_DGRAM;
 
-	st->protocol = rand() % (NETLINK_CRYPTO + 1);       // Current highest netlink socket.
+	st->protocol = rand() % (_NETLINK_MAX + 1);
 }
-- 
1.7.9.5
