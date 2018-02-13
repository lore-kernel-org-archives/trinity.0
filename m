From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 2/4] trinity: Add support for s390_pci_mmio_read and write
Date: Tue, 13 Feb 2018 08:55:50 +0100
Message-ID: <20180213075552.13932-2-tmricht@linux.vnet.ibm.com>
References: <20180213075552.13932-1-tmricht@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20180213075552.13932-1-tmricht@linux.vnet.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org, davej@codemonkey.org.uk
Cc: brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Thomas Richter <tmricht@linux.vnet.ibm.com>

Add support for s390 specific system calls
s390_pci_mmio_read and 390_pci_mmio_write
for 31 bit and 64 bit.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h        |  4 +--
 include/syscalls-s390x.h       |  4 +--
 syscalls/s390x/s390_pci_mmio.c | 70 ++++++++++++++++++++++++++++++++++++++++++
 syscalls/syscalls.h            |  2 ++
 4 files changed, 76 insertions(+), 4 deletions(-)
 create mode 100644 syscalls/s390x/s390_pci_mmio.c

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index c02ced94..a5a30c9e 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -363,8 +363,8 @@ struct syscalltable syscalls_s390[] = {
 #else
 	{ .entry = NULL },
 #endif
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_pci_mmio_write svc */
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_pci_mmio_read svc */
+	{ .entry = &syscall_s390_pci_mmio_write },
+	{ .entry = &syscall_s390_pci_mmio_read },
 	{ .entry = &syscall_execveat },
 	{ .entry = &syscall_userfaultfd },
 	{ .entry = &syscall_membarrier },
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index b955ceaa..e74caa14 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -363,8 +363,8 @@ struct syscalltable syscalls_s390x[] = {
 #else
 	{ .entry = NULL },
 #endif
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_pci_mmio_write svc */
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_pci_mmio_read svc */
+	{ .entry = &syscall_s390_pci_mmio_write },
+	{ .entry = &syscall_s390_pci_mmio_read },
 	{ .entry = &syscall_execveat },
 	{ .entry = &syscall_userfaultfd },
 	{ .entry = &syscall_membarrier },
diff --git a/syscalls/s390x/s390_pci_mmio.c b/syscalls/s390x/s390_pci_mmio.c
new file mode 100644
index 00000000..62566ce4
--- /dev/null
+++ b/syscalls/s390x/s390_pci_mmio.c
@@ -0,0 +1,70 @@
+/*
+ * int s390_pci_mmio_read(unsigned long mmio_addr,
+ *			  void *user_buffer, size_t length);
+ * int s390_pci_mmio_write(unsigned long mmio_addr,
+ *			   void *user_buffer, size_t length);
+ */
+
+#include "arch.h"
+#include "random.h"
+#include "sanitise.h"
+
+/*
+ * Allocate buffer which fits the svc requirements:
+ * - length must be lower or equal to page size.
+ * - transfer must no cross page boundary.
+ */
+static void sanitise_s390_pci_mmio(struct syscallrecord *rec)
+{
+	size_t offset = rec->a1 % page_size;
+
+	if (offset + rec->a3 > page_size)
+		rec->a3 = page_size - offset;
+	rec->a2 = (unsigned long)malloc(rec->a3);
+}
+
+/* Allocate buffer and generate random data. */
+static void sanitise_s390_pci_mmio_write(struct syscallrecord *rec)
+{
+	sanitise_s390_pci_mmio(rec);
+	if (rec->a2)		/* Buffer allocated */
+		generate_rand_bytes((void *)rec->a2, rec->a3);
+}
+
+/* Free buffer, freeptr takes care of NULL */
+static void post_s390_pci_mmio(struct syscallrecord *rec)
+{
+	freeptr(&rec->a2);
+}
+
+struct syscallentry syscall_s390_pci_mmio_read = {
+	.name = "s390_pci_mmio_read",
+	.sanitise = sanitise_s390_pci_mmio,
+	.post = post_s390_pci_mmio,
+	.num_args = 3,
+	.arg1name = "mmio_addr",
+	.arg1type = ARG_UNDEFINED,
+	.arg2name = "user_buffer",
+	.arg2type = ARG_NON_NULL_ADDRESS,
+	.arg3name = "length",
+	.arg3type = ARG_RANGE,
+	.low3range = 0,
+	.hi3range = 1 << PAGE_SHIFT,
+	.rettype = RET_ZERO_SUCCESS
+};
+
+struct syscallentry syscall_s390_pci_mmio_write = {
+	.name = "s390_pci_mmio_write",
+	.sanitise = sanitise_s390_pci_mmio_write,
+	.post = post_s390_pci_mmio,
+	.num_args = 3,
+	.arg1name = "mmio_addr",
+	.arg1type = ARG_UNDEFINED,
+	.arg2name = "user_buffer",
+	.arg2type = ARG_NON_NULL_ADDRESS,
+	.arg3name = "length",
+	.arg3type = ARG_RANGE,
+	.low3range = 0,
+	.hi3range = 1 << PAGE_SHIFT,
+	.rettype = RET_ZERO_SUCCESS
+};
diff --git a/syscalls/syscalls.h b/syscalls/syscalls.h
index 2260bbf8..6564e22e 100644
--- a/syscalls/syscalls.h
+++ b/syscalls/syscalls.h
@@ -387,5 +387,7 @@ extern struct syscallentry syscall_pkey_alloc;
 extern struct syscallentry syscall_pkey_free;
 extern struct syscallentry syscall_statx;
 extern struct syscallentry syscall_runtime_instr;
+extern struct syscallentry syscall_s390_pci_mmio_write;
+extern struct syscallentry syscall_s390_pci_mmio_read;
 
 unsigned int random_fcntl_setfl_flags(void);
-- 
2.14.3
