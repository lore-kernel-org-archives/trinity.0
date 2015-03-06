From: tyson.w.smith@gmail.com
Subject: [PATCH 01/12] Created ONE_IN(x) macro
Date: Fri,  6 Mar 2015 14:27:22 -0800
Message-ID: <1425680842-28298-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=9k3KH13hY+eCTWibHy+t3zAoD3sTCY5m+MK/IubUSa0=;
        b=FJhi+HfaZYfzseeDZIVaFS4P3MHdumJzR/ZlbZYQnwcPI0/MyWQBhMLMdd6UXmqVEz
         l03Djr2QcK5dlhCcrnHDtmQMDDl1UKe3vtzcyPIQ0LLIMganlHPonj3CCUCFcuP2f57G
         ZJ7zvjRZbE0ynydeAgsEpVyYJvhl2f30xu/Y0BGTCd4F1BK4dqvZviEAzFaW4glsCn0w
         w5Nhv6XRGydpTkQ9YfoyZP5ulTtT0phkyI5R6LXkHmuu+fL9XkRXxFIu327IWeFzvQD/
         Y0y1y2SUdZ7Vci1JOPM1iGTAoRvLibJTXEfOv0TvhxKLcbrvS5WdZkN2Y9tDTYKPTtri
         GPYQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

It takes a positive value and it can be used to express how often a branch
should randomly be taken. Made substitutions where possible.
---
 children/random-syscalls.c |  2 +-
 include/random.h           |  2 ++
 net/bpf.c                  | 28 ++++++++++++++--------------
 net/proto-packet.c         |  4 ++--
 random-length.c            |  2 +-
 random-pathname.c          |  2 +-
 random.c                   |  2 +-
 syscalls/ioctl.c           |  6 +++---
 syscalls/linkat.c          |  3 ++-
 syscalls/setsockopt.c      |  8 ++++----
 syscalls/socket.c          |  6 +++---
 syscalls/splice.c          |  2 +-
 12 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 8892a6f..5dab898 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -50,7 +50,7 @@ static bool choose_syscall_table(void)
 		/* If both tables enabled, pick randomly. */
 		if ((use_64bit == TRUE) && (use_32bit == TRUE)) {
 			/* 10% possibility of a 32bit syscall */
-			if (rand() % 100 < 10)
+			if (ONE_IN(10))
 				do32 = TRUE;
 		}
 
diff --git a/include/random.h b/include/random.h
index 3eaffe1..dbff344 100644
--- a/include/random.h
+++ b/include/random.h
@@ -3,6 +3,8 @@
 #include "child.h"
 #include "types.h"
 
+#define ONE_IN(x)				((rand() % x) == 0)	// limit of RAND_MAX-1
+
 extern unsigned int seed;
 unsigned int init_seed(unsigned int seed);
 void set_seed(struct childdata *child);
diff --git a/net/bpf.c b/net/bpf.c
index e5e8b0e..617ddb8 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -633,7 +633,7 @@ static uint16_t gen_bpf_code_more_crazy(bool last_instr)
 	}
 
 	/* Also give it a chance to fuzz some crap into it */
-	if (rand() % 1000 == 0)
+	if (ONE_IN(1000))
 		ret |= (uint16_t) rand();
 
 	return ret;
@@ -689,7 +689,7 @@ static int gen_seccomp_bpf_code(struct sock_filter *curr)
 		used = 3;
 		memcpy(curr, validate_arch, sizeof(validate_arch));
 		/* Randomize architecture */
-		if (rand() % 3 == 0)
+		if (ONE_IN(3))
 			curr[0].k = bpf_rand(seccomp_jmp_arch);
 		else
 			curr[0].k = TRUE_ARCH;
@@ -707,7 +707,7 @@ static int gen_seccomp_bpf_code(struct sock_filter *curr)
 	case STATE_GEN_KILL_PROCESS:
 		used = 1;
 		memcpy(curr, kill_process, sizeof(kill_process));
-		if (rand() % 3 == 0)
+		if (ONE_IN(3))
 			/* Variate between seccomp ret values */
 			curr[0].k = bpf_rand(seccomp_ret_k);
 		break;
@@ -722,11 +722,11 @@ static int gen_seccomp_bpf_code(struct sock_filter *curr)
 	}
 
 	/* Also give it a tiny chance to fuzz some crap into it */
-	if (rand() % 10000 == 0)
+	if (ONE_IN(10000))
 		curr[0].code |= (uint16_t) rand();
-	if (rand() % 10000 == 0)
+	if (ONE_IN(10000))
 		curr[1].code |= (uint16_t) rand();
-	if (rand() % 10000 == 0)
+	if (ONE_IN(10000))
 		curr[2].code |= (uint16_t) rand();
 
 	return used;
