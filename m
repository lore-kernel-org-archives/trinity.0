From: tyson.w.smith@gmail.com
Subject: [PATCH 6/7] fix undefined behavior
Date: Mon, 16 Mar 2015 13:26:47 -0700
Message-ID: <1426537607-55003-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=I/xX4Iw+U9F53eYwBMR6tgrm4zlvzzjkv7M+t9sSD8s=;
        b=HHdKNYTfKmkqKosT5VFcDNfbrAnwiqoIawoSoM1E7VE0E1O5o+HURRCy9tm/pMu0sg
         HR/tTv1IbmH08IQLjEwSJQyqwqioTfQkIpwl4tpvBsDmK5eaWP+pJmrOpCmE97TfO0oR
         uUQ4N0hQk8QqtbL5PAGOKfEegG+6mZOb84DpZe2r3PhWC5r68rJxY3WdQiHTPgGfooAc
         fz9pCYi51caaPqQFdNVydSTiXsBwHIyXKvdOh+RhEWR/zikCOqwdE9r9eUKgCGKetu1h
         GDr93Gdi2lG/SxDGBDTtkjNKfn20YMQgX5WCpBS9KfrGvNVQxEF//1f0rLSFyyFz3DfE
         m8Rg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

---
 include/random.h      | 6 ++++--
 interesting-numbers.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/random.h b/include/random.h
index e30dd9f..4e95996 100644
--- a/include/random.h
+++ b/include/random.h
@@ -7,8 +7,10 @@
 #define ONE_IN(x)				((rand() % x) == 0)	// limit of RAND_MAX-1
 
 #if RAND_MAX == 0x7FFFFFFF
-#define RAND_32()				((rand() << 1) | (rand() & 1))
-#define RAND_64()				(((0ULL | rand()) << 33) | ((0ULL | rand()) << 2) | (rand() & 0x3))
+#define RAND_32()				(((unsigned int)rand() << 1) | (rand() & 1))
+#define RAND_64()				(((unsigned long long)rand() << 33) | \
+								 ((unsigned long long)rand() << 2) | \
+								 (rand() & 0x3))
 #else
 #error "Unexpected RAND_MAX value. Please add support."
 #endif
diff --git a/interesting-numbers.c b/interesting-numbers.c
index 66728dd..2fecf3a 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -46,7 +46,7 @@ static unsigned int get_interesting_32bit_value(void)
 	switch (rand() % 10) {
 	case 0: return 0x80000000 >> (rand() & 0x1f);	// 2^n (1 -> 0x10000)
 	case 1: return rand();							// 0 -> RAND_MAX (likely 0x7fffffff)
-	case 2: return 0xff << (rand() % 25);
+	case 2: return 0xffUL << (rand() % 25);
 	case 3: return 0xffff0000;
 	case 4: return 0xffffe000;
 	case 5: return 0xffffff00 | RAND_BYTE();
-- 
1.9.1
