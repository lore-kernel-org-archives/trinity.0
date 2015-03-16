From: tyson.w.smith@gmail.com
Subject: [PATCH 7/7] strip down get_len() to a call to rand32()
Date: Mon, 16 Mar 2015 13:27:07 -0700
Message-ID: <1426537627-55047-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=dJ/sBdBYSVdufsmxdRxR405cDtGIolDoIrtviAMtEKw=;
        b=giEAoMrhAMOOfpmAot34x0Gg1i2EyeoX8lC/I7Kws1P1xcQi4T3RxgC1bI1r6xeRrp
         PKAG01/m7+UaHJat6UVeMn+R60RvbnjsIJjuLuRBce+XVmf6yRdd4Wpbd7G1Ot0D7pdv
         zpDKRoE/s41vEoqixFS1HuUpq2bMmaYFBDB8GoQ80frpfBHjt+bMg5FPxEsujGCyd4jH
         OctXyBj2ztm/7PtTJAN0F/uhfJvTOAIaZY00lVEBd+66Bwv2smamj2laB5UzLRg3BTLl
         ITuw9m9hB/HJ2U/3AARX7/TqQeV2y2d9ujuFATUhSySke70UnUF64f2KJL+3yqswxyrG
         rvXQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

The body of get_len() was the same as rand32() so applying it to a value
from rand32() didn't offer much value. A switch case could be
added that generates other length like values as well. This could include
2^n +/- ~2, page_size +/- 1, MAX_INT... etc.
---
 random-length.c | 40 +---------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/random-length.c b/random-length.c
index a1a72e3..1ef3dd2 100644
--- a/random-length.c
+++ b/random-length.c
@@ -1,45 +1,7 @@
-#include <stdlib.h>
-
-#include "arch.h"	// page_size
 #include "sanitise.h"
 #include "random.h"
 
 unsigned long get_len(void)
 {
-	int i = 0;
-
-	i = rand32();
-
-	/* short circuit if 0 */
-	if (i == 0)
-		return 0;
-
-	switch (rand() % 6) {
-
-	case 0:	i &= 0xff;
-		break;
-	case 1: i &= page_size - 1;
-		break;
-	case 2:	i &= 0xffff;
-		break;
-	case 3:	i &= 0xffffff;
-		break;
-	case 4:	i &= 0xffffffff;
-		break;
-	case 5:
-		// Pass through
-		break;
-	}
-
-	/* again, short circuit if 0 */
-	if (i == 0)
-		return 0;
-
-	/* we might get lucky if something is counting ints/longs etc. */
-	if (ONE_IN(4)) {
-		int _div = 1 << RAND_RANGE(1, 4);	/* 2,4,8 or 16 */
-		i /= _div;
-	}
-
-	return i;
+	return rand32();
 }
-- 
1.9.1
