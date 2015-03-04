From: tyson.w.smith@gmail.com
Subject: [PATCH 2/7] Simplified get_interesting_8bit_value()
Date: Wed,  4 Mar 2015 13:10:28 -0800
Message-ID: <1425503428-38015-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=4Z4RBMxn53atU5cZSeE3At5wkG7O44k4wek9KcWrJ8A=;
        b=htcilKTVpr6uZd9SrA/k2AVRGO3eQskEPsugEnPcMQyxmr2blr/Gn+f8OwF4f7fxL5
         weooRuIYYCTUtnwWqAsWVMcqWn3fVnH00NT0RowfCSA1fwV0GNirlupNA3EfkNgpymAG
         Y4Wpo7fc3lOFeT/OElMAUmNud4FXF8RFpC/MrwQ1YRvbzVJHu3mH3WV+jZ67fmzbTdep
         U+9STTzn+d3cyEkQRwTWd8S854Nch6VqEd611VXvvE3ayTRgSIGE3ewqVkt6Z7VIkHah
         6EkxVT1uCLTg9WBUvhjAOoV+Kke5xcTRbcva2yHbe31OIfLVY7bNFtxI9h85Dg2mlRsb
         ecTA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

2^n case will now cover up to 128 where previously it only went to 64.
Removed -128, 127, -1 cases, they will be covered by the 2^n and 0xff
cases with plus_minus_two() call.
---
 interesting-numbers.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/interesting-numbers.c b/interesting-numbers.c
index c0805ab..4b23b4c 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -20,28 +20,15 @@ static unsigned int plus_minus_two(unsigned int num)
 	return num;
 }
 
-static char get_interesting_8bit_value(void)
+static unsigned char get_interesting_8bit_value(void)
 {
-	char num = 0;
-
-	switch (rand() % 7) {
-	case 0:	num = -128;
-		break;
-	case 1:	num = -1;
-		break;
-	case 2:	num = 0;
-		break;
-	case 3:	num = 1;
-		break;
-	case 4:	num = 1UL << (rand() % 7);
-		break;
-	case 5:	num = 127;
-		break;
-	case 6:	num = rand() % 256;		// 00-0xff
-		break;
+	switch (rand() % 5) {
+	case 0: return 1;					// one
+	case 1: return 0xff;				// max
+	case 2: return 1UL << (rand() & 7);	// 2^n (1 -> 128)
+	case 3: return rand() & 0xff;		// 0 -> 0xff
+	default: return 0;					// zero
 	}
-
-	return num;
 }
 
 static int get_interesting_16bit_value(void)
@@ -103,7 +90,8 @@ unsigned int get_interesting_32bit_value(void)
 		break;
 	}
 
-	num = plus_minus_two(num);
+	num = rand() & 0xf ? num : plus_minus_two(num);	// 1 in 16 call plus_minus_two
+
 	return num;
 }
 
-- 
1.9.1
