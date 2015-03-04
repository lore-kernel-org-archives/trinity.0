From: tyson.w.smith@gmail.com
Subject: [PATCH 3/7] Unnest the get_interesting_<Nbit>_value() calls
Date: Wed,  4 Mar 2015 13:10:54 -0800
Message-ID: <1425503454-38059-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=D6mORCCZkZOCSD6QqiLfEbDaeawVrRAdqEmGcUzVkiw=;
        b=fahS0lcNPH+FytEC9fEB8/+E2ynkA96XS8V8Y+FGKdec/hkpxXQ1Q5NTdSAfBcJsd0
         rw7AehWjzbztJAqRadbEdkw/MKRmFjYHGSimrrq2WtqnY+OpNPtcmJm9PN7iAlLyNZQR
         L80i8Y7bLEwQeNo9/T4yoDAj5XjrRBvJ+5DGEC/hEJzzZouNeXIFtk6s5b3M/lVlc9mi
         aMJzDWAKxrekqW3HylBVfvi8UbizmMOvNgh/fiu15G/IHsbcjURsc77+lMQYuvT441eH
         WnamCEqymVfKtKLGw5HrDtGDEniZqpD92cv4VewFD/bg2dmfsOHNfQKcK8sSNBGCPMYQ
         YUvA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

This will help evenly distribute the calls to each
get_interesting_<Nbit>_value() functions. It will also make the modification
to the distribution easier in the future if tweaks are needed. Move call to
plus_minus_two() from get_interesting_32bit_value() to get_interesting_value().
---
 interesting-numbers.c | 61 +++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/interesting-numbers.c b/interesting-numbers.c
index 4b23b4c..e08e27d 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -35,22 +35,20 @@ static int get_interesting_16bit_value(void)
 {
 	int num = 0;
 
-	switch (rand() % 8) {
+	switch (rand() % 7) {
 	case 0:	num = 0;
 		break;
-	case 1:	num = get_interesting_8bit_value();
+	case 1:	num = -32768;
 		break;
-	case 2:	num = -32768;
+	case 2:	num = -129;
 		break;
-	case 3:	num = -129;
+	case 3:	num = 255;
 		break;
-	case 4:	num = 255;
+	case 4:	num = 32767;
 		break;
-	case 5:	num = 32767;
+	case 5:	num = 1UL << (rand() % 15);
 		break;
-	case 6:	num = 1UL << (rand() % 15);
-		break;
-	case 7:	num = rand() % 0xffff;
+	case 6:	num = rand() % 0xffff;
 		break;
 	}
 
@@ -61,37 +59,28 @@ unsigned int get_interesting_32bit_value(void)
 {
 	unsigned int num = 0;
 
-	switch (rand() % 11) {
+	switch (rand() % 9) {
 	case 0:	num = 0;
 		break;
-
-	case 1:	num = get_interesting_8bit_value();
+	case 1:	num = 1UL << (rand() % 32);	// set a single bit.
 		break;
-
-	case 2:	num = get_interesting_16bit_value();
+	case 2:	num = 0x8fffffff;
 		break;
-
-	case 3:	num = 1UL << (rand() % 32);	// set a single bit.
-		break;
-	case 4:	num = 0x8fffffff;
-		break;
-	case 5:	num = 0xff;
+	case 3:	num = 0xff;
 		num = num << (rand() % 31);
 		break;
-	case 6: num = 0xffff0000;
+	case 4: num = 0xffff0000;
 		break;
-	case 7: num = 0xffffe000;
+	case 5: num = 0xffffe000;
 		break;
-	case 8: num = 0xffffff00 | (rand() % 256);
+	case 6: num = 0xffffff00 | (rand() % 256);
 		break;
-	case 9: num = 0xffffffff - page_size;
+	case 7: num = 0xffffffff - page_size;
 		break;
-	case 10: num = 0xffffffff;
+	case 8: num = 0xffffffff;
 		break;
 	}
 
-	num = rand() & 0xf ? num : plus_minus_two(num);	// 1 in 16 call plus_minus_two
-
 	return num;
 }
 
@@ -119,13 +108,19 @@ static unsigned long per_arch_interesting_addr(unsigned long low)
 
 unsigned long get_interesting_value(void)
 {
-#if __WORDSIZE == 32
-	return get_interesting_32bit_value();
-#else
 	unsigned long low = 0;
 
-	if (rand_bool())
-		low = get_interesting_32bit_value();
+	switch (rand() % 3) {
+	case 0:	low = get_interesting_8bit_value();
+		break;
+	case 1:	low = get_interesting_16bit_value();
+		break;
+	case 2: low = get_interesting_32bit_value();
+		break;
+	}
+
+	low = (rand() & 0xf) ? low : plus_minus_two(low);	// 1 in 16 call plus_minus_two
+#if __WORDSIZE != 32
 
 	switch (rand() % 13) {
 	case 0: return 0;
@@ -143,6 +138,6 @@ unsigned long get_interesting_value(void)
 	case 12: return (low << 32);
 	}
 
-	return low;	// unreachable, but gcc is dumb.
 #endif	/* __WORDSIZE */
+	return low;
 }
-- 
1.9.1
