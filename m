From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH v2] syscalls: use ARRAY_SIZE(x) instead of hard code define
Date: Fri,  7 Jun 2013 00:28:37 +0800
Message-ID: <1370536117-17806-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=cNUKPW45iFdGY2luLNrea/6LM45/sjXPIfWFUrsBnz4=;
        b=z8QzMfWF8QEU867GcEoUnqKiUzG6Jpx4nkulYK8fd6JYiOXKfXbYosmjrRWvsPu/kz
         3fjko2G9xwUIq7GuMM1UPb+5GXdQo19UwsTbCANyOFQ7EDssfftUg7GwdGSBfNwTZIMQ
         pVIta/1PNV+rMwfj8Lhs8Ci5wo+4WPzbpzHULex8l57cMrF2l+g5Z34zDkLEk957YPVC
         eSUIN9YQuhOXSPOxe/E43QLBx244LhRThGrJWZqY8aqqYFoYlQvopR9I1ZeR0ZMvRTY8
         F0UJh104xaGmNLJy7E1MH1Xca4VT4dcorS3k7p9Js5wAsMaRCbQimEGT590ijh9YfvyD
         TWAg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 syscalls/setsockopt.h | 113 +++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 56 deletions(-)

diff --git a/syscalls/setsockopt.h b/syscalls/setsockopt.h
index 49607ea..e2624f2 100644
--- a/syscalls/setsockopt.h
+++ b/syscalls/setsockopt.h
@@ -32,6 +32,7 @@
 
 #include "compat.h"
 #include "config.h"
+#include "trinity.h"
 
 #ifdef USE_CAIF
 #include <linux/caif/caif_socket.h>
@@ -58,15 +59,15 @@
 #define SOL_ALG         279
 #define SOL_NFC		280
 
