From: Andi Shyti <andi@etezian.org>
Subject: [PATCH] ioctls: btrfs-control: fix header inclusion order
Date: Tue, 23 Jul 2013 21:35:28 +0200
Message-ID: <1374608128-29846-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, mikko.rapeli@iki.fi, andi@etezian.org

This patch enables older linux/btrfs.h where NULL is not
recognized as a define. It gets rid of the following compiling
error:

In file included from ioctls/btrfs-control.c:5:0:
/usr/include/linux/btrfs.h: In function =E2=80=98btrfs_err_str=E2=80=99=
:
/usr/include/linux/btrfs.h:486:11: error: =E2=80=98NULL=E2=80=99 undecl=
ared (first use in this function)
    return NULL;
           ^

This is done by postponing the inclusion of btrf.h

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 ioctls/btrfs-control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ioctls/btrfs-control.c b/ioctls/btrfs-control.c
index 35e5389..8d1e2d9 100644
--- a/ioctls/btrfs-control.c
+++ b/ioctls/btrfs-control.c
@@ -2,11 +2,11 @@
=20
 #ifdef USE_BTRFS
=20
-#include <linux/btrfs.h>
-
 #include "trinity.h"
 #include "ioctls.h"
=20
+#include <linux/btrfs.h>
+
 static const struct ioctl btrfs_control_ioctls[] =3D {
 	IOCTL(BTRFS_IOC_SCAN_DEV),
 	IOCTL(BTRFS_IOC_DEVICES_READY),
--=20
1.8.3.2
