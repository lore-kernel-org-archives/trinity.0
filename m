From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH trinity v2, RFT] trinity: use Boehm-Demers-Weiser's garbage collecting memory allocator
Date: Sun, 26 May 2013 12:36:33 +0200
Message-ID: <1369564593-18728-1-git-send-email-dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, dborkman@redhat.com

trinity currently quite often does not care about freeing memory on
its own that was fetched through malloc(). Therefore it can happen if
trinity runs for quite a long time, that oom-killer gets invoked. So
for now use the Boehm-Demers-Weiser's garbage collecting memory
allocator as a malloc replacement to avoid such situations.

In this patch, we wrap all BDW functions into bdw_* equivalents, so that
we could later on still #ifdef something if we want to and replace all
calls based on the build. Calling bdw_free() is still legimite although
not needed, but the memory is reclaimed automatically in the background
or forced via bdw_gcollect(), which would solve trinity's memory
management.

Dependency that we need when building (in case people don't want
additional libs, follow-up patches could still #ifdef bdw_* wrappers
to the glibc functions):

  Fedora: yum install gc-devel

  Debian: apt-get install libgc-dev

More information on Boehm-Demers-Weiser allocator can be found here:

  http://www.hpl.hp.com/personal/Hans_Boehm/gc/

Note that it is said that the performance is competitive with malloc(3),
free(3) calls.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 On top of ``minor: move offsetof into trinity.h''.

 Long-term testing is encouraged before applying, I tested it myself
 shortly and it seems good so far.

 v1 -> v2:
   - Do not explicitly free as it is discouraged from the man-page
   - Do not make static heap assumptions, that was stupid
   - Define GC_THREADS although we might not need it in our case
   - Invoke collector where appropriate (e.g. collect a little after the
     syscall, do a forced collect before we sleep 1 second in the main
     loop)

 Makefile              |  4 +++-
 child.c               |  3 +++
 devices.c             | 15 +++++++-------
 files.c               |  8 ++++----
 include/trinity.h     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 log.c                 |  6 ++++--
 main.c                |  2 ++
 maps.c                | 20 +++++++++----------
 net/alg.c             |  4 +++-
 net/appletalk.c       |  4 +++-
 net/atm.c             |  6 ++++--
 net/ax25.c            |  4 +++-
 net/bpf.c             | 12 +++++------
 net/caif.c            |  4 +++-
 net/can.c             |  5 ++++-
 net/decnet.c          |  4 +++-
 net/econet.c          |  4 +++-
 net/ipv4.c            |  4 +++-
 net/ipv6.c            |  4 +++-
 net/ipx.c             |  4 +++-
 net/irda.c            |  4 +++-
 net/llc.c             |  4 +++-
 net/netlink.c         |  4 +++-
 net/nfc.c             |  4 +++-
 net/packet.c          |  4 +++-
 net/phonet.c          |  4 +++-
 net/pppox.c           | 12 ++++++-----
 net/rose.c            |  4 +++-
 net/tipc.c            |  5 ++++-
 net/unix.c            |  4 +++-
 net/x25.c             |  4 +++-
 params.c              |  2 +-
 random-address.c      |  6 +++---
 random-syscalls.c     |  7 ++++++-
 syscalls/execve.c     |  5 +++--
 syscalls/modify_ldt.c |  6 +++---
 syscalls/move_pages.c | 16 +++++++--------
 syscalls/sendmsg.c    |  4 +++-
 syscalls/shmget.c     |  8 ++++++--
 syscalls/socketcall.c |  6 +++++-
 tables.c              |  6 +++---
 trinity.c             |  2 ++
 unicode.c             |  2 +-
 43 files changed, 211 insertions(+), 84 deletions(-)

diff --git a/Makefile b/Makefile
index 2dbaa65..eb362ec 100644
--- a/Makefile
+++ b/Makefile
@@ -21,6 +21,8 @@ CFLAGS += -Wwrite-strings
 # Only enabled during development.
 CFLAGS += -Werror
 
+LDFLAGS = -lgc
+
 V	= @
 Q	= $(V:1=)
 QUIET_CC = $(Q:@=@echo    '  CC	'$@;)
@@ -57,7 +59,7 @@ DEPDIR= .deps
 -include $(SRCS:%.c=$(DEPDIR)/%.d)
 
 trinity: test $(OBJS) $(HEADERS)
-	$(QUIET_CC)$(CC) $(CFLAGS) -o trinity $(OBJS)
+	$(QUIET_CC)$(CC) $(CFLAGS) -o trinity $(OBJS) $(LDFLAGS)
 	@mkdir -p tmp
 
 df = $(DEPDIR)/$(*F)
diff --git a/child.c b/child.c
index 5de2c19..b3678a3 100644
--- a/child.c
+++ b/child.c
@@ -13,6 +13,7 @@
 #include <sys/resource.h>
 #include <sys/prctl.h>
 
+#include "trinity.h"
 #include "child.h"
 #include "syscall.h"
 #include "log.h"
@@ -153,5 +154,7 @@ int child_process(int childno)
 
 	reenable_coredumps();
 
+	bdw_gcollect();
+
 	return ret;
 }
diff --git a/devices.c b/devices.c
index 0493c39..2e115f8 100644
--- a/devices.c
+++ b/devices.c
@@ -8,6 +8,7 @@
 #include <sys/types.h>
 #include <linux/kdev_t.h>
 