@@ -759,7 +759,7 @@ void bpf_gen_seccomp(unsigned long **addr, unsigned long *addrlen)
 
 	bpf->len = avail = rand() % 50;
 	/* Give it from time to time a chance to load big filters as well. */
-	if (rand() % 1000 == 0)
+	if (ONE_IN(1000))
 		bpf->len = avail = rand() % BPF_MAXINSNS;
 	if (bpf->len == 0)
 		bpf->len = avail = 50;
@@ -796,9 +796,9 @@ void bpf_gen_filter(unsigned long **addr, unsigned long *addrlen)
 
 	bpf->len = rand() % 10;
 	/* Give it from time to time a chance to load big filters as well. */
-	if (rand() % 100 == 0)
+	if (ONE_IN(100))
 		bpf->len = rand() % 100;
-	if (rand() % 1000 == 0)
+	if (ONE_IN(1000))
 		bpf->len = rand() % BPF_MAXINSNS;
 	if (bpf->len == 0)
 		bpf->len = 50;
@@ -806,7 +806,7 @@ void bpf_gen_filter(unsigned long **addr, unsigned long *addrlen)
 	bpf->filter = zmalloc(bpf->len * sizeof(struct sock_filter));
 
 	for (i = 0; i < bpf->len; i++) {
-		if (rand() % 100 == 0)
+		if (ONE_IN(100))
 			bpf->filter[i].code = gen_bpf_code_more_crazy(i == bpf->len - 1);
 		else
 			bpf->filter[i].code = gen_bpf_code_less_crazy(i == bpf->len - 1);
@@ -818,20 +818,20 @@ void bpf_gen_filter(unsigned long **addr, unsigned long *addrlen)
 		}
 
 		/* Also give it a chance if not BPF_JMP */
-		if (rand() % 100 == 0)
+		if (ONE_IN(100))
 			bpf->filter[i].jt |= (uint8_t) rand();
-		if (rand() % 100 == 0)
+		if (ONE_IN(100))
 			bpf->filter[i].jf |= (uint8_t) rand();
 
 		/* Not always fill out k */
