From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Include sys/io.h for UIO_MAXIOV symbol.
Date: Tue, 20 Jun 2017 22:43:01 +0000
Message-ID: <1497998581-17530-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

This patch fixes this build error.

  CC	net/proto-ipv4.o
net/proto-ipv4.c: In function ‘ip_setsockopt’:
net/proto-ipv4.c:231:49: error: ‘UIO_MAXIOV’ undeclared (first use in this function); did you mean ‘_IO_MAGIC’?
   so->optlen = rnd() % sizeof(unsigned long)*(2*UIO_MAXIOV+512);
                                                 ^~~~~~~~~~
                                                 _IO_MAGIC

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 net/proto-ipv4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index b77364e02cad..9ffaa5e97a50 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -1,6 +1,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <sys/uio.h>
 #include <netinet/in.h>
 #include <netinet/udp.h>
 #include <stdlib.h>
-- 
2.13.1
