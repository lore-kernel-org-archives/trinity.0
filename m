From: tyson.w.smith@gmail.com
Subject: [PATCH 03/12] Remove rand8x8()
Date: Fri,  6 Mar 2015 14:29:59 -0800
Message-ID: <1425680999-28404-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=PScaf2x5d9yzzUu4xRfIvlf2iX2L8XOUzdJ56W+TNb4=;
        b=Hklymd3fU2xFVj5vZodRodDA1LXIPA362LIDZpdXSmPtX+RrJIR+0NqbjebgZ0rNHd
         ozkrPngNEcbK4IYNDf2Fg+L/57mArSSzuKwZt1hrX2RumWNNdJafSQ+tnEiKUExqhCla
         fZt37UUpAYn8w4EMRpYSmd0ckBYC99oGz4GdaM17HLu2Ybo1nFvWjCaIwcoEtPQD89Ao
         3Lbq4W6msDZUburMD0MeNUw03iVcP2Q4SBag5igQT85oaiGCvxG3W1lERJzcp70PIV0s
         JmQlCYCccaCCiTQH54RXbLpMmZRxRhhgPmZ3QmQr2MZxlxlqMd7BN/DyBb9IUlQYO6yX
         XQog==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

Removed rand8x8() function since it is essentially the same as a call
to RAND_32 or RAND_64.
---
 random.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/random.c b/random.c
index f425ed5..adee25e 100644
--- a/random.c
+++ b/random.c
@@ -90,20 +90,6 @@ static unsigned long randbits(int limit)
 }
 
 /*
- * Pick 8 random bytes, and concatenate them into a long.
- */
-static unsigned long rand8x8(void)
-{
-	unsigned long r = 0UL;
-	unsigned int i;
-
-	for (i = rand_range(1, 7); i > 0; --i)
-		r = (r << 8) | rand() % 256;
-
-	return r;
-}
-
-/*
  * Pick 1 random byte, and repeat it through a long.
  */
 static unsigned long rept8(unsigned int num)
@@ -127,18 +113,16 @@ static unsigned int __rand32(void)
 {
 	unsigned long r = 0;
 
-	switch (rand() % 6) {
+	switch (rand() % 5) {
 	case 0: r = rand_single_bit(32);
 		break;
 	case 1:	r = randbits(32);
 		break;
 	case 2: r = RAND_32();
 		break;
-	case 3:	r = rand8x8();
-		break;
-	case 4:	r = rept8(4);
+	case 3:	r = rept8(4);
 		break;
-	case 5:	return get_interesting_value();
+	case 4:	return get_interesting_value();
 	}
 
 	return r;
@@ -211,19 +195,17 @@ u64 rand64(void)
 
 	} else {
 		/* 33:64-bit ranges. */
-		switch (rand() % 6) {
+		switch (rand() % 5) {
 		case 0:	r = rand_single_bit(64);
 			break;
 		case 1:	r = randbits(64);
 			break;
 		case 2:	r = RAND_64();
 			break;
-		case 3:	r = rand8x8();
-			break;
-		case 4:	r = rept8(8);
+		case 3:	r = rept8(8);
 			break;
 		/* Sometimes pick a not-so-random number. */
-		case 5:	return get_interesting_value();
+		case 4:	return get_interesting_value();
 		}
 
 		/* limit the size */
-- 
1.9.1
