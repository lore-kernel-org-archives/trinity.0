From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/5] x86: Annotate _ASM_EXTABLE users to distinguish uaccess from everything else
Date: Wed, 22 May 2013 14:07:42 -0700
Message-ID: <368e7a638f5355e7e2ba8b2e6d4db4361e4359ac.1369177867.git.luto@amacapital.net>
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
Cc: x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org

The idea is that the kernel can be much more careful fixing up
uaccess exceptions -- page faults on user addresses are the only
legitimate reason for a uaccess instruction to fault.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I'm not 100% sure what's happening in the KVM code.  Can someone familiar
with it take a look?

 arch/x86/ia32/ia32entry.S             |   4 +-
 arch/x86/include/asm/asm.h            |  13 ++-
 arch/x86/include/asm/fpu-internal.h   |   6 +-
 arch/x86/include/asm/futex.h          |   8 +-
 arch/x86/include/asm/kvm_host.h       |   2 +-
 arch/x86/include/asm/msr.h            |   4 +-
 arch/x86/include/asm/segment.h        |   2 +-
 arch/x86/include/asm/special_insns.h  |   2 +-
 arch/x86/include/asm/uaccess.h        |   8 +-
 arch/x86/include/asm/word-at-a-time.h |   2 +-
 arch/x86/include/asm/xsave.h          |   6 +-
 arch/x86/kernel/entry_32.S            |  26 ++---
 arch/x86/kernel/entry_64.S            |   6 +-
 arch/x86/kernel/ftrace.c              |   4 +-
 arch/x86/kernel/test_nx.c             |   2 +-
 arch/x86/kernel/test_rodata.c         |   2 +-
 arch/x86/kvm/emulate.c                |   4 +-
 arch/x86/lib/checksum_32.S            |   4 +-
 arch/x86/lib/copy_user_64.S           |  50 ++++----
 arch/x86/lib/copy_user_nocache_64.S   |  44 +++----
 arch/x86/lib/csum-copy_64.S           |   6 +-
 arch/x86/lib/getuser.S                |  12 +-
 arch/x86/lib/mmx_32.c                 |  12 +-
 arch/x86/lib/msr-reg.S                |   4 +-
 arch/x86/lib/putuser.S                |  10 +-
 arch/x86/lib/usercopy_32.c            | 212 +++++++++++++++++-----------------
 arch/x86/lib/usercopy_64.c            |   4 +-
 arch/x86/mm/init_32.c                 |   2 +-
 arch/x86/um/checksum_32.S             |   4 +-
 arch/x86/xen/xen-asm_32.S             |   2 +-
 30 files changed, 236 insertions(+), 231 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 474dc1b..8d3b5c2 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -149,7 +149,7 @@ ENTRY(ia32_sysenter_target)
  	   32bit zero extended */ 
 	ASM_STAC
 1:	movl	(%rbp),%ebp
-	_ASM_EXTABLE(1b,ia32_badarg)
+	_ASM_EXTABLE_UACCESS(1b,ia32_badarg)
 	ASM_CLAC
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
@@ -306,7 +306,7 @@ ENTRY(ia32_cstar_target)
 	/* hardware stack frame is complete now */	
 	ASM_STAC
 1:	movl	(%r8),%r9d
-	_ASM_EXTABLE(1b,ia32_badarg)
+	_ASM_EXTABLE_UACCESS(1b,ia32_badarg)
 	ASM_CLAC
 	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index fa47fd4..f48a850 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -57,14 +57,16 @@
  */
 
 /* There are two bits of extable entry class, added to a signed offset. */
-#define _EXTABLE_CLASS_DEFAULT	0		/* standard uaccess fixup */
+#define _EXTABLE_CLASS_UACCESS	0		/* standard uaccess fixup */
+#define _EXTABLE_CLASS_ANY	0x40000000	/* catch any exception */
 #define _EXTABLE_CLASS_EX	0x80000000	/* uaccess + set uaccess_err */
 
 /*
  * The biases are the class constants + 0x20000000, as signed integers.
  * This can't use ordinary arithmetic -- the assembler isn't that smart.
  */
-#define _EXTABLE_BIAS_DEFAULT	0x20000000
+#define _EXTABLE_BIAS_UACCESS	0x20000000
+#define _EXTABLE_BIAS_ANY	0x20000000 + 0x40000000
 #define _EXTABLE_BIAS_EX	0x20000000 - 0x80000000
 
 #ifdef __ASSEMBLY__
@@ -85,8 +87,11 @@
 	" .popsection\n"
 #endif
 
-#define _ASM_EXTABLE(from,to)						\
-	_ASM_EXTABLE_CLASS(from, to, _EXTABLE_BIAS_DEFAULT)
+#define _ASM_EXTABLE_UACCESS(from,to)					\
+	_ASM_EXTABLE_CLASS(from, to, _EXTABLE_BIAS_UACCESS)
+
+#define _ASM_EXTABLE_ANY(from,to)					\
+	_ASM_EXTABLE_CLASS(from, to, _EXTABLE_BIAS_ANY)
 
 #define _ASM_EXTABLE_EX(from,to)					\
 	_ASM_EXTABLE_CLASS(from, to, _EXTABLE_BIAS_EX)
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e25cc33..7f86031 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -133,7 +133,7 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 		     "3:  movl $-1,%[err]\n"				\
 		     "    jmp  2b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
+		     _ASM_EXTABLE_UACCESS(1b, 3b)				\
 		     : [err] "=r" (err), output				\
 		     : "0"(0), input);					\
 	err;								\
@@ -148,7 +148,7 @@ static inline void sanitize_i387_state(struct task_struct *tsk)
 		     "3:  movl $-1,%[err]\n"				\
 		     "    jmp  2b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
+		     _ASM_EXTABLE_ANY(1b, 3b)				\
 		     : [err] "=r" (err), output				\
 		     : "0"(0), input);					\
 	err;								\
@@ -356,7 +356,7 @@ static inline void __drop_fpu(struct task_struct *tsk)
 		/* Ignore delayed exceptions from user space */
 		asm volatile("1: fwait\n"
 			     "2:\n"
-			     _ASM_EXTABLE(1b, 2b));
+			     _ASM_EXTABLE_ANY(1b, 2b));
 		__thread_fpu_end(tsk);
 	}
 }
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index be27ba1..606006c 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -19,7 +19,7 @@
 		     "3:\tmov\t%3, %1\n"			\
 		     "\tjmp\t2b\n"				\
 		     "\t.previous\n"				\
