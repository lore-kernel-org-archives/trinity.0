From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] net: add ipv4/ipv6 sctp support
Date: Fri, 25 Jul 2014 12:25:49 +0800
Message-ID: <1406262349-22533-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=3gySK6EWObIE9Eb+y7aa/8Zg5E/UzLMJTnYBM++Qdtc=;
        b=uoBof5/GxvmcwGLvJYJc5k99menUP9jHHVias1f633CDvt4w3Psa1Wfsks12Z7Kq86
         s5hYlLH5RgocFdRCDK6JPwrMTtHdIIWK88RvnCO/ZxNYvl0vOb4P2iC8pGfz2huAyXmj
         FGS6zpSfHTcMbkTQSesW2uPUzbOSa/QBb5VNJ6XFIeCTzc8HsTInZzRixavWXvvkMM4y
         7cYN3uIzg9jpSxfI+vCmgK5YA1lipMq6FN5MWSC3t21cavgrRBlXKrvj0J4ILa5cigfm
         tbEfHH1FEvHBULgKZ0OAsacCr6Ypf2a3oFgJJr1P3mUIdTJfoPc0Umzn6KEwcZZ0/fA1
         FGfA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Trinity <trinity@vger.kernel.org>
Cc: Daniel Borkmann <dborkman@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/proto-ipv4.c | 20 ++++++++++++++------
 net/proto-ipv6.c | 21 ++++++++++++++++-----
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index 8babe6d..5588518 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -97,22 +97,30 @@ void ipv4_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void inet_rand_socket(struct socket_triplet *st)
 {
-	switch (rand() % 3) {
-	case 0: st->type = SOCK_STREAM;     // TCP
+	switch (rand() % 4) {
+	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
+		switch (rand() % 3) {
+		case 0: st->protocol = 0; break;
+		case 1: st->protocol = IPPROTO_TCP; break;
+		case 2: st->protocol = IPPROTO_SCTP; break;
+		default:break;
+		}
+
+	case 1: st->type = SOCK_DGRAM;      // UDP
 		if (rand_bool())
 			st->protocol = 0;
 		else
-			st->protocol = IPPROTO_TCP;
+			st->protocol = IPPROTO_UDP;
 		break;
 
-	case 1: st->type = SOCK_DGRAM;      // UDP
+	case 2: st->type = SOCK_SEQPACKET;      // SCTP
 		if (rand_bool())
 			st->protocol = 0;
 		else
-			st->protocol = IPPROTO_UDP;
+			st->protocol = IPPROTO_SCTP;
 		break;
 
-	case 2: st->type = SOCK_RAW;
+	case 3: st->type = SOCK_RAW;
 		st->protocol = rand() % PROTO_MAX;
 		break;
 
diff --git a/net/proto-ipv6.c b/net/proto-ipv6.c
index 16bceb3..d094939 100644
--- a/net/proto-ipv6.c
+++ b/net/proto-ipv6.c
@@ -29,10 +29,14 @@ void ipv6_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void inet6_rand_socket(struct socket_triplet *st)
 {
-	switch (rand() % 3) {
-	case 0: st->type = SOCK_STREAM;     // TCP
-		st->protocol = 0;
-		break;
+	switch (rand() % 4) {
+	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
+		switch (rand() % 3) {
+		case 0: st->protocol = 0; break;
+		case 1: st->protocol = IPPROTO_TCP; break;
+		case 2: st->protocol = IPPROTO_SCTP; break;
+		default:break;
+		}
 
 	case 1: st->type = SOCK_DGRAM;      // UDP
 		if (rand_bool())
@@ -41,7 +45,14 @@ void inet6_rand_socket(struct socket_triplet *st)
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
 
-- 
1.9.3
