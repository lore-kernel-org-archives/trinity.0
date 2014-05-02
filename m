From: Richard Weinberger <richard@nod.at>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Fri, 02 May 2014 09:46:44 +0200
Message-ID: <53634D64.5060407@nod.at>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com> <536221F4.6000405@gmx.de> <53623EFE.3040603@nod.at> <5362651A.1020504@gmx.de> <5362B53E.5060601@nod.at> <5362BDD1.9070105@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070301080600030809040306"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <5362BDD1.9070105@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------070301080600030809040306
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Am 01.05.2014 23:34, schrieb Toralf Förster:
> On 05/01/2014 10:57 PM, Richard Weinberger wrote:
>> Toralf,
>>
>> Yeah, this is because trinity destroys the UML stub code.
>> Please test the attached patch, it should fix the root cause of the problem.
>>
>> Thanks,
>> //richard
>>
> 
> If I do just apply fix2.patch onto latest git tree  v3.15-rc3-113-gba6728f then I do get after a while :
> 
>  * Starting sshd ...                                                                                                  [ ok ]
>  * Starting local
> net.core.warnings = 0                                                                                                 [ ok ]
> Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed, errno = 3
> 
> CPU: 0 PID: 1728 Comm: trinity-c0 Not tainted 3.15.0-rc3-00113-gba6728f-dirty #5
> Stack:
> BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c0:1728]
> 
> EIP: c500:[<47c6cf00>] CPU: 0 Not tainted EFLAGS: 476af700
>     Not tainted
> EAX: 47cfc500 EBX: 0a024d00 ECX: 086c75fc EDX: 080fff88
> ESI: 0839f4bc EDI: 47cfc500 EBP: 0839f4bc DS: c500 ES: cd62
> EXT4-fs (ubda): error count: 1
> EXT4-fs (ubda): initial error at 1398962134: ext4_mb_generate_buddy:756
> EXT4-fs (ubda): last error at 1398962134: ext4_mb_generate_buddy:756
> 
> 
> which is a big improvement because before it crashes immediately after few seconds.
> 
> After applying both fixes the test case runs w/o a crash till now.

Can you please also try fix3 (without fix1/2)?
I think I've found the other hidden issue.
So far trinity did not crash my kernel...

Thanks,
//richard

--------------070301080600030809040306
Content-Type: text/x-patch;
 name="fix3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix3.patch"

diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 9472079..f1b3eb1 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -12,6 +12,7 @@
 #include <mem_user.h>
 #include <os.h>
 #include <skas.h>
+#include <kern_util.h>
 
 struct host_vm_change {
 	struct host_vm_op {
@@ -124,6 +125,9 @@ static int add_munmap(unsigned long addr, unsigned long len,
 	struct host_vm_op *last;
 	int ret = 0;
 
+	if ((addr >= STUB_START) && (addr < STUB_END))
+		return -EINVAL;
+
 	if (hvc->index != 0) {
 		last = &hvc->ops[hvc->index - 1];
 		if ((last->type == MUNMAP) &&
@@ -283,8 +287,11 @@ void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 	/* This is not an else because ret is modified above */
 	if (ret) {
 		printk(KERN_ERR "fix_range_common: failed, killing current "
-		       "process\n");
+		       "process: %d\n", task_tgid_vnr(current));
+		/* We are under mmap_sem, release it such that current can terminate */
+		up_write(&current->mm->mmap_sem);
 		force_sig(SIGKILL, current);
+		do_signal();
 	}
 }
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index d531879..908579f 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -54,7 +54,7 @@ static int ptrace_dump_regs(int pid)
 
 void wait_stub_done(int pid)
 {
-	int n, status, err, bad_stop = 0;
+	int n, status, err;
 
 	while (1) {
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
@@ -74,8 +74,6 @@ void wait_stub_done(int pid)
 
 	if (((1 << WSTOPSIG(status)) & STUB_DONE_MASK) != 0)
 		return;
-	else
-		bad_stop = 1;
 
 bad_wait:
 	err = ptrace_dump_regs(pid);
@@ -85,10 +83,7 @@ bad_wait:
 	printk(UM_KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
 	       "pid = %d, n = %d, errno = %d, status = 0x%x\n", pid, n, errno,
 	       status);
-	if (bad_stop)
-		kill(pid, SIGKILL);
-	else
-		fatal_sigsegv();
+	fatal_sigsegv();
 }
 
 extern unsigned long current_stub_stack(void);

--------------070301080600030809040306--
