From: Vinson Lee <vlee@twitter.com>
Subject: [PATCH] Add tokens for kernels with earlier versions of exynos_drm.h.
Date: Fri, 29 Mar 2013 17:47:08 -0700
Message-ID: <1364604428-12490-1-git-send-email-vlee@twitter.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=twitter.com; s=google;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        bh=iyuH4hwSCJxihDNAyFzzXcYURm0h14srf4Rwy8pLNhE=;
        b=SiWjsBC8/wqFst6efLekQiUwaSsNEZeHYXvyj5rnGt9t2DRHJhZMgA5cxOcbUWK4cN
         Lk2Iv60vovnqQfXjALY2y/OMMiuCCXzR7bR2ADUv5rL0KoTqdH1r9+D6XI8tx4uDPYqg
         80DPeNIJLdcMNS4aBFLnq4LbPdFeinsSRR+H8=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors with Linux 3.4 and earlier.

  CC    ioctls/drm.o
ioctls/drm.c:179: error: =E2=80=98DRM_IOCTL_EXYNOS_GEM_GET=E2=80=99 und=
eclared here (not in a function)
ioctls/drm.c:181: error: =E2=80=98DRM_IOCTL_EXYNOS_G2D_GET_VER=E2=80=99=
 undeclared here (not in a function)
ioctls/drm.c:182: error: =E2=80=98DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST=E2=80=
=99 undeclared here (not in a function)
ioctls/drm.c:183: error: =E2=80=98DRM_IOCTL_EXYNOS_G2D_EXEC=E2=80=99 un=
declared here (not in a function)
make: *** [ioctls/drm.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |   14 ++++++++++++++
 ioctls/drm.c     |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 934ec78..70cf34c 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -487,4 +487,18 @@ struct sockaddr_nfc {
 #define IN_EXCL_UNLINK	0x04000000	/* exclude events on unlinked object=
s */
 #endif
=20
+/* drm/exynos_drm.h */
+#ifndef DRM_IOCTL_EXYNOS_GEM_GET
+#define DRM_IOCTL_EXYNOS_GEM_GET 0x04
+#endif
+#ifndef DRM_IOCTL_EXYNOS_G2D_GET_VER
+#define DRM_IOCTL_EXYNOS_G2D_GET_VER 0x20
+#endif
+#ifndef DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST
+#define DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST 0x21
+#endif
+#ifndef DRM_IOCTL_EXYNOS_G2D_EXEC
+#define DRM_IOCTL_EXYNOS_G2D_EXEC 0x22
+#endif
+
 #endif	/* _TRINITY_COMPAT_H */
diff --git a/ioctls/drm.c b/ioctls/drm.c
index afb3147..82b300e 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -17,6 +17,7 @@
=20
 #include "trinity.h"
 #include "ioctls.h"
+#include "compat.h"
=20
 /* Copy-paste relevant stuff from header, as it is buggy. */
 /* #include <drm/sis_drm.h> */
--=20
1.7.1

