From: tyson.w.smith@gmail.com
Subject: [PATCH 11/12] Rename rand_bool() to RAND_BOOL() to match other macros
Date: Fri,  6 Mar 2015 14:35:38 -0800
Message-ID: <1425681338-28832-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=DNp+7u48lRH4/Nh6hUh0YizYmUWb6aAXFgBkEsVOLmM=;
        b=bpHxQGEJkVaqJSKnpOBOe5ObboKERukHSuuCjccHPBS2KQOq0tyfqx/wRmo1Zv/Mhs
         6kS9fEuyR90Thl0Lain2GhAP0bpJ6RJKB25JvqL8GIx2veoIlk5NZGwENJWQ80aUwzmC
         CGhnsnNjn+tswJh0K+uJqkIOWG6rd5rvH3erXGNizaHSGFcVOGLoxNCEPqkdsHZ5qAA7
         YTB74tgaBbZI00HTrA9tUpFmMMmFmXPmi+YWEgeqt9vdp9V/sT1xSfIl4NHRNfIUyULh
         VP5WTOKnVHtKiGHYo7T8T5FgFqpkCvjFYwi2S1amfWKRA/tcPDZmxOIJAEk6Hf8iUFrJ
         sSyQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tyson Smith <tysmith@motorola.com>

From: Tyson Smith <tysmith@motorola.com>

---
 child.c                     |   2 +-
 children/read-all-files.c   |   2 +-
 fault-read.c                |   2 +-
 fault-write.c               |  20 ++--
 fd-epoll.c                  |   2 +-
 fd-files.c                  |   2 +-
 fd-sockets.c                |   2 +-
 fd-testfiles.c              |   2 +-
 generate-args.c             |   4 +-
 include/random.h            |   2 +-
 interesting-numbers.c       |   2 +-
 ioctls/autofs.c             |   2 +-
 ioctls/dm.c                 |   2 +-
 maps.c                      |   2 +-
 net/bpf.c                   |   2 +-
 net/proto-appletalk.c       |   2 +-
 net/proto-caif.c            |   2 +-
 net/proto-decnet.c          |   2 +-
 net/proto-ipv4.c            |   2 +-
 net/proto-ipv6.c            |   4 +-
 net/proto-ipx.c             |   2 +-
 net/proto-irda.c            |   2 +-
 net/proto-llc.c             |   2 +-
 net/proto-netlink.c         |   2 +-
 net/proto-nfc.c             |   4 +-
 net/proto-phonet.c          |   2 +-
 net/proto-x25.c             |   2 +-
 random-pathname.c           |   4 +-
 random.c                    |   2 +-
 seed.c                      |   2 +-
 syscalls/fcntl.c            |  12 +--
 syscalls/ioctl.c            |   2 +-
 syscalls/mlockall.c         |   2 +-
 syscalls/mmap.c             |   2 +-
 syscalls/mremap.c           |   2 +-
 syscalls/msync.c            |   2 +-
 syscalls/perf_event_open.c  | 230 ++++++++++++++++++++++----------------------
 syscalls/remap_file_pages.c |   6 +-
 syscalls/send.c             |   2 +-
 syscalls/setsockopt.c       |   4 +-
 syscalls/sigaction.c        |   4 +-
 syscalls/splice.c           |   4 +-
 syscalls/write.c            |   2 +-
 43 files changed, 180 insertions(+), 180 deletions(-)

diff --git a/child.c b/child.c
index 0127946..6961ef2 100644
--- a/child.c
+++ b/child.c
@@ -222,7 +222,7 @@ void init_child(struct childdata *child, int childno)
 
 	set_make_it_fail();
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		use_fpu();
 
 	mask_signals_child();
diff --git a/children/read-all-files.c b/children/read-all-files.c
index 290b56f..2505a4d 100644
--- a/children/read-all-files.c
+++ b/children/read-all-files.c
@@ -52,7 +52,7 @@ int child_read_all_files(void)
 //		if (ret != -1)
 //			output(0, "%s:%s\n", filename, buffer);
 
-		if (rand_bool())
+		if (RAND_BOOL())
 			sleep(1);
 
 		free(buffer);
diff --git a/fault-read.c b/fault-read.c
index ab6332b..a9e9862 100644
--- a/fault-read.c
+++ b/fault-read.c
@@ -43,7 +43,7 @@ static void read_every_other_page(struct map *map)
 
 	nr = nr_pages(map);
 
-	first = rand_bool();
+	first = RAND_BOOL();
 
 	for (i = first; i < nr; i+=2)
 		memcpy(buf, p + (i * page_size), page_size);
diff --git a/fault-write.c b/fault-write.c
index 9384954..bea0a34 100644
--- a/fault-write.c
+++ b/fault-write.c
@@ -31,7 +31,7 @@ static void fabricate_onepage_struct(char *page)
 			if (i > page_size)
 				return;
 
-			if (rand_bool())
+			if (RAND_BOOL())
 				val = rand64();
 			else
 				val = (unsigned long) get_address();