-		     _ASM_EXTABLE(1b, 3b)			\
+		     _ASM_EXTABLE_UACCESS(1b, 3b)		\
 		     : "=r" (oldval), "=r" (ret), "+m" (*uaddr)	\
 		     : "i" (-EFAULT), "0" (oparg), "1" (0))
 
@@ -35,8 +35,8 @@
 		     "4:\tmov\t%5, %1\n"			\
 		     "\tjmp\t3b\n"				\
 		     "\t.previous\n"				\
-		     _ASM_EXTABLE(1b, 4b)			\
-		     _ASM_EXTABLE(2b, 4b)			\
+		     _ASM_EXTABLE_UACCESS(1b, 4b)		\
+		     _ASM_EXTABLE_UACCESS(2b, 4b)		\
 		     : "=&a" (oldval), "=&r" (ret),		\
 		       "+m" (*uaddr), "=&r" (tem)		\
 		     : "r" (oparg), "i" (-EFAULT), "1" (0))
@@ -122,7 +122,7 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		     "3:\tmov     %3, %0\n"
 		     "\tjmp     2b\n"
 		     "\t.previous\n"
-		     _ASM_EXTABLE(1b, 3b)
+		     _ASM_EXTABLE_UACCESS(1b, 3b)
 		     : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
 		     : "i" (-EFAULT), "r" (newval), "1" (oldval)
 		     : "memory"
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4979778..96c576f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -986,7 +986,7 @@ extern bool kvm_rebooting;
 	__ASM_SIZE(push) " $666b \n\t"	      \
 	"call kvm_spurious_fault \n\t"	      \
 	".popsection \n\t" \
-	_ASM_EXTABLE(666b, 667b)
+	_ASM_EXTABLE_ANY(666b, 667b)
 
 #define __kvm_handle_fault_on_reboot(insn)		\
 	____kvm_handle_fault_on_reboot(insn, "")
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 9264802..54e4bea 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -75,7 +75,7 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 		     ".section .fixup,\"ax\"\n\t"
 		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
 		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
+		     _ASM_EXTABLE_ANY(2b, 3b)
 		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
 		     : "c" (msr), [fault] "i" (-EIO));
 	return EAX_EDX_VAL(val, low, high);
@@ -97,7 +97,7 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
 		     ".section .fixup,\"ax\"\n\t"
 		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
 		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
+		     _ASM_EXTABLE_ANY(2b, 3b)
 		     : [err] "=a" (err)
 		     : "c" (msr), "0" (low), "d" (high),
 		       [fault] "i" (-EIO)
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index c48a950..89cac10 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -231,7 +231,7 @@ do {									\
 		     "		jmp 1b				\n"	\
 		     ".previous					\n"	\
 									\
-		     _ASM_EXTABLE(1b, 2b)				\
+		     _ASM_EXTABLE_ANY(1b, 2b)				\
 									\
 		     : "+r" (__val) : : "memory");			\
 } while (0)
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 41fc93a..30b6f01 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -69,7 +69,7 @@ static inline unsigned long native_read_cr4_safe(void)
 #ifdef CONFIG_X86_32
 	asm volatile("1: mov %%cr4, %0\n"
 		     "2:\n"
-		     _ASM_EXTABLE(1b, 2b)
+		     _ASM_EXTABLE_ANY(1b, 2b)
 		     : "=r" (val), "=m" (__force_order) : "0" (0));
 #else
 	val = native_read_cr4();
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5ee2687..ed2d77a 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -188,8 +188,8 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 		     "4:	movl %3,%0\n"				\
 		     "	jmp 3b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 4b)				\
-		     _ASM_EXTABLE(2b, 4b)				\
+		     _ASM_EXTABLE_UACCESS(1b, 4b)			\
+		     _ASM_EXTABLE_UACCESS(2b, 4b)			\
 		     : "=r" (err)					\
 		     : "A" (x), "r" (addr), "i" (errret), "0" (err))
 
@@ -352,7 +352,7 @@ do {									\
 		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
 		     "	jmp 2b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
+		     _ASM_EXTABLE_UACCESS(1b, 3b)			\
 		     : "=r" (err), ltype(x)				\
 		     : "m" (__m(addr)), "i" (errret), "0" (err))
 
@@ -416,7 +416,7 @@ struct __large_struct { unsigned long buf[100]; };
 		     "3:	mov %3,%0\n"				\
 		     "	jmp 2b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
+		     _ASM_EXTABLE_UACCESS(1b, 3b)			\
 		     : "=r"(err)					\
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
 
diff --git a/arch/x86/include/asm/word-at-a-time.h b/arch/x86/include/asm/word-at-a-time.h
index 5b238981..aa80911 100644
--- a/arch/x86/include/asm/word-at-a-time.h
+++ b/arch/x86/include/asm/word-at-a-time.h
@@ -94,7 +94,7 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 		"shr %%cl,%0\n\t"
 		"jmp 2b\n"
 		".previous\n"
-		_ASM_EXTABLE(1b, 3b)
+		_ASM_EXTABLE_ANY(1b, 3b)
 		:"=&r" (ret),"=&c" (dummy)
 		:"m" (*(unsigned long *)addr),
 		 "i" (-sizeof(unsigned long)),
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0415cda..7859666 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -50,7 +50,7 @@ static inline int fpu_xrstor_checking(struct xsave_struct *fx)
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
 		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
+		     _ASM_EXTABLE_ANY(1b, 3b)
 		     : [err] "=r" (err)
 		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
 		     : "memory");
@@ -77,7 +77,7 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
 			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
+			     _ASM_EXTABLE_UACCESS(1b,3b)
 			     : [err] "=r" (err)
 			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
 			     : "memory");
@@ -98,7 +98,7 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
 			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
+			     _ASM_EXTABLE_UACCESS(1b,3b)
 			     : [err] "=r" (err)
 			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
 			     : "memory");	/* memory required? */
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 8f3e2de..fc85bb9 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -154,7 +154,7 @@
 99:	movl $0, (%esp)
 	jmp 98b
 .popsection
