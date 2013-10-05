From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/3] fix broken includes
Date: Sat,  5 Oct 2013 09:33:48 +0200
Message-ID: <1380958428-9611-3-git-send-email-jslaby@suse.cz>
References: <1380958428-9611-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1380958428-9611-1-git-send-email-jslaby@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>

In 3.0, we get errors like:
/usr/include/linux/netlink.h:34: error: expected specifier-qualifier-list before 'sa_family_t'
---
 net/irda_setsockopt.c    | 1 +
 net/netlink_setsockopt.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/irda_setsockopt.c b/net/irda_setsockopt.c
index a5d96ec..e6255b2 100644
--- a/net/irda_setsockopt.c
+++ b/net/irda_setsockopt.c
@@ -1,4 +1,5 @@
 #include <stdlib.h>
+#include <sys/socket.h> /* old irda.h is broken */
 #include <linux/irda.h>
 #include "net.h"
 #include "maps.h"	// page_rand
diff --git a/net/netlink_setsockopt.c b/net/netlink_setsockopt.c
index c6e9297..549c3f0 100644
--- a/net/netlink_setsockopt.c
+++ b/net/netlink_setsockopt.c
@@ -1,4 +1,5 @@
 #include <stdlib.h>
+#include <sys/socket.h> /* old netlink.h is broken */
 #include <linux/netlink.h>
 #include "net.h"
 #include "maps.h"	// page_rand
-- 
1.8.4

