From: Richard Weinberger <richard@nod.at>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Thu, 01 May 2014 14:33:02 +0200
Message-ID: <53623EFE.3040603@nod.at>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com> <536221F4.6000405@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070904020705090505030100"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <536221F4.6000405@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------070904020705090505030100
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Am 01.05.2014 12:29, schrieb Toralf Förster:
> On 05/01/2014 11:22 AM, Richard Weinberger wrote:
>> On Wed, Apr 30, 2014 at 8:19 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>> -or- it uncovers a bug in kernel v3.15-rc3 for UML:
>>
>> UML most not panic. :)
>>
>> Do you have the trinity logs?
>> I'd like to know the syscalls parameters.
> I run trinity with "-C 2 -c mremap" within the guest, the logs are attached

Can you please try the attached pre-patch?
It looks like the panic() in that code is an overreaction.
I'm currently looking deeper in the issue.

BTW: If you hit "BUG: failure at mm/filemap.c:202/__delete_from_page_cache()!",
this is a known issue https://lkml.org/lkml/2014/4/15/577

Thanks,
//richard

--------------070904020705090505030100
Content-Type: text/x-patch;
 name="fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix.patch"

diff --git a/arch/um/os-Linux/skas/mem.c b/arch/um/os-Linux/skas/mem.c
index 689b18d..2ce5d49 100644
--- a/arch/um/os-Linux/skas/mem.c
+++ b/arch/um/os-Linux/skas/mem.c
@@ -65,14 +65,17 @@ static inline long do_syscall_stub(struct mm_id * mm_idp, void **addr)
 		printk(UM_KERN_ERR "Registers - \n");
 		for (i = 0; i < MAX_REG_NR; i++)
 			printk(UM_KERN_ERR "\t%d\t0x%lx\n", i, syscall_regs[i]);
-		panic("do_syscall_stub : PTRACE_SETREGS failed, errno = %d\n",
-		      -n);
+		printk(KERN_ERR "do_syscall_stub : PTRACE_SETREGS failed, pid = %d, errno = %d\n",
+		      pid, -n);
+		return -EFAULT;
 	}
 
 	err = ptrace(PTRACE_CONT, pid, 0, 0);
-	if (err)
-		panic("Failed to continue stub, pid = %d, errno = %d\n", pid,
+	if (err) {
+		printk(KERN_ERR "Failed to continue stub, pid = %d, errno = %d\n", pid,
 		      errno);
+		return -EFAULT;
+	}
 
 	wait_stub_done(pid);
 

--------------070904020705090505030100--
