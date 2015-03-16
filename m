From: tyson.w.smith@gmail.com
Subject: [PATCH 4/7] simplify div by 2,4,8,16 statement
Date: Mon, 16 Mar 2015 13:26:16 -0700
Message-ID: <1426537576-54917-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=xIo+vN3Kphq9Ju1/TbEQi4ZV0mz8vLT4y6kraGghqFo=;
        b=NwqK90L34Z/1n4Mq1Ms34PyfL/jsMEjQaChzSfVOlYfzA/Mz7H639IfBfxuZFvsMEe
         L5QTI+J8i8YJWtfbGqw1HEKyGRij/iv/mCtEgiWrRGRalgyjgQbrbXYbcbSfEvBS16sG
         ErilRauQdBNVJkBtQ1OV3LHjFz3qrgF+zqbV88LwcRvaZ5LXNwuOef6bNsEnIuA8pr+C
         kY/TZnGCpyb1xiuXOuEhnR+po4Dl3d9tkC478LMeq1MJKE8tTLnoDH3Ln4wx+tCp3HU5
         LJW+u9cWueZozn6h2iBtXte2F6rwR9s9EE2k9NinaO3VWiy05Md+ey99DaZ+HA5FcQnQ
         FwQA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

---
 random.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/random.c b/random.c
index 8b4f715..8b8de04 100644
--- a/random.c
+++ b/random.c
@@ -108,10 +108,8 @@ unsigned int rand32(void)
 		r = ~r + 1;
 
 	/* we might get lucky if something is counting ints/longs etc. */
-	if (ONE_IN(4)) {
-		int _div = 1 << RAND_RANGE(1, 4);	/* 2,4,8 or 16 */
-		r /= _div;
-	}
+	if (ONE_IN(4))
+		r /= 2 << (rand() & 3); /* 2,4,8 or 16 */
 
 	/* limit the size */
 	switch (rand() % 5) {
-- 
1.9.1
