From: tyson.w.smith@gmail.com
Subject: [PATCH 05/12] Make rand_bool a macro
Date: Fri,  6 Mar 2015 14:31:21 -0800
Message-ID: <1425681081-28508-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=jRBLs6hKMBSfkI/m4DqdvgcBgbi+rZavunPUjGbF4mE=;
        b=L1frS74vvI5mu/LEs7Iln96tWGXFEsoBcuMLFm4nFZZrFA3RxIDoCw/zjzOkO/JeDv
         RqtE0w7OU2WBnDGUjV/Vw1ge8LYYBtZ2iO1y6SyENg4rEkFYw/p432Z67LdsvV4LT0bs
         QlQLxuCliHaE3wOdiJ9qFFkyK92dIhxLvFSe/2M+zUHxkVnVl3qtAMof9K2Hil+9qKB8
         wUKrnD7+kYTwM1BpL6ikA5STjBfm/anA8shSggTWaiwOmQkx2q6MvOuv2Q+rP4H1I3DX
         8kqoHyFY5iyVS2wD0V8YKzKaELPCTbw0xKorCLvGaLW+wzFJxfP1G3P4b8AMPr0Ycqqa
         fCTw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

Since rand_bool is used a heavily used operation simplifying it may
shave off some cycles here and there. Also replaced %2 with &1 with the
same intention.
---
 include/random.h | 3 ++-
 random.c         | 5 -----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/random.h b/include/random.h
index 69ccfa3..b8f8d2c 100644
--- a/include/random.h
+++ b/include/random.h
@@ -13,6 +13,8 @@
 #error "Unexpected RAND_MAX value. Please add support."
 #endif
 
+#define rand_bool()				(rand() & 1)
+
 extern unsigned int seed;
 unsigned int init_seed(unsigned int seed);
 void set_seed(struct childdata *child);
@@ -20,7 +22,6 @@ void reseed(void);
 unsigned int new_seed(void);
 
 void generate_rand_bytes(unsigned char *ptr, unsigned int len);
-unsigned int rand_bool(void);
 unsigned int rand32(void);
 u64 rand64(void);
 unsigned int rand_range(unsigned int min, unsigned int max);
diff --git a/random.c b/random.c
index 063912f..a1ff7a8 100644
--- a/random.c
+++ b/random.c
@@ -64,11 +64,6 @@ unsigned long set_rand_bitmask(unsigned int num, const unsigned long *values)
 	return mask;
 }
 
-unsigned int rand_bool(void)
-{
-	return rand() % 2;
-}
-
 /*
  * Pick a random power of two between 2^0 and 2^(__WORDSIZE-1)
  */
-- 
1.9.1
