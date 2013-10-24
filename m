From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 4/4] sockets: Take into account socket families disabled when generating sockets
Date: Fri, 25 Oct 2013 01:39:28 +0400
Message-ID: <1382650768-30954-5-git-send-email-gorcunov@gmail.com>
References: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qgGybKqc1xWvzGIVHPxqaGkDlhGrDbzSlob+YaXxJIY=;
        b=vIe5cdd4EPxOewCvK3WUGf/lwtCCEZ1PzrVISXzI0TFE+cYDc3lwes6u+//xNPp7MW
         7n8JDfZVd8UXqu+tWETxC1PSgMN71/xQ5Pa4RTGKvRFvlfjbJb1paRn4OMVTThILZ1Yw
         N6vMX+dJ1AkxAm3sI7c8UrqYB0Q9OtgIfCKA3XJLz0jqRDj0X+zpYax86/Jsgb+EpSQb
         vxZGWVOWY3ruZdyKWfA3/2iM6qO8zkcUNVX15dspgIyxgc1hcSjeh81AaIPmd9ALmB+3
         E3A8bJmkYvcTjfXx/HFEuuzYJ6nFQlzrt1hUneWFfgv5Aso36PoAh3/QEHS6/uA8cM/0
         x8Rg==
In-Reply-To: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

When we generate sockets cache file we should take into account
the option passed with --fds making sure the socket we're about
to create was not disabled.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 sockets.c         | 17 ++++++++++++++---
 syscalls/socket.c | 20 +++++++++++++++++++-
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/sockets.c b/sockets.c
index 590c814..cb9a9a2 100644
--- a/sockets.c
+++ b/sockets.c
@@ -132,6 +132,13 @@ static void generate_sockets(void)
 
 	lock_cachefile(cachefile, F_WRLCK);
 
+	/*
+	 * If we have all sockets disabled, don't create any.
+	 */
+	if (index((const char *)disabled_protos, 'y') &&
+	    !index((const char *)disabled_protos, 'n'))
+		nr_to_create = 0;
+
 	while (nr_to_create > 0) {
 
 		struct socket_triplet st;
@@ -141,6 +148,8 @@ static void generate_sockets(void)
 			return;
 		}
 
+		BUG_ON(ARRAY_SIZE(disabled_protos) >= TRINITY_PF_MAX);
+
 		for (st.family = 0; st.family < TRINITY_PF_MAX; st.family++) {
 
 			if (do_specific_proto == TRUE)
@@ -149,6 +158,9 @@ static void generate_sockets(void)
 			if (get_proto_name(st.family) == NULL)
 				goto skip;
 
+			if (disabled_protos[st.family] == 'y')
+				goto skip;
+
 			if (sanitise_socket_triplet(&st) == -1)
 				rand_proto_type(&st);
 
@@ -236,8 +248,8 @@ void open_sockets(void)
 		type = buffer[1];
 		protocol = buffer[2];
 
-		if (do_specific_proto == TRUE) {
-			if (domain != specific_proto) {
+		if ((do_specific_proto == TRUE && domain != specific_proto) ||
+		    (domain < ARRAY_SIZE(disabled_protos) && disabled_protos[domain] == 'y')) {
 				output(1, "ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
 regenerate:
 				unlock_cachefile(cachefile);	/* drop the reader lock. */
@@ -245,7 +257,6 @@ regenerate:
 				unlink(cachefilename);
 				generate_sockets();
 				return;
-			}
 		}
 
 		fd = open_socket(domain, type, protocol);
diff --git a/syscalls/socket.c b/syscalls/socket.c
index 21dabb1..8d5100c 100644
--- a/syscalls/socket.c
+++ b/syscalls/socket.c
@@ -44,17 +44,35 @@ static const struct socket_ptr socketptrs[] = {
 
 void rand_proto_type(struct socket_triplet *st)
 {
+	int n = 6;
 	st->protocol = rand() % PROTO_MAX;
 
-	switch (rand() % 6) {
+again:
+	switch (rand() % n) {
 	case 0:	st->type = SOCK_DGRAM;	break;
 	case 1:	st->type = SOCK_STREAM;	break;
 	case 2:	st->type = SOCK_SEQPACKET;	break;
 	case 3:	st->type = SOCK_RAW;	break;
 	case 4:	st->type = SOCK_RDM;	break;
+
+	/*
+	 * It must be last.
+	 */
 	case 5:	st->type = SOCK_PACKET;	break;
 	default: break;
 	}
+
+	/*
+	 * One special moment on packet sockets. They
+	 * can be created with SOCK_PACKET, so if
+	 * PF_PACKET is disabled, choose some other type.
+	 */
+	if (st->type == SOCK_PACKET	&&
+	    st->family == PF_INET	&&
+	    disabled_protos[PF_PACKET] == 'y') {
+		n = 5;
+		goto again;
+	}
 }
 
 /* note: also called from generate_sockets() */
-- 
1.8.3.1
