From: Richard Weinberger <richard@nod.at>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Thu, 01 May 2014 22:57:34 +0200
Message-ID: <5362B53E.5060601@nod.at>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com> <536221F4.6000405@gmx.de> <53623EFE.3040603@nod.at> <5362651A.1020504@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070604030702020703050302"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <5362651A.1020504@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------070604030702020703050302
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Toralf,

Am 01.05.2014 17:15, schrieb Toralf Förster:
> On 05/01/2014 02:33 PM, Richard Weinberger wrote:
>> Am 01.05.2014 12:29, schrieb Toralf Förster:
>>> On 05/01/2014 11:22 AM, Richard Weinberger wrote:
>>>> On Wed, Apr 30, 2014 at 8:19 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>> -or- it uncovers a bug in kernel v3.15-rc3 for UML:
>>>>
>>>> UML most not panic. :)
>>>>
>>>> Do you have the trinity logs?
>>>> I'd like to know the syscalls parameters.
>>> I run trinity with "-C 2 -c mremap" within the guest, the logs are attached
>>
>> Can you please try the attached pre-patch?
>> It looks like the panic() in that code is an overreaction.
>> I'm currently looking deeper in the issue.
>>
>> BTW: If you hit "BUG: failure at mm/filemap.c:202/__delete_from_page_cache()!",
>> this is a known issue https://lkml.org/lkml/2014/4/15/577
>>
>> Thanks,
>> //richard
>>
> 
> That patch helps a lot, in the syslog I do now get :
> 
> May  1 17:13:48 trinity kernel: Stub registers -
> May  1 17:13:48 trinity kernel:         0 - 100000
> May  1 17:13:48 trinity kernel:         1 - 2000
> May  1 17:13:48 trinity kernel:         2 - 0
> May  1 17:13:48 trinity kernel:         3 - 0
> May  1 17:13:48 trinity kernel:         4 - 0
> May  1 17:13:48 trinity kernel:         5 - 0
> May  1 17:13:48 trinity kernel:         6 - 0
> May  1 17:13:48 trinity kernel:         7 - 7b
> May  1 17:13:48 trinity kernel:         8 - 7b
> May  1 17:13:48 trinity kernel:         9 - 0
> May  1 17:13:48 trinity kernel:         10 - 33
> May  1 17:13:48 trinity kernel:         11 - ffffffff
> May  1 17:13:48 trinity kernel:         12 - 1000c3
> May  1 17:13:48 trinity kernel:         13 - 73
> May  1 17:13:48 trinity kernel:         14 - 10206
> May  1 17:13:48 trinity kernel:         15 - 101028
> May  1 17:13:48 trinity kernel:         16 - 7b
> May  1 17:13:48 trinity kernel: wait_stub_done : failed to wait for SIGTRAP, pid = 14757, n = 14757, errno = 0, status = 0xb7f
> May  1 17:13:48 trinity kernel: do_syscall_stub : ret = 0, offset = 1052680, data = 47788008
> May  1 17:13:48 trinity kernel: do_syscall_stub: syscall 91 failed, return value = 0x0, expected return value = 0x0
> May  1 17:13:48 trinity kernel: syscall parameters: 0x100000 0x2000 0x0 0x0 0x0 0x0
> May  1 17:13:48 trinity kernel: Registers - 
> May  1 17:13:48 trinity kernel:         0       0x2c92
> May  1 17:13:48 trinity kernel:         1       0x13
> May  1 17:13:48 trinity kernel:         2       0x2c92
> May  1 17:13:48 trinity kernel:         3       0x2c8e
> May  1 17:13:48 trinity kernel:         4       0xbfa39508
> May  1 17:13:48 trinity kernel:         5       0xbfa394ec
> May  1 17:13:48 trinity kernel:         6       0x0
> May  1 17:13:48 trinity kernel:         7       0x7b
> May  1 17:13:48 trinity kernel:         8       0x7b
> May  1 17:13:48 trinity kernel:         9       0x0
> May  1 17:13:48 trinity kernel:         10      0x33
> May  1 17:13:48 trinity kernel:         11      0x25
> May  1 17:13:48 trinity kernel:         12      0x1000a0
> May  1 17:13:48 trinity kernel:         13      0x73
> May  1 17:13:48 trinity kernel:         14      0x246
> May  1 17:13:48 trinity kernel:         15      0xbfa394b8
> May  1 17:13:48 trinity kernel:         16      0x7b
> May  1 17:13:48 trinity kernel: do_syscall_stub : PTRACE_SETREGS failed, pid = 14757, errno = 3
> May  1 17:13:48 trinity kernel: fix_range_common: failed, killing current process
> May  1 17:13:48 trinity kernel: BUG: Bad rss-counter state mm:475aab40 idx:0 val:1
> May  1 17:13:48 trinity kernel: Stub registers -
> May  1 17:13:48 trinity kernel:         0 - 100000
> May  1 17:13:48 trinity kernel:         1 - 2000
> May  1 17:13:48 trinity kernel:         2 - 0
> May  1 17:13:48 trinity kernel:         3 - 0
> May  1 17:13:48 trinity kernel:         4 - 0
> May  1 17:13:48 trinity kernel:         5 - 0
> May  1 17:13:48 trinity kernel:         6 - 0
> May  1 17:13:48 trinity kernel:         7 - 7b
> May  1 17:13:48 trinity kernel:         8 - 7b
> May  1 17:13:48 trinity kernel:         9 - 0
> May  1 17:13:48 trinity kernel:         10 - 33
> May  1 17:13:48 trinity kernel:         11 - ffffffff
> May  1 17:13:48 trinity kernel:         12 - 1000c3
> May  1 17:13:48 trinity kernel:         13 - 73
> May  1 17:13:48 trinity kernel:         14 - 10206
> May  1 17:13:48 trinity kernel:         15 - 101028
> May  1 17:13:48 trinity kernel:         16 - 7b
> May  1 17:13:48 trinity kernel: wait_stub_done : failed to wait for SIGTRAP, pid = 14758, n = 14758, errno = 0, status = 0xb7f
> May  1 17:13:48 trinity kernel: do_syscall_stub : ret = 0, offset = 1052680, data = 477a9008
> May  1 17:13:48 trinity kernel: do_syscall_stub: syscall 91 failed, return value = 0x0, expected return value = 0x0
> May  1 17:13:48 trinity kernel: syscall parameters: 0x100000 0x2000 0x0 0x0 0x0 0x0

Yeah, this is because trinity destroys the UML stub code.
Please test the attached patch, it should fix the root cause of the problem.

Thanks,
//richard

--------------070604030702020703050302
Content-Type: text/x-patch;
 name="fix2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix2.patch"

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
 

--------------070604030702020703050302--
