From: tyson.w.smith@gmail.com
Subject: [PATCH 06/12] Added RAND_BYTE() macro
Date: Fri,  6 Mar 2015 14:32:06 -0800
Message-ID: <1425681126-28569-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=yd4JJ4eI1c2a8rWC5WXozcjSMaK8j7Uj4IV0IsCT31c=;
        b=Xc9TF3p8Yfk1b/I4oGAyo6Dn/FeVyB9DtYkP6PUOz6GhLFPBJhGyROzrow/V8fOJYe
         agW5cZrcdXaNn28Vtg4FdOsN2FIptoMtXzrS9bGeGpphyeOTVEfeS6iSZYSTaINzprqb
         KCQnxsVbQIOPfaD9xh5CNCMq6IKLjthRQRnBBIqNZ9xAtnHgW6VjmED+zusrT0W/yDHh
         JcVmJXBiY6AZQcLTF8O2baohCO/1q+Q3YbXSsdSfRqye8Or/aTbG8zuyZlT7EwcKORjy
         NWhTaN8MmOMeLp0ne7sDACEjHVu5/Ix9uLVkaBbWYqLa+pzJU4shoHyXxNtRT1+r7Mwi
         gqUA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

This will prevent open coding rand() & ff to get a random byte and the
off-by-one's that accompany it (rand() % ff or rand() & 255). Made
substitutions where possible which led to fixing existing off-by-ones.
---
 fault-write.c              | 2 +-
 include/random.h           | 1 +
 interesting-numbers.c      | 8 ++++----
 random.c                   | 4 ++--
 syscalls/mremap.c          | 2 +-
 syscalls/perf_event_open.c | 6 +++---
 syscalls/setsockopt.c      | 2 +-
 7 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fault-write.c b/fault-write.c
index 86a5a46..9384954 100644
--- a/fault-write.c
+++ b/fault-write.c
@@ -66,7 +66,7 @@ static void generate_random_page(char *page)
 		return;
 
 	case 2:
-		memset(page, rand() % 0xff, page_size);
+		memset(page, RAND_BYTE(), page_size);
 		return;
 
 	case 3:
diff --git a/include/random.h b/include/random.h
index b8f8d2c..ce0b159 100644
--- a/include/random.h
+++ b/include/random.h
@@ -14,6 +14,7 @@
 #endif
 
 #define rand_bool()				(rand() & 1)
+#define RAND_BYTE()				(rand() & 0xff)
 
 extern unsigned int seed;
 unsigned int init_seed(unsigned int seed);
diff --git a/interesting-numbers.c b/interesting-numbers.c
index aeb0335..918f2a0 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -26,7 +26,7 @@ static unsigned char get_interesting_8bit_value(void)
 	case 0: return 1;					// one
 	case 1: return 0xff;				// max
 	case 2: return 1UL << (rand() & 7);	// 2^n (1 -> 128)
-	case 3: return rand() & 0xff;		// 0 -> 0xff
+	case 3: return RAND_BYTE();			// 0 -> 0xff
 	default: return 0;					// zero
 	}
 }
@@ -36,7 +36,7 @@ static unsigned short get_interesting_16bit_value(void)
 	switch (rand() % 4) {
 	case 0: return 0x8000 >> (rand() & 7);		// 2^n (0x100 -> 0x8000)
 	case 1: return rand() & 0xffff;				// 0 -> 0xffff
-	case 2: return 0xff00 | (rand() & 0xff);	// 0xff00 -> 0xffff
+	case 2: return 0xff00 | RAND_BYTE();		// 0xff00 -> 0xffff
 	default: return 0xffff;						// max
 	}
 }
@@ -49,7 +49,7 @@ static unsigned int get_interesting_32bit_value(void)
 	case 2: return 0xff << (rand() % 25);
 	case 3: return 0xffff0000;
 	case 4: return 0xffffe000;
