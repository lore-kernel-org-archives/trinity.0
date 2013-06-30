From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 7/8] ioctls/drm: add deprecated nouveau ioctls
Date: Sun, 30 Jun 2013 22:33:11 +0300
Message-ID: <1372620792-16384-8-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=OuUWz1XtXxfiTYidosIgADWey0ze9VGxAJbU/ymLw+k=;
        b=bSBsw9oKgVDS+CrUMKwKW9mdX68Z5JaYpCMNOIg8df3hFo9pl+bqC2l8yNFr1m+NEE
         Ng6qqP15oQawLMiWx7IQKDoKN99u5OYuz1TJczaejWvRjv9IjefyhwztJID6zzgScf1T
         RogxJ3R8yUx4+lv8j4ttHG1DRn+lhjbS9v1cAClLieT3vOkgBrOgAxfLnlsXBwhz3gsT
         dF1kV7HvJXuxzSa78DUlbqpkbiuVsabP05U7w3KQzkfaWRVApnFG6bdXkl0IBzRlO4rQ
         JocV31c5VOcNgUohxzsvMpe328XB3Qd7VIXARVFbRwlln76Si30g8zDTRnfkyGfY2Jt/
         xxyw==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

nouveau has some deprecated ioctls that the kernel implements, but the
ioctl definitions are no longer available in the kernel headers.
---
 ioctls/drm.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/ioctls/drm.c b/ioctls/drm.c
index 736c264..952a356 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -45,6 +45,101 @@
 #define DRM_IOCTL_SIS_FLIP_FINAL	DRM_IO(  0x50)
 */
 
+/* deprecated nouveau ioctls */
+/*
+ * Copyright 2005 Stephane Marchesin.
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+#ifndef DRM_IOCTL_NOUVEAU_GETPARAM
+struct drm_nouveau_getparam {
+	uint64_t param;
+	uint64_t value;
+};
+#define DRM_IOCTL_NOUVEAU_GETPARAM           DRM_IOWR(DRM_COMMAND_BASE + DRM_NOUVEAU_GETPARAM, struct drm_nouveau_getparam)
+#endif
+
+#ifndef DRM_IOCTL_NOUVEAU_SETPARAM
+struct drm_nouveau_setparam {
+	uint64_t param;
+	uint64_t value;
+};
+#define DRM_IOCTL_NOUVEAU_SETPARAM           DRM_IOWR(DRM_COMMAND_BASE + DRM_NOUVEAU_SETPARAM, struct drm_nouveau_setparam)
+#endif
+
+#ifndef DRM_IOCTL_NOUVEAU_CHANNEL_ALLOC
+struct drm_nouveau_channel_alloc {
+	uint32_t     fb_ctxdma_handle;
+	uint32_t     tt_ctxdma_handle;
+
+	int          channel;
+	uint32_t     pushbuf_domains;
+
+	/* Notifier memory */
+	uint32_t     notifier_handle;
+
+	/* DRM-enforced subchannel assignments */
+	struct {
+		uint32_t handle;
+		uint32_t grclass;
+	} subchan[8];
+	uint32_t nr_subchan;
+};
+#define DRM_IOCTL_NOUVEAU_CHANNEL_ALLOC      DRM_IOWR(DRM_COMMAND_BASE + DRM_NOUVEAU_CHANNEL_ALLOC, struct drm_nouveau_channel_alloc)
+#endif
+
+#ifndef DRM_IOCTL_NOUVEAU_CHANNEL_FREE
+struct drm_nouveau_channel_free {
+	int channel;
+};
+#define DRM_IOCTL_NOUVEAU_CHANNEL_FREE       DRM_IOW (DRM_COMMAND_BASE + DRM_NOUVEAU_CHANNEL_FREE, struct drm_nouveau_channel_free)
+#endif
+
+#ifndef DRM_IOCTL_NOUVEAU_GROBJ_ALLOC
+struct drm_nouveau_grobj_alloc {
+	int      channel;
+	uint32_t handle;
+	int      class;
+};
+#define DRM_IOCTL_NOUVEAU_GROBJ_ALLOC        DRM_IOW (DRM_COMMAND_BASE + DRM_NOUVEAU_GROBJ_ALLOC, struct drm_nouveau_grobj_alloc)
+#endif
+
+#ifndef DRM_IOCTL_NOUVEAU_NOTIFIEROBJ_ALLOC
+struct drm_nouveau_notifierobj_alloc {
+	uint32_t channel;
+	uint32_t handle;
+	uint32_t size;
+	uint32_t offset;
+};
+#define DRM_IOCTL_NOUVEAU_NOTIFIEROBJ_ALLOC  DRM_IOWR(DRM_COMMAND_BASE + DRM_NOUVEAU_NOTIFIEROBJ_ALLOC, struct drm_nouveau_notifierobj_alloc)
+#endif
+
+#ifndef DRM_IOCTL_NOUVEAU_GPUOBJ_FREE
+struct drm_nouveau_gpuobj_free {
+	int      channel;
+	uint32_t handle;
+};
+#define DRM_IOCTL_NOUVEAU_GPUOBJ_FREE        DRM_IOW (DRM_COMMAND_BASE + DRM_NOUVEAU_GPUOBJ_FREE, struct drm_nouveau_gpuobj_free)
+#endif
+
 typedef struct {
 	int context;
 	unsigned long offset;
@@ -294,6 +389,13 @@ static const struct ioctl drm_ioctls[] = {
 	IOCTL(DRM_IOCTL_MGA_DMA_BOOTSTRAP),
 
 	/* nouveau_drm.h */
+	IOCTL(DRM_IOCTL_NOUVEAU_GETPARAM),
+	IOCTL(DRM_IOCTL_NOUVEAU_SETPARAM),
+	IOCTL(DRM_IOCTL_NOUVEAU_CHANNEL_ALLOC),
+	IOCTL(DRM_IOCTL_NOUVEAU_CHANNEL_FREE),
+	IOCTL(DRM_IOCTL_NOUVEAU_GROBJ_ALLOC),
+	IOCTL(DRM_IOCTL_NOUVEAU_NOTIFIEROBJ_ALLOC),
+	IOCTL(DRM_IOCTL_NOUVEAU_GPUOBJ_FREE),
 #ifdef DRM_IOCTL_NOUVEAU_GEM_NEW
 	IOCTL(DRM_IOCTL_NOUVEAU_GEM_NEW),
 #endif
-- 
1.8.1.4
