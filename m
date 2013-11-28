From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Fixes bug with incorrect casting of on stackvariable to a
 pointer.
Date: Wed, 27 Nov 2013 16:30:16 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311271621580.18300@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=7oD5v88sXnS2lZUaRLqG/8UyFZpMOj28P2+MiS/MNMU=;
        b=oN5aq39mqm5ibAgNZXupnkjZFQUkEoS7hNPIS6KmvDRJCdcHtN0gv+q7MCj4gB7qB1
         VxBDRsB5iCitpja9SFicGU1RwVrEOERyPtpS870EEh6yA9hNfrJ4GJyJVZlslNFslrpM
         R7eq1rLo8XilDtDpiNr9ImmWZljGJDHSTtVn1jvTzqwPO3p0EBhYAheOcqvqPLHjxwgE
         bD/MjGABi0Cp7LRSOi7XxsUnEIdZfHtmCwJXDKqUoKEH40XZ5TO0a2oDs18iVnLH2AZN
         0zHziE60amY6m9ExkQau9IR7EKMAjUz8l3kE9s2By8jhrZ1dVcWdIBBT+RxqAHsteVSL
         p5mA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch fixes a bug in open_socket function with sa variable of type 
struct sockaddr. In particular, this variable is alloctaed on stack, and 
then address to it is passed to specific functions that allocate memory 
and overwrite the content of sa with the address of the newly allocated 
object, but not with the values that were assigned to the object. Thus, 4 
or 8 first bytes of the sa struct are always initialized with an 
address of newly allocated object.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 generic-sanitise.c |  2 +-
 include/net.h      | 50 +++++++++++++++++++++++++-------------------------
 net/alg.c          |  4 ++--
 net/appletalk.c    |  4 ++--
 net/atm.c          |  8 ++++----
 net/ax25.c         |  4 ++--
 net/bpf.c          |  4 ++--
 net/caif.c         |  4 ++--
 net/can.c          |  4 ++--
 net/decnet.c       |  4 ++--
 net/econet.c       |  4 ++--
 net/ipv4.c         |  4 ++--
 net/ipv6.c         |  4 ++--
 net/ipx.c          |  4 ++--
 net/irda.c         |  4 ++--
 net/llc.c          |  4 ++--
 net/netlink.c      |  4 ++--
 net/nfc.c          |  4 ++--
 net/packet.c       |  4 ++--
 net/phonet.c       |  4 ++--
 net/pppox.c        | 10 +++++-----
 net/rose.c         |  4 ++--
 net/sockaddr.c     |  4 ++--
 net/tipc.c         |  4 ++--
 net/unix.c         |  4 ++--
 net/x25.c          |  4 ++--
 sockets.c          |  8 +++++---
 syscalls/prctl.c   |  9 ++++++---
 28 files changed, 90 insertions(+), 85 deletions(-)

