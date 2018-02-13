From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 1/4] trinity: Add support for runtime_instr svc
Date: Tue, 13 Feb 2018 08:55:49 +0100
Message-ID: <20180213075552.13932-1-tmricht@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org, davej@codemonkey.org.uk
Cc: brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Thomas Richter <tmricht@linux.vnet.ibm.com>

This patch adds support for the s390 specific system
call runtime_instr() for 31 and 64 bit.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 Makefile                       |  1 +
 include/syscalls-s390.h        |  2 +-
 include/syscalls-s390x.h       |  2 +-
 syscalls/s390x/runtime_instr.c | 25 +++++++++++++++++++++++++
 syscalls/syscalls.h            |  1 +
 5 files changed, 29 insertions(+), 2 deletions(-)
 create mode 100644 syscalls/s390x/runtime_instr.c

diff --git a/Makefile b/Makefile
index 78619064..93e3460d 100644
--- a/Makefile
+++ b/Makefile
@@ -87,6 +87,7 @@ SYSCALLS_ARCH	:= $(shell case "$(MACHINE)" in \
 				  syscalls/x86/x86_64/*.c;; \
 		   (i?86*) echo syscalls/x86/*.c \
 				syscalls/x86/i386/*.c;; \
+		   (s390x*) echo syscalls/s390x/*.c ;; \
 		   esac)
 
 VERSION_H	:= include/version.h
diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index 682d2030..c02ced94 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -349,7 +349,7 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_setns },
 	{ .entry = &syscall_process_vm_readv },
 	{ .entry = &syscall_process_vm_writev },
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_runtime_instr */
+	{ .entry = &syscall_runtime_instr },	/* s390_runtime_instr svc */
 	{ .entry = &syscall_kcmp },
 	{ .entry = &syscall_finit_module },
 	{ .entry = &syscall_sched_setattr },
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index a3e26181..b955ceaa 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -349,7 +349,7 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_setns },
 	{ .entry = &syscall_process_vm_readv },
 	{ .entry = &syscall_process_vm_writev },
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_runtime_instr */
+	{ .entry = &syscall_runtime_instr },	/* s390_runtime_instr svc */
 	{ .entry = &syscall_kcmp },
 	{ .entry = &syscall_finit_module },
 	{ .entry = &syscall_sched_setattr },
diff --git a/syscalls/s390x/runtime_instr.c b/syscalls/s390x/runtime_instr.c
new file mode 100644
index 00000000..aa1f75fb
--- /dev/null
+++ b/syscalls/s390x/runtime_instr.c
@@ -0,0 +1,25 @@
+/*
+ * int runtime_instr(int on_off, int sig_nr)
+ */
+
+#include "sanitise.h"
+
+#define S390_RUNTIME_INSTR_START	0x1
+#define S390_RUNTIME_INSTR_STOP		0x2
+
+static unsigned long syscall_runtime_instr_arg1[] = {
+	0, S390_RUNTIME_INSTR_START, S390_RUNTIME_INSTR_STOP, 3
+};
+
+struct syscallentry syscall_runtime_instr = {
+	.name = "runtime_instr",
+	.num_args = 2,
+	.arg1name = "on_off",
+	.arg1type = ARG_LIST,
+	.arg1list = ARGLIST(syscall_runtime_instr_arg1),
+	.arg2name = "sig_nr",
+	.arg2type = ARG_RANGE,
+	.low2range = 0,
+	.hi2range = 128,
+	.rettype = RET_ZERO_SUCCESS
+};
diff --git a/syscalls/syscalls.h b/syscalls/syscalls.h
index 38819b37..2260bbf8 100644
--- a/syscalls/syscalls.h
+++ b/syscalls/syscalls.h
@@ -386,5 +386,6 @@ extern struct syscallentry syscall_pkey_mprotect;
 extern struct syscallentry syscall_pkey_alloc;
 extern struct syscallentry syscall_pkey_free;
 extern struct syscallentry syscall_statx;
+extern struct syscallentry syscall_runtime_instr;
 
 unsigned int random_fcntl_setfl_flags(void);
-- 
2.14.3
