From: tyson.w.smith@gmail.com
Subject: [PATCH 02/12] Created RAND_32 and RAND_64 macros.
Date: Fri,  6 Mar 2015 14:29:29 -0800
Message-ID: <1425680969-28361-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=QQS2jMpmDLzye4Mx+nmCFBBr2kbpUdZMZqIfmg/3gxQ=;
        b=WvJRahV0B72hRIaZ5p7b91NOy4QPGn3vCLzvuMWLdHJGmJqn63KFHN95F9Q55UYG/8
         2b599C06fjwaovd0hNHMGXyKQhGatY6xdY9P35eJBHCDhhoB5qZThrMMyOSQw7avgmCQ
         kNdch5I/EliIQ70UWU/GZ/aSa3GcCdVvJ8H2e/SvjbgFuvRrTi95uMCF9YyZMznglM3V
         dKxRHVUUoFoIJ8cPftpPZkHWoKJtqRog6/g4udn/BhsCr2x9Z/bjT74Ruhvvj+JPijU1
         myLJ7Y63Sds8shZdgXwMG2HOkAZR8whr9Uzda9vtQJR9Gg5zpIv+F/BlPFStTb/rmqg3
         oCxg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

These macros will generate a random number between 0 and 2^32 - 1 or
2^64 - 1 respectively. There is also a compile time check to verify
that a full 2^n bits of randomness will be generated (depends on RAND_MAX).
---
 include/random.h | 8 ++++++++
 random.c         | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/random.h b/include/random.h
index dbff344..f070568 100644
--- a/include/random.h
+++ b/include/random.h
@@ -1,10 +1,18 @@
 #pragma once
 
+#include <stdlib.h>
 #include "child.h"
 #include "types.h"
 
 #define ONE_IN(x)				((rand() % x) == 0)	// limit of RAND_MAX-1
 
+#if RAND_MAX == 0x7FFFFFFF
+#define RAND_32()				((rand() << 1) | (rand() & 1))
+#define RAND_64()				(((0ULL | rand()) << 33) | ((0ULL | rand()) << 2) | (rand() & 0x3))
+#else
+#error "Unexpected RAND_MAX value. Please add support."
+#endif
+
 extern unsigned int seed;
 unsigned int init_seed(unsigned int seed);
 void set_seed(struct childdata *child);
diff --git a/random.c b/random.c
index 6a2e90e..f425ed5 100644
--- a/random.c
+++ b/random.c
@@ -132,7 +132,7 @@ static unsigned int __rand32(void)
 		break;
 	case 1:	r = randbits(32);
 		break;
-	case 2: r = rand();
+	case 2: r = RAND_32();
 		break;
 	case 3:	r = rand8x8();
 		break;
@@ -216,7 +216,7 @@ u64 rand64(void)
 			break;
 		case 1:	r = randbits(64);
 			break;
-		case 2:	r = rand32() | rand32() << 31;
+		case 2:	r = RAND_64();
 			break;
 		case 3:	r = rand8x8();
 			break;
-- 
1.9.1
