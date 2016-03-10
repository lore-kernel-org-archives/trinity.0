From: Adrien Schildknecht <adrien+dev@schischi.me>
Subject: [PATCH] move x86 specific syscalls to x86 dir
Date: Thu, 10 Mar 2016 14:56:23 -0800
Message-ID: <1457650583-5460-1-git-send-email-adrien+dev@schischi.me>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schischi-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=CDk32sM5qIcmHAodMiAXg2KIeZnLSfNFY8KZZTYH5k8=;
        b=armOptnnQ48/3+Z2OBo7SKIbQz6ByjVunGHSoWSd9zP/QD67st7ac4gzA/WASncKW1
         WHwyI+Oe/2F9Ojj6kM9DrkiPfvUR9Qe/mMFPpyQjxEZ79I6fJW2wt8dwk/1f2tcDnwPt
         pztIXayvhCVrc7JAsi6xxE6oiZ1s03bCveTWuz2lPCVnSBdzYkdKFff7ci2c+MgTef0C
         Eestt24GC3p6grbyDGCnhNuNVvNCrvvLbGWnTRvmD5ne9ht1TB/Uo4Ky4C7x1Rc2DSQo
         86+w84PYQ2GnrFToEdfCa3RjPfykH9U4kmCASqPgf+jg+2JOKNQmYvWfFYjRQpYxnsfc
         AEvQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>

Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
---
 Makefile                         |  5 +++
 syscalls/arch_prctl.c            | 29 ---------------
 syscalls/ioperm.c                | 12 -------
 syscalls/iopl.c                  | 12 -------
 syscalls/modify_ldt.c            | 77 ----------------------------------------
 syscalls/vm86.c                  | 13 -------
 syscalls/vm86old.c               | 13 -------
 syscalls/x86/i386/vm86.c         | 13 +++++++
 syscalls/x86/i386/vm86old.c      | 13 +++++++
 syscalls/x86/ioperm.c            | 12 +++++++
 syscalls/x86/iopl.c              | 12 +++++++
 syscalls/x86/modify_ldt.c        | 77 ++++++++++++++++++++++++++++++++++++++++
 syscalls/x86/x86_64/arch_prctl.c | 29 +++++++++++++++
 13 files changed, 161 insertions(+), 156 deletions(-)
 delete mode 100644 syscalls/arch_prctl.c
 delete mode 100644 syscalls/ioperm.c
 delete mode 100644 syscalls/iopl.c
 delete mode 100644 syscalls/modify_ldt.c
 delete mode 100644 syscalls/vm86.c
 delete mode 100644 syscalls/vm86old.c
 create mode 100644 syscalls/x86/i386/vm86.c
 create mode 100644 syscalls/x86/i386/vm86old.c
 create mode 100644 syscalls/x86/ioperm.c
 create mode 100644 syscalls/x86/iopl.c
 create mode 100644 syscalls/x86/modify_ldt.c
 create mode 100644 syscalls/x86/x86_64/arch_prctl.c

