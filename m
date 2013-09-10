From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH] wire up support for the Alpha architecture
Date: Tue, 10 Sep 2013 13:43:04 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1309101335200.30015@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


Will Deacon has more exotic hardware than I do: he sent this patch
against my perf_fuzzer to add Alpha support (he already used it to find a 
kernel bug).

Anyway since I use the trinity headers, the patch applies equally well 
against trinity.  

I'm not sure enough with my git skills to know if sending a patch like 
this will preserve attributions properly, so I apologize if this breaks 
somehow.


From: Will Deacon <will.deacon@arm.com>

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/arch-alpha.h    | 16 ++++++++++++++++
 include/arch-syscalls.h |  3 +++
 include/arch.h          |  3 +++
 3 files changed, 22 insertions(+)
 create mode 100644 include/arch-alpha.h

diff --git a/include/arch-alpha.h b/include/arch-alpha.h
new file mode 100644
index 0000000..a6a7cac
--- /dev/null
+++ b/include/arch-alpha.h
@@ -0,0 +1,16 @@
+#define KERNEL_ADDR		0xfffffc0000310000
+/* KERNEL_ADDR is 0xfffffc0001010000 ifndef CONFIG_ALPHA_LEGACY_START_ADDRESS */
+
+#define PAGE_SHIFT		13
+#define PGDIR_SHIFT		(PAGE_SHIFT + 2*(PAGE_SHIFT-3))
+#define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
+#define MODULE_ADDR		(-2*PGDIR_SIZE)
+/* MODULE_ADDR is 0xfffffe0000000000 ifdef CONFIG_ALPHA_LARGE_VMALLOC */
+
+#define PAGE_OFFSET		0xfffffc0000000000UL
+/* PAGE_OFFSET is 0xffff800000000000UL ifdef USE_48_BIT_KSEG */
+
+#define TASK_SIZE		0x40000000000UL
+
+#define PTE_FILE_MAX_BITS	32
+
diff --git a/include/arch-syscalls.h b/include/arch-syscalls.h
index 509fd53..7824c13 100644
--- a/include/arch-syscalls.h
+++ b/include/arch-syscalls.h
@@ -32,5 +32,8 @@
 #ifdef __sh__
 #include "syscalls-sh.h"
 #endif
+#ifdef __alpha__
+#include "syscalls-alpha.h"
+#endif
 
 #endif  /* _ARCH_SYSCALLS_H */
diff --git a/include/arch.h b/include/arch.h
index 3d28cee..c0f41f2 100644
--- a/include/arch.h
+++ b/include/arch.h
@@ -30,6 +30,9 @@
 #ifdef __sh__
 #include "arch-sh.h"
 #endif
+#ifdef __alpha__
+#include "arch-alpha.h"
+#endif
 
 #ifndef SYSCALL_OFFSET
 #define SYSCALL_OFFSET 0
-- 
1.8.2.2