+#include "trinity.h"
 #include "log.h"
 
 static struct {
@@ -37,9 +38,9 @@ static void parse_proc_devices(void)
 			block = 1;
 		else if (sscanf(line, "%d %as", &major, &name) == 2) {
 			if (block) {
-				new = realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
+				new = bdw_realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
 				if (!new) {
-					free(name);
+					bdw_free(name);
 					continue;
 				}
 				block_devs = new;
@@ -48,9 +49,9 @@ static void parse_proc_devices(void)
 				block_devs[bldevs].name = name;
 				bldevs++;
 			} else {
-				new = realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
+				new = bdw_realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
 				if (!new) {
-					free(name);
+					bdw_free(name);
 					continue;
 				}
 				char_devs = new;
@@ -63,7 +64,7 @@ static void parse_proc_devices(void)
 	}
 
 	fclose(fp);
-	free(line);
+	bdw_free(line);
 }
 
 static void parse_proc_misc(void)
@@ -78,9 +79,9 @@ static void parse_proc_misc(void)
 		return;
 
 	while (fscanf(fp, "%d %as", &minor, &name) == 2) {
-		new = realloc(misc_devs, (miscdevs+1)*sizeof(*misc_devs));
+		new = bdw_realloc(misc_devs, (miscdevs+1)*sizeof(*misc_devs));
 		if (!new) {
-			free(name);
+			bdw_free(name);
 			continue;
 		}
 		misc_devs = new;
diff --git a/files.c b/files.c
index 1f817d0..424ad21 100644
--- a/files.c
+++ b/files.c
@@ -100,7 +100,7 @@ static struct namelist *list_alloc(void)
 {
 	struct namelist *node;
 
-	node = malloc(sizeof(struct namelist));
+	node = bdw_malloc(sizeof(struct namelist));
 	if (node == NULL)
 		exit(EXIT_FAILURE);
 	memset(node, 0, sizeof(struct namelist));
@@ -126,7 +126,7 @@ static void list_add(struct namelist *list, const char *name)
 		list->next = list;
 		list->prev = list;
 	}
-	newnode->name = strdup(name);
+	newnode->name = bdw_strdup(name);
 
 	__list_add(newnode, list, list->next);
 }
@@ -250,7 +250,7 @@ void generate_filelist(void)
 	/*
 	 * Generate an index of pointers to the filenames
 	 */
-	fileindex = malloc(sizeof(char *) * files_added);
+	fileindex = bdw_malloc(sizeof(char *) * files_added);
 
 	node = names;
 	do {
@@ -366,7 +366,7 @@ char * generate_pathname(void)
 
 	case 91 ... 99:
 		/* Create a bogus filename. */
-		newpath = malloc(page_size);	// FIXME: We leak this.
+		newpath = bdw_malloc(page_size);
 		if (newpath == NULL)
 			return get_filename();	// give up.
 
diff --git a/include/trinity.h b/include/trinity.h
index 158b566..b0dc2f8 100644
--- a/include/trinity.h
+++ b/include/trinity.h
@@ -1,6 +1,9 @@
 #ifndef _TRINITY_H
 #define _TRINITY_H 1
 
+#define GC_THREADS
+#include <gc.h>
+
 #include "types.h"
 
 #define UNLOCKED 0
@@ -25,6 +28,58 @@ void init_watchdog(void);
 
 extern unsigned int user_specified_children;
 
+static inline void bdw_init(void)
+{
+	GC_init();
+	GC_set_dont_expand(0);
+	GC_enable_incremental();
+}
+
+static inline void *bdw_malloc(size_t size)
+{
+	return GC_malloc(size);
+}
+
+static inline void *bdw_realloc(void *area, size_t size)
+{
+	return GC_realloc(area, size);
+}
+
+static inline void *bdw_memalign(size_t boundary, size_t size)
+{
+	return GC_memalign(boundary, size);
+}
+
+static inline char *bdw_strdup(const char *str)
+{
+	return GC_strdup(str);
+}
+
+static inline void bdw_free(__unused__ void *area)
+{
+	/* Garbage collector will do this for us. For small sized
+	 * frees it is said that it will hurt performance. From the
+	 * man page: "GC_free can be used to deallocate objects,
+	 * but its use is optional, and generally discouraged."
+	 */
+#if 0
+	return GC_free(area);
+#endif
+}
+
+static inline void bdw_gcollect(void)
+{
+	/* Usually done automatically, but we can also force
+	 * reclaiming memory here.
+	 */
+	GC_gcollect();
+}
+
+static inline int bdw_gcollect_little(void)
+{
+	return GC_collect_a_little();
+}
+
 #define UNUSED(x) (void)(x)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
diff --git a/log.c b/log.c
index 736995d..c0fe924 100644
--- a/log.c
+++ b/log.c
@@ -5,6 +5,8 @@
 #include <string.h>
 #include <unistd.h>
 #include <fcntl.h>
+
+#include "trinity.h"
 #include "params.h"	// logging, monochrome, quiet_level
 #include "shm.h"
 #include "pids.h"
@@ -16,7 +18,7 @@ void open_logfiles(void)
 	unsigned int i;
 	char *logfilename;
 
-	logfilename = malloc(64);
+	logfilename = bdw_malloc(64);
 	sprintf(logfilename, "trinity.log");
 	unlink(logfilename);
 	parentlogfile = fopen(logfilename, "a");
@@ -34,7 +36,7 @@ void open_logfiles(void)
 			exit(EXIT_FAILURE);
 		}
 	}
