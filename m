From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 4/6] net: protocols -- Move protocol function declarations to protocols.h
Date: Wed, 30 Oct 2013 16:15:44 +0400
Message-ID: <1383135346-31463-5-git-send-email-gorcunov@openvz.org>
References: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VcFnzejU2NwVo267ZLo/DpguTplIbZjQO6OBb2P09QY=;
        b=0Wxggfpoy+5R6JOeIYIShXrxk+ypTdtTtE7dWQhF8Y5zmEuvhveXyf82tTK4LL0UkY
         PtcshO0MvWhBAgwlkgRLLilYwXH97F9WZMji6BfN4LwFaa+lCu/ki2Yxyt2E1QwpI01e
         KpPO5vVNWOW9ru2mfsPUMjd+k1txjY/V3tfmxpjIoltzikzegfFIsCOFyPkbY/2Hyh92
         JF1b15KrHeYqAQd06EGaV7m2YlKdy+QzVd8pCbNwlCwncbHLrD3Cw4QotdXkYGpeXVlr
         WddgvWv/9uke9sF/a2zyCO0+A5g5L97VvPDol/wUe+zmihGn75vd2Kco4J2sW0kfGdyg
         QBrQ==
In-Reply-To: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

This allows to isolate functions and include the header only where needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/net.h       | 2 --
 include/protocols.h | 7 +++++++
 net/protocols.c     | 1 +
 sockets.c           | 1 +
 trinity.c           | 1 +
 5 files changed, 10 insertions(+), 2 deletions(-)
 create mode 100644 include/protocols.h

diff --git a/include/net.h b/include/net.h
index 4e43546..ae99c61 100644
--- a/include/net.h
+++ b/include/net.h
@@ -9,8 +9,6 @@ void generate_sockaddr(unsigned long *addr, unsigned long *addrlen, int pf);
 
 /* protocol decoding */
 extern unsigned int specific_proto;
-const char * get_proto_name(unsigned int proto);
-void find_specific_proto(const char *protoarg);
 
 
 /* glibc headers might be older than the kernel, so chances are we know
diff --git a/include/protocols.h b/include/protocols.h
new file mode 100644
index 0000000..e423a3a
--- /dev/null
+++ b/include/protocols.h
@@ -0,0 +1,7 @@
+#ifndef _PROTOCOLS_H
+#define _PROTOCOLS_H 1
+
+extern const char * get_proto_name(unsigned int proto);
+extern void find_specific_proto(const char *protoarg);
+
+#endif /* _PROTOCOLS_H */
diff --git a/net/protocols.c b/net/protocols.c
index 4331351..c279476 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -5,6 +5,7 @@
 
 #include "trinity.h"
 #include "constants.h"
+#include "protocols.h"
 #include "net.h"
 #include "log.h"
 
diff --git a/sockets.c b/sockets.c
index 590c814..fba3aa9 100644
--- a/sockets.c
+++ b/sockets.c
@@ -15,6 +15,7 @@
 #include "log.h"
 #include "params.h"	// victim_path, verbose, do_specific_proto
 #include "random.h"
+#include "protocols.h"
 
 unsigned int nr_sockets = 0;
 
diff --git a/trinity.c b/trinity.c
index 941c98b..d5b6041 100644
--- a/trinity.c
+++ b/trinity.c
@@ -32,6 +32,7 @@
 #include "syscall.h"
 #include "tables.h"
 #include "ioctls.h"
+#include "protocols.h"
 #include "config.h"	// for VERSION
 
 char *progname = NULL;
-- 
1.8.3.1
