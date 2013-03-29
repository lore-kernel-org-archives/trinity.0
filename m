From: Brian Haley <brian.haley@hp.com>
Subject: [PATCH v3] Fix 2.6.32 compiler errors
Date: Thu, 28 Mar 2013 22:41:35 -0400
Message-ID: <5154FF5F.1070103@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>

Fix compiler errors found when building on ancient 2.6.32 system.

Changes since v2:

Fix inotify error using compat.h

Changes since v1:

Added missing #include of config.h in ioctls/vhost.c

Signed-off-by: Brian Haley <brian.haley@hp.com>

diff --git a/configure.sh b/configure.sh
index c435208..5e54355 100755
--- a/configure.sh
+++ b/configure.sh
@@ -176,6 +176,8 @@ file_exists linux/rds.h USE_RDS
 file_exists linux/vfio.h USE_VFIO
 file_exists linux/btrfs.h USE_BTRFS
 file_exists drm/exynos_drm.h USE_DRM_EXYNOS
+file_exists sound/compress_offload.h USE_SNDDRV_COMPRESS_OFFLOAD
+file_exists linux/vhost.h USE_VHOST
 
 rm -f "$TMP" "$TMP.log" "$TMP.c"
 
diff --git a/include/compat.h b/include/compat.h
index fbf2945..934ec78 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -482,4 +482,9 @@ struct sockaddr_nfc {
 };
 #endif
 
+/* linux/inotify.h */
+#ifndef IN_EXCL_UNLINK
+#define IN_EXCL_UNLINK	0x04000000	/* exclude events on unlinked objects */
+#endif
+
 #endif	/* _TRINITY_COMPAT_H */