diff --git a/generic-sanitise.c b/generic-sanitise.c
index d6f5ab3..a4aa73e 100644
--- a/generic-sanitise.c
+++ b/generic-sanitise.c
@@ -247,7 +247,7 @@ static unsigned long handle_arg_sockaddr(int childno, unsigned long call, unsign
 {
 	unsigned long sockaddr = 0, sockaddrlen = 0;
 
-	generate_sockaddr(&sockaddr, &sockaddrlen, PF_NOHINT);
+	generate_sockaddr((unsigned long **)&sockaddr, &sockaddrlen, PF_NOHINT);
 
 	switch (argnum) {
 	case 1:	if (syscalls[call].entry->arg2type == ARG_SOCKADDRLEN)
diff --git a/include/net.h b/include/net.h
index 005d0fe..684bd7e 100644
--- a/include/net.h
+++ b/include/net.h
@@ -40,7 +40,7 @@ struct socketinfo {
 void open_sockets(void);
 void close_sockets(void);
 
-void generate_sockaddr(unsigned long *addr, unsigned long *addrlen, int pf);
+void generate_sockaddr(unsigned long **addr, unsigned long *addrlen, int pf);
 
 void sso_socket(struct socket_triplet *triplet, struct sockopt *so, int fd);
 
@@ -53,109 +53,109 @@ int get_random_ether_type(void);
 
 /* ipv4 */
 in_addr_t random_ipv4_address(void);
-void ipv4_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void ipv4_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void inet_rand_socket(struct socket_triplet *st);
 void ip_setsockopt(struct sockopt *so);
 
 /* ipv6 */
-void ipv6_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void ipv6_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void inet6_rand_socket(struct socket_triplet *st);
 void inet6_setsockopt(struct sockopt *so);
 
 /* pppox */
-void pppox_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void pppox_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void pppol2tp_setsockopt(struct sockopt *so);
 
 /* unix */
-void unix_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void unix_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void unix_rand_socket(struct socket_triplet *st);
 
 /* bpf */
 void gen_bpf(unsigned long *addr, unsigned long *addrlen);
-void gen_seccomp_bpf(unsigned long *addr, unsigned long *addrlen);
+void gen_seccomp_bpf(unsigned long **addr, unsigned long *addrlen);
 
 /* caif */
-void caif_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void caif_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void caif_rand_socket(struct socket_triplet *st);
 void caif_setsockopt(struct sockopt *so);
 
 /* alg */
-void alg_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void alg_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void alg_setsockopt(struct sockopt *so);
 
 /* nfc */
-void nfc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void nfc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void nfc_rand_socket(struct socket_triplet *st);
 void nfc_setsockopt(struct sockopt *so);
 
 /* ax25 */
-void ax25_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void ax25_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void ax25_rand_socket(struct socket_triplet *st);
 void ax25_setsockopt(struct sockopt *so);
 
 /* ipx */
-void ipx_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void ipx_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void ipx_rand_socket(struct socket_triplet *st);
 void ipx_setsockopt(struct sockopt *so);
 
 /* appletalk */
-void atalk_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void atalk_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void atalk_rand_socket(struct socket_triplet *st);
 void atalk_setsockopt(struct sockopt *so);
 
 /* atm */
-void atmpvc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
-void atmsvc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void atmpvc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
+void atmsvc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void atm_setsockopt(struct sockopt *so);
 
 /* x25 */
-void x25_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void x25_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void x25_rand_socket(struct socket_triplet *st);
 void x25_setsockopt(struct sockopt *so);
 
 /* rose */
-void rose_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void rose_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void rose_setsockopt(struct sockopt *so);
 
 /* decnet */
-void decnet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void decnet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void decnet_rand_socket(struct socket_triplet *st);
 void decnet_setsockopt(struct sockopt *so);
 
 /* llc */
-void llc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void llc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void llc_rand_socket(struct socket_triplet *st);
 void llc_setsockopt(struct sockopt *so);
 
 /* netlink */
-void netlink_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void netlink_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void netlink_rand_socket(struct socket_triplet *st);
 void netlink_setsockopt(struct sockopt *so);
 
 /* packet */
-void packet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void packet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void packet_rand_socket(struct socket_triplet *st);
 void packet_setsockopt(struct sockopt *so);
 
 /* econet */
-void econet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void econet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 
 /* irda */
-void irda_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void irda_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void irda_rand_socket(struct socket_triplet *st);
 void irda_setsockopt(struct sockopt *so);
 
 /* can */
-void can_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void can_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void can_rand_socket(struct socket_triplet *st);
 
 /* tipc */
-void tipc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void tipc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void tipc_rand_socket(struct socket_triplet *st);
 void tipc_setsockopt(struct sockopt *so);
 
 /* phonet */
-void phonet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen);
+void phonet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen);
 void phonet_rand_socket(struct socket_triplet *st);
 
 /* rds */
diff --git a/net/alg.c b/net/alg.c
index 86cdb66..e34521d 100644
--- a/net/alg.c
+++ b/net/alg.c
@@ -10,7 +10,7 @@
 #ifdef USE_IF_ALG
 #include <linux/if_alg.h>
 
-void alg_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void alg_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_alg *alg;
 	unsigned int i;
@@ -26,7 +26,7 @@ void alg_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	alg->salg_mask = rand();
 	for (i = 0; i < 64; i++)
 		alg->salg_name[i] = rand();
-	*addr = (unsigned long) alg;
+	*addr = (unsigned long *) alg;
 	*addrlen = sizeof(struct sockaddr_alg);
 }
 
diff --git a/net/appletalk.c b/net/appletalk.c
index 926dcb9..517e397 100644
--- a/net/appletalk.c
+++ b/net/appletalk.c
@@ -7,7 +7,7 @@
 #include "random.h"
 #include "net.h"
 
-void atalk_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void atalk_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_at *atalk;
 
@@ -19,7 +19,7 @@ void atalk_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	atalk->sat_port = rand();
 	atalk->sat_addr.s_net = rand();
 	atalk->sat_addr.s_node = rand();
-	*addr = (unsigned long) atalk;
+	*addr = (unsigned long*) atalk;
 	*addrlen = sizeof(struct sockaddr_at);
 }
 
