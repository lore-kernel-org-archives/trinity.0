From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/5] x86: Don't fixup uaccess faults to kernel or non-canonical addresses
Date: Wed, 22 May 2013 14:07:43 -0700
Message-ID: <06b4e052042729929da480bea7cf772a6a083195.1369177867.git.luto@amacapital.net>
References: <cover.1369177867.git.luto@amacapital.net>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <cover.1369177867.git.luto@amacapital.net>
In-Reply-To: <cover.1369177867.git.luto@amacapital.net>
References: <cover.1369177867.git.luto@amacapital.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Ananth N Mavinakayanahalli <ananth@in.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

These don't inherently cause crashes, but they're bugs and, if
there's one triggerable from userspace, it can be used to probe
KASLR.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I don't know what the kprobes code is doing, so I made the conservative
change.  This can probably be improved.

Kprobes people: what does this code do?

 arch/x86/include/asm/uaccess.h |  2 +-
 arch/x86/kernel/kprobes/core.c |  4 +++-
 arch/x86/kernel/traps.c        | 10 +++++++---
 arch/x86/mm/extable.c          |  7 +++++--
 arch/x86/mm/fault.c            | 17 ++++++++++-------
 5 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index ed2d77a..a2a92d8 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -101,7 +101,7 @@ struct exception_table_entry {
 #define ARCH_HAS_SORT_EXTABLE
 #define ARCH_HAS_SEARCH_EXTABLE
 
-extern int fixup_exception(struct pt_regs *regs);
+extern int fixup_exception(struct pt_regs *regs, bool uaccess_ok);
 extern int early_fixup_exception(unsigned long *ip);
 
 /*
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7bfe318..64932d2 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -927,8 +927,10 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		/*
 		 * In case the user-specified fault handler returned
 		 * zero, try to fix up.
+		 *
+		 * XXX: This could be much more conservative.
 		 */
-		if (fixup_exception(regs))
+		if (fixup_exception(regs, true))
 			return 1;
 
 		/*
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8647670..a9453b0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -124,7 +124,7 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
 	}
 #endif
 	if (!user_mode(regs)) {
-		if (!fixup_exception(regs)) {
+		if (!fixup_exception(regs, false)) {
 			tsk->thread.error_code = error_code;
 			tsk->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
@@ -277,7 +277,11 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	if (!user_mode(regs)) {
 		fixup_pnpbios_exception(regs);  /* Might not return */
 
-		if (fixup_exception(regs))
+		/*
+		 * This could be a non-canonical address in uaccess.  If so,
+		 * this is bad.
+		 */
+		if (fixup_exception(regs, false))
 			goto exit;
 
 		tsk->thread.error_code = error_code;
@@ -491,7 +495,7 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
 	if (!user_mode_vm(regs))
 	{
-		if (!fixup_exception(regs)) {
+		if (!fixup_exception(regs, false)) {
 			task->thread.error_code = error_code;
 			task->thread.trap_nr = trapnr;
 			die(str, regs, error_code);
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 85f45d4..05e078a 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -22,7 +22,7 @@ ex_fixup_addr(const struct exception_table_entry *x)
 	return (unsigned long)&x->fixup + offset;
 }
 
-int fixup_exception(struct pt_regs *regs)
+int fixup_exception(struct pt_regs *regs, bool uaccess_ok)
 {
 	const struct exception_table_entry *fixup;
 	unsigned long new_ip;
@@ -33,6 +33,9 @@ int fixup_exception(struct pt_regs *regs)
 		class = ex_class(fixup);
 		new_ip = ex_fixup_addr(fixup);
 
+		if (class != _EXTABLE_CLASS_ANY && !uaccess_ok)
+			return 0;
+
 		if (class == _EXTABLE_CLASS_EX) {
 			/* Special hack for uaccess_err */
 			current_thread_info()->uaccess_err = 1;
@@ -51,7 +54,7 @@ int __init early_fixup_exception(unsigned long *ip)
 
 	fixup = search_exception_tables(*ip);
 	if (fixup) {
-		if (ex_class(fixup) == _EXTABLE_CLASS_EX) {
+		if (ex_class(fixup) != _EXTABLE_CLASS_ANY) {
 			/* uaccess handling not supported during early boot */
 			return 0;
 		}
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 58afb50..c9fdf7d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -644,6 +644,11 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 	oops_end(flags, regs, sig);
 }
 
+static int fault_in_kernel_space(unsigned long address)
+{
+	return address >= TASK_SIZE_MAX;
+}
+
 static noinline void
 no_context(struct pt_regs *regs, unsigned long error_code,
 	   unsigned long address, int signal, int si_code)
@@ -655,8 +660,11 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 
 	fixup_pnpbios_exception(regs);  /* Might not return */
 
-	/* Are we prepared to handle this kernel fault? */
-	if (fixup_exception(regs)) {
+	/*
+	 * Are we prepared to handle this kernel fault?  If this is a
+	 * uaccess fault, then the faulting address must be in user space.
+	 */
+	if (fixup_exception(regs, !fault_in_kernel_space(address))) {
 		if (current_thread_info()->sig_on_uaccess_error && signal) {
 			tsk->thread.trap_nr = X86_TRAP_PF;
 			tsk->thread.error_code = error_code | PF_USER;
@@ -1001,11 +1009,6 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int fault_in_kernel_space(unsigned long address)
-{
-	return address >= TASK_SIZE_MAX;
-}
-
 static inline bool smap_violation(int error_code, struct pt_regs *regs)
 {
 	if (error_code & PF_USER)
-- 
1.8.1.4
