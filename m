From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 3/3] include tile headers
Date: Wed, 14 May 2014 13:42:48 +0800
Message-ID: <53730258.1000000@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=1VK2l7lewgzNxFZ6Z2LXwFcrPvtMnGg6+0Cj1s3iJ9o=;
        b=w4rvmX9IhkNjF8UMJnpXgofvGK17zNBUY+ByaGS5MR07pxdAqYoUGoOoLbzYo9wkmW
         IyXEFehAY+mFmYeTFF9nVEYsjolN+sQtL3SIaZIQoQbnhdcgQgUkIIWMxVudUyJIE+ns
         xNienDrkZ1jX4Koou7ievIGnd6saSYVwtTJ4XO05qyJmDJqyGedF3CE9CzYQ4Ob7NBqd
         /aUhDvZt3CCcJM09zJWT0AQfPePL0LlEmOZF2lC1ihM29HcbouImmGV5zHBKweNNLgAe
         s5ENY1W8H5Eph427HQhfSJt5Kse6FmErRZzGQgWzbqabePBBuPllXi86zF1G84d8usop
         BxlA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org


Include tile headers to add in the tile support.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

diff --git a/include/arch-syscalls.h b/include/arch-syscalls.h
index a30bb49..3e24d8d 100644
--- a/include/arch-syscalls.h
+++ b/include/arch-syscalls.h
@@ -40,3 +40,6 @@
 #ifdef __hppa__
 #include "syscalls-parisc.h"
 #endif
+#ifdef __tile__
+#include "syscalls-tile.h"
+#endif
diff --git a/include/arch.h b/include/arch.h
index 92c1aaf..a641e5b 100644
--- a/include/arch.h
+++ b/include/arch.h
@@ -50,6 +50,10 @@
 #include "arch-parisc.h"
 #endif

+#ifdef __tile__
+#include "arch-tile.h"
+#endif
+
 #ifndef SYSCALL_OFFSET
 #define SYSCALL_OFFSET 0
 #endif
-- 
1.7.1