diff --git a/net/atm.c b/net/atm.c
index 8b489f6..3e25d42 100644
--- a/net/atm.c
+++ b/net/atm.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include "net.h"
 
-void atmpvc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void atmpvc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_atmpvc *atmpvc;
 
@@ -18,11 +18,11 @@ void atmpvc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	atmpvc->sap_addr.itf = rand();
 	atmpvc->sap_addr.vpi = rand();
 	atmpvc->sap_addr.vci = rand();
-	*addr = (unsigned long) atmpvc;
+	*addr = (unsigned long *) atmpvc;
 	*addrlen = sizeof(struct sockaddr_atmpvc);
 }
 
-void atmsvc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void atmsvc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_atmsvc *atmsvc;
 	unsigned int i;
@@ -38,6 +38,6 @@ void atmsvc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 		atmsvc->sas_addr.pub[i] = rand();
 	atmsvc->sas_addr.lij_type = rand();
 	atmsvc->sas_addr.lij_id = rand();
-	*addr = (unsigned long) atmsvc;
+	*addr = (unsigned long *) atmsvc;
 	*addrlen = sizeof(struct sockaddr_atmsvc);
 }
diff --git a/net/ax25.c b/net/ax25.c
index 33e4c79..0901bdd 100644
--- a/net/ax25.c
+++ b/net/ax25.c
@@ -8,7 +8,7 @@
 #include "net.h"
 #include "random.h"
 
-void ax25_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void ax25_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_ax25 *ax25;
 
@@ -19,7 +19,7 @@ void ax25_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	ax25->sax25_family = PF_AX25;
 	memcpy(ax25->sax25_call.ax25_call, page_rand, 7);
 	ax25->sax25_ndigis = rand();
-	*addr = (unsigned long) ax25;
+	*addr = (unsigned long *) ax25;
 	*addrlen = sizeof(struct sockaddr_ax25);
 }
 
diff --git a/net/bpf.c b/net/bpf.c
index 198f8e1..a945a5e 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -316,7 +316,7 @@ static int seccomp_choose(const float probs[__STATE_GEN_MAX])
 	return -1;
 }
 
-void gen_seccomp_bpf(unsigned long *addr, unsigned long *addrlen)
+void gen_seccomp_bpf(unsigned long **addr, unsigned long *addrlen)
 {
 	int avail, used;
 	struct sock_filter *curr;
@@ -350,7 +350,7 @@ void gen_seccomp_bpf(unsigned long *addr, unsigned long *addrlen)
 	}
 
 	if (addrlen != NULL) {
-		*addr = (unsigned long) bpf;
+		*addr = (unsigned long *) bpf;
 		*addrlen = sizeof(struct sock_fprog);
 	}
 }
diff --git a/net/caif.c b/net/caif.c
index 9385727..6816a8a 100644
--- a/net/caif.c
+++ b/net/caif.c
@@ -11,7 +11,7 @@
 #ifdef USE_CAIF
 #include <linux/caif/caif_socket.h>
 
-void caif_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void caif_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_caif *caif;
 	unsigned int i;
@@ -31,7 +31,7 @@ void caif_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 		caif->u.rfm.volume[i] = rand();
 	caif->u.dbg.type = rand();
 	caif->u.dbg.service = rand();
-	*addr = (unsigned long) caif;
+	*addr = (unsigned long *) caif;
 	*addrlen = sizeof(struct sockaddr_caif);
 }
 
