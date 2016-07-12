From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Fix build on older kernels without BPF.
Date: Tue, 12 Jul 2016 18:43:06 +0000
Message-ID: <1468348986-13200-1-git-send-email-vlee@freedesktop.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 configure      |    1 +
 syscalls/bpf.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/configure b/configure
index 8d95929..ca37e4e 100755
--- a/configure
+++ b/configure
@@ -239,6 +239,7 @@ check_header execinfo.h USE_BACKTRACE
 check_header netatalk/at.h USE_APPLETALK
 check_header netrom/netrom.h USE_NETROM
 check_header netrose/rose.h USE_ROSE
+check_header linux/bpf.h USE_BPF
 
 rm -f "$TMP" "$TMP.log" "$TMP.c"
 
diff --git a/syscalls/bpf.c b/syscalls/bpf.c
index b2f57d3..4788082 100644
--- a/syscalls/bpf.c
+++ b/syscalls/bpf.c
@@ -1,13 +1,16 @@
 /*
  * SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
  */
+#ifdef USE_BPF
 #include <linux/bpf.h>
+#endif
 #include <linux/filter.h>
 #include "arch.h"
 #include "net.h"
 #include "random.h"
 #include "sanitise.h"
 
+#ifdef USE_BPF
 static unsigned long bpf_prog_types[] = {
 	BPF_PROG_TYPE_UNSPEC,
 	BPF_PROG_TYPE_SOCKET_FILTER,
@@ -15,9 +18,11 @@ static unsigned long bpf_prog_types[] = {
 	BPF_PROG_TYPE_SCHED_CLS,
 	BPF_PROG_TYPE_SCHED_ACT,
 };
+#endif
 
 static const char license[] = "GPLv2";
 
+#ifdef USE_BPF
 static void bpf_prog_load(struct syscallrecord *rec)
 {
 	unsigned long *insns = NULL, len = 0;
@@ -49,18 +54,22 @@ static void bpf_prog_load(struct syscallrecord *rec)
 	rec->a2 = (unsigned long) attr;
 	rec->a3 = sizeof(attr);
 }
+#endif
 
 static void sanitise_bpf(struct syscallrecord *rec)
 {
 	switch (rec->a1) {
+#ifdef USE_BPF
 	case BPF_PROG_LOAD:
 		bpf_prog_load(rec);
 		break;
+#endif
 	default:
 		break;
 	}
 }
 
+#ifdef USE_BPF
 static void post_bpf(struct syscallrecord *rec)
 {
 	union bpf_attr *attr;
@@ -84,10 +93,15 @@ static void post_bpf(struct syscallrecord *rec)
 		break;
 	}
 }
+#else
+static void post_bpf(__unused__ struct syscallrecord *rec) { }
+#endif
 
 static unsigned long bpf_flags[] = {
+#ifdef USE_BPF
 	BPF_MAP_CREATE, BPF_MAP_LOOKUP_ELEM, BPF_MAP_UPDATE_ELEM, BPF_MAP_DELETE_ELEM,
 	BPF_MAP_GET_NEXT_KEY, BPF_PROG_LOAD,
+#endif
 };
 
 struct syscallentry syscall_bpf = {
-- 
1.7.1
