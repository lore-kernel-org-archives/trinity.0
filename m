From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Fix unused variable build errors.
Date: Wed, 13 Nov 2013 11:17:27 -0800
Message-ID: <1384370247-21352-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors on CentOS 6.

  CC	net/caif_setsockopt.o
cc1: warnings being treated as errors
net/caif_setsockopt.c: In function =E2=80=98caif_setsockopt=E2=80=99:
net/caif_setsockopt.c:20: error: unused variable =E2=80=98val=E2=80=99

  CC	net/rds_setsockopt.o
cc1: warnings being treated as errors
net/rds_setsockopt.c: In function =E2=80=98rds_setsockopt=E2=80=99:
net/rds_setsockopt.c:23: error: unused variable =E2=80=98val=E2=80=99

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/caif_setsockopt.c |    2 ++
 net/rds_setsockopt.c  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/caif_setsockopt.c b/net/caif_setsockopt.c
index fcc42c0..c829521 100644
--- a/net/caif_setsockopt.c
+++ b/net/caif_setsockopt.c
@@ -17,7 +17,9 @@ static const unsigned int caif_opts[] =3D { CAIFSO_LI=
NK_SELECT, CAIFSO_REQ_PARAM }
=20
 void caif_setsockopt(struct sockopt *so)
 {
+#ifdef USE_CAIF
 	unsigned char val;
+#endif
=20
 	so->level =3D SOL_CAIF;
=20
diff --git a/net/rds_setsockopt.c b/net/rds_setsockopt.c
index 25b6c8b..6ad6e2a 100644
--- a/net/rds_setsockopt.c
+++ b/net/rds_setsockopt.c
@@ -20,7 +20,9 @@ static const unsigned int rds_opts[] =3D {
=20
 void rds_setsockopt(struct sockopt *so)
 {
+#ifdef USE_RDS
 	unsigned char val;
+#endif
=20
 	so->level =3D SOL_RDS;
 #ifdef USE_RDS
--=20
1.7.1
