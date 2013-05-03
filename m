From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] setsockopt: add missing SCTP socket layer options
Date: Fri,  3 May 2013 13:38:26 +0200
Message-ID: <54c8ad29a01a2fb0976484e512c42f4e87320a6a.1367580990.git.dborkman@redhat.com>
References: <cover.1367580990.git.dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <cover.1367580990.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org

There are a couple of missing socket options for SCTP, so simply
add them to the list.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/compat.h      | 1 +
 syscalls/setsockopt.h | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 3af8af4..a1f3d42 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -416,6 +416,7 @@ enum kcmp_type {
 #define SCTP_GET_LOCAL_ADDRS    109             /* Get all local address. */
 #define SCTP_SOCKOPT_CONNECTX   110             /* CONNECTX requests. */
 #define SCTP_SOCKOPT_CONNECTX3  111     /* CONNECTX requests (updated) */
+#define SCTP_GET_ASSOC_STATS    112	/* Read only */
 #endif
 
 /* linux/rxrpc.h */
diff --git a/syscalls/setsockopt.h b/syscalls/setsockopt.h
index ced1099..28204dc 100644
--- a/syscalls/setsockopt.h
+++ b/syscalls/setsockopt.h
@@ -103,7 +103,7 @@ static int ipv6_opts[NR_SOL_IPV6_OPTS] = {
 #define NR_SOL_ICMPV6_OPTS 1
 static int icmpv6_opts[NR_SOL_ICMPV6_OPTS] = { ICMPV6_FILTER };
 
-#define NR_SOL_SCTP_OPTS 39
+#define NR_SOL_SCTP_OPTS 41
 static int sctp_opts[NR_SOL_SCTP_OPTS] = {
 	SCTP_RTOINFO, SCTP_ASSOCINFO, SCTP_INITMSG, SCTP_NODELAY,
 	SCTP_AUTOCLOSE, SCTP_SET_PEER_PRIMARY_ADDR, SCTP_PRIMARY_ADDR, SCTP_ADAPTATION_LAYER,
@@ -112,10 +112,10 @@ static int sctp_opts[NR_SOL_SCTP_OPTS] = {
 	SCTP_DELAYED_ACK_TIME, SCTP_CONTEXT, SCTP_FRAGMENT_INTERLEAVE, SCTP_PARTIAL_DELIVERY_POINT,
 	SCTP_MAX_BURST, SCTP_AUTH_CHUNK, SCTP_HMAC_IDENT, SCTP_AUTH_KEY,
 	SCTP_AUTH_ACTIVE_KEY, SCTP_AUTH_DELETE_KEY, SCTP_PEER_AUTH_CHUNKS, SCTP_LOCAL_AUTH_CHUNKS,
-	SCTP_GET_ASSOC_NUMBER, SCTP_GET_ASSOC_ID_LIST, SCTP_AUTO_ASCONF,
-
+	SCTP_GET_ASSOC_NUMBER, SCTP_GET_ASSOC_ID_LIST, SCTP_AUTO_ASCONF, SCTP_PEER_ADDR_THLDS,
 	SCTP_SOCKOPT_BINDX_ADD, SCTP_SOCKOPT_BINDX_REM, SCTP_SOCKOPT_PEELOFF, SCTP_SOCKOPT_CONNECTX_OLD,
-	SCTP_GET_PEER_ADDRS, SCTP_GET_LOCAL_ADDRS, SCTP_SOCKOPT_CONNECTX, SCTP_SOCKOPT_CONNECTX3 };
+	SCTP_GET_PEER_ADDRS, SCTP_GET_LOCAL_ADDRS, SCTP_SOCKOPT_CONNECTX, SCTP_SOCKOPT_CONNECTX3,
+	SCTP_GET_ASSOC_STATS };
 
 #define NR_SOL_AX25_OPTS 12
 static int ax25_opts[NR_SOL_AX25_OPTS] = {
-- 
1.7.11.7
