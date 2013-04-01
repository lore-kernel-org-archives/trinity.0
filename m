From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/9] Check 'drm.h' existence
Date: Mon,  1 Apr 2013 21:58:32 +0300
Message-ID: <1364842720-24127-2-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=ZxOb5sBVQWSj+pWUWCAX4z4pOI+WujbcKT+p7GBwynU=;
        b=uMY5+15Ae9uUFqW7kLpQwtU/XHvu8CPpib5E9TZLeiTWakWtzE3hVhv7wEdBZtunqq
         ppebywkf6aDS1vHmWwFLv409teyOu8Ed//gtcjr2uQn5F9Js55ChaOCbvce9+BfuH+vV
         Ow4qjap7DtUj4KN3FexxY/ExassbdHcIY+90aQ+eQkdXmRpxRWWUOUu/X/LeF4zfB/Dc
         CB5741ToHWVe9wxCjfHllfma4LSrpPgS2GMkw66CyMHV81h51l2eWS9yvt0qmZvPvSKI
         nJd4bOW5jRPE1jK7PlEHKaCWUUMVuaAnkvmM6KtZYkqiKhlz6rVLm5aEl4wwJKP4Brbp
         3UrA==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

None of the DRM headers were available when I tried IA64 cross
compilation with some old kernel headers.
---
 configure.sh |    1 +
 ioctls/drm.c |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/configure.sh b/configure.sh
index 5e54355..98b740d 100755
--- a/configure.sh
+++ b/configure.sh
@@ -175,6 +175,7 @@ file_exists linux/if_alg.h USE_IF_ALG
 file_exists linux/rds.h USE_RDS
 file_exists linux/vfio.h USE_VFIO
 file_exists linux/btrfs.h USE_BTRFS
+file_exists drm/drm.h USE_DRM
 file_exists drm/exynos_drm.h USE_DRM_EXYNOS
 file_exists sound/compress_offload.h USE_SNDDRV_COMPRESS_OFFLOAD
 file_exists linux/vhost.h USE_VHOST
diff --git a/ioctls/drm.c b/ioctls/drm.c
index afb3147..5740021 100644
--- a/ioctls/drm.c
+++ b/ioctls/drm.c
@@ -1,5 +1,7 @@
 #include "config.h"
 
+#ifdef USE_DRM
+
 #include <stdlib.h>
 #include <inttypes.h>
 
@@ -422,3 +424,5 @@ static const struct ioctl_group drm_grp = {
 };
 
 REG_IOCTL_GROUP(drm_grp)
+
+#endif /* USE_DRM */
-- 
1.7.9.5
