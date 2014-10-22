From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] ioctls/drm: Fix build errors due to undefined symbols.
Date: Tue, 21 Oct 2014 17:04:03 -0700
Message-ID: <1413936243-8950-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors on Fedora 22
3.18.0-0.rc0.git9.4.fc22.x86_64.

  CC	ioctls/drm.o
In file included from ioctls/drm.c:20:0:
ioctls/drm.c:274:8: error: =E2=80=98DRM_IOCTL_EXYNOS_GEM_MAP_OFFSET=E2=80=
=99 undeclared here (not in a function)
  IOCTL(DRM_IOCTL_EXYNOS_GEM_MAP_OFFSET),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/drm.c:275:8: error: =E2=80=98DRM_IOCTL_EXYNOS_GEM_MMAP=E2=80=99 =
undeclared here (not in a function)
  IOCTL(DRM_IOCTL_EXYNOS_GEM_MMAP),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 ioctls/drm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ioctls/drm.c b/ioctls/drm.c
index 1f6174a..dd3cc43 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -271,8 +271,12 @@ static const struct ioctl drm_ioctls[] =3D {
 #ifdef USE_DRM_EXYNOS
 	/* exynos_drm.h */
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_CREATE),
+#ifdef DRM_IOCTL_EXYNOS_GEM_MAP_OFFSET
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_MAP_OFFSET),
+#endif
+#ifdef DRM_IOCTL_EXYNOS_GEM_MMAP
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_MMAP),
+#endif
 #ifdef DRM_IOCTL_EXYNOS_GEM_GET
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_GET),
 #endif
--=20
2.1.0
