From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH v2] net: add inet/inet6 rand_socket sctp support
Date: Fri,  1 Aug 2014 09:57:14 +0800
Message-ID: <1406858234-25290-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=F6dODA450x4s8bd5K2pAD8TWs8cUd3HVsTAevHMMldM=;
        b=EMB8MxsZVxlpT3WM/7MPef+IOvzFx7QYFqsBgLWfbioz+2tEEixAFH+L5gKuruISD4
         W1GxTX2H6+ravdVRgIq9CnMeACORjSz+cTLODn7Q5vSzv4zByyQsGuiMW3ugYyzdBKOK
         ke6L2PpBCx6KQVPIlgWLPb8FKqCtoY4Wq6lK6D5B1+Q07aPFB46rEzGEK36/RZUtU1Zc
         DMN+KNu3qUyujC/jINDi9VQ3NwUZxPDepCEmZbb3JhA4PFCTQnUBGPdrA96MWYOi92KJ
         Phx69q5dF4hFvWT9D4euAiHkxTDyFYJdPCv+eTPm+RLmWvqb2nFB3VnTQBvv/NXAczX1
         352Q==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Trinity <trinity@vger.kernel.org>
Cc: Daniel Borkmann <dborkman@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/proto-ipv4.c | 30 +++++++++++++++++++++++-------
 net/proto-ipv6.c | 31 +++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index 8babe6d..3e24b54 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -97,13 +97,21 @@ void ipv4_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void inet_rand_socket(struct socket_triplet *st)
 {
-	switch (rand() % 3) {
-	case 0: st->type = SOCK_STREAM;     // TCP
-		if (rand_bool())
+	switch (rand() % 4) {
+	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
+		switch (rand() % 3) {
+		case 0:
 			st->protocol = 0;
-		else
+			break;
+		case 1:
 			st->protocol = IPPROTO_TCP;
-		break;
+			break;
+		case 2:
+			st->protocol = IPPROTO_SCTP;
+			break;
+		default:
+			break;
+		}
 
 	case 1: st->type = SOCK_DGRAM;      // UDP
 		if (rand_bool())
@@ -112,11 +120,19 @@ void inet_rand_socket(struct socket_triplet *st)
 			st->protocol = IPPROTO_UDP;
 		break;
 
-	case 2: st->type = SOCK_RAW;
+	case 2: st->type = SOCK_SEQPACKET;      // SCTP
+		if (rand_bool())
+			st->protocol = 0;
+		else
+			st->protocol = IPPROTO_SCTP;
+		break;
+
+	case 3: st->type = SOCK_RAW;
 		st->protocol = rand() % PROTO_MAX;
 		break;
 
-	default:break;
+	default:
+		break;
 	}
 }
 
diff --git a/net/proto-ipv6.c b/net/proto-ipv6.c
index 16bceb3..02bb373 100644
--- a/net/proto-ipv6.c
+++ b/net/proto-ipv6.c
@@ -29,10 +29,21 @@ void ipv6_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void inet6_rand_socket(struct socket_triplet *st)
 {
-	switch (rand() % 3) {
-	case 0: st->type = SOCK_STREAM;     // TCP
-		st->protocol = 0;
-		break;
+	switch (rand() % 4) {
+	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
+		switch (rand() % 3) {
+		case 0:
+			st->protocol = 0;
+			break;
+		case 1:
+			st->protocol = IPPROTO_TCP;
+			break;
+		case 2:
+			st->protocol = IPPROTO_SCTP;
+			break;
+		default:
+			break;
+		}
 
 	case 1: st->type = SOCK_DGRAM;      // UDP
 		if (rand_bool())
@@ -41,11 +52,19 @@ void inet6_rand_socket(struct socket_triplet *st)
 			st->protocol = IPPROTO_UDP;
 		break;
 
-	case 2: st->type = SOCK_RAW;
+	case 2: st->type = SOCK_SEQPACKET;      // SCTP
+		if (rand_bool())
+			st->protocol = 0;
+		else
+			st->protocol = IPPROTO_SCTP;
+		break;
+
+	case 3: st->type = SOCK_RAW;
 		st->protocol = rand() % PROTO_MAX;
 		break;
 
-	default:break;
+	default:
+		break;
 	}
 }
 
-- 
1.9.3