-		bpf->filter[i].k = (rand() % 10 == 0 ? 0 : (uint32_t) rand());
+		bpf->filter[i].k = ((ONE_IN(10)) ? 0 : (uint32_t) rand());
 
 		/* Also try to jump into BPF extensions by chance */
 		if (BPF_CLASS(bpf->filter[i].code) == BPF_LD ||
 		    BPF_CLASS(bpf->filter[i].code) == BPF_LDX) {
 			if (bpf->filter[i].k > 65000 &&
 			    bpf->filter[i].k < (uint32_t) SKF_AD_OFF) {
-				if (rand() % 10 == 0) {
+				if (ONE_IN(10)) {
 					bpf->filter[i].k = (uint32_t) (SKF_AD_OFF +
 							   rand() % SKF_AD_MAX);
 				}
diff --git a/net/proto-packet.c b/net/proto-packet.c
index 35c6c8b..876173a 100644
--- a/net/proto-packet.c
+++ b/net/proto-packet.c
@@ -29,7 +29,7 @@ void packet_rand_socket(struct socket_triplet *st)
 {
 	st->protocol = htons(ETH_P_ALL);
 
-	if (rand() % 8 == 0)		// FIXME: 8 ? Why?
+	if (ONE_IN(8))		// FIXME: 8 ? Why?
 		st->protocol = get_random_ether_type();
 
 	switch (rand() % 3) {
@@ -72,7 +72,7 @@ void packet_setsockopt(struct sockopt *so)
 	case PACKET_TX_RING:
 	case PACKET_RX_RING:
 #ifdef TPACKET3_HDRLEN
-		if (rand() % 3 == 0)
+		if (ONE_IN(3))
 			so->optlen = sizeof(struct tpacket_req3);
 		else
 #endif
diff --git a/random-length.c b/random-length.c
index af38ad0..32087e1 100644
--- a/random-length.c
+++ b/random-length.c
@@ -36,7 +36,7 @@ unsigned long get_len(void)
 		return 0;
 
 	/* we might get lucky if something is counting ints/longs etc. */
-	if (rand() % 100 < 25) {
+	if (ONE_IN(4)) {
 		int _div = 1 << rand_range(1, 4);	/* 2,4,8 or 16 */
 		i /= _div;
 	}
diff --git a/random-pathname.c b/random-pathname.c
index 8728978..5f6f6cf 100644
--- a/random-pathname.c
+++ b/random-pathname.c
@@ -19,7 +19,7 @@ const char * generate_pathname(void)
 		return NULL;
 
 	/* 90% chance of returning an unmangled filename */
-	if ((rand() % 100) < 90)
+	if (!ONE_IN(10))
 		return pathname;
 
 	/* Create a bogus filename. */
diff --git a/random.c b/random.c
index c20acaf..6a2e90e 100644
--- a/random.c
+++ b/random.c
@@ -176,7 +176,7 @@ unsigned int rand32(void)
 		r |= (1L << 31);
 
 	/* we might get lucky if something is counting ints/longs etc. */
-	if (rand() % 100 < 25) {
+	if (ONE_IN(4)) {
 		int _div = 1 << rand_range(1, 4);	/* 2,4,8 or 16 */
 		r /= _div;
 	}
diff --git a/syscalls/ioctl.c b/syscalls/ioctl.c
index c137348..7ef81fe 100644
--- a/syscalls/ioctl.c
+++ b/syscalls/ioctl.c
@@ -36,7 +36,7 @@ static void ioctl_mangle_arg(struct syscallrecord *rec)
 
 static void generic_sanitise_ioctl(struct syscallrecord *rec)
 {
-	if ((rand() % 50)==0)
+	if (ONE_IN(50))
 		ioctl_mangle_cmd(rec);
 
 	ioctl_mangle_arg(rec);
@@ -46,7 +46,7 @@ static void sanitise_ioctl(struct syscallrecord *rec)
 {
 	const struct ioctl_group *grp;
 
-	if (rand() % 100 == 0)
+	if (ONE_IN(100))
 		grp = get_random_ioctl_group();
 	else
 		grp = find_ioctl_group(rec->a1);
@@ -56,7 +56,7 @@ static void sanitise_ioctl(struct syscallrecord *rec)
 
 		grp->sanitise(grp, rec);
 
-		if (rand() % 100 == 0)
+		if (ONE_IN(100))
 			ioctl_mangle_cmd(rec);
 	} else
 		generic_sanitise_ioctl(rec);
diff --git a/syscalls/linkat.c b/syscalls/linkat.c
index d18b206..7e64872 100644
--- a/syscalls/linkat.c
+++ b/syscalls/linkat.c
@@ -4,6 +4,7 @@
  */
 #include <fcntl.h>
 #include <stdlib.h>
+#include "random.h"
 #include "shm.h"
 #include "sanitise.h"
 #include "syscall.h"
@@ -14,7 +15,7 @@ static void sanitise_linkat(struct syscallrecord *rec)
 {
 	/* .. If oldpath is relative and olddirfd is the special value AT_FDCWD, then oldpath is
 	 * interpreted relative to the current working directory of the calling process  */
-	if ((rand() % 100) == 0)
+	if (ONE_IN(100))
 		rec->a1 = AT_FDCWD;
 }
 
diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index 5f8a94b..dd9a239 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -93,18 +93,18 @@ void do_setsockopt(struct sockopt *so)
 	else
 		so->optlen = rand() % 256;
 
-	if (rand() % 100 > 0) {
-		ssoptrs[rand() % ARRAY_SIZE(ssoptrs)].func(so);
-	} else {
+	if (ONE_IN(100)) {
 		so->level = rand();
 		so->optname = (rand() % 0x100);	/* random operation. */
+	} else {
+		ssoptrs[rand() % ARRAY_SIZE(ssoptrs)].func(so);
 	}
 
 	/*
 	 * 10% of the time, mangle the options.
 	 * This should catch new options we don't know about, and also maybe some missing bounds checks.
 	 */
-	if ((rand() % 100) < 10)
+	if (ONE_IN(10))
 		so->optname |= (1UL << (rand() % 32));
 
 	/* optval should be nonzero to enable a boolean option, or zero if the option is to be disabled.
diff --git a/syscalls/socket.c b/syscalls/socket.c
index 256ffe3..d2237f8 100644
--- a/syscalls/socket.c
+++ b/syscalls/socket.c
@@ -120,7 +120,7 @@ void gen_socket_args(struct socket_triplet *st)
 	}
 
 	/* sometimes, still gen rand crap */
-	if ((rand() % 100) == 0) {
+	if (ONE_IN(100)) {
 		rand_proto_type(st);
 		goto done;
 	}
@@ -131,9 +131,9 @@ void gen_socket_args(struct socket_triplet *st)
 
 
 done:
-	if ((rand() % 100) < 25)
+	if (ONE_IN(4))
 		st->type |= SOCK_CLOEXEC;
-	if ((rand() % 100) < 25)
+	if (ONE_IN(4))
 		st->type |= SOCK_NONBLOCK;
 }
 
diff --git a/syscalls/splice.c b/syscalls/splice.c
index c575cf0..b024d44 100644
--- a/syscalls/splice.c
+++ b/syscalls/splice.c
@@ -14,7 +14,7 @@
 
 static void sanitise_splice(struct syscallrecord *rec)
 {
-	if ((rand() % 10) < 3)
+	if (ONE_IN(3))
 		return;
 
 	if (rand_bool()) {
-- 
1.9.1
