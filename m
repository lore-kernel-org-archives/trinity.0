From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] net/rds_setsockopt.c: Always define SOL_RDS.
Date: Fri, 15 Nov 2013 17:01:29 -0800
Message-ID: <1384563689-6560-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes this build error on CentOS 6.

  CC	net/rds_setsockopt.o
net/rds_setsockopt.c: In function =E2=80=98rds_setsockopt=E2=80=99:
net/rds_setsockopt.c:33: error: =E2=80=98SOL_RDS=E2=80=99 undeclared (f=
irst use in this function)
net/rds_setsockopt.c:33: error: (Each undeclared identifier is reported=
 only once
net/rds_setsockopt.c:33: error: for each function it appears in.)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/rds_setsockopt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds_setsockopt.c b/net/rds_setsockopt.c
index 5421c3b..d0dec57 100644
--- a/net/rds_setsockopt.c
+++ b/net/rds_setsockopt.c
@@ -2,14 +2,14 @@
 #include "net.h"
 #include "config.h"
=20
+#define SOL_RDS 276
+
 #ifdef USE_RDS
 #include <linux/rds.h>
=20
 #include "compat.h"
 #include "trinity.h"	// ARRAY_SIZE
=20
-#define SOL_RDS 276
-
 #define NR_SOL_RDS_OPTS ARRAY_SIZE(rds_opts)
 static const unsigned int rds_opts[] =3D {
 	RDS_CANCEL_SENT_TO, RDS_GET_MR, RDS_FREE_MR,
--=20
1.7.1
