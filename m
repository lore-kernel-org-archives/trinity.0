From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Check for btrfs_ioctl_defrag_range_args.
Date: Fri, 17 Mar 2017 22:58:28 +0000
Message-ID: <1489791508-24580-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

btrfs_ioctl_defrag_range_args is not available until Linux 4.7.

Fix build error on earlier kernels.

  CC	ioctls/btrfs.o
In file included from /usr/include/x86_64-linux-gnu/asm/ioctl.h:1:0,
                 from /usr/include/linux/ioctl.h:4,
                 from /usr/include/linux/fs.h:10,
                 from ioctls/btrfs.c:3:
ioctls/btrfs.c:71:49: error: invalid application of ‘sizeof’ to incomplete type ‘struct btrfs_ioctl_defrag_range_args’
  { .name = "BTRFS_IOC_DEFRAG_RANGE", .request = BTRFS_IOC_DEFRAG_RANGE, },
                                                 ^

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 configure | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 03632d7..770d15b 100755
--- a/configure
+++ b/configure
@@ -251,12 +251,36 @@ else
 fi
 
 #############################################################################################
+# is /usr/include/linux/btrfs.h new enough to feature btrfs
+#
+echo -n "[*] Checking if btrfs can use btrfs_ioctl_defrag_range_args.. "
+rm -f "$TMP" || exit 1
+
+cat >"$TMP.c" << EOF
+#include <stdio.h>
+#include <linux/btrfs.h>
+
+void main()
+{
+	struct btrfs_ioctl_defrag_range_args args;
+}
+EOF
+
+${CC} ${CFLAGS} "$TMP.c" -o "$TMP" &>"$TMP.log"
+if [ ! -x "$TMP" ]; then
+        echo $RED "[NO]" $COL_RESET
+        MISSING_DEFS=1
+else
+        echo $GREEN "[YES]" $COL_RESET
+        echo "#define USE_BTRFS 1" >> $CONFIGH
+fi
+
+#############################################################################################
 
 check_header linux/caif/caif_socket.h USE_CAIF
 check_header linux/if_alg.h USE_IF_ALG
 check_header linux/rds.h USE_RDS
 check_header linux/vfio.h USE_VFIO
-check_header linux/btrfs.h USE_BTRFS
 check_header drm/drm.h USE_DRM
 check_header drm/exynos_drm.h USE_DRM_EXYNOS
 check_header sound/compress_offload.h USE_SNDDRV_COMPRESS_OFFLOAD
-- 
2.7.4