-	free(logfilename);
+	bdw_free(logfilename);
 }
 
 void close_logfiles(void)
diff --git a/main.c b/main.c
index fbe348a..e9bfd05 100644
--- a/main.c
+++ b/main.c
@@ -309,6 +309,8 @@ static void handle_children(void)
 		pid = waitpid(pid, &childstatus, WUNTRACED | WCONTINUED | WNOHANG);
 		if (pid != 0)
 			handle_child(pid, childstatus);
+
+		bdw_gcollect();
 	}
 }
 
diff --git a/maps.c b/maps.c
index 62b2328..7ab0eca 100644
--- a/maps.c
+++ b/maps.c
@@ -7,6 +7,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+
 #include "trinity.h"	// page_size
 #include "arch.h"
 #include "maps.h"
@@ -36,7 +37,7 @@ static struct map * alloc_map(void)
 {
 	struct map *newmap;
 
-	newmap = malloc(sizeof(struct map));
+	newmap = bdw_malloc(sizeof(struct map));
 	if (!newmap) {
 		printf("Couldn't allocate maps list!\n");
 		exit(EXIT_FAILURE);
@@ -94,7 +95,6 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 	size *= 2;
 
 	tmpmap->ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_SHARED, -1, 0);
-
 	if (tmpmap->ptr == MAP_FAILED) {
 		printf("mmap /dev/zero failure\n");
 		exit(EXIT_FAILURE);
@@ -102,7 +102,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 
 	tmpmap->size = size;
 
-	tmpmap->name = malloc(80);
+	tmpmap->name = bdw_malloc(80);
 	if (!tmpmap->name) {
 		fprintf(stderr, "malloc() failed in %s().", __func__);
 		exit(EXIT_FAILURE);
@@ -157,8 +157,8 @@ void destroy_maps(void)
 	for (i = 0; i < num_mappings; i++) {
 		next = thismap->next;
 		munmap(thismap->ptr, thismap->size);
-		free(thismap->name);
-		free(thismap);
+		bdw_free(thismap->name);
+		bdw_free(thismap);
 		thismap = next;
 	}
 	num_mappings = 0;
@@ -170,32 +170,32 @@ void init_buffers(void)
 
 	output(2, "shm is at %p\n", shm);
 
-	page_zeros = memalign(page_size, page_size * 2);
+	page_zeros = bdw_memalign(page_size, page_size * 2);
 	if (!page_zeros)
 		exit(EXIT_FAILURE);
 	memset(page_zeros, 0, page_size);
 	output(2, "page_zeros @ %p\n", page_zeros);
 
-	page_0xff = memalign(page_size, page_size * 2);
+	page_0xff = bdw_memalign(page_size, page_size * 2);
 	if (!page_0xff)
 		exit(EXIT_FAILURE);
 	memset(page_0xff, 0xff, page_size);
 	output(2, "page_0xff @ %p\n", page_0xff);
 
-	page_rand = memalign(page_size, page_size * 2);
+	page_rand = bdw_memalign(page_size, page_size * 2);
 	if (!page_rand)
 		exit(EXIT_FAILURE);
 	memset(page_rand, 0x55, page_size);	/* overwritten below */
 	output(2, "page_rand @ %p\n", page_rand);
 
-	page_allocs = memalign(page_size, page_size * 2);
+	page_allocs = bdw_memalign(page_size, page_size * 2);
 	if (!page_allocs)
 		exit(EXIT_FAILURE);
 	memset(page_allocs, 0xff, page_size);
 	output(2, "page_allocs @ %p\n", page_allocs);
 
 	for (i = 0; i < (page_size / sizeof(unsigned long *)); i++)
-		page_allocs[i] = (unsigned long) malloc(page_size);
+		page_allocs[i] = (unsigned long) bdw_malloc(page_size);
 
 	setup_maps();
 
diff --git a/net/alg.c b/net/alg.c
index 022d118..766369d 100644
--- a/net/alg.c
+++ b/net/alg.c
@@ -3,6 +3,8 @@
 #include <sys/un.h>
 #include <netinet/in.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "config.h"
 
 #ifdef USE_IF_ALG
@@ -13,7 +15,7 @@ void gen_alg(unsigned long *addr, unsigned long *addrlen)
 	struct sockaddr_alg *alg;
 	unsigned int i;
 
-	alg = malloc(sizeof(struct sockaddr_alg));
+	alg = bdw_malloc(sizeof(struct sockaddr_alg));
 	if (alg == NULL)
 		return;
 
diff --git a/net/appletalk.c b/net/appletalk.c
index 336a8b9..6d5cc65 100644
--- a/net/appletalk.c
+++ b/net/appletalk.c
@@ -5,11 +5,13 @@
 #include <netinet/in.h>
 #include <linux/atalk.h>
 
+#include "trinity.h"
+
 void gen_appletalk(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_at *atalk;
 
-	atalk = malloc(sizeof(struct sockaddr_at));
+	atalk = bdw_malloc(sizeof(struct sockaddr_at));
 	if (atalk == NULL)
 		return;
 
diff --git a/net/atm.c b/net/atm.c
index 732696c..7710bb8 100644
--- a/net/atm.c
+++ b/net/atm.c
@@ -5,11 +5,13 @@
 #include <linux/atm.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_atmpvc(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_atmpvc *atmpvc;
 
-	atmpvc = malloc(sizeof(struct sockaddr_atmpvc));
+	atmpvc = bdw_malloc(sizeof(struct sockaddr_atmpvc));
 	if (atmpvc == NULL)
 		return;
 
@@ -26,7 +28,7 @@ void gen_atmsvc(unsigned long *addr, unsigned long *addrlen)
 	struct sockaddr_atmsvc *atmsvc;
 	unsigned int i;
 
-	atmsvc = malloc(sizeof(struct sockaddr_atmsvc));
+	atmsvc = bdw_malloc(sizeof(struct sockaddr_atmsvc));
 	if (atmsvc == NULL)
 		return;
 
diff --git a/net/ax25.c b/net/ax25.c
index 907ffc9..da39489 100644
--- a/net/ax25.c
+++ b/net/ax25.c
@@ -4,13 +4,15 @@
 #include <netinet/in.h>
 #include <linux/ax25.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "maps.h"	// page_rand
 
 void gen_ax25(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_ax25 *ax25;
 
-	ax25 = malloc(sizeof(struct sockaddr_ax25));
+	ax25 = bdw_malloc(sizeof(struct sockaddr_ax25));
 	if (ax25 == NULL)
 		return;
 
diff --git a/net/bpf.c b/net/bpf.c
index 2c0ed32..806a05e 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -320,17 +320,17 @@ void gen_seccomp_bpf(unsigned long *addr, unsigned long *addrlen)
 	struct sock_fprog *bpf = (void *) addr;
 
 	if (addrlen != NULL) {
-		bpf = malloc(sizeof(struct sock_fprog));
+		bpf = bdw_malloc(sizeof(struct sock_fprog));
 		if (bpf == NULL)
 			return;
 	}
 
 	bpf->len = avail = rand() % BPF_MAXINSNS;
 
-	bpf->filter = malloc(bpf->len * sizeof(struct sock_filter));
+	bpf->filter = bdw_malloc(bpf->len * sizeof(struct sock_filter));
 	if (bpf->filter == NULL) {
 		if (addrlen != NULL)
-			free(bpf);
+			bdw_free(bpf);
 		return;
 	}
 
@@ -358,17 +358,17 @@ void gen_bpf(unsigned long *addr, unsigned long *addrlen)
 	struct sock_fprog *bpf = (void *) addr;
 
 	if (addrlen != NULL) {
-		bpf = malloc(sizeof(struct sock_fprog));
+		bpf = bdw_malloc(sizeof(struct sock_fprog));
 		if (bpf == NULL)
 			return;
 	}
 
 	bpf->len = rand() % BPF_MAXINSNS;
 
-	bpf->filter = malloc(bpf->len * sizeof(struct sock_filter));
+	bpf->filter = bdw_malloc(bpf->len * sizeof(struct sock_filter));
 	if (bpf->filter == NULL) {
 		if (addrlen != NULL)
-			free(bpf);
+			bdw_free(bpf);
 		return;
 	}
 
diff --git a/net/caif.c b/net/caif.c
index 18454f8..e39399f 100644
--- a/net/caif.c
+++ b/net/caif.c
@@ -3,6 +3,8 @@
 #include <sys/un.h>
 #include <netinet/in.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "config.h"
 
 #ifdef USE_CAIF
@@ -13,7 +15,7 @@ void gen_caif(unsigned long *addr, unsigned long *addrlen)
 	struct sockaddr_caif *caif;
 	unsigned int i;
 
-	caif = malloc(sizeof(struct sockaddr_caif));
+	caif = bdw_malloc(sizeof(struct sockaddr_caif));
 	if (caif == NULL)
 		return;
 
diff --git a/net/can.c b/net/can.c
index 520d12e..30ead34 100644
--- a/net/can.c
+++ b/net/can.c
@@ -5,13 +5,16 @@
 #include <linux/can.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_can(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_can *can;
 
-	can = malloc(sizeof(struct sockaddr_can));
+	can = bdw_malloc(sizeof(struct sockaddr_can));
 	if (can == NULL)
 		return;
+
 	can->can_family = AF_CAN;
 	can->can_ifindex = rand();
 	can->can_addr.tp.rx_id = rand();
diff --git a/net/decnet.c b/net/decnet.c
index b8f2fe7..70a0478 100644
--- a/net/decnet.c
+++ b/net/decnet.c
@@ -5,12 +5,14 @@
 #include <linux/dn.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_decnet(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_dn *dn;
 	unsigned int i;
 
-	dn = malloc(sizeof(struct sockaddr_dn));
+	dn = bdw_malloc(sizeof(struct sockaddr_dn));
 	if (dn == NULL)
 		return;
 
diff --git a/net/econet.c b/net/econet.c
index ea42ce6..a990c6b 100644
--- a/net/econet.c
+++ b/net/econet.c
@@ -5,11 +5,13 @@
 #include <neteconet/ec.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_econet(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_ec *ec;
 
-	ec = malloc(sizeof(struct sockaddr_ec));
+	ec = bdw_malloc(sizeof(struct sockaddr_ec));
 	if (ec == NULL)
 		return;
 
diff --git a/net/ipv4.c b/net/ipv4.c
index 2090cb5..4cde2f1 100644
--- a/net/ipv4.c
+++ b/net/ipv4.c
@@ -4,6 +4,8 @@
 #include <netinet/in.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 in_addr_t random_ipv4_address(void)
 {
 	int addr = 0;
@@ -61,7 +63,7 @@ void gen_ipv4(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_in *ipv4;
 
-	ipv4 = malloc(sizeof(struct sockaddr_in));
+	ipv4 = bdw_malloc(sizeof(struct sockaddr_in));
 	if (ipv4 == NULL)
 		return;
 
diff --git a/net/ipv6.c b/net/ipv6.c
index d8ade29..840e0cb 100644
--- a/net/ipv6.c
+++ b/net/ipv6.c
@@ -7,11 +7,13 @@
 #include <linux/if_packet.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_ipv6(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_in6 *ipv6;
 
-	ipv6 = malloc(sizeof(struct sockaddr_in6));
+	ipv6 = bdw_malloc(sizeof(struct sockaddr_in6));
 	if (ipv6 == NULL)
 		return;
 
diff --git a/net/ipx.c b/net/ipx.c
index cea6647..8bff0bf 100644
--- a/net/ipx.c
+++ b/net/ipx.c
@@ -5,12 +5,14 @@
 #include <linux/ipx.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_ipx(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_ipx *ipx;
 	unsigned int i;
 
-	ipx = malloc(sizeof(struct sockaddr_ipx));
+	ipx = bdw_malloc(sizeof(struct sockaddr_ipx));
 	if (ipx == NULL)
 		return;
 
diff --git a/net/irda.c b/net/irda.c
index 57752ed..31bfe07 100644
--- a/net/irda.c
+++ b/net/irda.c
@@ -5,12 +5,14 @@
 #include <linux/irda.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_irda(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_irda *irda;
 	unsigned int i;
 
-	irda = malloc(sizeof(struct sockaddr_irda));
+	irda = bdw_malloc(sizeof(struct sockaddr_irda));
 	if (irda == NULL)
 		return;
 
diff --git a/net/llc.c b/net/llc.c
index c3ebf43..af18802 100644
--- a/net/llc.c
+++ b/net/llc.c
@@ -7,12 +7,14 @@
 #include <linux/llc.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_llc(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_llc *llc;
 	unsigned int i;
 
-	llc = malloc(sizeof(struct sockaddr_llc));
+	llc = bdw_malloc(sizeof(struct sockaddr_llc));
 	if (llc == NULL)
 		return;
 	llc->sllc_family = AF_LLC;
diff --git a/net/netlink.c b/net/netlink.c
index 408782b..265d331 100644
--- a/net/netlink.c
+++ b/net/netlink.c
@@ -5,11 +5,13 @@
 #include <linux/netlink.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_netlink(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_nl *nl;
 
-	nl = malloc(sizeof(struct sockaddr_nl));
+	nl = bdw_malloc(sizeof(struct sockaddr_nl));
 	if (nl == NULL)
 		return;
 
diff --git a/net/nfc.c b/net/nfc.c
index c182774..e1d33fa 100644
--- a/net/nfc.c
+++ b/net/nfc.c
@@ -3,6 +3,8 @@
 #include <sys/un.h>
 #include <netinet/in.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "config.h"
 #include "compat.h"
 
@@ -11,7 +13,7 @@ void gen_nfc(unsigned long *addr, unsigned long *addrlen)
 	struct sockaddr_nfc *nfc;
 
 	// TODO: See also sockaddr_nfc_llcp
-	nfc = malloc(sizeof(struct sockaddr_nfc));
+	nfc = bdw_malloc(sizeof(struct sockaddr_nfc));
 	if (nfc == NULL)
 		return;
 
diff --git a/net/packet.c b/net/packet.c
index c060a1a..41fc908 100644
--- a/net/packet.c
+++ b/net/packet.c
@@ -5,13 +5,15 @@
 #include <linux/if_packet.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_packet(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_pkt *pkt;
 	unsigned int i;
 
 	//TODO: See also sockaddr_ll
-	pkt = malloc(sizeof(struct sockaddr_pkt));
+	pkt = bdw_malloc(sizeof(struct sockaddr_pkt));
 	if (pkt == NULL)
 		return;
 
diff --git a/net/phonet.c b/net/phonet.c
index 2a8bbc3..c25c68a 100644
--- a/net/phonet.c
+++ b/net/phonet.c
@@ -5,11 +5,13 @@
 #include <linux/phonet.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_phonet(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_pn *pn;
 
-	pn = malloc(sizeof(struct sockaddr_pn));
+	pn = bdw_malloc(sizeof(struct sockaddr_pn));
 	if (pn == NULL)
 		return;
 
diff --git a/net/pppox.c b/net/pppox.c
index b5ba19b..387c04a 100644
--- a/net/pppox.c
+++ b/net/pppox.c
@@ -6,6 +6,8 @@
 #include <linux/if_ether.h> /* for ETH_ALEN in if_pppox.h */
 #include <linux/if_pppox.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "net.h"
 #include "sanitise.h"
 
@@ -23,7 +25,7 @@ void gen_pppox(unsigned long *addr, unsigned long *addrlen)
 	switch (proto) {
 
 	case PX_PROTO_OE:
-		pppox = malloc(sizeof(struct sockaddr_pppox));
+		pppox = bdw_malloc(sizeof(struct sockaddr_pppox));
 		if (pppox == NULL)
 			return;
 
@@ -49,7 +51,7 @@ void gen_pppox(unsigned long *addr, unsigned long *addrlen)
 		switch (rand() % 4) {
 
 		case 0:	/* PPPoL2TP */
-			pppol2tp = malloc(sizeof(struct sockaddr_pppol2tp));
+			pppol2tp = bdw_malloc(sizeof(struct sockaddr_pppol2tp));
 			if (pppol2tp == NULL)
 				return;
 
@@ -71,7 +73,7 @@ void gen_pppox(unsigned long *addr, unsigned long *addrlen)
 			{
 			struct sockaddr_pppol2tpin6 *pppol2tpin6;
 
-			pppol2tpin6 = malloc(sizeof(struct sockaddr_pppol2tpin6));
+			pppol2tpin6 = bdw_malloc(sizeof(struct sockaddr_pppol2tpin6));
 			if (pppol2tpin6 == NULL)
 				return;
 
@@ -102,7 +104,7 @@ void gen_pppox(unsigned long *addr, unsigned long *addrlen)
 			{
 			struct sockaddr_pppol2tpv3 *pppol2tpv3;
 
-			pppol2tpv3 = malloc(sizeof(struct sockaddr_pppol2tpv3));
+			pppol2tpv3 = bdw_malloc(sizeof(struct sockaddr_pppol2tpv3));
 			if (pppol2tpv3 == NULL)
 				return;
 
@@ -126,7 +128,7 @@ void gen_pppox(unsigned long *addr, unsigned long *addrlen)
 			{
 			struct sockaddr_pppol2tpv3in6 *pppol2tpv3in6;
 
-			pppol2tpv3in6 = malloc(sizeof(struct sockaddr_pppol2tpv3in6));
+			pppol2tpv3in6 = bdw_malloc(sizeof(struct sockaddr_pppol2tpv3in6));
 			if (pppol2tpv3in6 == NULL)
 				return;
 
diff --git a/net/rose.c b/net/rose.c
index 046d535..cfd9d8a 100644
--- a/net/rose.c
+++ b/net/rose.c
@@ -5,13 +5,15 @@
 #include <linux/ax25.h> /* for ax25_address in rose.h */
 #include <linux/rose.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "maps.h"	// page_rand
 
 void gen_rose(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_rose *rose;
 
-	rose = malloc(sizeof(struct sockaddr_rose));
+	rose = bdw_malloc(sizeof(struct sockaddr_rose));
 	if (rose == NULL)
 		return;
 
diff --git a/net/tipc.c b/net/tipc.c
index c72c340..92b1546 100644
--- a/net/tipc.c
+++ b/net/tipc.c
@@ -5,13 +5,16 @@
 #include <linux/tipc.h>
 #include <stdlib.h>
 
+#include "trinity.h"
+
 void gen_tipc(unsigned long *addr, unsigned long *addrlen)
 {
 	struct sockaddr_tipc *tipc;
 
-	tipc = malloc(sizeof(struct sockaddr_tipc));
+	tipc = bdw_malloc(sizeof(struct sockaddr_tipc));
 	if (tipc == NULL)
 		return;
+
 	tipc->family = AF_TIPC;
 	tipc->addrtype = rand();
 	tipc->scope = rand();
diff --git a/net/unix.c b/net/unix.c
index 5d2a188..7e802f3 100644
--- a/net/unix.c
+++ b/net/unix.c
@@ -4,6 +4,8 @@
 #include <netinet/in.h>
 #include <linux/dn.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "maps.h"
 
 void gen_unixsock(unsigned long *addr, unsigned long *addrlen)
@@ -11,7 +13,7 @@ void gen_unixsock(unsigned long *addr, unsigned long *addrlen)
 	struct sockaddr_un *unixsock;
 	unsigned int len;
 
-	unixsock = malloc(sizeof(struct sockaddr_un));
+	unixsock = bdw_malloc(sizeof(struct sockaddr_un));
 	if (unixsock == NULL)
 		return;
 
diff --git a/net/x25.c b/net/x25.c
index 0ba40dd..662829e 100644
--- a/net/x25.c
+++ b/net/x25.c
@@ -4,6 +4,8 @@
 #include <netinet/in.h>
 #include <linux/x25.h>
 #include <stdlib.h>
+
+#include "trinity.h"
 #include "maps.h"	// page_rand
 
 void gen_x25(unsigned long *addr, unsigned long *addrlen)
@@ -11,7 +13,7 @@ void gen_x25(unsigned long *addr, unsigned long *addrlen)
 	struct sockaddr_x25 *x25;
 	unsigned int len;
 
-	x25 = malloc(sizeof(struct sockaddr_x25));
+	x25 = bdw_malloc(sizeof(struct sockaddr_x25));
 	if (x25 == NULL)
 		return;
 
diff --git a/params.c b/params.c
index c2c3f70..7691426 100644
--- a/params.c
+++ b/params.c
@@ -200,7 +200,7 @@ void parse_args(int argc, char *argv[])
 			break;
 
 		case 'V':
-			victim_path = strdup(optarg);
+			victim_path = bdw_strdup(optarg);
 			//FIXME: Later, allow for multiple victim files
 			break;
 
diff --git a/random-address.c b/random-address.c
index 5460d05..fa853cb 100644
--- a/random-address.c
+++ b/random-address.c
@@ -64,7 +64,7 @@ static void * _get_address(unsigned char null_allowed)
 		break;
 	case 7: addr = get_map();
 		break;
-	case 8: addr = malloc(page_size * 2);
+	case 8: addr = bdw_malloc(page_size * 2);
 		break;
 	default:
 		BUG("unreachable!\n");
@@ -145,10 +145,10 @@ struct iovec * alloc_iovec(unsigned int num)
 	struct iovec *iov;
 	unsigned int i;
 
-	iov = malloc(num * sizeof(struct iovec));
+	iov = bdw_malloc(num * sizeof(struct iovec));
 	if (iov != NULL) {
 		for (i = 0; i < num; i++) {
-			iov[i].iov_base = malloc(page_size);
+			iov[i].iov_base = bdw_malloc(page_size);
 			iov[i].iov_len = page_size;
 		}
 	}
diff --git a/random-syscalls.c b/random-syscalls.c
index ea1265f..46083cb 100644
--- a/random-syscalls.c
+++ b/random-syscalls.c
@@ -76,8 +76,11 @@ int do_random_syscalls(int childno)
 
 		check_parent_pid();
 
-		while (shm->regenerating == TRUE)
+		while (shm->regenerating == TRUE) {
+			/* We need to wait here, so do as well a forced reclaim */
+			bdw_gcollect();
 			sleep(1);
+		}
 
 		/* If the parent reseeded, we should reflect the latest seed too. */
 		if (shm->seed != shm->seeds[childno])
@@ -118,6 +121,8 @@ retry:
 		}
 
 		ret = mkcall(childno);
+
+		bdw_gcollect_little();
 	}
 out:
 	return ret;
diff --git a/syscalls/execve.c b/syscalls/execve.c
index b9f66bd..bc9fb72 100644
--- a/syscalls/execve.c
+++ b/syscalls/execve.c
@@ -11,6 +11,7 @@
  */
 #include <stdio.h>
 #include <stdlib.h>
+
 #include "trinity.h"	// page_size
 #include "sanitise.h"
 #include "shm.h"
@@ -23,12 +24,12 @@ static unsigned long ** gen_ptrs_to_crap(void)
 	unsigned int count = rand() % 32;
 
 	/* Fabricate argv */
-	ptr = malloc(count * sizeof(void *));	// FIXME: LEAK
+	ptr = bdw_malloc(count * sizeof(void *));
 	if (ptr == NULL)
 		return NULL;
 
 	for (i = 0; i < count; i++) {
-		ptr[i] = malloc(page_size);	// FIXME: LEAK
+		ptr[i] = bdw_malloc(page_size);
 		if (ptr[i] != NULL)
 			generate_random_page((char *) ptr[i]);
 	}
diff --git a/syscalls/modify_ldt.c b/syscalls/modify_ldt.c
index 0331a3e..a9de3a4 100644
--- a/syscalls/modify_ldt.c
+++ b/syscalls/modify_ldt.c
@@ -8,6 +8,8 @@
 #include <sys/types.h>
 #define __ASSEMBLY__ 1
 #include <asm/ldt.h>
+
+#include "trinity.h"
 #include "sanitise.h"
 #include "shm.h"
 
@@ -22,7 +24,7 @@ static void sanitise_modify_ldt(int childno)
 	case 0:
 		/* read the ldt into the memory pointed to by ptr.
 		   The number of bytes read is the smaller of bytecount and the actual size of the ldt. */
-		ldt = malloc(ALLOCSIZE);
+		ldt = bdw_malloc(ALLOCSIZE);
 		if (ldt == NULL)
 			return;
 		shm->a3[childno] = ALLOCSIZE;
@@ -48,8 +50,6 @@ static void sanitise_modify_ldt(int childno)
 	default:
 		break;
 	}
-
-	//FIXME: We leak 'ldt' here. Need to deallocate post-syscall.
 }
 
 struct syscall syscall_modify_ldt = {
diff --git a/syscalls/move_pages.c b/syscalls/move_pages.c
index 705c6c7..8322b40 100644
--- a/syscalls/move_pages.c
+++ b/syscalls/move_pages.c
@@ -11,14 +11,12 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/types.h>
+
 #include "trinity.h"	// page_size
 #include "sanitise.h"
 #include "arch.h"
 #include "shm.h"
 
-//FIXME: This leaks memory.
-// A ->post function should free up the allocations.
-
 static void sanitise_move_pages(int childno)
 {
 	int *nodes;
@@ -32,7 +30,7 @@ static void sanitise_move_pages(int childno)
 		shm->a6[childno] &= ~MPOL_MF_MOVE_ALL;
 	}
 
-	page_alloc = (unsigned long *) malloc(page_size);
+	page_alloc = bdw_malloc(page_size);
 	if (page_alloc == NULL)
 		return;
 
@@ -42,20 +40,20 @@ static void sanitise_move_pages(int childno)
 	shm->a2[childno] = count;
 
 	for (i = 0; i < count; i++) {
-		page_alloc[i] = (unsigned long) malloc(page_size);
+		page_alloc[i] = (unsigned long) bdw_malloc(page_size);
 		if (!page_alloc[i])
-			return;					// FIXME: MEMORY LEAK
+			return;
 		page_alloc[i] &= PAGE_MASK;
 	}
 
 	shm->a3[childno] = (unsigned long) page_alloc;
 
-	nodes = malloc(count * sizeof(int));
+	nodes = bdw_malloc(count * sizeof(int));
 	for (i = 0; i < count; i++)
 		nodes[i] = (int) rand() % 2;
-	shm->a4[childno] = (unsigned long) nodes;
 
-	shm->a5[childno] = (unsigned long) malloc(count * sizeof(int));
+	shm->a4[childno] = (unsigned long) nodes;
+	shm->a5[childno] = (unsigned long) bdw_malloc(count * sizeof(int));
 }
 
 struct syscall syscall_move_pages = {
diff --git a/syscalls/sendmsg.c b/syscalls/sendmsg.c
index 71ac549..9d47dd5 100644
--- a/syscalls/sendmsg.c
+++ b/syscalls/sendmsg.c
@@ -5,6 +5,8 @@
 #include <stdlib.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+
+#include "trinity.h"
 #include "compat.h"
 #include "random.h"
 #include "sanitise.h"
@@ -15,7 +17,7 @@ static void sanitise_sendmsg(int childno)
 	struct msghdr *msg;
 
 	// FIXME: Convert to use generic ARG_IOVEC
-        msg = malloc(sizeof(struct msghdr));
+        msg = bdw_malloc(sizeof(struct msghdr));
 	if (msg == NULL) {
 		shm->a2[childno] = (unsigned long) get_address();
 		return;
diff --git a/syscalls/shmget.c b/syscalls/shmget.c
index 09d543c..1cf26fa 100644
--- a/syscalls/shmget.c
+++ b/syscalls/shmget.c
@@ -5,6 +5,8 @@
 #include <stdlib.h>
 #include <sys/ipc.h>
 #include <sys/shm.h>
+
+#include "trinity.h"
 #include "sanitise.h"
 
 static void post_shmget(int syscallret)
@@ -14,11 +16,13 @@ static void post_shmget(int syscallret)
 	if (syscallret == -1)
 		return;
 
-	shmid_ds = malloc(sizeof(struct shmid_ds));
+	shmid_ds = bdw_malloc(sizeof(struct shmid_ds));
+	if (!shmid_ds)
+		return;
 
 	shmctl(syscallret, IPC_RMID, shmid_ds);
 
-	free(shmid_ds);
+	bdw_free(shmid_ds);
 }
 
 struct syscall syscall_shmget = {
diff --git a/syscalls/socketcall.c b/syscalls/socketcall.c
index 640900d..5a4819c 100644
--- a/syscalls/socketcall.c
+++ b/syscalls/socketcall.c
@@ -3,6 +3,8 @@
  */
 #include <stdlib.h>
 #include <linux/net.h>
+
+#include "trinity.h"
 #include "compat.h"
 #include "sanitise.h"
 #include "shm.h"
@@ -11,7 +13,9 @@ static void sanitise_socketcall(int childno)
 {
 	unsigned long *args;
 
-	args = malloc(6 * sizeof(unsigned long));
+	args = bdw_malloc(6 * sizeof(unsigned long));
+	if (!args)
+		return;
 
 	shm->a1[childno] = rand() % 20;
 
diff --git a/tables.c b/tables.c
index 2bccd83..b162aa0 100644
--- a/tables.c
+++ b/tables.c
@@ -505,7 +505,7 @@ int setup_syscall_group(unsigned int group)
 			goto try_64bit;
 		}
 
-		newsyscalls32 = malloc(count * sizeof(struct syscalltable));
+		newsyscalls32 = bdw_malloc(count * sizeof(struct syscalltable));
 		if (newsyscalls32 == NULL)
 			return FALSE;
 
@@ -533,7 +533,7 @@ try_64bit:
 			return FALSE;
 		}
 
-		newsyscalls64 = malloc(count * sizeof(struct syscalltable));
+		newsyscalls64 = bdw_malloc(count * sizeof(struct syscalltable));
 		if (newsyscalls64 == NULL)
 			return FALSE;
 
@@ -559,7 +559,7 @@ try_64bit:
 			return FALSE;
 		}
 
-		newsyscalls = malloc(count * sizeof(struct syscalltable));
+		newsyscalls = bdw_malloc(count * sizeof(struct syscalltable));
 		if (newsyscalls == NULL)
 			exit(EXIT_FAILURE);
 
diff --git a/trinity.c b/trinity.c
index b95d287..0ec9c2b 100644
--- a/trinity.c
+++ b/trinity.c
@@ -154,6 +154,8 @@ int main(int argc, char* argv[])
 	int childstatus;
 	unsigned int i;
 
+	bdw_init();
+
 	printf("Trinity v" __stringify(VERSION) "  Dave Jones <davej@redhat.com>\n");
 
 	progname = argv[0];
diff --git a/unicode.c b/unicode.c
index f94c82c..ef20997 100644
--- a/unicode.c
+++ b/unicode.c
@@ -126,7 +126,7 @@ void main(int argc, char* argv[])
 	gettimeofday(&t, 0);
 	srand((t.tv_sec * getpid()) ^ t.tv_usec);
 
-	page = malloc(4096);
+	page = bdw_malloc(4096);
 	memset(page, 0, 4096);
 
 	gen_unicode_page(page);
-- 
1.7.11.7
