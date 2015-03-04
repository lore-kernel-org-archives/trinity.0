From: tyson.w.smith@gmail.com
Subject: [PATCH 5/7] Simplify get_interesting_16bit_value()
Date: Wed,  4 Mar 2015 13:11:54 -0800
Message-ID: <1425503514-38147-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=7O2JYZ5g1qY5gbmxNh9yquGMi9GvpYxbnFRhZc8UFjM=;
        b=MrV0LtFiqmIOFl4l6KpvRLejC7NvhV/ofPuRDXsxti3ynQvK/LaBofsMb24ss3CmKd
         nAS1iiuL+jDmliV2FCJLBa+A6d6NMPSXbHm32QwZ6cYoWiIywiUQKOxQu8rv6h+SfCBm
         z/KmAM88+iCe5o8Tlk7nqqeesJW6nTEIBxTVMZ4y/nEvoFKCL+MOfVqlbQebl3A9z+cs
         cSpWC0KeqVmqQK3AhNcef8SJVjnzH267NwZx9Sv1+8/NXTDgW44pnH0sJzqlStvdJH5d
         9HteP0MuoFGSVUTw1zVMNUAFIWwlsEgmMwHoFr9Rf7M/8rJGg06Q8vzhTysRg8YOHqM2
         Xkaw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

Removed values that overlap with get_interesting_8bit_value() and others
that are covered by the 2^n case and 2^n with plus_minus_two().
---
 interesting-numbers.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/interesting-numbers.c b/interesting-numbers.c
index 311b16d..070ddfa 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -31,28 +31,14 @@ static unsigned char get_interesting_8bit_value(void)
 	}
 }
 
-static int get_interesting_16bit_value(void)
+static unsigned short get_interesting_16bit_value(void)
 {
-	int num = 0;
-
-	switch (rand() % 7) {
-	case 0:	num = 0;
-		break;
-	case 1:	num = -32768;
-		break;
-	case 2:	num = -129;
-		break;
-	case 3:	num = 255;
-		break;
-	case 4:	num = 32767;
-		break;
-	case 5:	num = 1UL << (rand() % 15);
-		break;
-	case 6:	num = rand() % 0xffff;
-		break;
+	switch (rand() % 4) {
+	case 0: return 0x8000 >> (rand() & 7);		// 2^n (0x100 -> 0x8000)
+	case 1: return rand() & 0xffff;				// 0 -> 0xffff
+	case 2: return 0xff00 | (rand() & 0xff);	// 0xff00 -> 0xffff
+	default: return 0xffff;						// max
 	}
-
-	return num;
 }
 
 static unsigned int get_interesting_32bit_value(void)
-- 
1.9.1
