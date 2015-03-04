From: tyson.w.smith@gmail.com
Subject: [PATCH 4/7] Make get_interesting_32bit_value() static
Date: Wed,  4 Mar 2015 13:11:18 -0800
Message-ID: <1425503478-38102-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=2/7aRJEXP5UqoUedBCV9N4pc4RvQxtYDDqqDouqLZwU=;
        b=ekqhcYBaU/znLFLpdpPDD1w5Lv9p4V5O+8I76tdHWqsyl7VP50ROfqo3mLInT6tTKa
         QMlR97ns2l2VdgnLrMmJ3i7rcZG8A+kR1scXRKQSQEwbVh3ngeu37VCVXx4y46ZhtwZi
         RYxyqpts8JtPpZza5mgB6H5ko+6E1qT0bK3pkYpsSegYcc93xGWFkme4OU3cqCK9K9+Z
         igV0AnYJvhX3EiUNr7rB0mZsq0vPbYPZtezaEC5yLPVeuBoR3gnuWKwPmdW09vgVgIz7
         EgTu/HBJgrV3d5PQOwUoq7m/2CMIwvfNejo8AkvfLFM+bEZtSPOrbJkv5/GPXd0UNXFJ
         z9ow==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

All calls to get_interesting_32bit_value() should now be made to
get_interesting_value() to help simplify generating interesting values.
---
 include/sanitise.h    | 1 -
 interesting-numbers.c | 2 +-
 random.c              | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/sanitise.h b/include/sanitise.h
index bd5c823..5001250 100644
--- a/include/sanitise.h
+++ b/include/sanitise.h
@@ -6,7 +6,6 @@ void generic_sanitise(struct syscallrecord *rec);
 void generic_free_arg(struct syscallrecord *rec);
 
 unsigned long get_interesting_value(void);
-unsigned int get_interesting_32bit_value(void);
 
 void *get_address(void);
 void *get_non_null_address(void);
diff --git a/interesting-numbers.c b/interesting-numbers.c
index e08e27d..311b16d 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -55,7 +55,7 @@ static int get_interesting_16bit_value(void)
 	return num;
 }
 
-unsigned int get_interesting_32bit_value(void)
+static unsigned int get_interesting_32bit_value(void)
 {
 	unsigned int num = 0;
 
diff --git a/random.c b/random.c
index 0601f4f..c20acaf 100644
--- a/random.c
+++ b/random.c
@@ -138,7 +138,7 @@ static unsigned int __rand32(void)
 		break;
 	case 4:	r = rept8(4);
 		break;
-	case 5:	return get_interesting_32bit_value();
+	case 5:	return get_interesting_value();
 	}
 
 	return r;
-- 
1.9.1