-	_ASM_EXTABLE(98b,99b)
+	_ASM_EXTABLE_ANY(98b,99b)
 .endm
 
 .macro PTGS_TO_GS
@@ -165,7 +165,7 @@
 99:	movl $0, PT_GS(%esp)
 	jmp 98b
 .popsection
-	_ASM_EXTABLE(98b,99b)
+	_ASM_EXTABLE_ANY(98b,99b)
 .endm
 
 .macro GS_TO_REG reg
@@ -248,9 +248,9 @@
 6:	movl $0, (%esp)
 	jmp 3b
 .popsection
-	_ASM_EXTABLE(1b,4b)
-	_ASM_EXTABLE(2b,5b)
-	_ASM_EXTABLE(3b,6b)
+	_ASM_EXTABLE_ANY(1b,4b)
+	_ASM_EXTABLE_ANY(2b,5b)
+	_ASM_EXTABLE_ANY(3b,6b)
 	POP_GS_EX
 .endm
 
@@ -426,7 +426,7 @@ sysenter_past_esp:
 1:	movl (%ebp),%ebp
 	ASM_CLAC
 	movl %ebp,PT_EBP(%esp)
-	_ASM_EXTABLE(1b,syscall_fault)
+	_ASM_EXTABLE_UACCESS(1b,syscall_fault)
 
 	GET_THREAD_INFO(%ebp)
 
@@ -494,7 +494,7 @@ sysexit_audit:
 2:	movl $0,PT_FS(%esp)
 	jmp 1b
 .popsection
-	_ASM_EXTABLE(1b,2b)
+	_ASM_EXTABLE_ANY(1b,2b)
 	PTGS_TO_GS_EX
 ENDPROC(ia32_sysenter_target)
 
@@ -550,7 +550,7 @@ ENTRY(iret_exc)
 	pushl $do_iret_error
 	jmp error_code
 .previous
-	_ASM_EXTABLE(irq_return,iret_exc)
+	_ASM_EXTABLE_ANY(irq_return,iret_exc)
 
 	CFI_RESTORE_STATE
 ldt_ss:
@@ -849,7 +849,7 @@ END(device_not_available)
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iret
-	_ASM_EXTABLE(native_iret, iret_exc)
+	_ASM_EXTABLE_ANY(native_iret, iret_exc)
 END(native_iret)
 
 ENTRY(native_irq_enable_sysexit)
@@ -1040,10 +1040,10 @@ ENTRY(xen_failsafe_callback)
 	movl %eax,16(%esp)
 	jmp 4b
 .previous
-	_ASM_EXTABLE(1b,6b)
-	_ASM_EXTABLE(2b,7b)
-	_ASM_EXTABLE(3b,8b)
-	_ASM_EXTABLE(4b,9b)
+	_ASM_EXTABLE_ANY(1b,6b)
+	_ASM_EXTABLE_ANY(2b,7b)
+	_ASM_EXTABLE_ANY(3b,8b)
+	_ASM_EXTABLE_ANY(4b,9b)
 ENDPROC(xen_failsafe_callback)
 
 BUILD_INTERRUPT3(xen_hvm_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c1d01e6..be185cd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1056,12 +1056,12 @@ restore_args:
 
 irq_return:
 	INTERRUPT_RETURN
-	_ASM_EXTABLE(irq_return, bad_iret)
+	_ASM_EXTABLE_ANY(irq_return, bad_iret)
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iretq
-	_ASM_EXTABLE(native_iret, bad_iret)
+	_ASM_EXTABLE_ANY(native_iret, bad_iret)
 #endif
 
 	.section .fixup,"ax"
@@ -1319,7 +1319,7 @@ gs_change:
 	CFI_ENDPROC
 END(native_load_gs_index)
 
-	_ASM_EXTABLE(gs_change,bad_gs)
+	_ASM_EXTABLE_ANY(gs_change,bad_gs)
 	.section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs:
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 42a392a..c6c4ebf 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -740,8 +740,8 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		"   jmp 3b\n"
 		".previous\n"
 
-		_ASM_EXTABLE(1b, 4b)
-		_ASM_EXTABLE(2b, 4b)
+		_ASM_EXTABLE_ANY(1b, 4b)
+		_ASM_EXTABLE_ANY(2b, 4b)
 
 		: [old] "=&r" (old), [faulted] "=r" (faulted)
 		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 3f92ce0..770cb68 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -92,7 +92,7 @@ static noinline int test_address(void *address)
 		"2:	mov %[zero], %[rslt]\n"
 		"	ret\n"
 		".previous\n"
-		_ASM_EXTABLE(0b,2b)
+		_ASM_EXTABLE_ANY(0b,2b)
 		: [rslt] "=r" (result)
 		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
 	);
diff --git a/arch/x86/kernel/test_rodata.c b/arch/x86/kernel/test_rodata.c
index b79133a..624e6af 100644
--- a/arch/x86/kernel/test_rodata.c
+++ b/arch/x86/kernel/test_rodata.c
@@ -43,7 +43,7 @@ int rodata_test(void)
 		".section .fixup,\"ax\"\n"
 		"2:	jmp 1b\n"
 		".previous\n"
-		_ASM_EXTABLE(0b,2b)
+		_ASM_EXTABLE_ANY(0b,2b)
 		: [rslt] "=r" (result)
 		: [rodata_test] "r" (&rodata_test_data), [zero] "r" (0UL)
 	);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a9c9d3e..fa7f66a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -548,7 +548,7 @@ FOP_END;
 			"3: movb $1, %4 \n\t"				\
 			"jmp 2b \n\t"					\
 			".popsection \n\t"				\
-			_ASM_EXTABLE(1b, 3b)				\
+			_ASM_EXTABLE_UACCESS(1b, 3b)			\
 			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
 			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
 			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
@@ -4479,7 +4479,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 		     "movb $1, %[fault] \n\t"
 		     "jmp 2b \n\t"
 		     ".popsection \n\t"
-		     _ASM_EXTABLE(1b, 3b)
+		     _ASM_EXTABLE_ANY(1b, 3b)
 		     : [fault]"+qm"(fault));
 	ctxt->ops->put_fpu(ctxt);
 
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index 2af5df3..20523f0 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -283,11 +283,11 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 
 #define SRC(y...)			\
 	9999: y;			\