-#define NR_SOL_IP_OPTS 19
-static int ip_opts[NR_SOL_IP_OPTS] = { IP_TOS, IP_TTL, IP_HDRINCL, IP_OPTIONS,
+#define NR_SOL_IP_OPTS ARRAY_SIZE(ip_opts)
+static int ip_opts[] = { IP_TOS, IP_TTL, IP_HDRINCL, IP_OPTIONS,
 	IP_ROUTER_ALERT, IP_RECVOPTS, IP_RETOPTS, IP_PKTINFO,
 	IP_PKTOPTIONS, IP_MTU_DISCOVER, IP_RECVERR, IP_RECVTTL,
 	IP_RECVTOS, IP_MTU, IP_FREEBIND, IP_IPSEC_POLICY,
 	IP_XFRM_POLICY, IP_PASSSEC, IP_TRANSPARENT };
 
-#define NR_SOL_SOCKET_OPTS 49
-static int socket_opts[NR_SOL_SOCKET_OPTS] = { SO_DEBUG, SO_REUSEADDR, SO_TYPE, SO_ERROR,
+#define NR_SOL_SOCKET_OPTS ARRAY_SIZE(socket_opts)
+static int socket_opts[] = { SO_DEBUG, SO_REUSEADDR, SO_TYPE, SO_ERROR,
 	SO_DONTROUTE, SO_BROADCAST, SO_SNDBUF, SO_RCVBUF,
 	SO_SNDBUFFORCE, SO_RCVBUFFORCE, SO_KEEPALIVE, SO_OOBINLINE,
 	SO_NO_CHECK, SO_PRIORITY, SO_LINGER, SO_BSDCOMPAT,
@@ -78,22 +79,22 @@ static int socket_opts[NR_SOL_SOCKET_OPTS] = { SO_DEBUG, SO_REUSEADDR, SO_TYPE,
 	SO_PROTOCOL, SO_DOMAIN, SO_RXQ_OVFL, SO_WIFI_STATUS,
 	SO_PEEK_OFF, SO_NOFCS, SO_LOCK_FILTER, SO_SELECT_ERR_QUEUE };
 
-#define NR_SOL_TCP_OPTS 23
-static int tcp_opts[NR_SOL_TCP_OPTS] = { TCP_NODELAY, TCP_MAXSEG, TCP_CORK, TCP_KEEPIDLE,
+#define NR_SOL_TCP_OPTS ARRAY_SIZE(tcp_opts)
+static int tcp_opts[] = { TCP_NODELAY, TCP_MAXSEG, TCP_CORK, TCP_KEEPIDLE,
 	TCP_KEEPINTVL, TCP_KEEPCNT, TCP_SYNCNT, TCP_LINGER2,
 	TCP_DEFER_ACCEPT, TCP_WINDOW_CLAMP, TCP_INFO, TCP_QUICKACK,
 	TCP_CONGESTION, TCP_MD5SIG, TCP_COOKIE_TRANSACTIONS, TCP_THIN_LINEAR_TIMEOUTS,
 	TCP_THIN_DUPACK, TCP_USER_TIMEOUT, TCP_REPAIR, TCP_REPAIR_QUEUE,
 	TCP_QUEUE_SEQ, TCP_REPAIR_OPTIONS, TCP_FASTOPEN};
 
-#define NR_SOL_UDP_OPTS 2
-static int udp_opts[NR_SOL_UDP_OPTS] = { UDP_CORK, UDP_ENCAP };
+#define NR_SOL_UDP_OPTS ARRAY_SIZE(udp_opts)
+static int udp_opts[] = { UDP_CORK, UDP_ENCAP };
 
-#define NR_SOL_UDPLITE_OPTS 4
-static int udplite_opts[NR_SOL_UDPLITE_OPTS] = { UDP_CORK, UDP_ENCAP, UDPLITE_SEND_CSCOV, UDPLITE_RECV_CSCOV };
+#define NR_SOL_UDPLITE_OPTS ARRAY_SIZE(udplite_opts)
+static int udplite_opts[] = { UDP_CORK, UDP_ENCAP, UDPLITE_SEND_CSCOV, UDPLITE_RECV_CSCOV };
 
-#define NR_SOL_IPV6_OPTS 24
-static int ipv6_opts[NR_SOL_IPV6_OPTS] = {
+#define NR_SOL_IPV6_OPTS ARRAY_SIZE(ipv6_opts)
+static int ipv6_opts[] = {
 	IPV6_ADDRFORM, IPV6_2292PKTINFO, IPV6_2292HOPOPTS, IPV6_2292DSTOPTS,
 	IPV6_2292RTHDR, IPV6_2292PKTOPTIONS, IPV6_CHECKSUM, IPV6_2292HOPLIMIT,
 	IPV6_NEXTHOP, IPV6_AUTHHDR, IPV6_FLOWINFO, IPV6_UNICAST_HOPS,
@@ -101,11 +102,11 @@ static int ipv6_opts[NR_SOL_IPV6_OPTS] = {
 	IPV6_DROP_MEMBERSHIP, IPV6_ROUTER_ALERT, IPV6_MTU_DISCOVER, IPV6_MTU,
 	IPV6_RECVERR, IPV6_V6ONLY, IPV6_JOIN_ANYCAST, IPV6_LEAVE_ANYCAST };
 
-#define NR_SOL_ICMPV6_OPTS 1
-static int icmpv6_opts[NR_SOL_ICMPV6_OPTS] = { ICMPV6_FILTER };
+#define NR_SOL_ICMPV6_OPTS ARRAY_SIZE(icmpv6_opts)
+static int icmpv6_opts[] = { ICMPV6_FILTER };
 
-#define NR_SOL_SCTP_OPTS 41
-static int sctp_opts[NR_SOL_SCTP_OPTS] = {
+#define NR_SOL_SCTP_OPTS ARRAY_SIZE(sctp_opts)
+static int sctp_opts[] = {
 	SCTP_RTOINFO, SCTP_ASSOCINFO, SCTP_INITMSG, SCTP_NODELAY,
 	SCTP_AUTOCLOSE, SCTP_SET_PEER_PRIMARY_ADDR, SCTP_PRIMARY_ADDR, SCTP_ADAPTATION_LAYER,
 	SCTP_DISABLE_FRAGMENTS, SCTP_PEER_ADDR_PARAMS, SCTP_DEFAULT_SEND_PARAM, SCTP_EVENTS,
@@ -118,24 +119,24 @@ static int sctp_opts[NR_SOL_SCTP_OPTS] = {
 	SCTP_GET_PEER_ADDRS, SCTP_GET_LOCAL_ADDRS, SCTP_SOCKOPT_CONNECTX, SCTP_SOCKOPT_CONNECTX3,
 	SCTP_GET_ASSOC_STATS };
 
-#define NR_SOL_AX25_OPTS 12
-static int ax25_opts[NR_SOL_AX25_OPTS] = {
+#define NR_SOL_AX25_OPTS ARRAY_SIZE(ax25_opts)
+static int ax25_opts[] = {
 	AX25_WINDOW, AX25_T1, AX25_N2, AX25_T3,
 	AX25_T2, AX25_BACKOFF, AX25_EXTSEQ, AX25_PIDINCL,
 	AX25_IDLE, AX25_PACLEN, AX25_IAMDIGI,
 	SO_BINDTODEVICE };
 
-#define NR_SOL_NETROM_OPTS 5
-static int netrom_opts[NR_SOL_NETROM_OPTS] = {
+#define NR_SOL_NETROM_OPTS ARRAY_SIZE(netrom_opts)
+static int netrom_opts[] = {
 	NETROM_T1, NETROM_T2, NETROM_N2, NETROM_T4, NETROM_IDLE };
 
-#define NR_SOL_ROSE_OPTS 7
-static int rose_opts[NR_SOL_ROSE_OPTS] = {
+#define NR_SOL_ROSE_OPTS ARRAY_SIZE(rose_opts)
+static int rose_opts[] = {
 	ROSE_DEFER, ROSE_T1, ROSE_T2, ROSE_T3,
 	ROSE_IDLE, ROSE_QBITINCL, ROSE_HOLDBACK };
 
-#define NR_SOL_DECNET_OPTS 18
-static int decnet_opts[NR_SOL_DECNET_OPTS] = {
+#define NR_SOL_DECNET_OPTS ARRAY_SIZE(decnet_opts)
+static int decnet_opts[] = {
 	SO_CONDATA, SO_CONACCESS, SO_PROXYUSR, SO_LINKINFO,
 	DSO_CONDATA, DSO_DISDATA, DSO_CONACCESS, DSO_ACCEPTMODE,
 	DSO_CONACCEPT, DSO_CONREJECT, DSO_LINKINFO, DSO_STREAM,
@@ -143,20 +144,20 @@ static int decnet_opts[NR_SOL_DECNET_OPTS] = {
 	DSO_SERVICES, DSO_INFO
 };
 
-#define NR_SOL_PACKET_OPTS 22
-static int packet_opts[NR_SOL_PACKET_OPTS] = {
+#define NR_SOL_PACKET_OPTS ARRAY_SIZE(packet_opts)
+static int packet_opts[] = {
 	PACKET_ADD_MEMBERSHIP, PACKET_DROP_MEMBERSHIP, PACKET_RECV_OUTPUT, 4,	/* Value 4 is still used by obsolete turbo-packet. */
 	PACKET_RX_RING, PACKET_STATISTICS, PACKET_COPY_THRESH, PACKET_AUXDATA,
 	PACKET_ORIGDEV, PACKET_VERSION, PACKET_HDRLEN, PACKET_RESERVE,
 	PACKET_TX_RING, PACKET_LOSS, PACKET_VNET_HDR, PACKET_TX_TIMESTAMP,
 	PACKET_TIMESTAMP, PACKET_FANOUT };
 
-#define NR_SOL_ATM_OPTS 6
-static int atm_opts[NR_SOL_ATM_OPTS] = {
+#define NR_SOL_ATM_OPTS ARRAY_SIZE(atm_opts)
+static int atm_opts[] = {
 	SO_SETCLP, SO_CIRANGE, SO_ATMQOS, SO_ATMSAP, SO_ATMPVC, SO_MULTIPOINT };
 
-#define NR_SOL_IRDA_OPTS 11
-static int irda_opts[NR_SOL_IRDA_OPTS] = {
+#define NR_SOL_IRDA_OPTS ARRAY_SIZE(irda_opts)
+static int irda_opts[] = {
 	IRLMP_ENUMDEVICES, IRLMP_IAS_SET, IRLMP_IAS_QUERY, IRLMP_HINTS_SET,
 	IRLMP_QOS_SET, IRLMP_QOS_GET, IRLMP_MAX_SDU_SIZE, IRLMP_IAS_GET,
 	IRLMP_IAS_DEL, IRLMP_HINT_MASK_SET, IRLMP_WAITDEVICE };
@@ -165,70 +166,70 @@ static int irda_opts[NR_SOL_IRDA_OPTS] = {
 #define LLC_OPT_PKTINFO LLC_OPT_UNKNOWN
 #endif
 
-#define NR_SOL_LLC_OPTS 9
-static int llc_opts[NR_SOL_LLC_OPTS] = {
+#define NR_SOL_LLC_OPTS ARRAY_SIZE(llc_opts)
+static int llc_opts[] = {
 	LLC_OPT_RETRY, LLC_OPT_SIZE, LLC_OPT_ACK_TMR_EXP, LLC_OPT_P_TMR_EXP,
 	LLC_OPT_REJ_TMR_EXP, LLC_OPT_BUSY_TMR_EXP, LLC_OPT_TX_WIN, LLC_OPT_RX_WIN,
 	LLC_OPT_PKTINFO };
 
-#define NR_SOL_DCCP_OPTS 16
-static int dccp_opts[NR_SOL_DCCP_OPTS] = {
+#define NR_SOL_DCCP_OPTS ARRAY_SIZE(dccp_opts)
+static int dccp_opts[] = {
 	DCCP_SOCKOPT_PACKET_SIZE, DCCP_SOCKOPT_SERVICE, DCCP_SOCKOPT_CHANGE_L, DCCP_SOCKOPT_CHANGE_R,
 	DCCP_SOCKOPT_GET_CUR_MPS, DCCP_SOCKOPT_SERVER_TIMEWAIT, DCCP_SOCKOPT_SEND_CSCOV, DCCP_SOCKOPT_RECV_CSCOV,
 	DCCP_SOCKOPT_AVAILABLE_CCIDS, DCCP_SOCKOPT_CCID, DCCP_SOCKOPT_TX_CCID, DCCP_SOCKOPT_RX_CCID,
 	DCCP_SOCKOPT_QPOLICY_ID, DCCP_SOCKOPT_QPOLICY_TXQLEN, DCCP_SOCKOPT_CCID_RX_INFO, DCCP_SOCKOPT_CCID_TX_INFO };
 
-#define NR_SOL_NETLINK_OPTS 5
-static int netlink_opts[NR_SOL_NETLINK_OPTS] = {
+#define NR_SOL_NETLINK_OPTS ARRAY_SIZE(netlink_opts)
+static int netlink_opts[] = {
 	NETLINK_ADD_MEMBERSHIP, NETLINK_DROP_MEMBERSHIP, NETLINK_PKTINFO, NETLINK_BROADCAST_ERROR,
 	NETLINK_NO_ENOBUFS };
 
-#define NR_SOL_TIPC_OPTS 6
-static int tipc_opts[NR_SOL_TIPC_OPTS] = {
+#define NR_SOL_TIPC_OPTS ARRAY_SIZE(tipc_opts)
+static int tipc_opts[] = {
 	TIPC_IMPORTANCE, TIPC_SRC_DROPPABLE, TIPC_DEST_DROPPABLE, TIPC_CONN_TIMEOUT,
 	TIPC_NODE_RECVQ_DEPTH, TIPC_SOCK_RECVQ_DEPTH };
 
-#define NR_SOL_RXRPC_OPTS 8
-static int rxrpc_opts[NR_SOL_RXRPC_OPTS] = {
+#define NR_SOL_RXRPC_OPTS ARRAY_SIZE(rxrpc_opts)
+static int rxrpc_opts[] = {
 	RXRPC_USER_CALL_ID, RXRPC_ABORT, RXRPC_ACK, RXRPC_NET_ERROR,
 	RXRPC_BUSY, RXRPC_LOCAL_ERROR, RXRPC_NEW_CALL, RXRPC_ACCEPT };
 
-#define NR_SOL_PPPOL2TP_OPTS 5
-static int pppol2tp_opts[NR_SOL_PPPOL2TP_OPTS] = {
+#define NR_SOL_PPPOL2TP_OPTS ARRAY_SIZE(pppol2tp_opts)
+static int pppol2tp_opts[] = {
 	PPPOL2TP_SO_DEBUG, PPPOL2TP_SO_RECVSEQ, PPPOL2TP_SO_SENDSEQ, PPPOL2TP_SO_LNSMODE,
 	PPPOL2TP_SO_REORDERTO };
 
-#define NR_SOL_BLUETOOTH_OPTS 5
-static int bluetooth_opts[NR_SOL_BLUETOOTH_OPTS] = {
+#define NR_SOL_BLUETOOTH_OPTS ARRAY_SIZE(bluetooth_opts)
+static int bluetooth_opts[] = {
 	BT_SECURITY, BT_DEFER_SETUP, BT_FLUSHABLE, BT_POWER,
 	BT_CHANNEL_POLICY };
 
-#define NR_SOL_BLUETOOTH_HCI_OPTS 3
-static int bluetooth_hci_opts[NR_SOL_BLUETOOTH_HCI_OPTS] = {
+#define NR_SOL_BLUETOOTH_HCI_OPTS ARRAY_SIZE(bluetooth_hci_opts)
+static int bluetooth_hci_opts[] = {
 	HCI_DATA_DIR, HCI_FILTER, HCI_TIME_STAMP };
 
-#define NR_SOL_BLUETOOTH_L2CAP_OPTS 2
-static int bluetooth_l2cap_opts[NR_SOL_BLUETOOTH_L2CAP_OPTS] = {
+#define NR_SOL_BLUETOOTH_L2CAP_OPTS ARRAY_SIZE(bluetooth_l2cap_opts)
+static int bluetooth_l2cap_opts[] = {
 	L2CAP_OPTIONS, L2CAP_LM };
 
-#define NR_SOL_BLUETOOTH_RFCOMM_OPTS 2
-static int bluetooth_rfcomm_opts[NR_SOL_BLUETOOTH_RFCOMM_OPTS] = { RFCOMM_LM };
+#define NR_SOL_BLUETOOTH_RFCOMM_OPTS ARRAY_SIZE(bluetooth_rfcomm_opts)
+static int bluetooth_rfcomm_opts[] = { RFCOMM_LM };
 
 #ifdef USE_RDS
-#define NR_SOL_RDS_OPTS 7
-static int rds_opts[NR_SOL_RDS_OPTS] = {
+#define NR_SOL_RDS_OPTS ARRAY_SIZE(rds_opts)
+static int rds_opts[] = {
 	RDS_CANCEL_SENT_TO, RDS_GET_MR, RDS_FREE_MR,
 	4, /* deprecated RDS_BARRIER 4 */
 	RDS_RECVERR, RDS_CONG_MONITOR, RDS_GET_MR_FOR_DEST };
 #endif
 
-#define NR_SOL_IUCV_OPTS 3
-static int iucv_opts[NR_SOL_IUCV_OPTS] = {
+#define NR_SOL_IUCV_OPTS ARRAY_SIZE(iucv_opts)
+static int iucv_opts[] = {
 	SO_IPRMDATA_MSG, SO_MSGLIMIT, SO_MSGSIZE };
 
 #ifdef USE_CAIF
-#define NR_SOL_CAIF_OPTS 2
-static int caif_opts[NR_SOL_CAIF_OPTS] = {
+#define NR_SOL_CAIF_OPTS ARRAY_SIZE(caif_opts)
+static int caif_opts[] = {
 	CAIFSO_LINK_SELECT, CAIFSO_REQ_PARAM };
 #endif
 
-- 
1.8.1.4
