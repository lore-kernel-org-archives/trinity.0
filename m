From: tyson.w.smith@gmail.com
Subject: [PATCH 12/12] Make RAND_RANGE() a macro
Date: Fri,  6 Mar 2015 14:36:30 -0800
Message-ID: <1425681390-28884-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=ZpiUGTFAMtxIKc2MNA+Jkrgq6TXbsSXiY2S7HIOQdyI=;
        b=bBIPeJGXMQulTmbfV+b+BAA0UD8pS4ttq5zL2bMgJJ9KRcTQGM7nJmqTrvwTrofIaA
         kB+dhW7EQKTWFVhM9gL4rbMioMMo9lgPjZD6fEMSaU+ItJ3QJqzaLGBhdLw+EWE4Klxv
         U5CF1Yyinl1AXfHI7kGLia399s8NazKVuhLhX9m3t076tQo3JUk6BAjU1TursPVwAMIu
         xnUJPZlnl3duLjLw2WxOVBncmzp8uHPESgCtoOxjwH7O0qDwVnhjEZmY8Sh8pxLtKdg3
         IwfBKScwIITnV6Nieagb8sgD8Fi2sTnzhHxxb6lqCc4/h4fOIMVUSA9VVqVUm21SP2Gh
         W1oA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

Renamed to uppercase to match other macros. Removed swap call. This should
be done outside of the call.
---
 fd-sockets.c        |  2 +-
 fds.c               |  5 ++++-
 generate-args.c     |  2 +-
 include/random.h    |  2 +-
 net/proto-udp.c     |  2 +-
 net/proto-udplite.c |  2 +-
 random-address.c    |  2 +-
 random-length.c     |  2 +-
 random.c            | 12 ++----------
 9 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fd-sockets.c b/fd-sockets.c
index bc1375b..5123dcf 100644
--- a/fd-sockets.c
+++ b/fd-sockets.c
@@ -88,7 +88,7 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
 
 		ret = bind(fd, sa, salen);
 		if (ret != -1) {
-			(void) listen(fd, rand_range(1, 128));
+			(void) listen(fd, RAND_RANGE(1, 128));
 		}
 	}
 
diff --git a/fds.c b/fds.c
index af5cbf7..fbb2bba 100644
--- a/fds.c
+++ b/fds.c
@@ -125,7 +125,10 @@ int get_random_fd(void)
 regen:
 	if (shm->fd_lifetime == 0) {
 		shm->current_fd = get_new_random_fd();
-		shm->fd_lifetime = rand_range(5, max_children);
+		if (max_children > 5)
+			shm->fd_lifetime = RAND_RANGE(5, max_children);
+		else
+			shm->fd_lifetime = RAND_RANGE(max_children, 5);
 	} else
 		shm->fd_lifetime--;
 
