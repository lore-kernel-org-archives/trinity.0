From: tyson.w.smith@gmail.com
Subject: [PATCH 10/12] Decrease the likelihood of performing mangling operations
Date: Fri,  6 Mar 2015 14:35:14 -0800
Message-ID: <1425681314-28780-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=TKwxZkrdzgJro6o9RGzmfGRIYYMLkRpkoqXzgkqb3NQ=;
        b=wS2r3QVYvy/PI7U+yYMdd9Fh78x7ILz9soYM4KA0hWtuAyVbizDmCEc5fQ3Ue9HuZg
         kcOMCiTq0IP8tSS40+AXlvxU9LawDZA7XTi2LdwG2zm57F6Oe9lugc2Eilv1mvyWKksp
         LrIbtEqPQC1tElVZiYgF/JMYowCiSMbnw+VWRAMIvBw0kRd6RCOjOfUyA5RPYdXaYiKR
         27lut59Ct4LEcU35xDtr3nZveJxmHrPi/Ophq00S8UoAoPVS3Ae/roFa7pX4oLU/lh6O
         DmteOSIwrKOCQSiTUj3DG+q6HfXoAEezWDCs+gm1ustKR+kAB+TZ+rQcNv1m1CF0aTc0
         x3PQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

These operations provide value however if they happen too often it prevents
the use of unmodified values that are generated that are more significant.
---
 random.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/random.c b/random.c
index d671035..fd5f2c0 100644
--- a/random.c
+++ b/random.c
@@ -125,11 +125,11 @@ unsigned int rand32(void)
 	}
 
 	/* Sometimes deduct it from INT_MAX */
-	if (rand_bool())
+	if (ONE_IN(25))
 		r = INT_MAX - r;
 
 	/* Sometimes flip sign */
-	if (rand_bool())
+	if (ONE_IN(25))
 		r = ~r + 1;
 
 	/* we might get lucky if something is counting ints/longs etc. */
@@ -193,11 +193,11 @@ u64 rand64(void)
 	}
 
 	/* Sometimes invert the generated number. */
-	if (rand_bool())
+	if (ONE_IN(25))
 		r = ~r;
 
 	/* increase distribution in MSB */
-	if ((rand() % 10)) {
+	if (ONE_IN(10)) {
 		unsigned int i;
 		unsigned int rounds;
 
@@ -207,7 +207,7 @@ u64 rand64(void)
 	}
 
 	/* Sometimes flip sign */
-	if (rand_bool())
+	if (ONE_IN(25))
 		r = ~r + 1;
 
 	return r;
-- 
1.9.1