-	case 5: return 0xffffff00 | (rand() & 0xff);
+	case 5: return 0xffffff00 | RAND_BYTE();
 	case 6: return 0xffffffff - page_size;
 	case 7: return page_size;
 	case 8: return page_size * ((rand() % (0xffffffff/page_size)) + 1);
@@ -101,7 +101,7 @@ unsigned long get_interesting_value(void)
 		case 1: return 0x7fffffff00000000UL | low;
 		case 2: return 0x8000000000000000UL | low;
 		case 3: return 0xffffffff00000000UL | low;
-		case 4: return 0xffffffffffffff00UL | (rand() & 0xff);
+		case 4: return 0xffffffffffffff00UL | RAND_BYTE();
 		case 5: return 0xffffffffffffffffUL - page_size;
 		case 6: return PAGE_OFFSET | (low << 4);
 		case 7: return KERNEL_ADDR | (low & 0xffffff);
diff --git a/random.c b/random.c
index a1ff7a8..aab85b0 100644
--- a/random.c
+++ b/random.c
@@ -22,7 +22,7 @@ void generate_rand_bytes(unsigned char *ptr, unsigned int len)
 		switch (choice) {
 		case 0:
 			/* Complete garbage. */
-			ptr[i] = rand();
+			ptr[i] = RAND_BYTE();
 			break;
 		case 1:
 			/* printable text strings. */
@@ -99,7 +99,7 @@ static unsigned long rept8(unsigned int num)
 	unsigned int i;
 	unsigned char c;
 
-	c = rand() % 256;
+	c = RAND_BYTE();
 	for (i = rand() % (num - 1) ; i > 0; --i)
 		r = (r << 8) | c;
 
diff --git a/syscalls/mremap.c b/syscalls/mremap.c
index ae47091..ee937b2 100644
--- a/syscalls/mremap.c
+++ b/syscalls/mremap.c
@@ -35,7 +35,7 @@ static void sanitise_mremap(struct syscallrecord *rec)
 		unsigned long align = alignments[rand() % ARRAY_SIZE(alignments)];
 		unsigned int shift = (__WORDSIZE / 2) - 1;
 
-		newaddr = rand() % 256;
+		newaddr = RAND_BYTE();
 		newaddr <<= shift;
 		newaddr |= align;
 		newaddr &= ~(align - 1);
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 7f68375..241ecfd 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -562,7 +562,7 @@ static long long random_cache_config(void)
 		cache_id = PERF_COUNT_HW_CACHE_NODE;
 		break;
 	case 7:
-		cache_id = rand() % 256;
+		cache_id = RAND_BYTE();
 		break;
 	default:
 		cache_id = 0;
@@ -580,7 +580,7 @@ static long long random_cache_config(void)
 		hw_cache_op_id = PERF_COUNT_HW_CACHE_OP_PREFETCH;
 		break;
 	case 3:
-		hw_cache_op_id = rand() % 256;
+		hw_cache_op_id = RAND_BYTE();
 		break;
 	default:
 		hw_cache_op_id = 0;
@@ -595,7 +595,7 @@ static long long random_cache_config(void)
 		hw_cache_op_result_id = PERF_COUNT_HW_CACHE_RESULT_MISS;
 		break;
 	case 2:
-		hw_cache_op_result_id = rand() % 256;
+		hw_cache_op_result_id = RAND_BYTE();
 		break;
 	default:
 		hw_cache_op_result_id = 0;
diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index dd9a239..e2480e8 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -95,7 +95,7 @@ void do_setsockopt(struct sockopt *so)
 
 	if (ONE_IN(100)) {
 		so->level = rand();
-		so->optname = (rand() % 0x100);	/* random operation. */
+		so->optname = RAND_BYTE();	/* random operation. */
 	} else {
 		ssoptrs[rand() % ARRAY_SIZE(ssoptrs)].func(so);
 	}
-- 
1.9.1