diff --git a/Makefile b/Makefile
index 9fbdb94..da93e75 100644
--- a/Makefile
+++ b/Makefile
@@ -72,6 +72,11 @@ SYSCALLS_ARCH	= $(shell case "$(MACHINE)" in \
 		  (ia64*) echo syscalls/ia64/*.c ;; \
 		  (ppc*|powerpc*) echo syscalls/ppc/*.c ;; \
 		  (sparc*) echo syscalls/sparc/*.c ;; \
+		  (x86_64*) echo syscalls/x86/*.c \
+				 syscalls/x86/i386/*.c \
+				 syscalls/x86/x86_64/*.c;; \
+		  (i?86*) echo syscalls/x86/*.c \
+			       syscalls/x86/i386/*.c;; \
 		  esac)
 
 HEADERS		= $(patsubst %.h,%.h,$(wildcard *.h)) $(patsubst %.h,%.h,$(wildcard syscalls/*.h)) $(patsubst %.h,%.h,$(wildcard ioctls/*.h))
diff --git a/syscalls/arch_prctl.c b/syscalls/arch_prctl.c
deleted file mode 100644
index 0433fe8..0000000
--- a/syscalls/arch_prctl.c
+++ /dev/null
@@ -1,29 +0,0 @@
-/* (x86-64 only)
- *  long sys_arch_prctl(int code, unsigned long addr)
- *
- * On success, arch_prctl() returns 0
- * On error, -1 is returned, and errno is set to indicate the error.
- */
-
-#if defined(__i386__) || defined (__x86_64__)
-
-#include "sanitise.h"
-#include <asm/prctl.h>
-#include <sys/prctl.h>
-
-static unsigned long arch_prctl_flags[] = {
-	ARCH_SET_FS, ARCH_GET_FS, ARCH_SET_GS, ARCH_GET_GS
-};
-
-struct syscallentry syscall_arch_prctl = {
-	.name = "arch_prctl",
-	.flags = AVOID_SYSCALL,
-	.num_args = 2,
-	.arg1name = "code",
-	.arg1type = ARG_OP,
-	.arg1list = ARGLIST(arch_prctl_flags),
-	.arg2name = "addr",
-	.arg2type = ARG_ADDRESS,
-	.rettype = RET_BORING,
-};
-#endif
diff --git a/syscalls/ioperm.c b/syscalls/ioperm.c
deleted file mode 100644
index a4a842d..0000000
--- a/syscalls/ioperm.c
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
-   asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
- */
-#include "sanitise.h"
-
-struct syscallentry syscall_ioperm = {
-	.name = "ioperm",
-	.num_args = 3,
-	.arg1name = "from",
-	.arg2name = "num",
-	.arg3name = "turn_on",
-};
diff --git a/syscalls/iopl.c b/syscalls/iopl.c
deleted file mode 100644
index b1ecd9e..0000000
--- a/syscalls/iopl.c
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
-   long sys_iopl(unsigned int level, struct pt_regs *regs)
- */
-#include "sanitise.h"
-
-struct syscallentry syscall_iopl = {
-	.name = "iopl",
-	.num_args = 2,
-	.arg1name = "level",
-	.arg2name = "regs",
-	.arg2type = ARG_ADDRESS,
-};
diff --git a/syscalls/modify_ldt.c b/syscalls/modify_ldt.c
deleted file mode 100644
index 6d42591..0000000
--- a/syscalls/modify_ldt.c
+++ /dev/null
@@ -1,77 +0,0 @@
-#include "arch.h"
-
-#ifdef X86
-/*
- * asmlinkage int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
- */
-#include <stdlib.h>
-#include <sys/types.h>
-#define __ASSEMBLY__ 1
-#include <asm/ldt.h>
-#include "sanitise.h"
-#include "shm.h"
-#include "syscall.h"
-#include "trinity.h"
-#include "utils.h"
-
-#define ALLOCSIZE LDT_ENTRIES * LDT_ENTRY_SIZE
-
-static void sanitise_modify_ldt(struct syscallrecord *rec)
-{
-	//struct user_desc *desc;
-	void *ldt;
-
-	switch (rec->a1) {
-	case 0:
-		/* read the ldt into the memory pointed to by ptr.
-		   The number of bytes read is the smaller of bytecount and the actual size of the ldt. */
-		ldt = zmalloc(ALLOCSIZE);
-		rec->a2 = (unsigned long) ldt;
-		rec->a3 = ALLOCSIZE;
-		break;
-
-	case 1:
-		rec->a2 = 0L;
-		/* modify one ldt entry.
-		 * ptr points to a user_desc structure
-		 * bytecount must equal the size of this structure. */
-
-	/*
-               unsigned int  entry_number;
-               unsigned long base_addr;
-               unsigned int  limit;
-               unsigned int  seg_32bit:1;
-               unsigned int  contents:2;
-               unsigned int  read_exec_only:1;
-               unsigned int  limit_in_pages:1;
-               unsigned int  seg_not_present:1;
-               unsigned int  useable:1;
-	*/
-		break;
-	default:
-		rec->a2 = 0L;
-		break;
-	}
-}
-
-static void post_modify_ldt(__unused__ struct syscallrecord *rec)
-{
-	freeptr(&rec->a2);
-}
-
-static unsigned long modify_ldt_funcs[] = {
-	0, 1,
-};
-
-struct syscallentry syscall_modify_ldt = {
-	.name = "modify_ldt",
-	.num_args = 3,
-	.arg1name = "func",
-	.arg1type = ARG_OP,
-	.arg1list = ARGLIST(modify_ldt_funcs),
-	.arg2name = "ptr",
-	.arg3name = "bytecount",
-	.sanitise = sanitise_modify_ldt,
-	.post = post_modify_ldt,
-};
-#endif
diff --git a/syscalls/vm86.c b/syscalls/vm86.c
deleted file mode 100644
index d7b48c0..0000000
--- a/syscalls/vm86.c
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * int sys_vm86(unsigned long cmd, unsigned long arg, struct pt_regs *regs)
- */
-#include "sanitise.h"
-
-struct syscallentry syscall_vm86 = {
-	.name = "vm86",
-	.num_args = 3,
-	.arg1name = "cmd",
-	.arg2name = "arg",
-	.arg3name = "regs",
-	.arg3type = ARG_ADDRESS,
-};
diff --git a/syscalls/vm86old.c b/syscalls/vm86old.c
deleted file mode 100644
index f4ff998..0000000
--- a/syscalls/vm86old.c
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
- */
-#include "sanitise.h"
-
-struct syscallentry syscall_vm86old = {
-	.name = "vm86old",
-	.num_args = 2,
-	.arg1name = "v86",
-	.arg1type = ARG_ADDRESS,
-	.arg2name = "regs",
-	.arg2type = ARG_ADDRESS,
-};
diff --git a/syscalls/x86/i386/vm86.c b/syscalls/x86/i386/vm86.c
new file mode 100644
index 0000000..d7b48c0
--- /dev/null
+++ b/syscalls/x86/i386/vm86.c
@@ -0,0 +1,13 @@
+/*
+ * int sys_vm86(unsigned long cmd, unsigned long arg, struct pt_regs *regs)
+ */
+#include "sanitise.h"
+
+struct syscallentry syscall_vm86 = {
+	.name = "vm86",
+	.num_args = 3,
+	.arg1name = "cmd",
+	.arg2name = "arg",
+	.arg3name = "regs",
+	.arg3type = ARG_ADDRESS,
+};
diff --git a/syscalls/x86/i386/vm86old.c b/syscalls/x86/i386/vm86old.c
new file mode 100644
index 0000000..f4ff998
--- /dev/null
+++ b/syscalls/x86/i386/vm86old.c
@@ -0,0 +1,13 @@
+/*
+ * int sys_vm86old(struct vm86_struct __user *v86, struct pt_regs *regs)
+ */
+#include "sanitise.h"
+
+struct syscallentry syscall_vm86old = {
+	.name = "vm86old",
+	.num_args = 2,
+	.arg1name = "v86",
+	.arg1type = ARG_ADDRESS,
+	.arg2name = "regs",
+	.arg2type = ARG_ADDRESS,
+};
diff --git a/syscalls/x86/ioperm.c b/syscalls/x86/ioperm.c
new file mode 100644
index 0000000..a4a842d
--- /dev/null
+++ b/syscalls/x86/ioperm.c
@@ -0,0 +1,12 @@
+/*
+   asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
+ */
+#include "sanitise.h"
+
+struct syscallentry syscall_ioperm = {
+	.name = "ioperm",
+	.num_args = 3,
+	.arg1name = "from",
+	.arg2name = "num",
+	.arg3name = "turn_on",
+};
diff --git a/syscalls/x86/iopl.c b/syscalls/x86/iopl.c
new file mode 100644
index 0000000..b1ecd9e
--- /dev/null
+++ b/syscalls/x86/iopl.c
@@ -0,0 +1,12 @@
+/*
+   long sys_iopl(unsigned int level, struct pt_regs *regs)
+ */
+#include "sanitise.h"
+
+struct syscallentry syscall_iopl = {
+	.name = "iopl",
+	.num_args = 2,
+	.arg1name = "level",
+	.arg2name = "regs",
+	.arg2type = ARG_ADDRESS,
+};
diff --git a/syscalls/x86/modify_ldt.c b/syscalls/x86/modify_ldt.c
new file mode 100644
index 0000000..6d42591
--- /dev/null
+++ b/syscalls/x86/modify_ldt.c
@@ -0,0 +1,77 @@
+#include "arch.h"
+
+#ifdef X86
+/*
+ * asmlinkage int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
+ */
+#include <stdlib.h>
+#include <sys/types.h>
+#define __ASSEMBLY__ 1
+#include <asm/ldt.h>
+#include "sanitise.h"
+#include "shm.h"
+#include "syscall.h"
+#include "trinity.h"
+#include "utils.h"
+
+#define ALLOCSIZE LDT_ENTRIES * LDT_ENTRY_SIZE
+
+static void sanitise_modify_ldt(struct syscallrecord *rec)
+{
+	//struct user_desc *desc;
+	void *ldt;
+
+	switch (rec->a1) {
+	case 0:
+		/* read the ldt into the memory pointed to by ptr.
+		   The number of bytes read is the smaller of bytecount and the actual size of the ldt. */
+		ldt = zmalloc(ALLOCSIZE);
+		rec->a2 = (unsigned long) ldt;
+		rec->a3 = ALLOCSIZE;
+		break;
+
+	case 1:
+		rec->a2 = 0L;
+		/* modify one ldt entry.
+		 * ptr points to a user_desc structure
+		 * bytecount must equal the size of this structure. */
+
+	/*
+               unsigned int  entry_number;
+               unsigned long base_addr;
+               unsigned int  limit;
+               unsigned int  seg_32bit:1;
+               unsigned int  contents:2;
+               unsigned int  read_exec_only:1;
+               unsigned int  limit_in_pages:1;
+               unsigned int  seg_not_present:1;
+               unsigned int  useable:1;
+	*/
+		break;
+	default:
+		rec->a2 = 0L;
+		break;
+	}
+}
+
+static void post_modify_ldt(__unused__ struct syscallrecord *rec)
+{
+	freeptr(&rec->a2);
+}
+
+static unsigned long modify_ldt_funcs[] = {
+	0, 1,
+};
+
+struct syscallentry syscall_modify_ldt = {
+	.name = "modify_ldt",
+	.num_args = 3,
+	.arg1name = "func",
+	.arg1type = ARG_OP,
+	.arg1list = ARGLIST(modify_ldt_funcs),
+	.arg2name = "ptr",
+	.arg3name = "bytecount",
+	.sanitise = sanitise_modify_ldt,
+	.post = post_modify_ldt,
+};
+#endif
diff --git a/syscalls/x86/x86_64/arch_prctl.c b/syscalls/x86/x86_64/arch_prctl.c
new file mode 100644
index 0000000..0433fe8
--- /dev/null
+++ b/syscalls/x86/x86_64/arch_prctl.c
@@ -0,0 +1,29 @@
+/* (x86-64 only)
+ *  long sys_arch_prctl(int code, unsigned long addr)
+ *
+ * On success, arch_prctl() returns 0
+ * On error, -1 is returned, and errno is set to indicate the error.
+ */
+
+#if defined(__i386__) || defined (__x86_64__)
+
+#include "sanitise.h"
+#include <asm/prctl.h>
+#include <sys/prctl.h>
+
+static unsigned long arch_prctl_flags[] = {
+	ARCH_SET_FS, ARCH_GET_FS, ARCH_SET_GS, ARCH_GET_GS
+};
+
+struct syscallentry syscall_arch_prctl = {
+	.name = "arch_prctl",
+	.flags = AVOID_SYSCALL,
+	.num_args = 2,
+	.arg1name = "code",
+	.arg1type = ARG_OP,
+	.arg1list = ARGLIST(arch_prctl_flags),
+	.arg2name = "addr",
+	.arg2type = ARG_ADDRESS,
+	.rettype = RET_BORING,
+};
+#endif
-- 
2.7.2
