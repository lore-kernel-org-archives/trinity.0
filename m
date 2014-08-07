From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH v2] trinity: add connection support for AF_INET and AF_INET6
Date: Thu,  7 Aug 2014 16:56:38 +0800
Message-ID: <1407401798-18437-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=kkcuik3x8omuQMsSP+o7sSrP1v5ggGx9f7geOE5m0dU=;
        b=s9zmG2/a8GdEXmZ0DjPvHAG/i6O78RE8ikbdzs+fQq60hiWdxxDpybiECa4yefE5Ba
         G4l1QgWA4XT6PDPdIHYm/1jH7fhhgY4GkShAwrNLh0ivrbMEUVXVNp0zwwh7A169Da9d
         C6jQHBvPjdVmBI7+w55JS0fx/KA7lK6C/fuKI/fA3fvxKKuJ6+8tkODjKYiF9ktRW/Lr
         xBfi+CDQ9HxDWMNvzju7j+r0/XgHTBCQbWYmuglpXNydHBAZHaxA5hXjkEYrqC47Q5bN
         E5uPH5rZS511eWHuoTOwZ6SSUfgVF3uIZ7wGd77ldw8nVPFS90FeVvUOF4A/rdviAmhK
         yRFQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Trinity <trinity@vger.kernel.org>
Cc: Daniel Borkmann <dborkman@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>

Trinity is a syscall fuzz tool for local host testing. But it would also be
very useful to fuzz during established sessions over the network. This patch
add simple connection ability for IPv4/IPv6 so user can use it as a
client/server and simulate as a real environment.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net.h    |  2 ++
 include/params.h |  3 +++
 net/proto-ipv4.c | 13 +++++++++++++
 net/proto-ipv6.c | 14 ++++++++++++++
 params.c         | 25 +++++++++++++++++++++----
 5 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/net.h b/include/net.h
index 15c51a6..d7a0f0f 100644
--- a/include/net.h
+++ b/include/net.h
@@ -13,6 +13,8 @@ extern unsigned int nr_sockets;
 /* protocol decoding */
 extern unsigned int specific_proto;
 
+extern int server_port;
+extern char server_addr[INET6_ADDRSTRLEN];
 
 /* glibc headers might be older than the kernel, so chances are we know
  * about more protocols than glibc does. So we define our own PF_MAX */
diff --git a/include/params.h b/include/params.h
index 2ee0f7b..40d213e 100644
--- a/include/params.h
+++ b/include/params.h
@@ -52,3 +52,6 @@ extern unsigned int kernel_taint_mask;
 extern bool kernel_taint_param_occured;
 
 extern unsigned int user_specified_children;
+
+extern int server_port;
+extern char server_addr[INET6_ADDRSTRLEN];
diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index 8babe6d..976197f 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -85,12 +85,25 @@ in_addr_t random_ipv4_address(void)
 void ipv4_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 {
 	struct sockaddr_in *ipv4;
+	struct in_addr serv_addr;
 
 	ipv4 = zmalloc(sizeof(struct sockaddr_in));
 
 	ipv4->sin_family = PF_INET;
 	ipv4->sin_addr.s_addr = random_ipv4_address();
 	ipv4->sin_port = htons(rand() % 65535);
+
+	/* Client side if we supplied server_addr */
+	if (inet_pton(PF_INET, server_addr, &serv_addr) == 1)
+		ipv4->sin_addr = serv_addr;
+	/* Server side if we supplied port without addr, so listen on INADDR_ANY */
+	else if (server_port != 0)
+		ipv4->sin_addr.s_addr = htonl(INADDR_ANY);
+
+	/* Fuzz from port to (port + 100) if supplied */
+	if (server_port != 0)
+		ipv4->sin_port = htons(server_port + rand() % 100);
+
 	*addr = (struct sockaddr *) ipv4;
 	*addrlen = sizeof(struct sockaddr_in);
 }
diff --git a/net/proto-ipv6.c b/net/proto-ipv6.c
index 16bceb3..bf62897 100644
--- a/net/proto-ipv6.c
+++ b/net/proto-ipv6.c
@@ -5,6 +5,7 @@
 #include <linux/if.h>
 #include <linux/if_arp.h>
 #include <linux/if_packet.h>
