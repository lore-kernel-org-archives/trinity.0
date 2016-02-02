From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] net/protocols.c: fix build on old machines
Date: Tue,  2 Feb 2016 13:25:21 +0100
Message-ID: <1454415921-13454-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>

* include compat.h for PF_* constants
* use PF_NFC only if it can fit into the list
* use PF_ALG only if USE_IF_ALG is defined

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/protocols.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/protocols.c b/net/protocols.c
index b8ae822ea2cf..febe0fd44781 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -1,6 +1,7 @@
 #include <sys/socket.h>
 #include "config.h"
 #include "net.h"
+#include "compat.h"
 
 const struct protoptr net_protocols[PF_MAX] = {
 	[PF_UNIX] = { .proto = &proto_unix },
@@ -29,7 +30,9 @@ const struct protoptr net_protocols[PF_MAX] = {
 #ifdef USE_CAIF
 	[PF_CAIF] = { .proto = &proto_caif },
 #endif
+#if PF_NFC < PF_MAX
 	[PF_NFC] = { .proto = &proto_nfc },
+#endif
 #ifdef USE_NETROM
 	[PF_NETROM] = { .proto = &proto_netrom },
 #endif
@@ -43,5 +46,7 @@ const struct protoptr net_protocols[PF_MAX] = {
 	[PF_PPPOX] = { .proto = &proto_pppol2tp },
 	[PF_IUCV] = { .proto = &proto_iucv },
 	[PF_RXRPC] = { .proto = &proto_rxrpc },
+#ifdef USE_IF_ALG
 	[PF_ALG] = { .proto = &proto_alg },
+#endif
 };
-- 
2.7.0
