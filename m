From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH v2] Fix build on older kernels without BPF.
Date: Tue, 12 Jul 2016 21:33:56 +0000
Message-ID: <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
References: <20160712190217.GA5525@codemonkey.org.uk>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20160712190217.GA5525@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Suggested-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 configure                  |    1 +
 include/syscalls-aarch64.h |    2 ++
 include/syscalls-arm.h     |    2 ++
 include/syscalls-i386.h    |    2 ++
 include/syscalls-ia64.h    |    2 ++
 include/syscalls-mips.h    |    2 ++
 include/syscalls-parisc.h  |    2 ++
 include/syscalls-s390.h    |    2 ++
 include/syscalls-s390x.h   |    2 ++
 include/syscalls-sparc.h   |    2 ++
 include/syscalls-x86_64.h  |    2 ++
 syscalls/bpf.c             |    2 ++
 12 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/configure b/configure
index 8d95929..fe3985f 100755
--- a/configure
+++ b/configure
@@ -239,6 +239,7 @@ check_header execinfo.h USE_BACKTRACE
 check_header netatalk/at.h USE_APPLETALK
 check_header netrom/netrom.h USE_NETROM
 check_header netrose/rose.h USE_ROSE
+check_header linux/bfp.h USE_BPF
 
 rm -f "$TMP" "$TMP.log" "$TMP.c"
 
diff --git a/include/syscalls-aarch64.h b/include/syscalls-aarch64.h
index 09acf41..ee18c64 100644
--- a/include/syscalls-aarch64.h
+++ b/include/syscalls-aarch64.h
@@ -290,6 +290,8 @@ struct syscalltable syscalls_aarch64[] = {
 /* 277 */	{ .entry = &syscall_seccomp },
 /* 278 */	{ .entry = &syscall_getrandom },
 /* 279 */	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 /* 280 */	{ .entry = &syscall_bpf },
+#endif
 /* 281 */	{ .entry = &syscall_execveat },
 };
diff --git a/include/syscalls-arm.h b/include/syscalls-arm.h
index 7ecc435..2c59316 100644
--- a/include/syscalls-arm.h
+++ b/include/syscalls-arm.h
@@ -396,7 +396,9 @@ struct syscalltable syscalls_arm[] = {
 		{ .entry = &syscall_seccomp },
 		{ .entry = &syscall_getrandom },
 /* 385 */	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 		{ .entry = &syscall_bpf },
+#endif
 		{ .entry = &syscall_execveat },
 		{ .entry = &syscall_userfaultfd },
 		{ .entry = &syscall_membarrier },
diff --git a/include/syscalls-i386.h b/include/syscalls-i386.h
index 147b1eb..078efa3 100644
--- a/include/syscalls-i386.h
+++ b/include/syscalls-i386.h
@@ -364,7 +364,9 @@ struct syscalltable syscalls_i386[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_execveat },
 	{ .entry = &syscall_socket },
 	{ .entry = &syscall_socketpair },
diff --git a/include/syscalls-ia64.h b/include/syscalls-ia64.h
index 28eacce..172c64f 100644
--- a/include/syscalls-ia64.h
+++ b/include/syscalls-ia64.h
@@ -324,7 +324,9 @@ struct syscalltable syscalls_ia64[] = {
 	{ .entry = &syscall_renameat2 },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_userfaultfd },
 	{ .entry = &syscall_membarrier },
 	{ .entry = &syscall_kcmp },
diff --git a/include/syscalls-mips.h b/include/syscalls-mips.h
index 273ba25..1f1748b 100644
--- a/include/syscalls-mips.h
+++ b/include/syscalls-mips.h
@@ -371,5 +371,7 @@ struct syscalltable syscalls_mips[] = {
 		{ .entry = &syscall_seccomp },
 		{ .entry = &syscall_getrandom },
 		{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 		{ .entry = &syscall_bpf },		/* 4355 */
+#endif
 };
diff --git a/include/syscalls-parisc.h b/include/syscalls-parisc.h
index 8d164e5..1b830f8 100644
--- a/include/syscalls-parisc.h
+++ b/include/syscalls-parisc.h
@@ -348,6 +348,8 @@ struct syscalltable syscalls_parisc[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_execveat },
 };
diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index dd9c93a..24d981e 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -358,7 +358,9 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_write
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_read
 	{ .entry = &syscall_execveat },
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index 6ddeb85..75c10f8 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -358,7 +358,9 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_write
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_read
 	{ .entry = &syscall_execveat },
diff --git a/include/syscalls-sparc.h b/include/syscalls-sparc.h
index 5cedd89..77cfe2a 100644
--- a/include/syscalls-sparc.h
+++ b/include/syscalls-sparc.h
@@ -356,6 +356,8 @@ struct syscalltable syscalls_sparc[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_execveat },
 };
diff --git a/include/syscalls-x86_64.h b/include/syscalls-x86_64.h
index c75f4de..07a67ca 100644
--- a/include/syscalls-x86_64.h
+++ b/include/syscalls-x86_64.h
@@ -328,7 +328,9 @@ struct syscalltable syscalls_x86_64[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_memfd_create },
 	{ .entry = &syscall_kexec_file_load },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#endif
 	{ .entry = &syscall_execveat },
 	{ .entry = &syscall_userfaultfd },
 	{ .entry = &syscall_membarrier },
diff --git a/syscalls/bpf.c b/syscalls/bpf.c
index b2f57d3..476a277 100644
--- a/syscalls/bpf.c
+++ b/syscalls/bpf.c
@@ -1,6 +1,7 @@
 /*
  * SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
  */
+#ifdef USE_BPF
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include "arch.h"
@@ -102,3 +103,4 @@ struct syscallentry syscall_bpf = {
 	.sanitise = sanitise_bpf,
 	.post = post_bpf,
 };
+#endif
-- 
1.7.1
