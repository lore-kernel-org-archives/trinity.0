From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 2/3] tile: add arch-tile.h
Date: Wed, 14 May 2014 13:42:05 +0800
Message-ID: <5373022D.1040808@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=txhWJer5R8gaQcM/ncSkGQEdiARMUlEjnhM+Vo1n2yQ=;
        b=ejOvpyY7GzoJNAoObirm6gJueIlD9t5nZxZ8ar4hqIByOyd4LCb8ESbyhyXaYhrd37
         jWfXrQjCk7VrEUFNDpA+HmljWaYxU+kPxgTIv7idEd5zj8T/pRzkN9oS3mOH/B//ajdD
         CmyD961D4ksGbEeHM8gx3YsMxyy5B4d2IuQDAb07fwtjsqpysG27FdAsrAWGy5OII/o2
         8g3e5xqM/MqtGAQ1/o+iKGq0R5/9xEpdvu2J+bYlLTgS2Fh1SPjyjaH9QxXqfMSJ9yzH
         WLVcGY8b30BCuNJfJTwpllAsw2tLaBDZAbK9eluYEQULHslpIqamgyoU+CCoAJ6PYImu
         yxrA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org


Add Tilera constants definition.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

 create mode 100644 include/arch-tile.h

diff --git a/include/arch-tile.h b/include/arch-tile.h
new file mode 100644
index 0000000..785b236
--- /dev/null
+++ b/include/arch-tile.h
@@ -0,0 +1,25 @@
+#pragma once
+
+#ifdef __tilegx__
+
+#define MAX_VA_WIDTH   42
+#define MAX_PA_WIDTH   40
+
+#define PAGE_OFFSET            (-(1 << (MAX_VA_WIDTH - 1)))
+#define KERNEL_HIGH_VADDR       0xfffffff800000000  /* high 32GB */
+#define MEM_SV_START            (KERNEL_HIGH_VADDR - 0x100000000) /* 256 MB */
+#define MEM_MODULE_START        (MEM_SV_START + (256*1024*1024)) /* 256 MB */
+#define MEM_MODULE_END          (MEM_MODULE_START + (256*1024*1024))
+#define KERNEL_ADDR            MEM_SV_START
+#define MODULE_ADDR            MEM_MODULE_START
+
+#define TASK_SIZE_MAX           (1 << (MAX_VA_WIDTH - 1))
+#define TASK_SIZE               TASK_SIZE_MAX
+
+#define PAGE_SHIFT     16
+#define PTE_FILE_MAX_BITS 32
+#define BITS_PER_LONG  64
+
+#endif
+
+#define SYSCALLS syscalls_tile
-- 
1.7.1
