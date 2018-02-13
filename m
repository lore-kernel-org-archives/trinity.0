From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 4/4] trinity: Add support for s390_sthyi svc
Date: Tue, 13 Feb 2018 08:55:52 +0100
Message-ID: <20180213075552.13932-4-tmricht@linux.vnet.ibm.com>
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

Add support for s390 specific system call s390_sthyi
for 31 bit and 64 bit.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h     |  2 +-
 include/syscalls-s390x.h    |  2 +-
 syscalls/s390x/s390_sthyi.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
 syscalls/syscalls.h         |  1 +
 4 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 syscalls/s390x/s390_sthyi.c

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index ad2f88c6..07706650 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -391,5 +391,5 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_pwritev2 },
 	{ .entry = &syscall_s390_guarded_storage },
 	{ .entry = &syscall_statx },
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_sthyi svc */
+	{ .entry = &syscall_s390_sthyi },
 };
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index a83974e4..66f3bc56 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -391,5 +391,5 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_pwritev2 },
 	{ .entry = &syscall_s390_guarded_storage },
 	{ .entry = &syscall_statx },
-	{ .entry = &syscall_ni_syscall },	/* TODO: s390_sthyi svc */
+	{ .entry = &syscall_s390_sthyi },
 };
diff --git a/syscalls/s390x/s390_sthyi.c b/syscalls/s390x/s390_sthyi.c
new file mode 100644
index 00000000..9bf488a9
--- /dev/null
+++ b/syscalls/s390x/s390_sthyi.c
@@ -0,0 +1,60 @@
+/*
+ * int s390_sthyi(unsigned long function_code, void *resp_buffer,
+ *		  uint64_t *return_code, unsigned long flags);
+ */
+
+#include <asm/sthyi.h>
+
+#include "arch.h"
+#include "random.h"
+#include "sanitise.h"
+
+static unsigned long syscall_s390_sthyi_arg1[] = {
+	STHYI_FC_CP_IFL_CAP,
+	-1
+};
+
+static u64 syscall_s390_sthyi_return_code;
+
+/* Allocate buffer. */
+static void sanitise_s390_sthyi(struct syscallrecord *rec)
+{
+	size_t size = RAND_RANGE(0, page_size);
+	void *addr = size ? malloc(size) : NULL;
+
+	rec->a2 = (unsigned long)addr;
+
+	/* Use NULL, random or valid address */
+	switch (rnd() % 3) {
+	case 0:	rec->a3 = 0;
+		break;
+	case 1: rec->a3 = rnd();
+		break;
+	case 2: rec->a3 = (unsigned long)&syscall_s390_sthyi_return_code;
+		break;
+	}
+}
+
+/* Free buffer, freeptr takes care of NULL */
+static void post_s390_sthyi(struct syscallrecord *rec)
+{
+	freeptr(&rec->a2);
+}
+
+struct syscallentry syscall_s390_sthyi = {
+	.name = "s390_sthyi",
+	.sanitise = sanitise_s390_sthyi,
+	.post = post_s390_sthyi,
+	.num_args = 4,
+	.arg1name = "function_code",
+	.arg1type = ARG_LIST,
+	.arg1list = ARGLIST(syscall_s390_sthyi_arg1),
+	.arg2name = "resp_buffer",
+	.arg2type = ARG_NON_NULL_ADDRESS,
+	.arg3name = "return_code",
+	.arg3type = ARG_ADDRESS,
+	.arg4name = "resp_buffer",
+	.arg4type = ARG_RANGE,
+	.low4range = 0,
+	.hi4range = 128
+};
diff --git a/syscalls/syscalls.h b/syscalls/syscalls.h
index 38271170..3620c4ea 100644
--- a/syscalls/syscalls.h
+++ b/syscalls/syscalls.h
@@ -390,5 +390,6 @@ extern struct syscallentry syscall_runtime_instr;
 extern struct syscallentry syscall_s390_pci_mmio_write;
 extern struct syscallentry syscall_s390_pci_mmio_read;
 extern struct syscallentry syscall_s390_guarded_storage;
+extern struct syscallentry syscall_s390_sthyi;
 
 unsigned int random_fcntl_setfl_flags(void);
-- 
2.14.3
