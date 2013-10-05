From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/3] net/netlink: add missing compat.h include
Date: Sat,  5 Oct 2013 09:33:47 +0200
Message-ID: <1380958428-9611-2-git-send-email-jslaby@suse.cz>
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

On 3.0, we get:
net/netlink.c:32: error: 'NETLINK_CRYPTO' undeclared (first use in this function)
---
 net/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink.c b/net/netlink.c
index 9ca2d07..6192184 100644
--- a/net/netlink.c
+++ b/net/netlink.c
@@ -4,6 +4,7 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <stdlib.h>
+#include "compat.h"
 #include "net.h"
 #include "random.h"
 
-- 
1.8.4