-	_ASM_EXTABLE(9999b, 6001f)
+	_ASM_EXTABLE_UACCESS(9999b, 6001f)
 
 #define DST(y...)			\
 	9999: y;			\
-	_ASM_EXTABLE(9999b, 6002f)
+	_ASM_EXTABLE_UACCESS(9999b, 6002f)
 
 #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
 
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index a30ca15..20c0258 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -65,8 +65,8 @@
 	jmp copy_user_handle_tail
 	.previous
 
-	_ASM_EXTABLE(100b,103b)
-	_ASM_EXTABLE(101b,103b)
+	_ASM_EXTABLE_UACCESS(100b,103b)
+	_ASM_EXTABLE_UACCESS(101b,103b)
 #endif
 	.endm
 
@@ -192,26 +192,26 @@ ENTRY(copy_user_generic_unrolled)
 60:	jmp copy_user_handle_tail /* ecx is zerorest also */
 	.previous
 
-	_ASM_EXTABLE(1b,30b)
-	_ASM_EXTABLE(2b,30b)
-	_ASM_EXTABLE(3b,30b)
-	_ASM_EXTABLE(4b,30b)
-	_ASM_EXTABLE(5b,30b)
-	_ASM_EXTABLE(6b,30b)
-	_ASM_EXTABLE(7b,30b)
-	_ASM_EXTABLE(8b,30b)
-	_ASM_EXTABLE(9b,30b)
-	_ASM_EXTABLE(10b,30b)
-	_ASM_EXTABLE(11b,30b)
-	_ASM_EXTABLE(12b,30b)
-	_ASM_EXTABLE(13b,30b)
-	_ASM_EXTABLE(14b,30b)
-	_ASM_EXTABLE(15b,30b)
-	_ASM_EXTABLE(16b,30b)
-	_ASM_EXTABLE(18b,40b)
-	_ASM_EXTABLE(19b,40b)
-	_ASM_EXTABLE(21b,50b)
-	_ASM_EXTABLE(22b,50b)
+	_ASM_EXTABLE_UACCESS(1b,30b)
+	_ASM_EXTABLE_UACCESS(2b,30b)
+	_ASM_EXTABLE_UACCESS(3b,30b)
+	_ASM_EXTABLE_UACCESS(4b,30b)
+	_ASM_EXTABLE_UACCESS(5b,30b)
+	_ASM_EXTABLE_UACCESS(6b,30b)
+	_ASM_EXTABLE_UACCESS(7b,30b)
+	_ASM_EXTABLE_UACCESS(8b,30b)
+	_ASM_EXTABLE_UACCESS(9b,30b)
+	_ASM_EXTABLE_UACCESS(10b,30b)
+	_ASM_EXTABLE_UACCESS(11b,30b)
+	_ASM_EXTABLE_UACCESS(12b,30b)
+	_ASM_EXTABLE_UACCESS(13b,30b)
+	_ASM_EXTABLE_UACCESS(14b,30b)
+	_ASM_EXTABLE_UACCESS(15b,30b)
+	_ASM_EXTABLE_UACCESS(16b,30b)
+	_ASM_EXTABLE_UACCESS(18b,40b)
+	_ASM_EXTABLE_UACCESS(19b,40b)
+	_ASM_EXTABLE_UACCESS(21b,50b)
+	_ASM_EXTABLE_UACCESS(22b,50b)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_unrolled)
 
@@ -259,8 +259,8 @@ ENTRY(copy_user_generic_string)
 	jmp copy_user_handle_tail
 	.previous
 
-	_ASM_EXTABLE(1b,11b)
-	_ASM_EXTABLE(3b,12b)
+	_ASM_EXTABLE_UACCESS(1b,11b)
+	_ASM_EXTABLE_UACCESS(3b,12b)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_string)
 
@@ -293,6 +293,6 @@ ENTRY(copy_user_enhanced_fast_string)
 	jmp copy_user_handle_tail
 	.previous
 
-	_ASM_EXTABLE(1b,12b)
+	_ASM_EXTABLE_UACCESS(1b,12b)
 	CFI_ENDPROC
 ENDPROC(copy_user_enhanced_fast_string)
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 6a4f43c..c9b8193 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -38,8 +38,8 @@
 	jmp copy_user_handle_tail
 	.previous
 
-	_ASM_EXTABLE(100b,103b)
-	_ASM_EXTABLE(101b,103b)
+	_ASM_EXTABLE_UACCESS(100b,103b)
+	_ASM_EXTABLE_UACCESS(101b,103b)
 #endif
 	.endm
 
@@ -112,25 +112,25 @@ ENTRY(__copy_user_nocache)
 	jmp copy_user_handle_tail
 	.previous
 
-	_ASM_EXTABLE(1b,30b)
-	_ASM_EXTABLE(2b,30b)
-	_ASM_EXTABLE(3b,30b)
-	_ASM_EXTABLE(4b,30b)
-	_ASM_EXTABLE(5b,30b)
-	_ASM_EXTABLE(6b,30b)
-	_ASM_EXTABLE(7b,30b)
-	_ASM_EXTABLE(8b,30b)
-	_ASM_EXTABLE(9b,30b)
-	_ASM_EXTABLE(10b,30b)
-	_ASM_EXTABLE(11b,30b)
-	_ASM_EXTABLE(12b,30b)
-	_ASM_EXTABLE(13b,30b)
-	_ASM_EXTABLE(14b,30b)
-	_ASM_EXTABLE(15b,30b)
-	_ASM_EXTABLE(16b,30b)
-	_ASM_EXTABLE(18b,40b)
-	_ASM_EXTABLE(19b,40b)
-	_ASM_EXTABLE(21b,50b)
-	_ASM_EXTABLE(22b,50b)
+	_ASM_EXTABLE_UACCESS(1b,30b)
+	_ASM_EXTABLE_UACCESS(2b,30b)
+	_ASM_EXTABLE_UACCESS(3b,30b)
+	_ASM_EXTABLE_UACCESS(4b,30b)
+	_ASM_EXTABLE_UACCESS(5b,30b)
+	_ASM_EXTABLE_UACCESS(6b,30b)
+	_ASM_EXTABLE_UACCESS(7b,30b)
+	_ASM_EXTABLE_UACCESS(8b,30b)
+	_ASM_EXTABLE_UACCESS(9b,30b)
+	_ASM_EXTABLE_UACCESS(10b,30b)
+	_ASM_EXTABLE_UACCESS(11b,30b)
+	_ASM_EXTABLE_UACCESS(12b,30b)
+	_ASM_EXTABLE_UACCESS(13b,30b)
+	_ASM_EXTABLE_UACCESS(14b,30b)
+	_ASM_EXTABLE_UACCESS(15b,30b)
+	_ASM_EXTABLE_UACCESS(16b,30b)
+	_ASM_EXTABLE_UACCESS(18b,40b)
+	_ASM_EXTABLE_UACCESS(19b,40b)
+	_ASM_EXTABLE_UACCESS(21b,50b)
+	_ASM_EXTABLE_UACCESS(22b,50b)
 	CFI_ENDPROC
 ENDPROC(__copy_user_nocache)
diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
index 2419d5f..e6ecfc9 100644
--- a/arch/x86/lib/csum-copy_64.S
+++ b/arch/x86/lib/csum-copy_64.S
@@ -32,17 +32,17 @@
 
 	.macro source
 10:
-	_ASM_EXTABLE(10b, .Lbad_source)
+	_ASM_EXTABLE_UACCESS(10b, .Lbad_source)
 	.endm
 
 	.macro dest
 20:
-	_ASM_EXTABLE(20b, .Lbad_dest)
+	_ASM_EXTABLE_UACCESS(20b, .Lbad_dest)
 	.endm
 
 	.macro ignore L=.Lignore
 30:
-	_ASM_EXTABLE(30b, \L)
+	_ASM_EXTABLE_UACCESS(30b, \L)
 	.endm
 
 
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index a451235..8f15607 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -129,12 +129,12 @@ bad_get_user_8:
 END(bad_get_user_8)
 #endif
 
-	_ASM_EXTABLE(1b,bad_get_user)
-	_ASM_EXTABLE(2b,bad_get_user)
-	_ASM_EXTABLE(3b,bad_get_user)
+	_ASM_EXTABLE_UACCESS(1b,bad_get_user)
+	_ASM_EXTABLE_UACCESS(2b,bad_get_user)
+	_ASM_EXTABLE_UACCESS(3b,bad_get_user)
 #ifdef CONFIG_X86_64
-	_ASM_EXTABLE(4b,bad_get_user)
+	_ASM_EXTABLE_UACCESS(4b,bad_get_user)
 #else
-	_ASM_EXTABLE(4b,bad_get_user_8)
-	_ASM_EXTABLE(5b,bad_get_user_8)
+	_ASM_EXTABLE_UACCESS(4b,bad_get_user_8)
+	_ASM_EXTABLE_UACCESS(5b,bad_get_user_8)
 #endif
diff --git a/arch/x86/lib/mmx_32.c b/arch/x86/lib/mmx_32.c
index c9f2d9b..d1a21f7 100644
--- a/arch/x86/lib/mmx_32.c
+++ b/arch/x86/lib/mmx_32.c
@@ -49,7 +49,7 @@ void *_mmx_memcpy(void *to, const void *from, size_t len)
 		"3: movw $0x1AEB, 1b\n"	/* jmp on 26 bytes */
 		"   jmp 2b\n"
 		".previous\n"
-			_ASM_EXTABLE(1b, 3b)
+			_ASM_EXTABLE_UACCESS(1b, 3b)
 			: : "r" (from));
 
 	for ( ; i > 5; i--) {
@@ -75,7 +75,7 @@ void *_mmx_memcpy(void *to, const void *from, size_t len)
 		"3: movw $0x05EB, 1b\n"	/* jmp on 5 bytes */
 		"   jmp 2b\n"
 		".previous\n"
-			_ASM_EXTABLE(1b, 3b)
+			_ASM_EXTABLE_UACCESS(1b, 3b)
 			: : "r" (from), "r" (to) : "memory");
 
 		from += 64;
@@ -176,7 +176,7 @@ static void fast_copy_page(void *to, void *from)
 		"3: movw $0x1AEB, 1b\n"	/* jmp on 26 bytes */
 		"   jmp 2b\n"
 		".previous\n"
-			_ASM_EXTABLE(1b, 3b) : : "r" (from));
+			_ASM_EXTABLE_UACCESS(1b, 3b) : : "r" (from));
 
 	for (i = 0; i < (4096-320)/64; i++) {
 		__asm__ __volatile__ (
@@ -201,7 +201,7 @@ static void fast_copy_page(void *to, void *from)
 		"3: movw $0x05EB, 1b\n"	/* jmp on 5 bytes */
 		"   jmp 2b\n"
 		".previous\n"
-		_ASM_EXTABLE(1b, 3b) : : "r" (from), "r" (to) : "memory");
+		_ASM_EXTABLE_UACCESS(1b, 3b) : : "r" (from), "r" (to) : "memory");
 
 		from += 64;
 		to += 64;
@@ -294,7 +294,7 @@ static void fast_copy_page(void *to, void *from)
 		"3: movw $0x1AEB, 1b\n"	/* jmp on 26 bytes */
 		"   jmp 2b\n"
 		".previous\n"
