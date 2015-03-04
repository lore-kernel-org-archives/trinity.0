From: tyson.w.smith@gmail.com
Subject: [PATCH 7/7] Removed overlapping values in get_interesting_value()
Date: Wed,  4 Mar 2015 13:12:37 -0800
Message-ID: <1425503557-38233-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=FUjNyyGfZS6Folkyhmun7OdB1YtmCnLqJI33h3iN+Lk=;
        b=PqRNwqxNYBYdauiACfONdxfJdQmzKtGieRPAa42uF+/F7T6zzTS0llBMzq7087EETI
         Wvzegc46GCxQefLv6H1BNvC+jeCHaVwNgCLcyfTaoDswkCY3qiLvj8EuRNH47J98Js6P
         qrmS/oPNZGvV0d8coVWXjobr5H1Scvn7aQuocm1dHtJj8/4hm/+DoZSHvJ7riwFli4am
         2bDcSBCNUiPnTfqLBdFHekH1ZvQ2fC8jORzr6ikNxe6jXhd4T8OVdw8VrM5klp5t5lR1
         tAY0X53ggPkHC0gTmFpT5t4UbBpNuKpy1CO2dxt8+Jt518Qd2FAHHzFyGGxFpo74SCls
         B8Vw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

Added 50/50 chance of skipping 64bit modifications code block. This should
likely be closer to 1 in 4 odds of entering this branch, perhaps less if
these values haven't been triggering issues in the past.
---
 interesting-numbers.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/interesting-numbers.c b/interesting-numbers.c
index 4b4e785..aeb0335 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -95,20 +95,20 @@ unsigned long get_interesting_value(void)
 	low = (rand() & 0xf) ? low : plus_minus_two(low);	// 1 in 16 call plus_minus_two
 #if __WORDSIZE != 32
 
-	switch (rand() % 13) {
-	case 0: return 0;
-	case 1: return low;
-	case 2: return 0x0000000100000000UL | low;
-	case 3: return 0x7fffffff00000000UL | low;
-	case 4: return 0x8000000000000000UL | low;
-	case 5: return 0xffffffff00000000UL | low;
-	case 6: return 0xffffffffffffff00UL | (rand() % 256);
-	case 7: return 0xffffffffffffffffUL - page_size;
-	case 8: return PAGE_OFFSET | (low << 4);
-	case 9: return KERNEL_ADDR | (low & 0xffffff);
-	case 10: return MODULE_ADDR | (low & 0xffffff);
-	case 11: return per_arch_interesting_addr(low);
-	case 12: return (low << 32);
+	if (rand_bool()) {	// FIXME: This should likely be less aggressive than 50/50
+		switch (rand() % 11) {
+		case 0: return 0x0000000100000000UL | low;
+		case 1: return 0x7fffffff00000000UL | low;
+		case 2: return 0x8000000000000000UL | low;
+		case 3: return 0xffffffff00000000UL | low;
+		case 4: return 0xffffffffffffff00UL | (rand() & 0xff);
+		case 5: return 0xffffffffffffffffUL - page_size;
+		case 6: return PAGE_OFFSET | (low << 4);
+		case 7: return KERNEL_ADDR | (low & 0xffffff);
+		case 8: return MODULE_ADDR | (low & 0xffffff);
+		case 9: return per_arch_interesting_addr(low);
+		case 10: return (low << 32);
+		}
 	}
 
 #endif	/* __WORDSIZE */
-- 
1.9.1
