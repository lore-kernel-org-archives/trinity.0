From: tyson.w.smith@gmail.com
Subject: [PATCH 6/7] Simplify get_interesting_32bit_value()
Date: Wed,  4 Mar 2015 13:12:17 -0800
Message-ID: <1425503537-38190-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=B86PzBeWSX814qNPxOhic26OufdWYI0YTQMpcTQKo3I=;
        b=y2dWVZahYfZGeL0ik0vnoEGRO+6oqZUJWCFJBOAd9jqG4DPNv/2djZ7aEbfvVoP9J8
         p+lklbWA3j11nzYgQN5h//zsDhMIUFv86x/Oe4Iq0N1Znjzkobrx9/kWm+nuimIhLHok
         5syJo4uRqsW2O8EiWY6FCb6DkIyqzjrb+HCy09M5kIuutrfL2Zf8u0Vy/41K41loT8ht
         gmbfOFE6Zwvz1PxhdoTSuKhoPsNrAbVIgEJqYEgNU8shhefB8481sF2lfUnZDZBVFZZ9
         SbvxjgNm9e+RApPDocG+7+3ZZvzQDb66bY4HiW1XCq+w/EDXBqtj67B90j3IODRZ/25a
         9AEQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

Removed values that overlap with values generated but the other functions.
Added multiple of page_size case.
---
 interesting-numbers.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/interesting-numbers.c b/interesting-numbers.c
index 070ddfa..4b4e785 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -43,31 +43,18 @@ static unsigned short get_interesting_16bit_value(void)
 
 static unsigned int get_interesting_32bit_value(void)
 {
-	unsigned int num = 0;
-
-	switch (rand() % 9) {
-	case 0:	num = 0;
-		break;
-	case 1:	num = 1UL << (rand() % 32);	// set a single bit.
-		break;
-	case 2:	num = 0x8fffffff;
-		break;
-	case 3:	num = 0xff;
-		num = num << (rand() % 31);
-		break;
-	case 4: num = 0xffff0000;
-		break;
-	case 5: num = 0xffffe000;
-		break;
-	case 6: num = 0xffffff00 | (rand() % 256);
-		break;
-	case 7: num = 0xffffffff - page_size;
-		break;
-	case 8: num = 0xffffffff;
-		break;
+	switch (rand() % 10) {
+	case 0: return 0x80000000 >> (rand() & 0x1f);	// 2^n (1 -> 0x10000)
+	case 1: return rand();							// 0 -> RAND_MAX (likely 0x7fffffff)
+	case 2: return 0xff << (rand() % 25);
+	case 3: return 0xffff0000;
+	case 4: return 0xffffe000;
+	case 5: return 0xffffff00 | (rand() & 0xff);
+	case 6: return 0xffffffff - page_size;
+	case 7: return page_size;
+	case 8: return page_size * ((rand() % (0xffffffff/page_size)) + 1);
+	default: return 0xffffffff;						// max
 	}
-
-	return num;
 }
 
 #if __WORDSIZE != 32
-- 
1.9.1
