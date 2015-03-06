From: tyson.w.smith@gmail.com
Subject: [PATCH 04/12] Remove static from rand_single_bit()
Date: Fri,  6 Mar 2015 14:30:39 -0800
Message-ID: <1425681039-28465-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=l4AsuLZrdsDA2M4th0RbhAyNLGRw6qRr/3xmXcw5oBQ=;
        b=BFmB5CfBCT92zBDEvfCyL4NS0rFLn8gyKCTWVoR2zNsHhhFkHDwvLVcGkg2J24nWS5
         gnwwwMOIKsMZ3tkdUpp0thzqwOntBbh4ndeNy58GdX/zwFxRECF+wUIaa5x8vFF55qYs
         4AEd2MpPKZGNc4CV9zE3+nh9tTIipiWr6u3P53PsoHbTQZEzWtEzBNaACBWZeTZHDVm0
         aKDUhQZU3kA5NFG68hVAu9VoXVIITPH6r3IZqDduLmGS2SYrYfnWIpsGMPhWa0n+s1bZ
         83v85txEYXVIAqMIbJJhVjRrki3lb3Upu3m9PGgMphqpl8xy2c1KXDQYu2v7tcnIhkdj
         83Qw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

Added a check to verify input value is between 0 and 32 or 64 bits
depending on __WORDSIZE.
---
 include/random.h | 1 +
 random.c         | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/random.h b/include/random.h
index f070568..69ccfa3 100644
--- a/include/random.h
+++ b/include/random.h
@@ -24,4 +24,5 @@ unsigned int rand_bool(void);
 unsigned int rand32(void);
 u64 rand64(void);
 unsigned int rand_range(unsigned int min, unsigned int max);
+unsigned long rand_single_bit(unsigned char size);
 unsigned long set_rand_bitmask(unsigned int num, const unsigned long *values);
diff --git a/random.c b/random.c
index adee25e..063912f 100644
--- a/random.c
+++ b/random.c
@@ -69,8 +69,14 @@ unsigned int rand_bool(void)
 	return rand() % 2;
 }
 
-static unsigned int rand_single_bit(unsigned char size)
+/*
+ * Pick a random power of two between 2^0 and 2^(__WORDSIZE-1)
+ */
+unsigned long rand_single_bit(unsigned char size)
 {
+	if (size > __WORDSIZE)
+		size = __WORDSIZE;
+
 	return (1UL << (rand() % size));
 }
 
-- 
1.9.1