-			_ASM_EXTABLE(1b, 3b) : : "r" (from));
+			_ASM_EXTABLE_UACCESS(1b, 3b) : : "r" (from));
 
 	for (i = 0; i < 4096/64; i++) {
 		__asm__ __volatile__ (
@@ -319,7 +319,7 @@ static void fast_copy_page(void *to, void *from)
 		"3: movw $0x05EB, 1b\n"	/* jmp on 5 bytes */
 		"   jmp 2b\n"
 		".previous\n"
-			_ASM_EXTABLE(1b, 3b)
+			_ASM_EXTABLE_UACCESS(1b, 3b)
 			: : "r" (from), "r" (to) : "memory");
 
 		from += 64;
diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
index f6d13ee..ded3bd5 100644
--- a/arch/x86/lib/msr-reg.S
+++ b/arch/x86/lib/msr-reg.S
@@ -43,7 +43,7 @@ ENTRY(\op\()_safe_regs)
 	movl    $-EIO, %r11d
 	jmp     2b
 
-	_ASM_EXTABLE(1b, 3b)
+	_ASM_EXTABLE_ANY(1b, 3b)
 	CFI_ENDPROC
 ENDPROC(\op\()_safe_regs)
 .endm
@@ -90,7 +90,7 @@ ENTRY(\op\()_safe_regs)
 	movl    $-EIO, 4(%esp)
 	jmp     2b
 
-	_ASM_EXTABLE(1b, 3b)
+	_ASM_EXTABLE_ANY(1b, 3b)
 	CFI_ENDPROC
 ENDPROC(\op\()_safe_regs)
 .endm
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index fc6ba17..b2fbb72 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -92,10 +92,10 @@ bad_put_user:
 	EXIT
 END(bad_put_user)
 
-	_ASM_EXTABLE(1b,bad_put_user)
-	_ASM_EXTABLE(2b,bad_put_user)
-	_ASM_EXTABLE(3b,bad_put_user)
-	_ASM_EXTABLE(4b,bad_put_user)
+	_ASM_EXTABLE_UACCESS(1b,bad_put_user)
+	_ASM_EXTABLE_UACCESS(2b,bad_put_user)
+	_ASM_EXTABLE_UACCESS(3b,bad_put_user)
+	_ASM_EXTABLE_UACCESS(4b,bad_put_user)
 #ifdef CONFIG_X86_32
-	_ASM_EXTABLE(5b,bad_put_user)
+	_ASM_EXTABLE_UACCESS(5b,bad_put_user)
 #endif
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index f0312d7..0884951 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -51,8 +51,8 @@ do {									\
 		"3:	lea 0(%2,%0,4),%0\n"				\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		_ASM_EXTABLE(0b,3b)					\
-		_ASM_EXTABLE(1b,2b)					\
+		_ASM_EXTABLE_UACCESS(0b,3b)					\
+		_ASM_EXTABLE_UACCESS(1b,2b)					\
 		: "=&c"(size), "=&D" (__d0)				\
 		: "r"(size & 3), "0"(size / 4), "1"(addr), "a"(0));	\
 } while (0)
@@ -157,44 +157,44 @@ __copy_user_intel(void __user *to, const void *from, unsigned long size)
 		       "101:   lea 0(%%eax,%0,4),%0\n"
 		       "       jmp 100b\n"
 		       ".previous\n"
-		       _ASM_EXTABLE(1b,100b)
-		       _ASM_EXTABLE(2b,100b)
-		       _ASM_EXTABLE(3b,100b)
-		       _ASM_EXTABLE(4b,100b)
-		       _ASM_EXTABLE(5b,100b)
-		       _ASM_EXTABLE(6b,100b)
-		       _ASM_EXTABLE(7b,100b)
-		       _ASM_EXTABLE(8b,100b)
-		       _ASM_EXTABLE(9b,100b)
-		       _ASM_EXTABLE(10b,100b)
-		       _ASM_EXTABLE(11b,100b)
-		       _ASM_EXTABLE(12b,100b)
-		       _ASM_EXTABLE(13b,100b)
-		       _ASM_EXTABLE(14b,100b)
-		       _ASM_EXTABLE(15b,100b)
-		       _ASM_EXTABLE(16b,100b)
-		       _ASM_EXTABLE(17b,100b)
-		       _ASM_EXTABLE(18b,100b)
-		       _ASM_EXTABLE(19b,100b)
-		       _ASM_EXTABLE(20b,100b)
-		       _ASM_EXTABLE(21b,100b)
-		       _ASM_EXTABLE(22b,100b)
-		       _ASM_EXTABLE(23b,100b)
-		       _ASM_EXTABLE(24b,100b)
-		       _ASM_EXTABLE(25b,100b)
-		       _ASM_EXTABLE(26b,100b)
-		       _ASM_EXTABLE(27b,100b)
-		       _ASM_EXTABLE(28b,100b)
-		       _ASM_EXTABLE(29b,100b)
-		       _ASM_EXTABLE(30b,100b)
-		       _ASM_EXTABLE(31b,100b)
-		       _ASM_EXTABLE(32b,100b)
-		       _ASM_EXTABLE(33b,100b)
-		       _ASM_EXTABLE(34b,100b)
-		       _ASM_EXTABLE(35b,100b)
-		       _ASM_EXTABLE(36b,100b)
-		       _ASM_EXTABLE(37b,100b)
-		       _ASM_EXTABLE(99b,101b)
+		       _ASM_EXTABLE_UACCESS(1b,100b)
+		       _ASM_EXTABLE_UACCESS(2b,100b)
+		       _ASM_EXTABLE_UACCESS(3b,100b)
+		       _ASM_EXTABLE_UACCESS(4b,100b)
+		       _ASM_EXTABLE_UACCESS(5b,100b)
+		       _ASM_EXTABLE_UACCESS(6b,100b)
+		       _ASM_EXTABLE_UACCESS(7b,100b)
+		       _ASM_EXTABLE_UACCESS(8b,100b)
+		       _ASM_EXTABLE_UACCESS(9b,100b)
+		       _ASM_EXTABLE_UACCESS(10b,100b)
+		       _ASM_EXTABLE_UACCESS(11b,100b)
+		       _ASM_EXTABLE_UACCESS(12b,100b)
+		       _ASM_EXTABLE_UACCESS(13b,100b)
+		       _ASM_EXTABLE_UACCESS(14b,100b)
+		       _ASM_EXTABLE_UACCESS(15b,100b)
+		       _ASM_EXTABLE_UACCESS(16b,100b)
+		       _ASM_EXTABLE_UACCESS(17b,100b)
+		       _ASM_EXTABLE_UACCESS(18b,100b)
+		       _ASM_EXTABLE_UACCESS(19b,100b)
+		       _ASM_EXTABLE_UACCESS(20b,100b)
+		       _ASM_EXTABLE_UACCESS(21b,100b)
+		       _ASM_EXTABLE_UACCESS(22b,100b)
+		       _ASM_EXTABLE_UACCESS(23b,100b)
+		       _ASM_EXTABLE_UACCESS(24b,100b)
+		       _ASM_EXTABLE_UACCESS(25b,100b)
+		       _ASM_EXTABLE_UACCESS(26b,100b)
+		       _ASM_EXTABLE_UACCESS(27b,100b)
+		       _ASM_EXTABLE_UACCESS(28b,100b)
+		       _ASM_EXTABLE_UACCESS(29b,100b)
+		       _ASM_EXTABLE_UACCESS(30b,100b)
+		       _ASM_EXTABLE_UACCESS(31b,100b)
+		       _ASM_EXTABLE_UACCESS(32b,100b)
+		       _ASM_EXTABLE_UACCESS(33b,100b)
+		       _ASM_EXTABLE_UACCESS(34b,100b)
+		       _ASM_EXTABLE_UACCESS(35b,100b)
+		       _ASM_EXTABLE_UACCESS(36b,100b)
+		       _ASM_EXTABLE_UACCESS(37b,100b)
+		       _ASM_EXTABLE_UACCESS(99b,101b)
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -267,26 +267,26 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 		       "        popl %0\n"
 		       "        jmp 8b\n"
 		       ".previous\n"
