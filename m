From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 3/4] trinity: Add support for s390_guarded_storage svc
Date: Tue, 13 Feb 2018 08:55:51 +0100
Message-ID: <20180213075552.13932-3-tmricht@linux.vnet.ibm.com>
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

Add support for s390 specific system call s390_guarded_storage
for 31 bit and 64 bit.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h               |  2 +-
 include/syscalls-s390x.h              |  2 +-
 syscalls/s390x/s390_guarded_storage.c | 48 +++++++++++++++++++++++++++++++++++
 syscalls/syscalls.h                   |  1 +
 4 files changed, 51 insertions(+), 2 deletions(-)
 create mode 100644 syscalls/s390x/s390_guarded_storage.c

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index a5a30c9e..ad2f88c6 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -389,7 +389,7 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_copy_file_range },
 	{ .entry = &syscall_preadv2 },
 	{ .entry = &syscall_pwritev2 },
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_guarded_storage svc */
+	{ .entry = &syscall_s390_guarded_storage },
 	{ .entry = &syscall_statx },
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_sthyi svc */
 };
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index e74caa14..a83974e4 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -389,7 +389,7 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_copy_file_range },
 	{ .entry = &syscall_preadv2 },
 	{ .entry = &syscall_pwritev2 },
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_guarded_storage svc */
+	{ .entry = &syscall_s390_guarded_storage },
 	{ .entry = &syscall_statx },
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_sthyi svc */
 };
diff --git a/syscalls/s390x/s390_guarded_storage.c b/syscalls/s390x/s390_guarded_storage.c
new file mode 100644
index 00000000..290fe626
--- /dev/null
+++ b/syscalls/s390x/s390_guarded_storage.c
@@ -0,0 +1,48 @@
+/*
+ * int s390_guarded_storage(int command, struct gs_cb *gs_cb)
+ */
+
+#include <asm/guarded_storage.h>
+
+#include "random.h"
+#include "sanitise.h"
+
+static unsigned long syscall_s390_guarded_storage_arg1[] = {
+	GS_ENABLE,
+	GS_DISABLE,
+	GS_SET_BC_CB,
+	GS_CLEAR_BC_CB,
+	GS_BROADCAST,
+	GS_BROADCAST + 1,
+	-1
+};
+
+/* Allocate buffer and generate random data. */
+static void sanitise_s390_gs(struct syscallrecord *rec)
+{
+	size_t size = sizeof(struct gs_cb);
+	void *addr = malloc(size);
+
+	if (addr) {
+		generate_rand_bytes(addr, size);
+		rec->a2 = (unsigned long)addr;
+	}
+}
+
+/* Free buffer, freeptr takes care of NULL */
+static void post_s390_gs(struct syscallrecord *rec)
+{
+	freeptr(&rec->a2);
+}
+
+struct syscallentry syscall_s390_guarded_storage = {
+	.name = "s390_guarded_storage",
+	.sanitise = sanitise_s390_gs,
+	.post = post_s390_gs,
+	.num_args = 2,
+	.arg1name = "command",
+	.arg1type = ARG_LIST,
+	.arg1list = ARGLIST(syscall_s390_guarded_storage_arg1),
+	.arg2name = "gs_cb",
+	.arg2type = ARG_NON_NULL_ADDRESS
+};
diff --git a/syscalls/syscalls.h b/syscalls/syscalls.h
index 6564e22e..38271170 100644
--- a/syscalls/syscalls.h
+++ b/syscalls/syscalls.h
@@ -389,5 +389,6 @@ extern struct syscallentry syscall_statx;
 extern struct syscallentry syscall_runtime_instr;
 extern struct syscallentry syscall_s390_pci_mmio_write;
 extern struct syscallentry syscall_s390_pci_mmio_read;
+extern struct syscallentry syscall_s390_guarded_storage;
 
 unsigned int random_fcntl_setfl_flags(void);
-- 
2.14.3
