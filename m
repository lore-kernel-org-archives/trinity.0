From: tyson.w.smith@gmail.com
Subject: [PATCH 08/12] Cleaned up rand32() and remove __rand32()
Date: Fri,  6 Mar 2015 14:33:48 -0800
Message-ID: <1425681228-28673-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=RVIx8zMG5Fpnu2jzW9DRGrcw0VZAoP3tVufFv9/gVhI=;
        b=X89ncd9STawvPBtLf2VL6q9tDhkG1QvQlTkvg8OvIMNKRdg0bISzhdyhW9awHwJj7U
         q2ZR3VWwOEp2/lTSbowqTOf6qmC0kws2goZ3Mx6NJ92aKLbM2rw9dT+dFYVF+/hi+YdQ
         UhRc+18wa0xGUBF4GjuarUZWl9EP2nyz63wGsY89gnJzhOqj2AsYFX12Z1kdFvvgQi/9
         0k1eZSw89UZ2RAPvG39e+K2sMA8Jij+Q+aEHy8zqkdHjR71M+uLeDRIMxLDVA5dUCitE
         nlX691j+OD+CUaSypVcaHKeZc4otmqsDPBB7jLXYpD6ymaIoUN80ljbECocqZ1jtOL5f
         MttA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

Removed the block at the beginning of rand32() that just basically |s and ^s
rand() with rand() or a more interesting number to basically get rand again.
This is just an expensive way of getting a random number. Merged the small
switch case from __rand32() in to rand32() now that there is room.
---
 random.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/random.c b/random.c
index bf32648..ec20656 100644
--- a/random.c
+++ b/random.c
@@ -106,10 +106,9 @@ static unsigned long rept_byte(void)
 }
 
 /*
- * "selector" function for 32bit random.
- * only called from rand32()
+ * Generate, and munge a 32bit number.
  */
-static unsigned int __rand32(void)
+unsigned int rand32(void)
 {
 	unsigned long r = 0;
 
@@ -125,32 +124,6 @@ static unsigned int __rand32(void)
 	case 4:	return get_interesting_value();
 	}
 
-	return r;
-}
-
-/*
- * Generate, and munge a 32bit number.
- */
-unsigned int rand32(void)
-{
-	unsigned long r = 0;
-
-	r = __rand32();
-
-	if (rand_bool()) {
-		unsigned int i;
-		unsigned int rounds;
-
-		/* mangle it. */
-		rounds = rand() % 3;
-		for (i = 0; i < rounds; i++) {
-			if (rand_bool())
-				r |= __rand32();
-			else
-				r ^= __rand32();
-		}
-	}
-
 	/* Sometimes deduct it from INT_MAX */
 	if (rand_bool())
 		r = INT_MAX - r;
-- 
1.9.1