-		       _ASM_EXTABLE(0b,16b)
-		       _ASM_EXTABLE(1b,16b)
-		       _ASM_EXTABLE(2b,16b)
-		       _ASM_EXTABLE(21b,16b)
-		       _ASM_EXTABLE(3b,16b)
-		       _ASM_EXTABLE(31b,16b)
-		       _ASM_EXTABLE(4b,16b)
-		       _ASM_EXTABLE(41b,16b)
-		       _ASM_EXTABLE(10b,16b)
-		       _ASM_EXTABLE(51b,16b)
-		       _ASM_EXTABLE(11b,16b)
-		       _ASM_EXTABLE(61b,16b)
-		       _ASM_EXTABLE(12b,16b)
-		       _ASM_EXTABLE(71b,16b)
-		       _ASM_EXTABLE(13b,16b)
-		       _ASM_EXTABLE(81b,16b)
-		       _ASM_EXTABLE(14b,16b)
-		       _ASM_EXTABLE(91b,16b)
-		       _ASM_EXTABLE(6b,9b)
-		       _ASM_EXTABLE(7b,16b)
+		       _ASM_EXTABLE_UACCESS(0b,16b)
+		       _ASM_EXTABLE_UACCESS(1b,16b)
+		       _ASM_EXTABLE_UACCESS(2b,16b)
+		       _ASM_EXTABLE_UACCESS(21b,16b)
+		       _ASM_EXTABLE_UACCESS(3b,16b)
+		       _ASM_EXTABLE_UACCESS(31b,16b)
+		       _ASM_EXTABLE_UACCESS(4b,16b)
+		       _ASM_EXTABLE_UACCESS(41b,16b)
+		       _ASM_EXTABLE_UACCESS(10b,16b)
+		       _ASM_EXTABLE_UACCESS(51b,16b)
+		       _ASM_EXTABLE_UACCESS(11b,16b)
+		       _ASM_EXTABLE_UACCESS(61b,16b)
+		       _ASM_EXTABLE_UACCESS(12b,16b)
+		       _ASM_EXTABLE_UACCESS(71b,16b)
+		       _ASM_EXTABLE_UACCESS(13b,16b)
+		       _ASM_EXTABLE_UACCESS(81b,16b)
+		       _ASM_EXTABLE_UACCESS(14b,16b)
+		       _ASM_EXTABLE_UACCESS(91b,16b)
+		       _ASM_EXTABLE_UACCESS(6b,9b)
+		       _ASM_EXTABLE_UACCESS(7b,16b)
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -366,26 +366,26 @@ static unsigned long __copy_user_zeroing_intel_nocache(void *to,
 	       "        popl %0\n"
 	       "        jmp 8b\n"
 	       ".previous\n"
-	       _ASM_EXTABLE(0b,16b)
-	       _ASM_EXTABLE(1b,16b)
-	       _ASM_EXTABLE(2b,16b)
-	       _ASM_EXTABLE(21b,16b)
-	       _ASM_EXTABLE(3b,16b)
-	       _ASM_EXTABLE(31b,16b)
-	       _ASM_EXTABLE(4b,16b)
-	       _ASM_EXTABLE(41b,16b)
-	       _ASM_EXTABLE(10b,16b)
-	       _ASM_EXTABLE(51b,16b)
-	       _ASM_EXTABLE(11b,16b)
-	       _ASM_EXTABLE(61b,16b)
-	       _ASM_EXTABLE(12b,16b)
-	       _ASM_EXTABLE(71b,16b)
-	       _ASM_EXTABLE(13b,16b)
-	       _ASM_EXTABLE(81b,16b)
-	       _ASM_EXTABLE(14b,16b)
-	       _ASM_EXTABLE(91b,16b)
-	       _ASM_EXTABLE(6b,9b)
-	       _ASM_EXTABLE(7b,16b)
+	       _ASM_EXTABLE_UACCESS(0b,16b)
+	       _ASM_EXTABLE_UACCESS(1b,16b)
+	       _ASM_EXTABLE_UACCESS(2b,16b)
+	       _ASM_EXTABLE_UACCESS(21b,16b)
+	       _ASM_EXTABLE_UACCESS(3b,16b)
+	       _ASM_EXTABLE_UACCESS(31b,16b)
+	       _ASM_EXTABLE_UACCESS(4b,16b)
+	       _ASM_EXTABLE_UACCESS(41b,16b)
+	       _ASM_EXTABLE_UACCESS(10b,16b)
+	       _ASM_EXTABLE_UACCESS(51b,16b)
+	       _ASM_EXTABLE_UACCESS(11b,16b)
+	       _ASM_EXTABLE_UACCESS(61b,16b)
+	       _ASM_EXTABLE_UACCESS(12b,16b)
+	       _ASM_EXTABLE_UACCESS(71b,16b)
+	       _ASM_EXTABLE_UACCESS(13b,16b)
+	       _ASM_EXTABLE_UACCESS(81b,16b)
+	       _ASM_EXTABLE_UACCESS(14b,16b)
+	       _ASM_EXTABLE_UACCESS(91b,16b)
+	       _ASM_EXTABLE_UACCESS(6b,9b)
+	       _ASM_EXTABLE_UACCESS(7b,16b)
 	       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 	       :  "1"(to), "2"(from), "0"(size)
 	       : "eax", "edx", "memory");