diff --git a/net/can.c b/net/can.c
index 7322f3e..b88ded6 100644
--- a/net/can.c
+++ b/net/can.c
@@ -8,7 +8,7 @@
 #include "random.h"
 #include "compat.h"
 
-void can_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void can_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_can *can;
 
@@ -19,7 +19,7 @@ void can_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	can->can_ifindex = rand();
 	can->can_addr.tp.rx_id = rand();
 	can->can_addr.tp.tx_id = rand();
-	*addr = (unsigned long) can;
+	*addr = (unsigned long *) can;
 	*addrlen = sizeof(struct sockaddr_can);
 }
 
diff --git a/net/decnet.c b/net/decnet.c
index 6530695..e3ad649 100644
--- a/net/decnet.c
+++ b/net/decnet.c
@@ -7,7 +7,7 @@
 #include "net.h"
 #include "random.h"
 
-void decnet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void decnet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_dn *dn;
 	unsigned int i;
@@ -25,7 +25,7 @@ void decnet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	dn->sdn_add.a_len = rand() % 2;
 	dn->sdn_add.a_addr[0] = rand();
 	dn->sdn_add.a_addr[1] = rand();
-	*addr = (unsigned long) dn;
+	*addr = (unsigned long *) dn;
 	*addrlen = sizeof(struct sockaddr_dn);
 }
 
diff --git a/net/econet.c b/net/econet.c
index 5e51d74..2f508db 100644
--- a/net/econet.c
+++ b/net/econet.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include "net.h"
 
-void econet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void econet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_ec *ec;
 
@@ -21,6 +21,6 @@ void econet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	ec->addr.station = rand();
 	ec->addr.net = rand();
 	ec->cookie = rand();
-	*addr = (unsigned long) ec;
+	*addr = (unsigned long *) ec;
 	*addrlen = sizeof(struct sockaddr_ec);
 }
diff --git a/net/ipv4.c b/net/ipv4.c
index 2f25ca9..4f78501 100644
--- a/net/ipv4.c
+++ b/net/ipv4.c
@@ -57,7 +57,7 @@ in_addr_t random_ipv4_address(void)
 	return htonl(addr);
 }
 
-void ipv4_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void ipv4_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_in *ipv4;
 
@@ -68,7 +68,7 @@ void ipv4_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	ipv4->sin_family = PF_INET;
 	ipv4->sin_addr.s_addr = random_ipv4_address();
 	ipv4->sin_port = rand() % 65535;
-	*addr = (unsigned long) ipv4;
+	*addr = (unsigned long *) ipv4;
 	*addrlen = sizeof(struct sockaddr_in);
 }
 
diff --git a/net/ipv6.c b/net/ipv6.c
index 7f12240..3719f8f 100644
--- a/net/ipv6.c
+++ b/net/ipv6.c
@@ -9,7 +9,7 @@
 #include "net.h"
 #include "random.h"
 
-void ipv6_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void ipv6_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_in6 *ipv6;
 
@@ -23,7 +23,7 @@ void ipv6_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	ipv6->sin6_addr.s6_addr32[2] = 0;
 	ipv6->sin6_addr.s6_addr32[3] = htonl(1);
 	ipv6->sin6_port = rand() % 65535;
-	*addr = (unsigned long) ipv6;
+	*addr = (unsigned long *) ipv6;
 	*addrlen = sizeof(struct sockaddr_in6);
 }
 
diff --git a/net/ipx.c b/net/ipx.c
index 994f578..3148c1c 100644
--- a/net/ipx.c
+++ b/net/ipx.c
@@ -7,7 +7,7 @@
 #include "net.h"
 #include "random.h"
 
-void ipx_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void ipx_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_ipx *ipx;
 	unsigned int i;
@@ -23,7 +23,7 @@ void ipx_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 		ipx->sipx_node[i] = rand();
 	ipx->sipx_type = rand();
 	ipx->sipx_zero = rand_bool();
-	*addr = (unsigned long) ipx;
+	*addr = (unsigned long *) ipx;
 	*addrlen = sizeof(struct sockaddr_ipx);
 }
 
