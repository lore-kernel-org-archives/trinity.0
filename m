From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] Specific domain in sanitise_socket
Date: Sat,  8 Jun 2013 11:03:39 +0800
Message-ID: <1370660619-15319-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=6C2q91+x1Qlzbwz/4/GHHMxo6Fija1bLqdyp5Ei9p3o=;
        b=i6ygZpjvnDAsiHRJtcR7N2HeC/ZWfb9IUcB5HZTF39XTfqC8g2nQn50E+aqnn0ICjq
         e/rb0VLwdqi9VQr58jH5vFgPBvn5dR2wONR16czmyEr5m2mi3eVy0YonXvduDkvi0tEX
         XHtz25X+aeperNJB1UXZT9PvMX+Jce1Ep54m1ZuuV8QAPaXQX/Np444rlpta0qv491ce
         kBTguR6/RFK1zo5+xEUa3YwaE2uUKuBoq+3fS/TpadeReeZY4rzW2rCLzuaEUlxiTKki
         yLgQbg2CwTEnSP4hqB1qSKMZloQgQpICEempF9B0/7nsoi0G9eSdIlghSRcwXiXPAFQx
         BpbA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Hangbin Liu <liuhangbin@gmail.com>

We should specific the domain in sanitise_socket(). If out side it, we may get
unrelated type and protocol.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 sockets.c         |  9 +--------
 syscalls/socket.c | 13 ++++++++++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/sockets.c b/sockets.c
index d47da38..7eade96 100644
--- a/sockets.c
+++ b/sockets.c
@@ -105,14 +105,7 @@ void generate_sockets(void)
 		/* Pretend we're child 0 and we've called sys_socket */
 		sanitise_socket(0);
 
-		//FIXME: If we passed a specific domain, we want to sanitise
-		//  the proto/type fields.  Split it out of sanitise_socket()
-
-		if (do_specific_proto == TRUE)
-			domain = specific_proto;
-		else
-			domain = shm->a1[0];
-
+		domain = shm->a1[0];
 		type = shm->a2[0];
 		protocol = shm->a3[0];
 
diff --git a/syscalls/socket.c b/syscalls/socket.c
index 2d9d6b9..26e3a6e 100644
--- a/syscalls/socket.c
+++ b/syscalls/socket.c
@@ -16,6 +16,7 @@
 #include "sanitise.h"
 #include "shm.h"
 #include "config.h"
+#include "params.h"
 
 #ifdef USE_CAIF
 #include <linux/caif/caif_socket.h>
@@ -41,9 +42,15 @@ static int ax25_protocols[NR_AX25_PROTOS] = {
 /* note: also called from generate_sockets() & sanitise_socketcall() */
 void sanitise_socket(int childno)
 {
-        unsigned long family = rand() % PF_MAX;
-        unsigned long type= rand() % TYPE_MAX;
-        unsigned long protocol = rand() % PROTO_MAX;
+	unsigned long family, type, protocol;
+
+	if (do_specific_proto == TRUE)
+		family = specific_proto;
+	else
+		family = rand() % PF_MAX;
+
+	type = rand() % TYPE_MAX;
+	protocol = rand() % PROTO_MAX;
 
 	switch (family) {
 
-- 
1.8.1.4