@@ -76,7 +76,7 @@ static void generate_random_page(char *page)
 
 	case 4:
 		for (i = 0; i < page_size; )
-			page[i++] = (unsigned char)rand_bool();
+			page[i++] = (unsigned char)RAND_BOOL();
 		return;
 
 	/* return a page that looks kinda like a struct */
@@ -87,7 +87,7 @@ static void generate_random_page(char *page)
 	case 6:
 		for (i = 0; i < page_size; i += 2) {
 			page[i] = '%';
-			switch (rand_bool()) {
+			switch (RAND_BOOL()) {
 			case 0:	page[i + 1] = 'd';
 				break;
 			case 1:	page[i + 1] = 's';
@@ -104,11 +104,11 @@ static void generate_random_page(char *page)
 		case 0:
 			switch (rand() % 3) {
 			case 0:	p = sprintf(page, "%s%lu",
-					rand_bool() ? "-" : "",
+					RAND_BOOL() ? "-" : "",
 					(unsigned long) rand64());
 				break;
 			case 1:	p = sprintf(page, "%s%ld",
-					rand_bool() ? "-" : "",
+					RAND_BOOL() ? "-" : "",
 					(unsigned long) rand64());
 				break;
 			case 2:	p = sprintf(page, "%lx", (unsigned long) rand64());
@@ -119,11 +119,11 @@ static void generate_random_page(char *page)
 		case 1:
 			switch (rand() % 3) {
 			case 0:	p = sprintf(page, "%s%u",
-					rand_bool() ? "-" : "",
+					RAND_BOOL() ? "-" : "",
 					(unsigned int) rand32());
 				break;
 			case 1:	p = sprintf(page, "%s%d",
-					rand_bool() ? "-" : "",
+					RAND_BOOL() ? "-" : "",
 					(int) rand32());
 				break;
 			case 2:	p = sprintf(page, "%x", (int) rand32());
@@ -134,11 +134,11 @@ static void generate_random_page(char *page)
 		case 2:
 			switch (rand() % 3) {
 			case 0:	p = sprintf(page, "%s%u",
-					rand_bool() ? "-" : "",
+					RAND_BOOL() ? "-" : "",
 					(unsigned char) rand());
 				break;
 			case 1:	p = sprintf(page, "%s%d",
-					rand_bool() ? "-" : "",
+					RAND_BOOL() ? "-" : "",
 					(char) rand());
 				break;
 			case 2:	p = sprintf(page, "%x", (char) rand());
@@ -179,7 +179,7 @@ static void dirty_every_other_page(struct map *map)
 
 	nr = nr_pages(map);
 
-	first = rand_bool();
+	first = RAND_BOOL();
 
 	for (i = first; i < nr; i+=2)
 		p[i * page_size] = rand();
diff --git a/fd-epoll.c b/fd-epoll.c
index 5f849a0..ec6615d 100644
--- a/fd-epoll.c
+++ b/fd-epoll.c
@@ -25,7 +25,7 @@ static int open_epoll_fds(void)
 
 	while (i < MAX_EPOLL_FDS) {
 
-		if (rand_bool())
+		if (RAND_BOOL())
 			fd = epoll_create(1);
 		else
 			fd = epoll_create1(EPOLL_CLOEXEC);
diff --git a/fd-files.c b/fd-files.c
index d1c8039..5dd297c 100644
--- a/fd-files.c
+++ b/fd-files.c
@@ -312,7 +312,7 @@ retry:
 	/* OR in some random flags. */
 retry_flags:
 
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		randflags = get_o_flags();
 		fd = open(filename, flags | randflags | O_NONBLOCK);
 	} else {
diff --git a/fd-sockets.c b/fd-sockets.c
index 1a4168b..bc1375b 100644
--- a/fd-sockets.c
+++ b/fd-sockets.c
@@ -80,7 +80,7 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
 	nr_sockets++;
 
 	/* Sometimes, listen on created sockets. */
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		int ret;
 
 		/* fake a sockaddr. */
diff --git a/fd-testfiles.c b/fd-testfiles.c
index 83db8c1..87b7ab9 100644
--- a/fd-testfiles.c
+++ b/fd-testfiles.c
@@ -25,7 +25,7 @@ static int open_testfile(char *filename)
 	/* file might be around from an earlier run, nuke it. */
 	(void) unlink(filename);
 
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		fd = open_with_fopen(filename, O_RDWR);
 		if (fd != -1)
 			output(2, "fd[%d] = fopen(\"%s\", O_RDWR)\n", fd, filename);
diff --git a/generate-args.c b/generate-args.c
index 7bdc5e5..05224a6 100644
--- a/generate-args.c
+++ b/generate-args.c
@@ -37,7 +37,7 @@ static unsigned long handle_arg_address(struct syscallrecord *rec, unsigned int
 	if (argnum == 1)
 		return (unsigned long) get_address();
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		return (unsigned long) get_address();
 
 	/* Half the time, we look to see if earlier args were also ARG_ADDRESS,
@@ -304,7 +304,7 @@ static unsigned long fill_arg(struct syscallrecord *rec, unsigned int argnum)
 
 	switch (argtype) {
 	case ARG_UNDEFINED:
-		if (rand_bool())
+		if (RAND_BOOL())
 			return (unsigned long) rand64();
 		return (unsigned long) get_writable_address(page_size);
 
diff --git a/include/random.h b/include/random.h
index ce0b159..897bb61 100644
--- a/include/random.h
+++ b/include/random.h
@@ -13,7 +13,7 @@
 #error "Unexpected RAND_MAX value. Please add support."
 #endif
 
-#define rand_bool()				(rand() & 1)
+#define RAND_BOOL()				(rand() & 1)
 #define RAND_BYTE()				(rand() & 0xff)
 
 extern unsigned int seed;
diff --git a/interesting-numbers.c b/interesting-numbers.c
index 918f2a0..66728dd 100644
--- a/interesting-numbers.c
+++ b/interesting-numbers.c
@@ -95,7 +95,7 @@ unsigned long get_interesting_value(void)
 	low = (rand() & 0xf) ? low : plus_minus_two(low);	// 1 in 16 call plus_minus_two
 #if __WORDSIZE != 32
 
-	if (rand_bool()) {	// FIXME: This should likely be less aggressive than 50/50
+	if (RAND_BOOL()) {	// FIXME: This should likely be less aggressive than 50/50
 		switch (rand() % 11) {
 		case 0: return 0x0000000100000000UL | low;
 		case 1: return 0x7fffffff00000000UL | low;
diff --git a/ioctls/autofs.c b/ioctls/autofs.c
index 45dc5fd..6b3e2b4 100644
--- a/ioctls/autofs.c
+++ b/ioctls/autofs.c
@@ -291,7 +291,7 @@ static void autofs_sanitise(const struct ioctl_group *grp, struct syscallrecord
 		arg->ioctlfd = get_random_fd();
 		arg->fail.token = rand();
 		arg->fail.status = rand();
-		if (rand_bool()) {
+		if (RAND_BOOL()) {
 			arg->size += 5;
 			arg->path[0] = '/';
 			arg->path[1] = rand();
diff --git a/ioctls/dm.c b/ioctls/dm.c
index 096abe8..7b09f14 100644
--- a/ioctls/dm.c
+++ b/ioctls/dm.c
@@ -46,7 +46,7 @@ static void dm_sanitise(const struct ioctl_group *grp, struct syscallrecord *rec
 	dm->version[2] = DM_VERSION_PATCHLEVEL;
 
 	/* clear one of these strings to pass some kernel validation */
-	if (rand_bool())
+	if (RAND_BOOL())
 		dm->name[0] = 0;
 	else
 		dm->uuid[0] = 0;
diff --git a/maps.c b/maps.c
index 9e4bcad..9c60e82 100644
--- a/maps.c
+++ b/maps.c
@@ -120,7 +120,7 @@ struct map * common_set_mmap_ptr_len(void)
  */
 void dirty_mapping(struct map *map)
 {
-	bool rw = rand_bool();
+	bool rw = RAND_BOOL();
 
 	if (rw == TRUE) {
 		/* Check mapping is writable, or we'll segv.
diff --git a/net/bpf.c b/net/bpf.c
index 617ddb8..9e10c59 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -606,7 +606,7 @@ static uint16_t gen_bpf_code_more_crazy(bool last_instr)
 		 * increase the chance to be accepted and that we
 		 * actually run the generated fuzz filter code.
 		 */
-		if (rand_bool())
+		if (RAND_BOOL())
 			ret = BPF_RET;
 	}
 
diff --git a/net/proto-appletalk.c b/net/proto-appletalk.c
index 3078ea8..08f0927 100644
--- a/net/proto-appletalk.c
+++ b/net/proto-appletalk.c
@@ -28,7 +28,7 @@ void atalk_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void atalk_rand_socket(struct socket_triplet *st)
 {
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		st->type = SOCK_DGRAM;
 	        st->protocol = 0;
 	        return;
diff --git a/net/proto-caif.c b/net/proto-caif.c
index f75ae9c..94fbab2 100644
--- a/net/proto-caif.c
+++ b/net/proto-caif.c
@@ -39,7 +39,7 @@ void caif_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 void caif_rand_socket(struct socket_triplet *st)
 {
 	st->protocol = rand() % _CAIFPROTO_MAX;
-	if (rand_bool())
+	if (RAND_BOOL())
 		st->type = SOCK_SEQPACKET;
 	else
 		st->type = SOCK_STREAM;
diff --git a/net/proto-decnet.c b/net/proto-decnet.c
index da75154..d7d835e 100644
--- a/net/proto-decnet.c
+++ b/net/proto-decnet.c
@@ -31,7 +31,7 @@ void decnet_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void decnet_rand_socket(struct socket_triplet *st)
 {
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		st->type = SOCK_SEQPACKET;
 		st->protocol = DNPROTO_NSP;
 	} else {
diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index 21840c0..db08c16 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -193,7 +193,7 @@ void ip_setsockopt(struct sockopt *so)
 	case IP_MULTICAST_ALL:
 	case IP_MULTICAST_LOOP:
 	case IP_RECVORIGDSTADDR:
-		if (rand_bool())
+		if (RAND_BOOL())
 			so->optlen = sizeof(int);
 		else
 			so->optlen = sizeof(char);
diff --git a/net/proto-ipv6.c b/net/proto-ipv6.c
index 049cd44..b8c0bb8 100644
--- a/net/proto-ipv6.c
+++ b/net/proto-ipv6.c
@@ -64,14 +64,14 @@ void inet6_rand_socket(struct socket_triplet *st)
 		break;
 
 	case 1: st->type = SOCK_DGRAM;      // UDP
-		if (rand_bool())
+		if (RAND_BOOL())
 			st->protocol = 0;
 		else
 			st->protocol = IPPROTO_UDP;
 		break;
 
 	case 2: st->type = SOCK_SEQPACKET;      // SCTP
-		if (rand_bool())
+		if (RAND_BOOL())
 			st->protocol = 0;
 		else
 			st->protocol = IPPROTO_SCTP;
diff --git a/net/proto-ipx.c b/net/proto-ipx.c
index 88f8c03..22ee832 100644
--- a/net/proto-ipx.c
+++ b/net/proto-ipx.c
@@ -21,7 +21,7 @@ void ipx_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 	for (i = 0; i < 6; i++)
 		ipx->sipx_node[i] = rand();
 	ipx->sipx_type = rand();
-	ipx->sipx_zero = rand_bool();
+	ipx->sipx_zero = RAND_BOOL();
 	*addr = (struct sockaddr *) ipx;
 	*addrlen = sizeof(struct sockaddr_ipx);
 }
diff --git a/net/proto-irda.c b/net/proto-irda.c
index 3a5a6d9..6b91e20 100644
--- a/net/proto-irda.c
+++ b/net/proto-irda.c
@@ -40,7 +40,7 @@ void irda_rand_socket(struct socket_triplet *st)
 		break;
 
 	case 2: st->type = SOCK_DGRAM;
-		if (rand_bool())
+		if (RAND_BOOL())
 			st->protocol = IRDAPROTO_ULTRA;
 		else
 			st->protocol = IRDAPROTO_UNITDATA;
diff --git a/net/proto-llc.c b/net/proto-llc.c
index 9b3bf26..628998d 100644
--- a/net/proto-llc.c
+++ b/net/proto-llc.c
@@ -34,7 +34,7 @@ void llc_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 void llc_rand_socket(struct socket_triplet *st)
 {
 	st->protocol = rand() % PROTO_MAX;
-	if (rand_bool())
+	if (RAND_BOOL())
 		st->type = SOCK_STREAM;
 	else
 		st->type = SOCK_DGRAM;
diff --git a/net/proto-netlink.c b/net/proto-netlink.c
index 1ff9a2b..079c341 100644
--- a/net/proto-netlink.c
+++ b/net/proto-netlink.c
@@ -39,7 +39,7 @@ void netlink_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void netlink_rand_socket(struct socket_triplet *st)
 {
-	if (rand_bool())
+	if (RAND_BOOL())
 		st->type = SOCK_RAW;
 	else
 		st->type = SOCK_DGRAM;
diff --git a/net/proto-nfc.c b/net/proto-nfc.c
index 74adf52..df27ea2 100644
--- a/net/proto-nfc.c
+++ b/net/proto-nfc.c
@@ -26,9 +26,9 @@ void nfc_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 void nfc_rand_socket(struct socket_triplet *st)
 {
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		st->protocol = NFC_SOCKPROTO_LLCP;
-		if (rand_bool())
+		if (RAND_BOOL())
 			st->type = SOCK_DGRAM;
 		else
 			st->type = SOCK_STREAM;
diff --git a/net/proto-phonet.c b/net/proto-phonet.c
index c6efdf7..15f7ea2 100644
--- a/net/proto-phonet.c
+++ b/net/proto-phonet.c
@@ -26,7 +26,7 @@ void phonet_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 void phonet_rand_socket(struct socket_triplet *st)
 {
 	st->protocol = 0;
-	if (rand_bool())
+	if (RAND_BOOL())
 		st->type = SOCK_DGRAM;
 	else
 		st->type = SOCK_SEQPACKET;
diff --git a/net/proto-x25.c b/net/proto-x25.c
index 456f322..79f04b5 100644
--- a/net/proto-x25.c
+++ b/net/proto-x25.c
@@ -35,7 +35,7 @@ void x25_setsockopt(struct sockopt *so)
 	so->level = SOL_X25;
 
 	optval = (unsigned int *) so->optval;
-	*optval = rand_bool();
+	*optval = RAND_BOOL();
 
 	so->optlen = sizeof(int);
 }
diff --git a/random-pathname.c b/random-pathname.c
index 5f6f6cf..4d093d1 100644
--- a/random-pathname.c
+++ b/random-pathname.c
@@ -27,7 +27,7 @@ const char * generate_pathname(void)
 
 	len = strlen(pathname);
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		(void) strncpy(newpath, pathname, len);
 	else {
 		if (len < MAX_PATH_LEN - 2) {
@@ -39,7 +39,7 @@ const char * generate_pathname(void)
 	}
 
 	/* 50/50 chance of making it look like a dir */
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		if (len <= MAX_PATH_LEN - 2) {
 			newpath[len] = '/';
 			newpath[len + 1] = 0;
diff --git a/random.c b/random.c
index fd5f2c0..6b0603b 100644
--- a/random.c
+++ b/random.c
@@ -162,7 +162,7 @@ u64 rand64(void)
 {
 	unsigned long r = 0;
 
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		/* 32-bit ranges. */
 		r = rand32();
 
diff --git a/seed.c b/seed.c
index 73e86f6..ee8cb62 100644
--- a/seed.c
+++ b/seed.c
@@ -44,7 +44,7 @@ unsigned int new_seed(void)
 	if ((fd = open("/dev/urandom", O_RDONLY)) < 0 ||
 	    read(fd, &r, sizeof(r)) != sizeof(r)) {
 		r = rand();
-		if (!(rand_bool())) {
+		if (!(RAND_BOOL())) {
 			gettimeofday(&t, NULL);
 			r |= t.tv_usec;
 		}
diff --git a/syscalls/fcntl.c b/syscalls/fcntl.c
index 127f022..59be8ca 100644
--- a/syscalls/fcntl.c
+++ b/syscalls/fcntl.c
@@ -100,17 +100,17 @@ static void sanitise_fcntl(struct syscallrecord *rec)
 
 	case F_NOTIFY:
 		rec->a3 = 0L;
-		if (rand_bool())
+		if (RAND_BOOL())
 			rec->a3 |= DN_ACCESS;
-		if (rand_bool())
+		if (RAND_BOOL())
 			rec->a3 |= DN_MODIFY;
-		if (rand_bool())
+		if (RAND_BOOL())
 			rec->a3 |= DN_CREATE;
-		if (rand_bool())
+		if (RAND_BOOL())
 			rec->a3 |= DN_DELETE;
-		if (rand_bool())
+		if (RAND_BOOL())
 			rec->a3 |= DN_RENAME;
-		if (rand_bool())
+		if (RAND_BOOL())
 			rec->a3 |= DN_ATTRIB;
 		break;
 
diff --git a/syscalls/ioctl.c b/syscalls/ioctl.c
index 7ef81fe..a7c0b5f 100644
--- a/syscalls/ioctl.c
+++ b/syscalls/ioctl.c
@@ -28,7 +28,7 @@ static void ioctl_mangle_cmd(struct syscallrecord *rec)
 static void ioctl_mangle_arg(struct syscallrecord *rec)
 {
 	/* the argument could mean anything, because ioctl sucks like that. */
-	if (rand_bool())
+	if (RAND_BOOL())
 		rec->a3 = rand32();
 	else
 		rec->a3 = (unsigned long) get_non_null_address();
diff --git a/syscalls/mlockall.c b/syscalls/mlockall.c
index 994b681..c2d347f 100644
--- a/syscalls/mlockall.c
+++ b/syscalls/mlockall.c
@@ -16,7 +16,7 @@ static void sanitise_mlockall(struct syscallrecord *rec)
 	if (rec->a1 != 0)
 		return;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		rec->a1 = MCL_CURRENT;
 	else
 		rec->a1 = MCL_FUTURE;
diff --git a/syscalls/mmap.c b/syscalls/mmap.c
index 30d6dbe..9a31ff5 100644
--- a/syscalls/mmap.c
+++ b/syscalls/mmap.c
@@ -99,7 +99,7 @@ static void post_mmap(struct syscallrecord *rec)
 	this_child->num_mappings++;
 
 	/* Sometimes dirty the mapping. */
-	if (rand_bool())
+	if (RAND_BOOL())
 		dirty_mapping(new);
 }
 
diff --git a/syscalls/mremap.c b/syscalls/mremap.c
index ee937b2..80f1c79 100644
--- a/syscalls/mremap.c
+++ b/syscalls/mremap.c
@@ -58,7 +58,7 @@ static void post_mremap(struct syscallrecord *rec)
 	map->ptr = ptr;
 
 	/* Sometimes dirty the mapping first. */
-	if (rand_bool())
+	if (RAND_BOOL())
 		dirty_mapping(map);
 }
 
diff --git a/syscalls/msync.c b/syscalls/msync.c
index c29b8a4..e71f738 100644
--- a/syscalls/msync.c
+++ b/syscalls/msync.c
@@ -16,7 +16,7 @@ static void sanitise_msync(struct syscallrecord *rec)
 {
        (void) common_set_mmap_ptr_len();
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		rec->a3 |= MS_INVALIDATE;
 }
 
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 241ecfd..7b9fa69 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -755,7 +755,7 @@ static long long random_event_config(__u32 *event_type,
 	case PERF_TYPE_BREAKPOINT:
 		/* Breakpoint type only valid if config==0 */
 		/* Set it to something else too anyway     */
-		if (rand_bool())
+		if (RAND_BOOL())
 			config = rand64();
 		else
 			config = 0;
@@ -831,46 +831,46 @@ static long long random_sample_type(void)
 
 	long long sample_type = 0;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		return rand64();
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_IP;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_TID;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_TIME;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_ADDR;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_READ;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_CALLCHAIN;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_ID;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_CPU;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_PERIOD;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_STREAM_ID;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_RAW;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_BRANCH_STACK;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_REGS_USER;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_STACK_USER;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_WEIGHT;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_DATA_SRC;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_IDENTIFIER;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_TRANSACTION;
-	if (rand_bool())
+	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_REGS_INTR;
 
 	return sample_type;
@@ -881,16 +881,16 @@ static long long random_read_format(void)
 
 	long long read_format = 0;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		return rand64();
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		read_format |= PERF_FORMAT_GROUP;
-	if (rand_bool())
+	if (RAND_BOOL())
 		read_format |= PERF_FORMAT_ID;
-	if (rand_bool())
+	if (RAND_BOOL())
 		read_format |= PERF_FORMAT_TOTAL_TIME_ENABLED;
-	if (rand_bool())
+	if (RAND_BOOL())
 		read_format |= PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	return read_format;
@@ -934,30 +934,30 @@ static long long random_branch_sample_type(void)
 	if (rand() % 2)
 		return rand64();
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_USER;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_KERNEL;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_HV;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_ANY;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_ANY_CALL;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_ANY_RETURN;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_IND_CALL;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_COND;
 
 	/* Transactional Memory Types */
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_ABORT_TX;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_IN_TX;
-	if (rand_bool())
+	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_NO_TX;
 
 	return branch_sample;
@@ -980,32 +980,32 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 	attr->read_format = random_read_format();
 
 	/* Bitfield parameters, mostly boolean */
-	attr->disabled = rand_bool();
-	attr->inherit = rand_bool();
+	attr->disabled = RAND_BOOL();
+	attr->inherit = RAND_BOOL();
 	if (group_leader) {
-		attr->pinned = rand_bool();
+		attr->pinned = RAND_BOOL();
 	}
-	attr->exclusive = rand_bool();
-	attr->exclude_user = rand_bool();
-	attr->exclude_kernel = rand_bool();
-	attr->exclude_hv = rand_bool();
-	attr->exclude_idle = rand_bool();
-	attr->mmap = rand_bool();
-	attr->comm = rand_bool();
-	attr->freq = rand_bool();
-	attr->inherit_stat = rand_bool();
-	attr->enable_on_exec = rand_bool();
-	attr->task = rand_bool();
-	attr->watermark = rand_bool();
+	attr->exclusive = RAND_BOOL();
+	attr->exclude_user = RAND_BOOL();
+	attr->exclude_kernel = RAND_BOOL();
+	attr->exclude_hv = RAND_BOOL();
+	attr->exclude_idle = RAND_BOOL();
+	attr->mmap = RAND_BOOL();
+	attr->comm = RAND_BOOL();
+	attr->freq = RAND_BOOL();
+	attr->inherit_stat = RAND_BOOL();
+	attr->enable_on_exec = RAND_BOOL();
+	attr->task = RAND_BOOL();
+	attr->watermark = RAND_BOOL();
 	attr->precise_ip = rand() % 4;	// two bits
-	attr->mmap_data = rand_bool();
-	attr->sample_id_all = rand_bool();
-	attr->exclude_host = rand_bool();
-	attr->exclude_guest = rand_bool();
-	attr->exclude_callchain_kernel = rand_bool();
-	attr->exclude_callchain_user = rand_bool();
-	attr->mmap2 = rand_bool();
-	attr->comm_exec = rand_bool();
+	attr->mmap_data = RAND_BOOL();
+	attr->sample_id_all = RAND_BOOL();
+	attr->exclude_host = RAND_BOOL();
+	attr->exclude_guest = RAND_BOOL();
+	attr->exclude_callchain_kernel = RAND_BOOL();
+	attr->exclude_callchain_user = RAND_BOOL();
+	attr->mmap2 = RAND_BOOL();
+	attr->comm_exec = RAND_BOOL();
 
 	/* wakeup events not relevant */
 
@@ -1040,35 +1040,35 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 	attr->read_format = random_read_format();
 
 	/* Bitfield parameters, mostly boolean */
-	attr->disabled = rand_bool();
-	attr->inherit = rand_bool();
+	attr->disabled = RAND_BOOL();
+	attr->inherit = RAND_BOOL();
 	/* only group leaders can be pinned */
 	if (group_leader) {
-		attr->pinned = rand_bool();
+		attr->pinned = RAND_BOOL();
 	} else {
 		attr->pinned = 0;
 	}
-	attr->exclusive = rand_bool();
-	attr->exclude_user = rand_bool();
-	attr->exclude_kernel = rand_bool();
-	attr->exclude_hv = rand_bool();
-	attr->exclude_idle = rand_bool();
-	attr->mmap = rand_bool();
-	attr->comm = rand_bool();
-	attr->freq = rand_bool();
-	attr->inherit_stat = rand_bool();
-	attr->enable_on_exec = rand_bool();
-	attr->task = rand_bool();
-	attr->watermark = rand_bool();
+	attr->exclusive = RAND_BOOL();
+	attr->exclude_user = RAND_BOOL();
+	attr->exclude_kernel = RAND_BOOL();
+	attr->exclude_hv = RAND_BOOL();
+	attr->exclude_idle = RAND_BOOL();
+	attr->mmap = RAND_BOOL();
+	attr->comm = RAND_BOOL();
+	attr->freq = RAND_BOOL();
+	attr->inherit_stat = RAND_BOOL();
+	attr->enable_on_exec = RAND_BOOL();
+	attr->task = RAND_BOOL();
+	attr->watermark = RAND_BOOL();
 	attr->precise_ip = rand() % 4;	// two bits
-	attr->mmap_data = rand_bool();
-	attr->sample_id_all = rand_bool();
-	attr->exclude_host = rand_bool();
-	attr->exclude_guest = rand_bool();
-	attr->exclude_callchain_kernel = rand_bool();
-	attr->exclude_callchain_user = rand_bool();
-	attr->mmap2 = rand_bool();
-	attr->comm_exec = rand_bool();
+	attr->mmap_data = RAND_BOOL();
+	attr->sample_id_all = RAND_BOOL();
+	attr->exclude_host = RAND_BOOL();
+	attr->exclude_guest = RAND_BOOL();
+	attr->exclude_callchain_kernel = RAND_BOOL();
+	attr->exclude_callchain_user = RAND_BOOL();
+	attr->mmap2 = RAND_BOOL();
+	attr->comm_exec = RAND_BOOL();
 
 	attr->wakeup_events = rand32();
 
@@ -1122,10 +1122,10 @@ static void create_mostly_valid_global_event(struct perf_event_attr *attr,
 	attr->read_format = random_read_format();
 
 	/* Bitfield parameters, mostly boolean */
-	attr->disabled = rand_bool();
-	attr->inherit = rand_bool();
+	attr->disabled = RAND_BOOL();
+	attr->inherit = RAND_BOOL();
 	if (group_leader) {
-		attr->pinned = rand_bool();
+		attr->pinned = RAND_BOOL();
 	}
 
 	/* Not setting most other paramaters */
@@ -1149,35 +1149,35 @@ static void create_random_event(struct perf_event_attr *attr)
 	attr->read_format = random_read_format();
 
 	/* bitfields */
-	attr->disabled = rand_bool();
-	attr->inherit = rand_bool();
-	attr->pinned = rand_bool();
-	attr->exclusive = rand_bool();
-	attr->exclude_user = rand_bool();
-	attr->exclude_kernel = rand_bool();
-	attr->exclude_hv = rand_bool();
-	attr->exclude_idle = rand_bool();
-	attr->mmap = rand_bool();
-	attr->comm = rand_bool();
-	attr->freq = rand_bool();
-	attr->inherit_stat = rand_bool();
-	attr->enable_on_exec = rand_bool();
-	attr->task = rand_bool();
-	attr->watermark = rand_bool();
+	attr->disabled = RAND_BOOL();
+	attr->inherit = RAND_BOOL();
+	attr->pinned = RAND_BOOL();
+	attr->exclusive = RAND_BOOL();
+	attr->exclude_user = RAND_BOOL();
+	attr->exclude_kernel = RAND_BOOL();
+	attr->exclude_hv = RAND_BOOL();
+	attr->exclude_idle = RAND_BOOL();
+	attr->mmap = RAND_BOOL();
+	attr->comm = RAND_BOOL();
+	attr->freq = RAND_BOOL();
+	attr->inherit_stat = RAND_BOOL();
+	attr->enable_on_exec = RAND_BOOL();
+	attr->task = RAND_BOOL();
+	attr->watermark = RAND_BOOL();
 	attr->precise_ip = rand() % 4;
-	attr->mmap_data = rand_bool();
-	attr->sample_id_all = rand_bool();
-	attr->exclude_host = rand_bool();
-	attr->exclude_guest = rand_bool();
-	attr->exclude_callchain_kernel = rand_bool();
-	attr->exclude_callchain_user = rand_bool();
-	attr->mmap2 = rand_bool();
-	attr->comm_exec = rand_bool();
+	attr->mmap_data = RAND_BOOL();
+	attr->sample_id_all = RAND_BOOL();
+	attr->exclude_host = RAND_BOOL();
+	attr->exclude_guest = RAND_BOOL();
+	attr->exclude_callchain_kernel = RAND_BOOL();
+	attr->exclude_callchain_user = RAND_BOOL();
+	attr->mmap2 = RAND_BOOL();
+	attr->comm_exec = RAND_BOOL();
 
 	attr->wakeup_events=rand32();
 
 	/* Breakpoints are unioned with the config values */
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		setup_breakpoints(attr);
 	}
 	else {
@@ -1243,16 +1243,16 @@ void sanitise_perf_event_open(struct syscallrecord *rec)
 	/* flags */
 	/* You almost never set these unless you're playing with cgroups */
 	flags = 0;
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		flags = rand64();
 	} else {
-		if (rand_bool())
+		if (RAND_BOOL())
 			flags |= PERF_FLAG_FD_NO_GROUP;
-		if (rand_bool())
+		if (RAND_BOOL())
 			flags |= PERF_FLAG_FD_OUTPUT;
-		if (rand_bool())
+		if (RAND_BOOL())
 			flags |= PERF_FLAG_PID_CGROUP;
-		if (rand_bool())
+		if (RAND_BOOL())
 			flags |= PERF_FLAG_FD_CLOEXEC;
 	}
 	rec->a5 = flags;
diff --git a/syscalls/remap_file_pages.c b/syscalls/remap_file_pages.c
index 3ffa668..e22b756 100644
--- a/syscalls/remap_file_pages.c
+++ b/syscalls/remap_file_pages.c
@@ -21,14 +21,14 @@ static void sanitise_remap_file_pages(struct syscallrecord *rec)
 
 	map = common_set_mmap_ptr_len();
 
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		start = rand() % map->size;
 		start &= PAGE_MASK;
 		rec->a1 += start;
 	}
 
 	/* We just want to remap a part of the mapping. */
-	if (rand_bool())
+	if (RAND_BOOL())
 		size = page_size;
 	else {
 		size = rand() % map->size;
@@ -45,7 +45,7 @@ static void sanitise_remap_file_pages(struct syscallrecord *rec)
 	rec->a3 = 0;
 
 	/* Pick a random pgoff. */
-	if (rand_bool())
+	if (RAND_BOOL())
 		offset = rand() & (size / page_size);
 	else
 		offset = 0;
diff --git a/syscalls/send.c b/syscalls/send.c
index f77de4f..98930c0 100644
--- a/syscalls/send.c
+++ b/syscalls/send.c
@@ -19,7 +19,7 @@ static void sanitise_send(struct syscallrecord *rec)
 	unsigned int size;
 	void *ptr;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		size = 1;
 	else
 		size = rand() % page_size;
diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index e2480e8..dc1d523 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -88,7 +88,7 @@ void do_setsockopt(struct sockopt *so)
 	so->optval = (unsigned long) zmalloc(page_size);
 
 	// pick a size for optlen. At the minimum, we want an int (overridden below)
-	if (rand_bool())
+	if (RAND_BOOL())
 		so->optlen = sizeof(int);
 	else
 		so->optlen = rand() % 256;
@@ -110,7 +110,7 @@ void do_setsockopt(struct sockopt *so)
 	/* optval should be nonzero to enable a boolean option, or zero if the option is to be disabled.
 	 * Let's disable it half the time.
 	 */
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		free((void *) so->optval);
 		so->optval = 0;
 	}
diff --git a/syscalls/sigaction.c b/syscalls/sigaction.c
index ac2926f..af35390 100644
--- a/syscalls/sigaction.c
+++ b/syscalls/sigaction.c
@@ -14,10 +14,10 @@
 
 static void sanitise_rt_sigaction(struct syscallrecord *rec)
 {
-	if (rand_bool())
+	if (RAND_BOOL())
 		rec->a2 = 0;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		rec->a3 = 0;
 
 	rec->a4 = sizeof(sigset_t);
diff --git a/syscalls/splice.c b/syscalls/splice.c
index b024d44..c219491 100644
--- a/syscalls/splice.c
+++ b/syscalls/splice.c
@@ -17,12 +17,12 @@ static void sanitise_splice(struct syscallrecord *rec)
 	if (ONE_IN(3))
 		return;
 
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		rec->a1 = shm->pipe_fds[rand() % MAX_PIPE_FDS];
 		rec->a2 = 0;
 	}
 
-	if (rand_bool()) {
+	if (RAND_BOOL()) {
 		rec->a3 = shm->pipe_fds[rand() % MAX_PIPE_FDS];
 		rec->a4 = 0;
 	}
diff --git a/syscalls/write.c b/syscalls/write.c
index fd7255d..1cb55f0 100644
--- a/syscalls/write.c
+++ b/syscalls/write.c
@@ -16,7 +16,7 @@ static void sanitise_write(struct syscallrecord *rec)
 	unsigned int size;
 	void *ptr;
 
-	if (rand_bool())
+	if (RAND_BOOL())
 		size = 1;
 	else
 		size = rand() % page_size;
-- 
1.9.1
