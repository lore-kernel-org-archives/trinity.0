From: tyson.w.smith@gmail.com
Subject: [PATCH 3/7] simplify most significant byte modification statement
Date: Mon, 16 Mar 2015 13:26:02 -0700
Message-ID: <1426537562-54874-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=jKUgMT1qJXgnk5vcdH6l07bKcde/9dXMDoXm5Oa733E=;
        b=zE6d9SdcTDxzkj3xHcl4KgrzLfBZ6FCODXu6CXXmVNa/iFq1P3M0dyx/YJ9sqqcVpj
         UsPyyzkdpJoXn84IrErL+6EUm9Ev/+zRtGpw5aOgVfPg1UlYrLtc5n4PZ7JoBN84dheU
         yBt1WDnTgqW+YpYTcGC3oc6mQ6Vk4YEE+Z8Kk+FFck+1oOXX+F7k8bjPCU1wd1LN8UsO
         vhbjlm9SSeC4zWo9in4oFHvI+PdLUpqN7zyq8rp4xuZ727tgWd11AiqXp11gQGtxsr0z
         rUGab4C1qfYTNtOfw6I1CjF1/nLOSDl+ZlxCX6EAAd25ya2S0yX82dpjB77cWzcdaFnR
         M6Fg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

---
 random.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/random.c b/random.c
index 7917f78..8b4f715 100644
--- a/random.c
+++ b/random.c
@@ -171,15 +171,9 @@ u64 rand64(void)
 	if (ONE_IN(25))
 		r = ~r;
 
-	/* increase distribution in MSB */
-	if (ONE_IN(10)) {
-		unsigned int i;
-		unsigned int rounds;
-
-		rounds = rand() % 4;
-		for (i = 0; i < rounds; i++)
-			r |= (1UL << ((__WORDSIZE - 1) - (rand() % 8)));
-	}
+	/* Set ~2 bits in MSB to increase distribution */
+	if (ONE_IN(10))
+		r |= (rand() & rand() & 0xffULL) << 56;
 
 	/* Sometimes flip sign */
 	if (ONE_IN(25))
-- 
1.9.1
