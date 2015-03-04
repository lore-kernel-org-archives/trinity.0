From: tyson.w.smith@gmail.com
Subject: [PATCH 1/7] Remove value modification decision from plus_minus_two()
Date: Wed,  4 Mar 2015 13:09:55 -0800
Message-ID: <1425503395-37972-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=Hhwkj7DvBvSklCRh3yW6dAJTQ9pPfgQMOv3CQAga2PM=;
        b=HJDxfcsJI0Qk/zKcic5ZtdTMKsXhJceoFHz18PvnRGnRF/1Brk0JYuFc8ZIEtls8pn
         8eowYPDxJbAG9YkCDmTBz+EJuCEkYCGDqRTSy6fuY34fbNoOThATtrNIHk7MtN+otuy/
         SMj82jx0vGU6h4W89QyHUnjZAFE+sFqG2BWoCCrzrg4OwFtbvNdtGoeq50trVsV5SnK9
         6pFl2Z9hhQZx7QII5dv6zUORrGnBqZUljAtymsW46RNVX3PRzdJunZZAF8aAqahwtGID
         LvZO1qpIGYlw/30EjRkRmYdD+mMwkZ6lSwJItK6qnKVmsDJJbKAJ32hp/8b0MDbvgAMK
         aj9A==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

---
 interesting-numbers.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/interesting-numbers.c b/interesting-numbers.c
index e77ec80..c0805ab 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -7,15 +7,14 @@
 static unsigned int plus_minus_two(unsigned int num)
 {
 	/* Now munge it for off-by-ones. */
-	switch (rand() % 5) {
+	switch (rand() % 4) {
 	case 0:	num -= 2;
 		break;
 	case 1:	num -= 1;
 		break;
-	case 2:	return num;
-	case 3:	num += 1;
+	case 2:	num += 1;
 		break;
-	case 4:	num += 2;
+	case 3:	num += 2;
 		break;
 	}
 	return num;
-- 
1.9.1
