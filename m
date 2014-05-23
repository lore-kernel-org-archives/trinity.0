From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] Compat fixes for DRM & prctl()
Date: Fri, 23 May 2014 19:09:25 +1000
Message-ID: <1400836165-23714-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

---
 include/compat.h | 9 +++++++++
 ioctls/drm.c     | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 51f0936..8bdaf92 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -257,10 +257,19 @@ enum {
 
 #ifndef PR_SET_MM
 #define PR_SET_MM               35
+#endif
+
+#ifndef PR_SET_CHILD_SUBREAPER
 #define PR_SET_CHILD_SUBREAPER  36
 #define PR_GET_CHILD_SUBREAPER  37
+#endif
+
+#ifndef PR_SET_NO_NEW_PRIVS
 #define PR_SET_NO_NEW_PRIVS     38
 #define PR_GET_NO_NEW_PRIVS     39
+#endif
+
+#ifndef PR_GET_TID_ADDRESS
 #define PR_GET_TID_ADDRESS      40
 #endif
 
diff --git a/ioctls/drm.c b/ioctls/drm.c
index 986b668..1f6174a 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -276,7 +276,9 @@ static const struct ioctl drm_ioctls[] = {
 #ifdef DRM_IOCTL_EXYNOS_GEM_GET
 	IOCTL(DRM_IOCTL_EXYNOS_GEM_GET),
 #endif
+#ifdef DRM_IOCTL_EXYNOS_VIDI_CONNECTION
 	IOCTL(DRM_IOCTL_EXYNOS_VIDI_CONNECTION),
+#endif
 #ifdef DRM_IOCTL_EXYNOS_G2D_GET_VER
 	IOCTL(DRM_IOCTL_EXYNOS_G2D_GET_VER),
 #endif
-- 
1.9.1
