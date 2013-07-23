From: Andi Shyti <andi@etezian.org>
Subject: [PATCH] ioctls: videodev2: check if defines are obsolete
Date: Wed, 24 Jul 2013 00:42:07 +0200
Message-ID: <1374619327-13259-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, mikko.rapeli@iki.fi, andi@etezian.org

In kernel headers 3.11 the VIDIOC_DBG_G_CHIP_IDENT define is
considered obsolete, therefore removed, generating the following
compiling error:

ioctls/videodev2.c:72:15: error: =E2=80=98VIDIOC_DBG_G_CHIP_IDENT=E2=80=
=99 undeclared here (not in a function)
  IOCTL(VIDIOC_DBG_G_CHIP_IDENT),
               ^

Check the definition of it before using it

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 ioctls/videodev2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ioctls/videodev2.c b/ioctls/videodev2.c
index 0d1473e..03a5ae5 100644
--- a/ioctls/videodev2.c
+++ b/ioctls/videodev2.c
@@ -69,7 +69,9 @@ static const struct ioctl videodev2_ioctls[] =3D {
 	IOCTL(VIDIOC_TRY_ENCODER_CMD),
 	IOCTL(VIDIOC_DBG_S_REGISTER),
 	IOCTL(VIDIOC_DBG_G_REGISTER),
+#ifdef VIDIOC_DBG_G_CHIP_IDENT
 	IOCTL(VIDIOC_DBG_G_CHIP_IDENT),
+#endif
 	IOCTL(VIDIOC_S_HW_FREQ_SEEK),
 #ifdef VIDIOC_ENUM_DV_PRESETS
 	IOCTL(VIDIOC_ENUM_DV_PRESETS),
--=20
1.8.3.2