diff --git a/net/irda.c b/net/irda.c
index 5bd44f1..8598be6 100644
--- a/net/irda.c
+++ b/net/irda.c
@@ -7,7 +7,7 @@
 #include "net.h"
 #include "random.h"
 
-void irda_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void irda_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_irda *irda;
 	unsigned int i;
@@ -21,7 +21,7 @@ void irda_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	irda->sir_addr = rand();
 	for (i = 0; i < 25; i++)
 		irda->sir_name[i] = rand();
-	*addr = (unsigned long) irda;
+	*addr = (unsigned long *) irda;
 	*addrlen = sizeof(struct sockaddr_irda);
 }
 
diff --git a/net/llc.c b/net/llc.c
index 3bd9b60..20f9fe3 100644
--- a/net/llc.c
+++ b/net/llc.c
@@ -9,7 +9,7 @@
 #include "net.h"
 #include "random.h"
 
-void llc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void llc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_llc *llc;
 	unsigned int i;
@@ -25,7 +25,7 @@ void llc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	llc->sllc_sap = rand();
 	for (i = 0; i < IFHWADDRLEN; i++)
 		llc->sllc_mac[i] = rand();
-	*addr = (unsigned long) llc;
+	*addr = (unsigned long *) llc;
 	*addrlen = sizeof(struct sockaddr_llc);
 }
 
diff --git a/net/netlink.c b/net/netlink.c
index de017fb..254c1bb 100644
--- a/net/netlink.c
+++ b/net/netlink.c
@@ -20,7 +20,7 @@
 	#endif /* NETLINK_RDMA */
 #endif /* NETLINK_CRYPTO */
 
-void netlink_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void netlink_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_nl *nl;
 
@@ -31,7 +31,7 @@ void netlink_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	nl->nl_family = PF_NETLINK;
 	nl->nl_pid = get_pid();
 	nl->nl_groups = rand32();
-	*addr = (unsigned long) nl;
+	*addr = (unsigned long *) nl;
 	*addrlen = sizeof(struct sockaddr_nl);
 }
 
diff --git a/net/nfc.c b/net/nfc.c
index e2e5dc5..17a9933 100644
--- a/net/nfc.c
+++ b/net/nfc.c
@@ -8,7 +8,7 @@
 #include "net.h"
 #include "random.h"
 
-void nfc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void nfc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_nfc *nfc;
 
@@ -21,7 +21,7 @@ void nfc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	nfc->dev_idx = rand();
 	nfc->target_idx = rand();
 	nfc->nfc_protocol = rand() % 5;
-	*addr = (unsigned long) nfc;
+	*addr = (unsigned long *) nfc;
 	*addrlen = sizeof(struct sockaddr_nfc);
 }
 
diff --git a/net/packet.c b/net/packet.c
index 51bcf6a..a7f1f1c 100644
--- a/net/packet.c
+++ b/net/packet.c
@@ -8,7 +8,7 @@
 #include "net.h"
 #include "random.h"
 
-void packet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void packet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_pkt *pkt;
 	unsigned int i;
@@ -21,7 +21,7 @@ void packet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	pkt->spkt_family = PF_PACKET;
 	for (i = 0; i < 14; i++)
 		pkt->spkt_device[i] = rand();
-	*addr = (unsigned long) pkt;
+	*addr = (unsigned long *) pkt;
 	*addrlen = sizeof(struct sockaddr_pkt);
 }
 
diff --git a/net/phonet.c b/net/phonet.c
index 79d20a6..728316e 100644
--- a/net/phonet.c
+++ b/net/phonet.c
@@ -7,7 +7,7 @@
 #include "net.h"
 #include "random.h"
 
-void phonet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void phonet_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_pn *pn;
 
@@ -19,7 +19,7 @@ void phonet_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	pn->spn_obj = rand();
 	pn->spn_dev = rand();
 	pn->spn_resource = rand();
-	*addr = (unsigned long) pn;
+	*addr = (unsigned long *) pn;
 	*addrlen = sizeof(struct sockaddr_pn);
 }
 
diff --git a/net/pppox.c b/net/pppox.c
index 11d9098..d898353 100644
--- a/net/pppox.c
+++ b/net/pppox.c
@@ -12,7 +12,7 @@
 
 //TODO: Split out each case into separate function.
 