@@ -454,26 +454,26 @@ static unsigned long __copy_user_intel_nocache(void *to,
 	       "9:      lea 0(%%eax,%0,4),%0\n"
 	       "16:     jmp 8b\n"
 	       ".previous\n"
-	       _ASM_EXTABLE(0b,16b)
-	       _ASM_EXTABLE(1b,16b)
-	       _ASM_EXTABLE(2b,16b)
-	       _ASM_EXTABLE(21b,16b)
-	       _ASM_EXTABLE(3b,16b)
-	       _ASM_EXTABLE(31b,16b)
-	       _ASM_EXTABLE(4b,16b)
-	       _ASM_EXTABLE(41b,16b)
-	       _ASM_EXTABLE(10b,16b)
-	       _ASM_EXTABLE(51b,16b)
-	       _ASM_EXTABLE(11b,16b)
-	       _ASM_EXTABLE(61b,16b)
-	       _ASM_EXTABLE(12b,16b)
-	       _ASM_EXTABLE(71b,16b)
-	       _ASM_EXTABLE(13b,16b)
-	       _ASM_EXTABLE(81b,16b)
-	       _ASM_EXTABLE(14b,16b)
-	       _ASM_EXTABLE(91b,16b)
-	       _ASM_EXTABLE(6b,9b)
-	       _ASM_EXTABLE(7b,16b)
+	       _ASM_EXTABLE_UACCESS(0b,16b)
+	       _ASM_EXTABLE_UACCESS(1b,16b)
+	       _ASM_EXTABLE_UACCESS(2b,16b)
+	       _ASM_EXTABLE_UACCESS(21b,16b)
+	       _ASM_EXTABLE_UACCESS(3b,16b)
+	       _ASM_EXTABLE_UACCESS(31b,16b)
+	       _ASM_EXTABLE_UACCESS(4b,16b)
+	       _ASM_EXTABLE_UACCESS(41b,16b)
+	       _ASM_EXTABLE_UACCESS(10b,16b)
+	       _ASM_EXTABLE_UACCESS(51b,16b)
+	       _ASM_EXTABLE_UACCESS(11b,16b)
+	       _ASM_EXTABLE_UACCESS(61b,16b)
+	       _ASM_EXTABLE_UACCESS(12b,16b)
+	       _ASM_EXTABLE_UACCESS(71b,16b)
+	       _ASM_EXTABLE_UACCESS(13b,16b)
+	       _ASM_EXTABLE_UACCESS(81b,16b)
+	       _ASM_EXTABLE_UACCESS(14b,16b)
+	       _ASM_EXTABLE_UACCESS(91b,16b)
+	       _ASM_EXTABLE_UACCESS(6b,9b)
+	       _ASM_EXTABLE_UACCESS(7b,16b)
 	       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 	       :  "1"(to), "2"(from), "0"(size)
 	       : "eax", "edx", "memory");
@@ -520,9 +520,9 @@ do {									\
 		"3:	lea 0(%3,%0,4),%0\n"				\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		_ASM_EXTABLE(4b,5b)					\
-		_ASM_EXTABLE(0b,3b)					\
-		_ASM_EXTABLE(1b,2b)					\
+		_ASM_EXTABLE_UACCESS(4b,5b)					\
+		_ASM_EXTABLE_UACCESS(0b,3b)					\
+		_ASM_EXTABLE_UACCESS(1b,2b)					\
 		: "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)	\
 		: "3"(size), "0"(size), "1"(to), "2"(from)		\
 		: "memory");						\
@@ -559,9 +559,9 @@ do {									\
 		"	popl %0\n"					\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		_ASM_EXTABLE(4b,5b)					\
-		_ASM_EXTABLE(0b,3b)					\
-		_ASM_EXTABLE(1b,6b)					\
+		_ASM_EXTABLE_UACCESS(4b,5b)					\
+		_ASM_EXTABLE_UACCESS(0b,3b)					\
+		_ASM_EXTABLE_UACCESS(1b,6b)					\
 		: "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)	\
 		: "3"(size), "0"(size), "1"(to), "2"(from)		\
 		: "memory");						\
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 906fea3..bcc15a1 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -36,8 +36,8 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 		"3:	lea 0(%[size1],%[size8],8),%[size8]\n"
 		"	jmp 2b\n"
 		".previous\n"
-		_ASM_EXTABLE(0b,3b)
-		_ASM_EXTABLE(1b,2b)
+		_ASM_EXTABLE_UACCESS(0b,3b)
+		_ASM_EXTABLE_UACCESS(1b,2b)
 		: [size8] "=&c"(size), [dst] "=&D" (__d0)
 		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr),
 		  [zero] "r" (0UL), [eight] "r" (8UL));
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2d19001..47471d0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -890,7 +890,7 @@ static noinline int do_test_wp_bit(void)
 		"1:	movb %1, %0	\n"
 		"	xorl %2, %2	\n"
 		"2:			\n"
-		_ASM_EXTABLE(1b,2b)
+		_ASM_EXTABLE_ANY(1b,2b)
 		:"=m" (*(char *)fix_to_virt(FIX_WP_TEST)),
 		 "=q" (tmp_reg),
 		 "=r" (flag)
diff --git a/arch/x86/um/checksum_32.S b/arch/x86/um/checksum_32.S
index 8d0c420..30289b8 100644
--- a/arch/x86/um/checksum_32.S
+++ b/arch/x86/um/checksum_32.S
@@ -233,11 +233,11 @@ unsigned int csum_partial_copy_generic (const char *src, char *dst,
 
 #define SRC(y...)			\
 	9999: y;			\
-	_ASM_EXTABLE(9999b, 6001f)
+	_ASM_EXTABLE_UACCESS(9999b, 6001f)
 
 #define DST(y...)			\
 	9999: y;			\
-	_ASM_EXTABLE(9999b, 6002f)
+	_ASM_EXTABLE_UACCESS(9999b, 6002f)
 
 .align 4
 
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 33ca6e4..57c63ac 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -138,7 +138,7 @@ iret_restore_end:
 
 1:	iret
 xen_iret_end_crit:
-	_ASM_EXTABLE(1b, iret_exc)
+	_ASM_EXTABLE_ANY(1b, iret_exc)
 
 hyper_iret:
 	/* put this out of line since its very rarely used */
-- 
1.8.1.4
