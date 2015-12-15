From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC PATCH] nvme ioctl support
Date: Tue, 15 Dec 2015 15:19:04 +0100
Message-ID: <1450189144-12735-1-git-send-email-jthumshirn@suse.de>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

Add support for NVMe ioctls

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 ioctls/nvme.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 ioctls/nvme.c

diff --git a/ioctls/nvme.c b/ioctls/nvme.c
new file mode 100644
index 0000000..5588e81
--- /dev/null
+++ b/ioctls/nvme.c
@@ -0,0 +1,39 @@
+#include <linux/ioctl.h>
+#include <linux/nvme.h>
+
+#include "utils.h"
+#include "ioctls.h"
+
+static const struct ioctl nvme_ioctls[] = {
+	IOCTL(NVME_IOCTL_ID),
+	IOCTL(NVME_IOCTL_ADMIN_CMD),
+	IOCTL(NVME_IOCTL_SUBMIT_IO),
+	IOCTL(NVME_IOCTL_IO_CMD),
+	IOCTL(NVME_IOCTL_RESET),
+};
+
+static const char *const nvme_devs[] = {
+	"nvme",
+};
+
+static const struct ioctl_group nvme_grp_misc = {
+	.devtype = DEV_CHAR,
+	.devs = nvme_devs,
+	.devs_cnt = ARRAY_SIZE(nvme_devs),
+	.sanitise = pick_random_ioctl,
+	.ioctls = nvme_ioctls,
+	.ioctls_cnt = ARRAY_SIZE(nvme_ioctls),
+};
+
+REG_IOCTL_GROUP(nvme_grp_misc)
+
+static const struct ioctl_group nvme_grp_block = {
+	.devtype = DEV_BLOCK,
+	.devs = nvme_devs,
+	.devs_cnt = ARRAY_SIZE(nvme_devs),
+	.sanitise = pick_random_ioctl,
+	.ioctls = nvme_ioctls,
+	.ioctls_cnt = ARRAY_SIZE(nvme_ioctls),
+};
+
+REG_IOCTL_GROUP(nvme_grp_block);
-- 
2.6.3
