From: Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 2/2] ioctls/vfs.c: FS_IOC_GETFSMAP
Date: Wed, 21 Jun 2017 21:33:58 +0300
Message-ID: <20170621183358.25578-2-tommi.t.rantala@nokia.com>
References: <20170621183358.25578-1-tommi.t.rantala@nokia.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=m5tPv25WBIujOpwZ2Yo2QrBpMcy9Kj4X0fpKIm6rB7U=;
 b=jKRGjm4XWo5dRAOt12evG79gbLo/jdAy4Lv7t9me7fakuDu8X/QfL46CksnYjfhplBODZOcs4BdxBfAB2jrwDtKknZX5l5rq/Xms2qPaXiDa1Y2SOhRaTX8zvcsRy9A6h8fFRQ9jOwT8ZeCXsqZKD0wELVEjTqLM7ZK3jhtV3C4=
In-Reply-To: <20170621183358.25578-1-tommi.t.rantala@nokia.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>

---
 configure    | 1 +
 ioctls/vfs.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/configure b/configure
index 8639a38e..450c94ad 100755
--- a/configure
+++ b/configure
@@ -291,6 +291,7 @@ fi
 #############################################################################################
 
 check_header linux/caif/caif_socket.h USE_CAIF
+check_header linux/fsmap.h USE_FSMAP
 check_header linux/if_alg.h USE_IF_ALG
 check_header linux/rds.h USE_RDS
 check_header linux/vfio.h USE_VFIO
diff --git a/ioctls/vfs.c b/ioctls/vfs.c
index 0bad6f56..1f60da45 100644
--- a/ioctls/vfs.c
+++ b/ioctls/vfs.c
@@ -2,6 +2,9 @@
 #include <linux/fiemap.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
+#ifdef USE_FSMAP
+#include <linux/fsmap.h>
+#endif
 #include <linux/ioctl.h>
 #include <asm/ioctls.h>
 #include "ioctls.h"
@@ -241,6 +244,9 @@ static const struct ioctl vfs_ioctls[] = {
 #ifdef FS_IOC_GET_ENCRYPTION_POLICY
 	{ .name = "FS_IOC_GET_ENCRYPTION_POLICY", .request = FS_IOC_GET_ENCRYPTION_POLICY, },
 #endif
+#ifdef FS_IOC_GETFSMAP
+	{ .name = "FS_IOC_GETFSMAP", .request = FS_IOC_GETFSMAP, },
+#endif
 };
 
 static const struct ioctl_group vfs_grp = {
-- 
2.13.0