-void pppox_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void pppox_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_pppox *pppox;
 	struct sockaddr_pppol2tp *pppol2tp;
@@ -42,7 +42,7 @@ void pppox_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 		pppox->sa_addr.pptp.sin_addr.s_addr = random_ipv4_address();
 #endif
 
-		*addr = (unsigned long) pppox;
+		*addr = (unsigned long *) pppox;
 		*addrlen = sizeof(struct sockaddr_pppox);
 		break;
 
@@ -63,7 +63,7 @@ void pppox_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 			pppol2tp->pppol2tp.s_session = rand();
 			pppol2tp->pppol2tp.d_tunnel = rand();
 			pppol2tp->pppol2tp.d_session = rand();
-			*addr = (unsigned long) pppol2tp;
+			*addr = (unsigned long *) pppol2tp;
 			*addrlen = sizeof(struct sockaddr_pppol2tp);
 			break;
 
@@ -92,7 +92,7 @@ void pppox_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 			pppol2tpin6->pppol2tp.addr.sin6_addr.s6_addr32[2] = 0;
 			pppol2tpin6->pppol2tp.addr.sin6_addr.s6_addr32[3] = htonl(1);
 			pppol2tpin6->pppol2tp.addr.sin6_scope_id = rand();
-			*addr = (unsigned long) pppol2tpin6;
+			*addr = (unsigned long *) pppol2tpin6;
 			*addrlen = sizeof(struct sockaddr_pppol2tpin6);
 			}
 #endif
@@ -116,7 +116,7 @@ void pppox_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 			pppol2tpv3->pppol2tp.s_session = rand();
 			pppol2tpv3->pppol2tp.d_tunnel = rand();
 			pppol2tpv3->pppol2tp.d_session = rand();
-			*addr = (unsigned long) pppol2tpv3;
+			*addr = (unsigned long *) pppol2tpv3;
 			*addrlen = sizeof(struct sockaddr_pppol2tpv3);
 			}
 #endif
diff --git a/net/rose.c b/net/rose.c
index 8e36799..a38bd81 100644
--- a/net/rose.c
+++ b/net/rose.c
@@ -8,7 +8,7 @@
 #include "maps.h"	// page_rand
 #include "net.h"
 
-void rose_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void rose_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_rose *rose;
 
@@ -29,6 +29,6 @@ void rose_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 
 	memcpy(rose->srose_digi.ax25_call, page_rand + 7, 7);
 
-	*addr = (unsigned long) rose;
+	*addr = (unsigned long *) rose;
 	*addrlen = sizeof(struct sockaddr_rose);
 }
diff --git a/net/sockaddr.c b/net/sockaddr.c
index ce0f4a4..409483f 100644
--- a/net/sockaddr.c
+++ b/net/sockaddr.c
@@ -13,7 +13,7 @@
 
 struct sa_func_entry {
 	unsigned int pf;
-	void (*func)(unsigned long *addr, unsigned long *addrlen);
+	void (*func)(unsigned long **addr, unsigned long *addrlen);
 };
 
 static const struct sa_func_entry sa_funcs[] = {
@@ -62,7 +62,7 @@ static const struct sa_func_entry sa_funcs[] = {
 //TODO	{ .pf = PF_VSOCK, .func = &vsock_gen_sockaddr },
 };
 
-void generate_sockaddr(unsigned long *addr, unsigned long *addrlen, int pf)
+void generate_sockaddr(unsigned long **addr, unsigned long *addrlen, int pf)
 {
 	unsigned int i;
 
diff --git a/net/tipc.c b/net/tipc.c
index a6bfb69..105cabf 100644
--- a/net/tipc.c
+++ b/net/tipc.c
@@ -7,7 +7,7 @@
 #include "net.h"
 #include "random.h"
 
-void tipc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void tipc_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_tipc *tipc;
 
@@ -25,7 +25,7 @@ void tipc_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	tipc->addr.name.name.type = rand();
 	tipc->addr.name.name.instance = rand();
 	tipc->addr.name.domain = rand();
-	*addr = (unsigned long) tipc;
+	*addr = (unsigned long *) tipc;
 	*addrlen = sizeof(struct sockaddr_tipc);
 }
 
diff --git a/net/unix.c b/net/unix.c
index 74576fb..7855982 100644
--- a/net/unix.c
+++ b/net/unix.c
@@ -7,7 +7,7 @@
 #include "maps.h"
 #include "net.h"
 
-void unix_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void unix_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_un *unixsock;
 	unsigned int len;
@@ -20,7 +20,7 @@ void unix_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	len = rand() % 20;
 	memset(&page_rand[len], 0, 1);
 	strncpy(unixsock->sun_path, page_rand, len);
-	*addr = (unsigned long) unixsock;
+	*addr = (unsigned long *) unixsock;
 	*addrlen = sizeof(struct sockaddr_un);
 }
 
