From: Will Deacon <will.deacon@arm.com>
Subject: [PATCH] ARM: tidy up arch-specific constants
Date: Wed, 21 Aug 2013 11:36:08 +0100
Message-ID: <1377081368-1609-1-git-send-email-will.deacon@arm.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>

arch-arm.h is basically a copy of arch-i386.h, but there are differences
between the two, so tidy up the ARM header to match exactly how the
kernel is structured.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/arch-arm.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/arch-arm.h b/include/arch-arm.h
index d496d94..a711df0 100644
--- a/include/arch-arm.h
+++ b/include/arch-arm.h
@@ -1,16 +1,13 @@
-#define KERNEL_ADDR	0xc0100220
-#define MODULE_ADDR     0xa0000000	//FIXME: Placeholder
-
-#define PAGE_OFFSET 0xC0000000
-#define TASK_SIZE (PAGE_OFFSET)
+#define PAGE_OFFSET		0xC0000000
 /*
  * Alternative possibilities for PAGE_OFFSET:
- * default 0xB0000000 if VMSPLIT_3G_OPT
- * default 0x78000000 if VMSPLIT_2G
  * default 0x40000000 if VMSPLIT_1G
+ * default 0x80000000 if VMSPLIT_2G
  */
+#define TASK_SIZE		(PAGE_OFFSET - 0x01000000)
+#define MODULE_ADDR		(PAGE_OFFSET - 0x00800000)
+#define KERNEL_ADDR		(PAGE_OFFSET + 0x00008000)
 
-#define PAGE_SHIFT 12
-
-#define PTE_FILE_MAX_BITS 31
+#define PAGE_SHIFT		12
 
+#define PTE_FILE_MAX_BITS	29
-- 
1.8.2.2
