From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] net: include compat.h first incase some specifier-qualifier-list error
Date: Tue, 13 Aug 2013 23:13:29 +0800
Message-ID: <1376406809-12604-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:mime-version:content-type
         :content-transfer-encoding;
        bh=4OXvdaRFOJfuU0wZdfoq3OEMjJGNGWFC0EiYD8fTHrI=;
        b=NpnQQp46ZtPNaqYtaWfDuUgufGKkNK5+jsz1rZ98AJ5Bo0kycz07x6soMqGOGyTGBZ
         hHDS2SlfDrX4hhpMQm/DlF3Saj3uTa4QH5ytnd67YCVEa7xLNAUvgXhp+YNgqaUdu05I
         3tZ6E9ssR4DJIUnGACdb1ux8vBxBF2kyS457hIf4RyYifHS0Kx+4Hd2IwNuAcSjkZhOF
         aOZqewfcKlZDrTceEUgXqs23tuwtBjz73IN6hK5iGhWc3xYg2SsNb8PUcrJ/Uf4ZzCi5
         ERnKrBjQM0mwETOtmz0zDXHJip0bnIzsaR76lXoF233O3D2tCJ2a29oUEPnjV3ZJfucx
         tAPg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Trinity list <trinity@vger.kernel.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>

On some old distros, we use sa_family_t in linux/irda.h and linux/netli=
nk.h
first, but include the header file bits/sockaddr.h later in compat.h. T=
hen it
will compile failed with error: expected specifier-qualifier-list befor=
e
=E2=80=98sa_family_t=E2=80=99. So let's move compat.h before irda.h and=
 netlink.h

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/irda_setsockopt.c    | 2 +-
 net/netlink_setsockopt.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/irda_setsockopt.c b/net/irda_setsockopt.c
index a5d96ec..21ff649 100644
--- a/net/irda_setsockopt.c
+++ b/net/irda_setsockopt.c
@@ -1,9 +1,9 @@
 #include <stdlib.h>
-#include <linux/irda.h>
 #include "net.h"
 #include "maps.h"	// page_rand
 #include "compat.h"
 #include "trinity.h"	// ARRAY_SIZE
+#include <linux/irda.h>
=20
 #define NR_SOL_IRDA_OPTS ARRAY_SIZE(irda_opts)
 static const unsigned int irda_opts[] =3D {
diff --git a/net/netlink_setsockopt.c b/net/netlink_setsockopt.c
index c6e9297..c401047 100644
--- a/net/netlink_setsockopt.c
+++ b/net/netlink_setsockopt.c
@@ -1,9 +1,9 @@
 #include <stdlib.h>
-#include <linux/netlink.h>
 #include "net.h"
 #include "maps.h"	// page_rand
 #include "compat.h"
 #include "trinity.h"	// ARRAY_SIZE
+#include <linux/netlink.h>
=20
 #define SOL_NETLINK 270
=20
--=20
1.8.1.4
