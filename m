From: Praveen Pandey <praveen@linux.vnet.ibm.com>
Subject: [PATCH] fix trinity compilation (make) error in ppcle system
Date: Mon, 20 Jul 2015 14:29:16 +0530
Message-ID: <1437382756-4631-1-git-send-email-praveen@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: sachinp@in.ibm.com, Praveen Pandey <praveen@linux.vnet.ibm.com>

Solution include termios.h in ioctls/vt.c 

Signed-off-by: Praveen Pandey <praveen@linux.vnet.ibm.com>
---
 ioctls/vt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ioctls/vt.c b/ioctls/vt.c
index a4a7e0c..350416f 100644
--- a/ioctls/vt.c
+++ b/ioctls/vt.c
@@ -2,6 +2,7 @@
 #include <sys/ioctl.h>
 #include <linux/kd.h>
 #include <linux/serial.h>
+#include <sys/termios.h>
 
 #include "utils.h"
 #include "ioctls.h"
-- 
1.9.3