diff --git a/generate-args.c b/generate-args.c
index 05224a6..a208f8a 100644
--- a/generate-args.c
+++ b/generate-args.c
@@ -162,7 +162,7 @@ static unsigned long handle_arg_iovec(struct syscallentry *entry, struct syscall
 {
 	unsigned long num_entries;
 
-	num_entries = rand_range(1, 256);
+	num_entries = RAND_RANGE(1, 256);
 
 	switch (argnum) {
 	case 1:	if (entry->arg2type == ARG_IOVECLEN)
diff --git a/include/random.h b/include/random.h
index 897bb61..e30dd9f 100644
--- a/include/random.h
+++ b/include/random.h
@@ -15,6 +15,7 @@
 
 #define RAND_BOOL()				(rand() & 1)
 #define RAND_BYTE()				(rand() & 0xff)
+#define RAND_RANGE(min, max)	(min + rand() / (RAND_MAX / (max - min + 1) + 1))
 
 extern unsigned int seed;
 unsigned int init_seed(unsigned int seed);
@@ -25,6 +26,5 @@ unsigned int new_seed(void);
 void generate_rand_bytes(unsigned char *ptr, unsigned int len);
 unsigned int rand32(void);
 u64 rand64(void);
-unsigned int rand_range(unsigned int min, unsigned int max);
 unsigned long rand_single_bit(unsigned char size);
 unsigned long set_rand_bitmask(unsigned int num, const unsigned long *values);
diff --git a/net/proto-udp.c b/net/proto-udp.c
index ab9e3a8..ad589ba 100644
--- a/net/proto-udp.c
+++ b/net/proto-udp.c
@@ -23,7 +23,7 @@ void udp_setsockopt(struct sockopt *so)
 		break;
 	case UDP_ENCAP:
 		optval = (char *) so->optval;
-		optval[0] = rand_range(1, 3);        // Encapsulation types.
+		optval[0] = RAND_RANGE(1, 3);        // Encapsulation types.
 		break;
 	default:
 		break;
diff --git a/net/proto-udplite.c b/net/proto-udplite.c
index f7b0b0d..451368f 100644
--- a/net/proto-udplite.c
+++ b/net/proto-udplite.c
@@ -25,7 +25,7 @@ void udplite_setsockopt(struct sockopt *so)
 		break;
 	case UDP_ENCAP:
 		optval = (char *) so->optval;
-		optval[0] = rand_range(1, 3);        // Encapsulation types.
+		optval[0] = RAND_RANGE(1, 3);        // Encapsulation types.
 		break;
 	case UDPLITE_SEND_CSCOV:
 		break;
diff --git a/random-address.c b/random-address.c
index f6ff4d8..fe3111b 100644
--- a/random-address.c
+++ b/random-address.c
@@ -40,7 +40,7 @@ static void * _get_address(unsigned char null_allowed)
 	if (null_allowed == TRUE)
 		i = rand() % 4;
 	else
-		i = rand_range(1, 3);
+		i = RAND_RANGE(1, 3);
 
 	switch (i) {
 	case 0: addr = NULL;
diff --git a/random-length.c b/random-length.c
index 32087e1..a1a72e3 100644
--- a/random-length.c
+++ b/random-length.c
@@ -37,7 +37,7 @@ unsigned long get_len(void)
 
 	/* we might get lucky if something is counting ints/longs etc. */
 	if (ONE_IN(4)) {
-		int _div = 1 << rand_range(1, 4);	/* 2,4,8 or 16 */
+		int _div = 1 << RAND_RANGE(1, 4);	/* 2,4,8 or 16 */
 		i /= _div;
 	}
 
diff --git a/random.c b/random.c
index 6b0603b..3477a17 100644
--- a/random.c
+++ b/random.c
@@ -36,14 +36,6 @@ void generate_rand_bytes(unsigned char *ptr, unsigned int len)
 	}
 }
 
-unsigned int rand_range(unsigned int min, unsigned int max)
-{
-	if (min > max)
-		swap(min, max);
-
-	return min + rand() / (RAND_MAX / (max - min + 1) + 1);
-}
-
 /*
  * OR a random number of bits into a mask.
  * Used by ARG_LIST generation, and get_o_flags()
@@ -54,7 +46,7 @@ unsigned long set_rand_bitmask(unsigned int num, const unsigned long *values)
 	unsigned long mask = 0;
 	unsigned int bits;
 
-	bits = rand_range(0, num);      /* num of bits to OR */
+	bits = RAND_RANGE(0, num);      /* num of bits to OR */
 	if (bits == 0)
 		return mask;
 
@@ -134,7 +126,7 @@ unsigned int rand32(void)
 
 	/* we might get lucky if something is counting ints/longs etc. */
 	if (ONE_IN(4)) {
-		int _div = 1 << rand_range(1, 4);	/* 2,4,8 or 16 */
+		int _div = 1 << RAND_RANGE(1, 4);	/* 2,4,8 or 16 */
 		r /= _div;
 	}
 
-- 
1.9.1