diff --git a/ioctls/drm.c b/ioctls/drm.c
index 8d110fb..afb3147 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -75,7 +75,9 @@ static const struct ioctl drm_ioctls[] = {
 	IOCTL(DRM_IOCTL_GEM_CLOSE),
 	IOCTL(DRM_IOCTL_GEM_FLINK),
 	IOCTL(DRM_IOCTL_GEM_OPEN),
+#ifdef DRM_IOCTL_GET_CAP
 	IOCTL(DRM_IOCTL_GET_CAP),
+#endif
 	IOCTL(DRM_IOCTL_SET_UNIQUE),
 	IOCTL(DRM_IOCTL_AUTH_MAGIC),
 	IOCTL(DRM_IOCTL_BLOCK),
@@ -141,9 +143,15 @@ static const struct ioctl drm_ioctls[] = {
 	IOCTL(DRM_IOCTL_MODE_RMFB),
 	IOCTL(DRM_IOCTL_MODE_PAGE_FLIP),
 	IOCTL(DRM_IOCTL_MODE_DIRTYFB),
+#ifdef DRM_IOCTL_MODE_CREATE_DUMB
 	IOCTL(DRM_IOCTL_MODE_CREATE_DUMB),
+#endif
+#ifdef DRM_IOCTL_MODE_MAP_DUMB
 	IOCTL(DRM_IOCTL_MODE_MAP_DUMB),
+#endif
+#ifdef DRM_IOCTL_MODE_DESTROY_DUMB
 	IOCTL(DRM_IOCTL_MODE_DESTROY_DUMB),
+#endif
 #ifdef DRM_IOCTL_MODE_GETPLANERESOURCES
 	IOCTL(DRM_IOCTL_MODE_GETPLANERESOURCES),
 #endif
@@ -209,7 +217,9 @@ static const struct ioctl drm_ioctls[] = {
 	IOCTL(DRM_IOCTL_I915_SET_VBLANK_PIPE),
 	IOCTL(DRM_IOCTL_I915_GET_VBLANK_PIPE),
 	IOCTL(DRM_IOCTL_I915_VBLANK_SWAP),
+#ifdef DRM_IOCTL_I915_HWS_ADDR
 	IOCTL(DRM_IOCTL_I915_HWS_ADDR),
+#endif
 	IOCTL(DRM_IOCTL_I915_GEM_INIT),
 	IOCTL(DRM_IOCTL_I915_GEM_EXECBUFFER),
 	IOCTL(DRM_IOCTL_I915_GEM_EXECBUFFER2),
@@ -274,11 +284,21 @@ static const struct ioctl drm_ioctls[] = {
 	IOCTL(DRM_IOCTL_MGA_DMA_BOOTSTRAP),
 
 	/* nouveau_drm.h */
+#ifdef DRM_IOCTL_NOUVEAU_GEM_NEW
 	IOCTL(DRM_IOCTL_NOUVEAU_GEM_NEW),
+#endif
+#ifdef DRM_IOCTL_NOUVEAU_GEM_PUSHBUF
 	IOCTL(DRM_IOCTL_NOUVEAU_GEM_PUSHBUF),
+#endif
+#ifdef DRM_IOCTL_NOUVEAU_GEM_CPU_PREP
 	IOCTL(DRM_IOCTL_NOUVEAU_GEM_CPU_PREP),
+#endif
+#ifdef DRM_IOCTL_NOUVEAU_GEM_CPU_FINI
 	IOCTL(DRM_IOCTL_NOUVEAU_GEM_CPU_FINI),
+#endif
+#ifdef DRM_IOCTL_NOUVEAU_GEM_INFO
 	IOCTL(DRM_IOCTL_NOUVEAU_GEM_INFO),
+#endif
 
 	/* r128_drm.h */
 	IOCTL(DRM_IOCTL_R128_INIT),
@@ -336,18 +356,30 @@ static const struct ioctl drm_ioctls[] = {
 	IOCTL(DRM_IOCTL_RADEON_GEM_WAIT_IDLE),
 	IOCTL(DRM_IOCTL_RADEON_CS),
 	IOCTL(DRM_IOCTL_RADEON_INFO),
+#ifdef DRM_IOCTL_RADEON_GEM_SET_TILING
 	IOCTL(DRM_IOCTL_RADEON_GEM_SET_TILING),
+#endif
+#ifdef DRM_IOCTL_RADEON_GEM_GET_TILING
 	IOCTL(DRM_IOCTL_RADEON_GEM_GET_TILING),
+#endif
 	IOCTL(DRM_IOCTL_RADEON_GEM_BUSY),
 #ifdef DRM_IOCTL_RADEON_GEM_VA
 	IOCTL(DRM_IOCTL_RADEON_GEM_VA),
 #endif
 
 	/* savage_drm.h */
+#ifdef DRM_IOCTL_SAVAGE_BCI_INIT
 	IOCTL(DRM_IOCTL_SAVAGE_BCI_INIT),
+#endif
+#ifdef DRM_IOCTL_SAVAGE_BCI_CMDBUF
 	IOCTL(DRM_IOCTL_SAVAGE_BCI_CMDBUF),
+#endif
+#ifdef DRM_IOCTL_SAVAGE_BCI_EVENT_EMIT
 	IOCTL(DRM_IOCTL_SAVAGE_BCI_EVENT_EMIT),
+#endif
+#ifdef DRM_IOCTL_SAVAGE_BCI_EVENT_WAIT
 	IOCTL(DRM_IOCTL_SAVAGE_BCI_EVENT_WAIT),
+#endif
 
 	/* sis_drm.h */
 	IOCTL(DRM_IOCTL_SIS_FB_ALLOC),
diff --git a/ioctls/framebuffer.c b/ioctls/framebuffer.c
index 5c54108..18beb96 100644
--- a/ioctls/framebuffer.c
+++ b/ioctls/framebuffer.c
@@ -22,7 +22,9 @@ static const struct ioctl fb_ioctls[] = {
 	IOCTL(FBIOGET_HWCINFO),
 	IOCTL(FBIOPUT_MODEINFO),
 	IOCTL(FBIOGET_DISPINFO),
+#ifdef FBIO_WAITFORVSYNC
 	IOCTL(FBIO_WAITFORVSYNC),
+#endif
 };
 
 static const char *const fb_chardevs[] = {
diff --git a/ioctls/snd.c b/ioctls/snd.c
index 11a7d36..83b8b9a 100644
--- a/ioctls/snd.c
+++ b/ioctls/snd.c
@@ -10,7 +10,9 @@
 #include <sound/hdspm.h>
 #include <sound/sb16_csp.h>
 #include <sound/sfnt_info.h>
+#ifdef USE_SNDDRV_COMPRESS_OFFLOAD
 #include <sound/compress_offload.h>
+#endif
 
 /* would use this, but the header uses DECLARE_BITMAP() from the kernel */
 /* #include <sound/emu10k1.h> */
@@ -205,6 +207,7 @@ static const struct ioctl sound_ioctls[] = {
 	{ .name = "SNDRV_EMU10K1_IOCTL_SINGLE_STEP", .request = _IOC(_IOC_NONE,'H',0x83,0), },
 	{ .name = "SNDRV_EMU10K1_IOCTL_DBG_READ", .request = _IOC(_IOC_NONE,'H',0x84,0), },
 
+#ifdef USE_SNDDRV_COMPRESS_OFFLOAD
 	IOCTL(SNDRV_COMPRESS_IOCTL_VERSION),
 	IOCTL(SNDRV_COMPRESS_GET_CAPS),
 	IOCTL(SNDRV_COMPRESS_GET_CODEC_CAPS),
@@ -229,6 +232,7 @@ static const struct ioctl sound_ioctls[] = {
 #ifdef SNDRV_COMPRESS_PARTIAL_DRAIN
 	IOCTL(SNDRV_COMPRESS_PARTIAL_DRAIN),
 #endif
+#endif /* USE_SNDDRV_COMPRESS_OFFLOAD */
 };
 
 static const char *const sound_devs[] = {
diff --git a/ioctls/uinput.c b/ioctls/uinput.c
index cdecb91..10aacc6 100644
--- a/ioctls/uinput.c
+++ b/ioctls/uinput.c
@@ -17,7 +17,9 @@ static const struct ioctl uinput_ioctls[] = {
 	IOCTL(UI_SET_FFBIT),
 	IOCTL(UI_SET_PHYS),
 	IOCTL(UI_SET_SWBIT),
+#ifdef UI_SET_PROPBIT
 	IOCTL(UI_SET_PROPBIT),
+#endif
 	IOCTL(UI_BEGIN_FF_UPLOAD),
 	IOCTL(UI_END_FF_UPLOAD),
 	IOCTL(UI_BEGIN_FF_ERASE),
diff --git a/ioctls/vhost.c b/ioctls/vhost.c
index 4ead0e6..58a8b09 100644
--- a/ioctls/vhost.c
+++ b/ioctls/vhost.c
@@ -1,3 +1,6 @@
+#include "config.h"
+
+#ifdef USE_VHOST
 #include <linux/vhost.h>
 
 #include "trinity.h"
@@ -35,3 +38,4 @@ static const struct ioctl_group vhost_grp = {
 };
 
 REG_IOCTL_GROUP(vhost_grp)
+#endif /* USE_VHOST */
diff --git a/ioctls/videodev2.c b/ioctls/videodev2.c
index 79af31b..0d1473e 100644
--- a/ioctls/videodev2.c
+++ b/ioctls/videodev2.c
@@ -71,15 +71,33 @@ static const struct ioctl videodev2_ioctls[] = {
 	IOCTL(VIDIOC_DBG_G_REGISTER),
 	IOCTL(VIDIOC_DBG_G_CHIP_IDENT),
 	IOCTL(VIDIOC_S_HW_FREQ_SEEK),
+#ifdef VIDIOC_ENUM_DV_PRESETS
 	IOCTL(VIDIOC_ENUM_DV_PRESETS),
+#endif
+#ifdef VIDIOC_S_DV_PRESET
 	IOCTL(VIDIOC_S_DV_PRESET),
+#endif
+#ifdef VIDIOC_G_DV_PRESET
 	IOCTL(VIDIOC_G_DV_PRESET),
+#endif
+#ifdef VIDIOC_QUERY_DV_PRESET
 	IOCTL(VIDIOC_QUERY_DV_PRESET),
+#endif
+#ifdef VIDIOC_S_DV_TIMINGS
 	IOCTL(VIDIOC_S_DV_TIMINGS),
+#endif
+#ifdef VIDIOC_G_DV_TIMINGS
 	IOCTL(VIDIOC_G_DV_TIMINGS),
+#endif
+#ifdef VIDIOC_DQEVENT
 	IOCTL(VIDIOC_DQEVENT),
+#endif
+#ifdef VIDIOC_SUBSCRIBE_EVENT
 	IOCTL(VIDIOC_SUBSCRIBE_EVENT),
+#endif
+#ifdef VIDIOC_UNSUBSCRIBE_EVENT
 	IOCTL(VIDIOC_UNSUBSCRIBE_EVENT),
+#endif
 #ifdef VIDIOC_CREATE_BUFS
 	IOCTL(VIDIOC_CREATE_BUFS),
 #endif
diff --git a/syscalls/inotify_add_watch.c b/syscalls/inotify_add_watch.c
index 9c69fc7..be9b9ad 100644
--- a/syscalls/inotify_add_watch.c
+++ b/syscalls/inotify_add_watch.c
@@ -2,6 +2,7 @@
  * SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname, u32, mask)
  */
 #include "sanitise.h"
+#include "compat.h"
 
 #include <sys/inotify.h>
 
