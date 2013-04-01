From: Vinson Lee <vlee@twitter.com>
Subject: [PATCH v2] Add #ifdefs around missing exynos ioctls on earlier kernels.
Date: Mon,  1 Apr 2013 11:40:45 -0700
Message-ID: <1364841645-32744-1-git-send-email-vlee@twitter.com>
References: <CA+ydwtpTkRyo12PYuNof2CuxPUe8iQs52MNV=+LE4+WDr43wnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=twitter.com; s=google;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        bh=3ilyDTWx6VYGJ/+4P69HR1U7yLTiBi5By106aHQveqA=;
        b=HDB5IIVqOJlU0qJuLCVsayXWZJOVJYQBlKABFXACCmK8LB9Y+xL/a0BiQWQ/Szjkn5
         71scBhgDR0b7mBocBnWdd+YbqVvWOKdzkjxwng7JzcFf5SkIn7lwszcNrTRBSm9wpPVb
         0C3wjVm+cxpZi+6xAYmuNkap4cl3/5de6Imkk=
In-Reply-To: <CA+ydwtpTkRyo12PYuNof2CuxPUe8iQs52MNV=+LE4+WDr43wnQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors with Linux 3.4 and earlier.

  CC	ioctls/drm.o
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
 ioctls/drm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/ioctls/drm.c b/ioctls/drm.c
index afb3147..8f3dfd0 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -176,12 +176,20 @@ static const struct ioctl drm_ioctls[] =3D {
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_CREATE),
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_MAP_OFFSET),
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_MMAP),
+#ifdef DRM_IOCTL_EXYNOS_GEM_GET
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_GET),
+#endif
 	IOCTL(DRM_IOCTL_EXYNOS_VIDI_CONNECTION),
+#ifdef DRM_IOCTL_EXYNOS_G2D_GET_VER
 	IOCTL(DRM_IOCTL_EXYNOS_G2D_GET_VER),
+#endif
+#ifdef DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST
 	IOCTL(DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST),
+#endif
+#ifdef DRM_IOCTL_EXYNOS_G2D_EXEC
 	IOCTL(DRM_IOCTL_EXYNOS_G2D_EXEC),
 #endif
+#endif
=20
 	/* i810_drm.h */
 	IOCTL(DRM_IOCTL_I810_INIT),
--=20
1.7.1