diff --git a/net/x25.c b/net/x25.c
index 26c8888..1ccf411 100644
--- a/net/x25.c
+++ b/net/x25.c
@@ -7,7 +7,7 @@
 #include "net.h"
 #include "maps.h"	// page_rand
 
-void x25_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
+void x25_gen_sockaddr(unsigned long **addr, unsigned long *addrlen)
 {
 	struct sockaddr_x25 *x25;
 	unsigned int len;
@@ -20,7 +20,7 @@ void x25_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 	len = rand() % 15;
 	memset(&page_rand[len], 0, 1);
 	strncpy(x25->sx25_addr.x25_addr, page_rand, len);
-	*addr = (unsigned long) x25;
+	*addr = (unsigned long *) x25;
 	*addrlen = sizeof(struct sockaddr_x25);
 }
 
diff --git a/sockets.c b/sockets.c
index 339cca7..d0b018e 100644
--- a/sockets.c
+++ b/sockets.c
@@ -28,7 +28,7 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
 {
 	int fd;
 	__unused__ int ret;
-	struct sockaddr sa;
+	struct sockaddr *sa = NULL;
 	socklen_t salen;
 	struct sockopt so = { 0, 0, 0, 0 };
 
@@ -52,9 +52,9 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
 	/* Sometimes, listen on created sockets. */
 	if (rand_bool()) {
 		/* fake a sockaddr. */
-		generate_sockaddr((unsigned long *) &sa, (unsigned long *) &salen, domain);
+		generate_sockaddr((unsigned long **) &sa, (unsigned long *) &salen, domain);
 
-		ret = bind(fd, &sa, salen);
+		ret = bind(fd, sa, salen);
 /*		if (ret == -1)
 			debugf("bind: %s\n", strerror(errno));
 		else
@@ -67,6 +67,8 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
 			debugf("listen: success!\n");
 */
 	}
+        if (sa != NULL)
+          free(sa);
 
 	return fd;
 }
diff --git a/syscalls/prctl.c b/syscalls/prctl.c
index 3a09297..e052f8d 100644
--- a/syscalls/prctl.c
+++ b/syscalls/prctl.c
@@ -10,6 +10,7 @@
 #include <linux/seccomp.h>
 #endif
 #include <sys/prctl.h>
+#include <sys/socket.h>
 
 #include "sanitise.h"
 #include "net.h"
@@ -32,6 +33,7 @@ static int prctl_opts[NR_PRCTL_OPTS] = {
 void sanitise_prctl(int childno)
 {
 	int option = prctl_opts[rand() % NR_PRCTL_OPTS];
+	struct sockaddr *saddr = NULL;
 
 // For now, just do SECCOMP, the other options need some attention.
 option = PR_SET_SECCOMP;
@@ -44,10 +46,11 @@ option = PR_SET_SECCOMP;
 	case PR_SET_SECCOMP:
 #ifdef USE_SECCOMP
 //		if (rand() % 3 == SECCOMP_MODE_FILTER) {
-			gen_seccomp_bpf((unsigned long *) page_rand, NULL);
-
+// FIXME: This leaks memory, but needs to be cleared
+// after the syscall is done.
+			gen_seccomp_bpf((unsigned long **) saddr, NULL);
 			shm->a2[childno] = SECCOMP_MODE_FILTER;
-			shm->a3[childno] = (unsigned long) page_rand;
+			shm->a3[childno] = (unsigned long) saddr;
 //		}
 #endif
 		break;
-- 
1.8.4.1
