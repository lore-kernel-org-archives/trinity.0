From: tyson.w.smith@gmail.com
Subject: [PATCH 2/7] remove randbits()
Date: Mon, 16 Mar 2015 13:25:41 -0700
Message-ID: <1426537541-54831-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=LNJKhNmb6g+WeG4/KLk5s/bABp4uFinKxGmPEDChJiM=;
        b=aNWPn9uh8lp9Brts7bpEJ9VdC5yPTc1UzzYIO01oCa5CPXWkDqYd9fFoEETTDWSUtu
         ZYNCm7nVKrwAc+tJX1l9ZIOA7mqpKJiAGX6ZzyFEmD+uP15093CV7BJ+Vmy7hrM4+/gt
         Xm1ihWAbHXiXJRYXbUwBwmT4io9f8NaEyTTzwS4givJF1RFHRCKhpEUo0/pJsMoqUxqK
         XWXZY9hSPWNX7r69A6sJ+cwzqRtB4de8KGOxE6gA5kC8SDreoEqakZ1rXPyz6C/ZYX2T
         6+SLojnSsXtlDyDmg8PxjYvVd4sdC9T6v2Ka2B06le6JQmJCYKI4KPYupL5ZnTiLOxvY
         OcEQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

randbits() acts very much like rand() & rand() and does not
provide much value in this context. This function would likely
be more useful in a random bit mask scenario.
---
 random.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/random.c b/random.c
index 6b824bf..7917f78 100644
--- a/random.c
+++ b/random.c
@@ -68,21 +68,6 @@ unsigned long rand_single_bit(unsigned char size)
 }
 
 /*
- * set N bits, where N= rand(0 - WORDSIZE/2)
- */
-static unsigned long randbits(int limit)
-{
-	unsigned int num = rand() % (limit / 2);
-	unsigned int i;
-	unsigned long r = 0;
-
-	for (i = 0; i < num; i++)
-		r |= (1UL << (rand() % (limit - 1)));
-
-	return r;
-}
-
-/*
  * Pick 1 random byte, and repeat it through a long.
  */
 static unsigned long rept_byte(void)
@@ -104,16 +89,14 @@ unsigned int rand32(void)
 {
 	unsigned long r = 0;
 
-	switch (rand() % 5) {
+	switch (rand() % 4) {
 	case 0: r = rand_single_bit(32);
 		break;
-	case 1:	r = randbits(32);
+	case 1: r = RAND_32();
 		break;
-	case 2: r = RAND_32();
+	case 2:	r = rept_byte();
 		break;
-	case 3:	r = rept_byte();
-		break;
-	case 4:	return get_interesting_value();
+	case 3:	return get_interesting_value();
 	}
 
 	/* Sometimes deduct it from INT_MAX */
@@ -160,17 +143,15 @@ u64 rand64(void)
 
 	} else {
 		/* 33:64-bit ranges. */
-		switch (rand() % 5) {
+		switch (rand() % 4) {
 		case 0:	r = rand_single_bit(64);
 			break;
-		case 1:	r = randbits(64);
-			break;
-		case 2:	r = RAND_64();
+		case 1:	r = RAND_64();
 			break;
-		case 3:	r = rept_byte();
+		case 2:	r = rept_byte();
 			break;
 		/* Sometimes pick a not-so-random number. */
-		case 4:	return get_interesting_value();
+		case 3:	return get_interesting_value();
 		}
 
 		/* limit the size */
-- 
1.9.1
