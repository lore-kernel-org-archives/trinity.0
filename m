From: Adrien Schildknecht <adrien+dev@schischi.me>
Subject: [PATCH] net: include <linux/if.h> instead of <net/if.h>
Date: Thu, 10 Mar 2016 15:31:49 -0800
Message-ID: <1457652709-13314-1-git-send-email-adrien+dev@schischi.me>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schischi-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=SKRpW21G/x+YgLLUrSMGDLcBUN0a0O+Sh1DhVbSDc3I=;
        b=aQfVAfv9Bp8PneW8dkhLJitJpPdH63LRaAMUrvb6DoCVd6A6omxH3kptS3g/uj+bwu
         t+wH/PT+81YftQmcJ30gyfOB1K7YrLjgJMTSWqFnIGS7G9r88jf15r2gwbtmZ2xgnVd3
         T9EjVXYa2HpXomvukhGYuM1mAj5kq1PpJqciuo7RoyaokSYWOd01GYJyyxcVetAMzW2p
         zV7hjULNhUPWpMLEZSOqTb5plFEry9EKaAu3EWydsDBInNMqhmsJLOvQik7yRFhrtPLu
         /Ffb44F5CiJAQ5/N0p94pv4SGO/kEfYKjxyOQqLKY8LmtuDSexJaopTVCecOJ2WHEEEl
         /+Cw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>

Commit 4ada80dd202675 includes net/if.h and linux/netfilter_ipv4/ip_tables.h
net/* and linux/* should not be mixed.
Debian Jessie x86_64:
  CC    net/proto-ipv4.o
  In file included from net/proto-ipv4.c:11:0:
  /usr/include/linux/if.h:71:2: error: redeclaration of enumerator 'IFF_UP'
    IFF_UP    = 1<<0,  /* sysfs */
  /usr/include/net/if.h:44:5: note: previous definition of 'IFF_UP' was here
    IFF_UP = 0x1,  /* Interface is up.  */
  [...]

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
---
 net/proto-ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index dc9aa48..0be0263 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 #include <arpa/inet.h>
 #include <linux/mroute.h>
-#include <net/if.h>
+#include <linux/if.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_arp/arp_tables.h>
-- 
2.7.2
