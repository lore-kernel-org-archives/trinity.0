From: tyson.w.smith@gmail.com
Subject: [PATCH 07/12] Cleaned up rept8() and renamed to rept_byte()
Date: Fri,  6 Mar 2015 14:32:21 -0800
Message-ID: <1425681141-28612-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=OjrhtWM/Ixd6rSAWuK8rhtasVSCbq2nK/9OwQYx0EfY=;
        b=DOtBVyQ2r/zDbHSWcjCBN+Md8Wz4aqxTcG72n2I7aptd8GinmCvkZ+MSa8cU9b1cbn
         WhmcbAVYesTShh6I4l5gX16iDvCF4aJVnAg0HGbGmZolK+NzVc2E1xlPjLPkueetyUdA
         JOH4BBjcJS1svwDv+0lhYtD7mKIRDCKkBNk/GKW/ALEFhEzMJ2VHkiG4uz2UAuWnF918
         WenxdyTafzpkZaP0U2zGb/q4v/koPTr/p71S2lJwLROSjATvMoOb44PBeuL6tq2lNMBa
         sc/vD7YxFeNpiQzFP1vNz2aDznK9CYVJxiXS+87qdTAK/rhEl0ufuw+X/yDWVjP28d4N
         fWbQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

This function basically generates 256 different values. These values do not
seem to have much significance and unless it has triggered results in the
past it should likely be removed.
---
 random.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/random.c b/random.c
index aab85b0..bf32648 100644
--- a/random.c
+++ b/random.c
@@ -93,16 +93,15 @@ static unsigned long randbits(int limit)
 /*
  * Pick 1 random byte, and repeat it through a long.
  */
-static unsigned long rept8(unsigned int num)
+static unsigned long rept_byte(void)
 {
-	unsigned long r = 0UL;
-	unsigned int i;
-	unsigned char c;
-
-	c = RAND_BYTE();
-	for (i = rand() % (num - 1) ; i > 0; --i)
-		r = (r << 8) | c;
+	unsigned long r = RAND_BYTE();
 
+	r = (r << 8) | r;
+	r = (r << 16) | r;
+#if __WORDSIZE == 64
+	r = (r << 32) | r;
+#endif
 	return r;
 }
 
@@ -121,7 +120,7 @@ static unsigned int __rand32(void)
 		break;
 	case 2: r = RAND_32();
 		break;
-	case 3:	r = rept8(4);
+	case 3:	r = rept_byte();
 		break;
 	case 4:	return get_interesting_value();
 	}
@@ -203,7 +202,7 @@ u64 rand64(void)
 			break;
 		case 2:	r = RAND_64();
 			break;
-		case 3:	r = rept8(8);
+		case 3:	r = rept_byte();
 			break;
 		/* Sometimes pick a not-so-random number. */
 		case 4:	return get_interesting_value();
-- 
1.9.1
