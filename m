From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 6/6] net: sockets -- Don't generate sockets with disabled protocol families
Date: Wed, 30 Oct 2013 16:15:46 +0400
Message-ID: <1383135346-31463-7-git-send-email-gorcunov@openvz.org>
References: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vm7MpOmBAe43zVQj+/MTt6I4SSpvgbsIDz7AW6VABFE=;
        b=eLBugDFzqKVRSz1CRaorYrMfIYZe0Of9ioJGdaKinaECR65zkKi5+VFxSkhQ91E5jU
         k/N1Py6BSO/dRUCHTJyhaAA1gcvASdgjNmC4v6H2cQEXDzSr/RoaBrebhJJgeSdYuynm
         36d+fULTYxPXUtkptoWNUnLgVR8VF220flo0TlknhU6z7B+Vi3nvcwLleEi2TCE20rET
         pwoxl5+NkRvUyggRSSOznLNJmiWOUmcd5Mdg+u4nlEW16W7solozAVCeu2H9faZz3xeV
         E1XYqwKS78r+TW8rwqR2F/pyw8Kh1w7Wa43saAR4j9+cAXNAoNJSS29YI4xmUHaN8yyj
         EUXg==
In-Reply-To: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/protocols.h |  1 +
 net/protocols.c     | 19 +++++++++++++++++++
 sockets.c           | 26 ++++++++++++++++++++++----
 syscalls/socket.c   | 36 ++++++++++++++++++++++++++++++++++--
 4 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/include/protocols.h b/include/protocols.h
index e52d7c3..6414d65 100644
--- a/include/protocols.h
+++ b/include/protocols.h
@@ -4,5 +4,6 @@
 extern const char * get_proto_name(unsigned int proto);
 extern void find_specific_proto(const char *protoarg);
 extern void parse_exclude_protos(const char *arg);
+extern unsigned int find_next_enabled_proto(unsigned int from);
 
 #endif /* _PROTOCOLS_H */
diff --git a/net/protocols.c b/net/protocols.c
index 4c50d0e..0ebeff0 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -103,6 +103,25 @@ void find_specific_proto(const char *protoarg)
 	exit(EXIT_FAILURE);
 }
 
+unsigned int find_next_enabled_proto(unsigned int from)
+{
+	unsigned int i;
+
+	from %= ARRAY_SIZE(no_protos);
+
+	for (i = from; i < ARRAY_SIZE(no_protos); i++) {
+		if (no_protos[i] == FALSE)
+			return no_protos[i];
+	}
+
+	for (i = 0; i < from; i++) {
+		if (no_protos[i] == FALSE)
+			return no_protos[i];
+	}
+
+	return -1u;
+}
+
 void parse_exclude_protos(const char *arg)
 {
 	char *_arg = strdup(arg);
diff --git a/sockets.c b/sockets.c
index fba3aa9..60aeb0c 100644
--- a/sockets.c
+++ b/sockets.c
@@ -133,6 +133,19 @@ static void generate_sockets(void)
 
 	lock_cachefile(cachefile, F_WRLCK);
 
+	/*
+	 * Don't loop forever if all protos all are disabled.
+	 */
+	if (!do_specific_proto) {
+		for (n = 0; n < (int)ARRAY_SIZE(no_protos); n++) {
+			if (!no_protos[n])
+				break;
+		}
+
+		if (n >= (int)ARRAY_SIZE(no_protos))
+			nr_to_create = 0;
+	}
+
 	while (nr_to_create > 0) {
 
 		struct socket_triplet st;
@@ -150,6 +163,10 @@ static void generate_sockets(void)
 			if (get_proto_name(st.family) == NULL)
 				goto skip;
 
+			BUG_ON(st.family >= ARRAY_SIZE(no_protos));
+			if (no_protos[st.family])
+				goto skip;
+
 			if (sanitise_socket_triplet(&st) == -1)
 				rand_proto_type(&st);
 
@@ -237,16 +254,17 @@ void open_sockets(void)
 		type = buffer[1];
 		protocol = buffer[2];
 
-		if (do_specific_proto == TRUE) {
-			if (domain != specific_proto) {
-				output(1, "ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
+		if ((do_specific_proto == TRUE && domain != specific_proto) ||
+		    (domain < ARRAY_SIZE(no_protos) && no_protos[domain] == TRUE)) {
+			output(1, "ignoring socket cachefile due to specific "
+			       "protocol request (or protocol disabled), "
+			       "and stale data in cachefile.\n");
 regenerate:
 				unlock_cachefile(cachefile);	/* drop the reader lock. */
 				close(cachefile);
 				unlink(cachefilename);
 				generate_sockets();
 				return;
-			}
 		}
 
 		fd = open_socket(domain, type, protocol);
diff --git a/syscalls/socket.c b/syscalls/socket.c
index 21dabb1..3badd86 100644
--- a/syscalls/socket.c
+++ b/syscalls/socket.c
@@ -12,6 +12,7 @@
 #include "shm.h"
 #include "config.h"
 #include "params.h"
+#include "protocols.h"
 #include "trinity.h"
 
 struct socket_ptr {
@@ -44,14 +45,30 @@ static const struct socket_ptr socketptrs[] = {
 
 void rand_proto_type(struct socket_triplet *st)
 {
+	int n;
+
+	/*
+	 * One special moment on packet sockets. They
+	 * can be created with SOCK_PACKET, so if
+	 * PF_PACKET is disabled, choose some other type.
+	 */
+
 	st->protocol = rand() % PROTO_MAX;
 
-	switch (rand() % 6) {
+	if (st->family == PF_INET && no_protos[PF_PACKET])
+		n = 5;
+	else
+		n = 6;
+
+	switch (rand() % n) {
 	case 0:	st->type = SOCK_DGRAM;	break;
 	case 1:	st->type = SOCK_STREAM;	break;
 	case 2:	st->type = SOCK_SEQPACKET;	break;
 	case 3:	st->type = SOCK_RAW;	break;
 	case 4:	st->type = SOCK_RDM;	break;
+	/*
+	 * Make sure it's last one.
+	 */
 	case 5:	st->type = SOCK_PACKET;	break;
 	default: break;
 	}
@@ -77,9 +94,24 @@ void gen_socket_args(struct socket_triplet *st)
 {
 	if (do_specific_proto == TRUE)
 		st->family = specific_proto;
-	else
+
+	else {
 		st->family = rand() % TRINITY_PF_MAX;
 
+		/*
+		 * If we get a disabled family, try to find
+		 * first next allowed.
+		 */
+		BUG_ON(st->family >= ARRAY_SIZE(no_protos));
+		if (no_protos[st->family]) {
+			st->family = find_next_enabled_proto(st->family);
+			if (st->family == -1u) {
+				outputerr("No available socket family found\n");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
 	/* sometimes, still gen rand crap */
 	if ((rand() % 100) == 0) {
 		rand_proto_type(st);
-- 
1.8.3.1