+#include <arpa/inet.h>
 #include <stdlib.h>
 #include "net.h"
 #include "random.h"
@@ -14,6 +15,7 @@
 void ipv6_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 {
 	struct sockaddr_in6 *ipv6;
+	struct in6_addr serv_addr;
 
 	ipv6 = zmalloc(sizeof(struct sockaddr_in6));
 
@@ -23,6 +25,18 @@ void ipv6_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 	ipv6->sin6_addr.s6_addr32[2] = 0;
 	ipv6->sin6_addr.s6_addr32[3] = htonl(1);
 	ipv6->sin6_port = htons(rand() % 65535);
+
+	/* Client side if we supplied server_addr */
+	if (inet_pton(PF_INET6, server_addr, &serv_addr) == 1)
+		ipv6->sin6_addr = serv_addr;
+	/* Server side if we supplied port without addr, so listen on in6addr_any */
+	else if (server_port != 0)
+		ipv6->sin6_addr = in6addr_any;
+
+	/* Fuzz from port to (port + 100) if supplied */
+	if (server_port != 0)
+		ipv6->sin6_port = htons(server_port + rand() % 100);
+
 	*addr = (struct sockaddr *) ipv6;
 	*addrlen = sizeof(struct sockaddr_in6);
 }
diff --git a/params.c b/params.c
index df702e3..c8eef3a 100644
--- a/params.c
+++ b/params.c
@@ -57,6 +57,9 @@ char *victim_path = NULL;
 unsigned int kernel_taint_mask = 0xFFFFFFFF;
 bool kernel_taint_param_occured = FALSE;
 
+int server_port = 0;
+char server_addr[INET6_ADDRSTRLEN] = "\0";
+
 static void usage(void)
 {
 	outputerr("%s\n", progname);
@@ -77,6 +80,8 @@ static void usage(void)
 	outputerr(" --no_proto,-E: specify network protocols to be excluded from testing.\n");
 	outputerr(" --quiet,-q: less output.\n");
 	outputerr(" --random,-r#: pick N syscalls at random and just fuzz those\n");
+	outputerr(" --server_addr: supply an IPv4 or IPv6 address to connect, no need for server side.\n");
+	outputerr(" --server_port: supply an server port to listen or connect, will fuzz between port to (port + 100)\n");
 	outputerr(" --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
 	outputerr(" --verbose,-v: increase output verbosity.\n");
 	outputerr(" --victims,-V: path to victim files.\n");
@@ -110,6 +115,8 @@ static const struct option longopts[] = {
 	{ "proto", required_argument, NULL, 'P' },
 	{ "quiet", no_argument, NULL, 'q' },
 	{ "random", required_argument, NULL, 'r' },
+	{ "server_addr", required_argument, NULL, 0 },
+	{ "server_port", required_argument, NULL, 0 },
 	{ "syslog", no_argument, NULL, 'S' },
 	{ "verbose", no_argument, NULL, 'v' },
 	{ "victims", required_argument, NULL, 'V' },
@@ -118,8 +125,9 @@ static const struct option longopts[] = {
 void parse_args(int argc, char *argv[])
 {
 	int opt;
+	int opt_index = 0;
 
-	while ((opt = getopt_long(argc, argv, paramstr, longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, paramstr, longopts, &opt_index)) != -1) {
 		switch (opt) {
 		default:
 			if (opt == '?')
@@ -128,9 +136,6 @@ void parse_args(int argc, char *argv[])
 				outputstd("opt:%c\n", opt);
 			return;
 
-		case '\0':
-			return;
-
 		case 'b':
 			init_bdev_list();
 			process_bdev_param(optarg);
@@ -294,6 +299,18 @@ void parse_args(int argc, char *argv[])
 		case 'X':
 			dropprivs = TRUE;
 			break;
+
+		case 0:
+			/*
+			 * FIXME: It's really hard to find two reasonable short
+			 * names since S s P p all have been used. Use long
+			 * options before we fix this issue.
+			*/
+			if (strcmp("server_addr", longopts[opt_index].name) == 0)
+				strcpy(server_addr, optarg);
+			if (strcmp("server_port", longopts[opt_index].name) == 0)
+				server_port = atoi(optarg);
+			break;
 		}
 	}
 	if (quiet_level > MAX_LOGLEVEL)
-- 
1.9.3
