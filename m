From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 5/5] btrfs/ioctl.h is not really needed
Date: Sun,  5 Feb 2017 17:53:52 +0200
Message-ID: <20170205155352.13191-5-tt.rantala@gmail.com>
References: <20170205155352.13191-1-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s5ikwBUMvU5VHZzBlcPNtirgEr0JpDE8yvEwn6+k0kY=;
        b=VDDoWDJm9cGm/Lsso7X/D2q6EVtaKbec0VY3uLjUFxsrq1G1iX4cxXuKITpktSE5pT
         R8Du2ADQn2+sU0OugONLNZNDO0NbZUPzAGBJTM8Bq5Zjyt+MPj1HxJk5GUrVw8lfa0nx
         BYDzksO7pVmeMUsT/6C1ejv1bMBaer7OXnoRUsxFClyWdVv0pAjL3lGB5j5ZCUJe+aq/
         lD0Y57sD5mDdM6B+rR3NkWGS4aNC+alatcaMIDzI18OPNetjo8KhyCirlqnGWRWZlhbo
         s0WlDHAe7qor0V3FDbj08AR9EVx4tmMcKh4A+MMyqOmJ2dznN+1troTzuFbTQEtFv7NP
         K9SQ==
In-Reply-To: <20170205155352.13191-1-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

<linux/btrfs.h> has the ioctl definitions we want, so I see no reason for
checking for <btrfs/ioctl.h>.
---
 configure      | 1 -
 ioctls/btrfs.c | 7 +++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index dc09317..dff66d3 100755
--- a/configure
+++ b/configure
@@ -255,7 +255,6 @@ check_header linux/if_alg.h USE_IF_ALG
 check_header linux/rds.h USE_RDS
 check_header linux/vfio.h USE_VFIO
 check_header linux/btrfs.h USE_BTRFS
-check_header btrfs/ioctl.h USE_BTRFS_IOCTL
 check_header drm/drm.h USE_DRM
 check_header drm/exynos_drm.h USE_DRM_EXYNOS
 check_header sound/compress_offload.h USE_SNDDRV_COMPRESS_OFFLOAD
diff --git a/ioctls/btrfs.c b/ioctls/btrfs.c
index 374baa6..fd9c4b4 100644
--- a/ioctls/btrfs.c
+++ b/ioctls/btrfs.c
@@ -1,9 +1,8 @@
 #include "config.h"
-#ifdef USE_BTRFS_IOCTL
+#ifdef USE_BTRFS
 #include <stdio.h>
 #include <linux/fs.h>
-
-#include <btrfs/ioctl.h>
+#include <linux/btrfs.h>
 #include "ioctls.h"
 #include "shm.h"
 #include "utils.h"
@@ -122,4 +121,4 @@ static const struct ioctl_group btrfs_grp = {
 };
 
 REG_IOCTL_GROUP(btrfs_grp)
-#endif /* USE_BTRFS_IOCTL */
+#endif /* USE_BTRFS */
-- 
2.9.3
