From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/5] x86: Split "utter crap" pnpbios fixup out of fixup_exception
Date: Wed, 22 May 2013 14:07:40 -0700
Message-ID: <c35fe5a1a29b05384b16f68dca0bdc0ee966070b.1369177867.git.luto@amacapital.net>
References: <cover.1369177867.git.luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1369177867.git.luto@amacapital.net>
In-Reply-To: <cover.1369177867.git.luto@amacapital.net>
References: <cover.1369177867.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>

It has odd semantics, and it's only applicable (AFAICS) to #GP and #PF.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/traps.h |  6 ++++++
 arch/x86/kernel/traps.c      |  2 ++
 arch/x86/mm/extable.c        | 14 --------------
 arch/x86/mm/fault.c          | 19 +++++++++++++++++++
 4 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..55521de 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -89,6 +89,12 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+#ifdef CONFIG_PNPBIOS
+extern void fixup_pnpbios_exception(struct pt_regs *regs);
+#else
+static inline void fixup_pnpbios_exception(struct pt_regs *regs) {}
+#endif
+
 /* Interrupts/Exceptions */
 enum {
 	X86_TRAP_DE = 0,	/*  0, Divide-by-zero */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 68bda7a..8647670 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -275,6 +275,8 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 	tsk = current;
 	if (!user_mode(regs)) {
+		fixup_pnpbios_exception(regs);  /* Might not return */
+
 		if (fixup_exception(regs))
 			goto exit;
 
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 903ec1e..82e4ae8 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -19,20 +19,6 @@ int fixup_exception(struct pt_regs *regs)
 	const struct exception_table_entry *fixup;
 	unsigned long new_ip;
 
-#ifdef CONFIG_PNPBIOS
-	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
-		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
-		extern u32 pnp_bios_is_utter_crap;
-		pnp_bios_is_utter_crap = 1;
-		printk(KERN_CRIT "PNPBIOS fault.. attempting recovery.\n");
-		__asm__ volatile(
-			"movl %0, %%esp\n\t"
-			"jmp *%1\n\t"
-			: : "g" (pnp_bios_fault_esp), "g" (pnp_bios_fault_eip));
-		panic("do_trap: can't hit this");
-	}
-#endif
-
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
 		new_ip = ex_fixup_addr(fixup);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 0e88336..58afb50 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -569,6 +569,23 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 	return 0;
 }
 
+#ifdef CONFIG_PNPBIOS
+void fixup_pnpbios_exception(struct pt_regs *regs)
+{
+	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
+		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
+		extern u32 pnp_bios_is_utter_crap;
+		pnp_bios_is_utter_crap = 1;
+		printk(KERN_CRIT "PNPBIOS fault.. attempting recovery.\n");
+		__asm__ volatile(
+			"movl %0, %%esp\n\t"
+			"jmp *%1\n\t"
+			: : "g" (pnp_bios_fault_esp), "g" (pnp_bios_fault_eip));
+		panic("do_trap: can't hit this");
+	}
+}
+#endif
+
 static const char nx_warning[] = KERN_CRIT
 "kernel tried to execute NX-protected page - exploit attempt? (uid: %d)\n";
 
@@ -636,6 +653,8 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	unsigned long flags;
 	int sig;
 
+	fixup_pnpbios_exception(regs);  /* Might not return */
+
 	/* Are we prepared to handle this kernel fault? */
 	if (fixup_exception(regs)) {
 		if (current_thread_info()->sig_on_uaccess_error && signal) {
-- 
1.8.1.4
