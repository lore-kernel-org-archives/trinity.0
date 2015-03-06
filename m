From: tyson.w.smith@gmail.com
Subject: [PATCH 09/12] Actually flip the sign of the value (1 -> -1)
Date: Fri,  6 Mar 2015 14:34:09 -0800
Message-ID: <1425681249-28725-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=Mcpwl2ff7C+CcuEug30HGXo+XmoEFtH/xAeO0qrAYxc=;
        b=r1J6KhBkbR/OYO63b8OaUxFm91X4qX+L6f4vbiYsxxZWITIS8gOq4O543TZxl0SBT9
         MPaPr3B4qDAb8DyBGnDeq1RXPVie6AuUSq9E5TOXKxk6vRZbELDKEZcgqmEMzByUZNNX
         ZLf8Fm/TXzvJKC7JTZFQFvf64uwQz9/Xvk5iHV51aGdmCLWsYkfe8OUfHXWH51haTGpS
         wL4eYUJHcbHfp9J5l1yoCYeuUntAEnHAIOPY1ZDihQCFrQyw8XE7bhDV0vP9kJ/VuwVG
         IjZks+Bi6dFzuxUMeS8H3AvPcWVy92ynq2q8XQgWm/L/cfVmI8/ozBT0YD296OGMN2k4
         FExg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

I believe this is what was intended, previously the high bit was just being set.
Perhaps it was meant to be toggled? If that is the case we can add that too.
---
 random.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/random.c b/random.c
index ec20656..d671035 100644
--- a/random.c
+++ b/random.c
@@ -130,7 +130,7 @@ unsigned int rand32(void)
 
 	/* Sometimes flip sign */
 	if (rand_bool())
-		r |= (1L << 31);
+		r = ~r + 1;
 
 	/* we might get lucky if something is counting ints/longs etc. */
 	if (ONE_IN(4)) {
@@ -206,9 +206,9 @@ u64 rand64(void)
 			r |= (1UL << ((__WORDSIZE - 1) - (rand() % 8)));
 	}
 
-	/* randomly flip sign bit. */
+	/* Sometimes flip sign */
 	if (rand_bool())
-		r |= (1UL << (__WORDSIZE - 1));
+		r = ~r + 1;
 
 	return r;
 }
-- 
1.9.1
