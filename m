From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [PATCH] fix build when USE_BPF is not defined
Date: Tue, 8 Nov 2016 11:46:01 +0100
Message-ID: <3ae384b5-2690-0711-3fdb-b674c8e69056@redhat.com>
References: <dc2c60882d0fe97a0c956dd856d74aa3347a3e5f.1478519712.git.jstancek@redhat.com>
 <20161107143434.k54git2ujrkzrwly@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------2E8E4EE3A386694158A39C9A"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20161107143434.k54git2ujrkzrwly@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

This is a multi-part message in MIME format.
--------------2E8E4EE3A386694158A39C9A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 11/07/2016 03:34 PM, Dave Jones wrote:
> I think it might be better if we wrap all of net/bpf.c in this ifdef,
> and then add additional ones wherever we call bpf_gen_filter.
> (Right now only two places iirc)

Attached is v2, that follows your suggestion.

Regards,
Jan


--------------2E8E4EE3A386694158A39C9A
Content-Type: text/x-patch;
 name="0001-fix-build-when-USE_BPF-is-not-defined.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-fix-build-when-USE_BPF-is-not-defined.patch"

From 3b98782aa7c345a6d873dbc69764340777ef8e6c Mon Sep 17 00:00:00 2001
Message-Id: <3b98782aa7c345a6d873dbc69764340777ef8e6c.1478601616.git.jstancek@redhat.com>
From: Jan Stancek <jstancek@redhat.com>
Date: Mon, 7 Nov 2016 12:50:27 +0100
Subject: [PATCH v2] fix build when USE_BPF is not defined

net/bpf.o: In function `bpf_gen_filter': bpf.c:852: undefined reference to `get_rand_bpf_fd'

Signed-off-by: Jan Stancek <jstancek@redhat.com>
---
 net/bpf.c             | 3 +++
 syscalls/bpf.c        | 2 ++
 syscalls/prctl.c      | 4 +++-
 syscalls/setsockopt.c | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/bpf.c b/net/bpf.c
index 4fe941733016..d6ca14bde6d3 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -8,6 +8,7 @@
 #include <string.h>
 
 #include "bpf.h"
+#include "config.h"
 #include "debug.h"
 #include "log.h"
 #include "net.h"
@@ -17,6 +18,7 @@
 #include "utils.h"
 #include "compat.h"
 
+#ifdef USE_BPF
 /**
  * BPF filters are used in networking such as in pf_packet, but also
  * in seccomp for application sand-boxing. Additionally, with arch
@@ -885,3 +887,4 @@ void bpf_gen_filter(unsigned long **addr, unsigned long *addrlen)
 	if (dump_bpf)
 		bpf_disasm_all(bpf->filter, bpf->len);
 }
+#endif
diff --git a/syscalls/bpf.c b/syscalls/bpf.c
index 476a2778d8a0..372ab6dc5376 100644
--- a/syscalls/bpf.c
+++ b/syscalls/bpf.c
@@ -29,9 +29,11 @@ static void bpf_prog_load(struct syscallrecord *rec)
 	attr->prog_type = RAND_ARRAY(bpf_prog_types);
 
 	switch (attr->prog_type) {
+#ifdef USE_BPF
 	case BPF_PROG_TYPE_SOCKET_FILTER:
 		bpf_gen_filter(&insns, &len);
 		break;
+#endif
 	default:
 		// this will go away when all the other cases are enumerated
 		insns = zmalloc(page_size);
diff --git a/syscalls/prctl.c b/syscalls/prctl.c
index 02d2dbc6d8ab..cdbcdc217075 100644
--- a/syscalls/prctl.c
+++ b/syscalls/prctl.c
@@ -45,9 +45,11 @@ static int prctl_opts[] = {
 #ifdef USE_SECCOMP
 static void do_set_seccomp(struct syscallrecord *rec)
 {
-	unsigned long *optval = NULL, optlen = 0;
+	unsigned long *optval = NULL, __unused__ optlen = 0;
 
+#ifdef USE_BPF
 	bpf_gen_seccomp(&optval, &optlen);
+#endif
 
 	rec->a2 = SECCOMP_MODE_FILTER;
 	rec->a3 = (unsigned long) optval;
diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index 8189b7a8ce9b..d395e54e23b9 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -48,7 +48,9 @@ static void socket_setsockopt(struct sockopt *so, __unused__ struct socket_tripl
 	case SO_ATTACH_FILTER: {
 		unsigned long *optval = NULL, optlen = 0;
 
+#ifdef USE_BPF
 		bpf_gen_filter(&optval, &optlen);
+#endif
 
 		so->optval = (unsigned long) optval;
 		so->optlen = optlen;
-- 
1.8.3.1


--------------2E8E4EE3A386694158A39C9A--
