From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] net/netlink.c: include compat.h for NETLINK_CRYPTO
Date: Tue, 13 Aug 2013 23:14:00 +0800
Message-ID: <1376406840-12883-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=RtDMNT/+Bu0cuHAcRVRK15yss1ZWz/eyyJmyrFZ6POs=;
        b=r9WA7tsEbLntMVep3I3li3FYV39JG4pkz5yLTXwaBz5zhQni3zv/Ojv6fuM3OiVNgR
         qvJI5ZvZoguaX/GnpThRlZBpJL+skFeF0w15/xzNqjN6mcetr6EczlgdbF0D+I5M5Zm0
         DthN1c4s4CsSklk24UyssPCKtGyVqY4WoTaXYG/VkAzgZ4tgNP4cT27VhZ+3VEQDyfaK
         dT7le+RJ4CGhB9ZSlhCR8fkz4cJy17Gt4gqKXVKXDwufW/kkJxGcGIxMTO++vZOzzOVb
         yPqEmQzzXx8whHdGjXfHClX1Y8HjmOKzIbhbJSixo0wudRSkJS+4gNaE5KFwhvkXv13p
         H3bw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Trinity list <trinity@vger.kernel.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>

compat.h have defined NETLINK_CRYPTO, but net/netlink.c didn't include it.
Which will make trinity complie filed on some distro.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink.c b/net/netlink.c
index 9ca2d07..ee73972 100644
--- a/net/netlink.c
+++ b/net/netlink.c
@@ -6,6 +6,7 @@
 #include <stdlib.h>
 #include "net.h"
 #include "random.h"
+#include "compat.h"
 
 void netlink_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 {
-- 
1.8.1.4
