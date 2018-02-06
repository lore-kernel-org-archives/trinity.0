From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 1/7] trinity: Fix compile error on linux 4.15 kernel
Date: Tue,  6 Feb 2018 09:02:23 +0100
Message-ID: <20180206080229.27721-1-tmricht@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org, davej@codemonkey.org.uk
Cc: brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Thomas Richter <tmricht@linux.vnet.ibm.com>

Commit 1f28c5d055032e7e8ee5e48198dca7e125d0eec6
("autofs: remove unused AUTOFS_IOC_EXPIRE_DIRECT/INDIRECT")

in the linux kernel removed the 2 defines
AUTOFS_IOC_EXPIRE_INDIRECT
AUTOFS_IOC_EXPIRE_DIRECT

Since they are used unconditionally the build fails.
To fix this add #ifdef/#endif around it.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 ioctls/autofs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ioctls/autofs.c b/ioctls/autofs.c
index a39ccccc..03eacaae 100644
--- a/ioctls/autofs.c
+++ b/ioctls/autofs.c
@@ -239,8 +239,15 @@ static const struct ioctl autofs_ioctls[] = {
 	IOCTL(AUTOFS_IOC_SETTIMEOUT),
 	IOCTL(AUTOFS_IOC_EXPIRE),
 	IOCTL(AUTOFS_IOC_EXPIRE_MULTI),
+	/* Both defines removed by kernel commit
+	 * 1f28c5d055032e7e8ee5e48198dca7e125d0eec6
+	 */
+#ifdef AUTOFS_IOC_EXPIRE_INDIRECT
 	IOCTL(AUTOFS_IOC_EXPIRE_INDIRECT),
+#endif
+#ifdef AUTOFS_IOC_EXPIRE_DIRECT
 	IOCTL(AUTOFS_IOC_EXPIRE_DIRECT),
+#endif
 	IOCTL(AUTOFS_IOC_PROTOSUBVER),
 	IOCTL(AUTOFS_IOC_ASKUMOUNT),
 
-- 
2.14.3
