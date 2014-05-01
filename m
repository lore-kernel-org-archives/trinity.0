From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap" at
 a 32 bit user mode linux
Date: Thu, 1 May 2014 11:22:17 +0200
Message-ID: <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com>
References: <53613E96.2030006@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=GbqJNBe5ug/xZ4OLO6rcStw05EDtDpx0u5uF/NPI9jA=;
        b=mNHqNAxDq21CcmbDZ6Ab9Hy3UOqF+uBBev+sK+NlGZUpkJQsokmQc62lSA1d3HnkCw
         gPvfjXSBwxjieGCstW9qcuG4NuMvtO0S79esqohNFILAj+l8gmUHtk/U6HduAEegJV12
         KsnlHGAa9HheB51PrRsVUCc0f1No0cAwLf3MjzTbK+kPNeLp+LigJexh3ZuLWplDUk5l
         O7P+9xElx9+wUNv3l2xw5VCDIM59BxSQcKymPBfiWdlU/tPGOgrqDw419TrS4YQrBOc/
         F4goRKsHuzHg8wSYWU6TQM0t5PftT0mM4mJrMTqg1/4sy+Ob/TVeelukZxXMRWb1aOHQ
         H9dA==
In-Reply-To: <53613E96.2030006@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On Wed, Apr 30, 2014 at 8:19 PM, Toralf F=C3=B6rster <toralf.foerster@g=
mx.de> wrote:
> -or- it uncovers a bug in kernel v3.15-rc3 for UML:

UML most not panic. :)

Do you have the trinity logs?
I'd like to know the syscalls parameters.

It looks like trinity managed it to crash a thread on the host side.
This is why ptrace() failed with ESRCH.

>
>
> commit 23dc478aba4134db51584d19e4783ec87ce87b88
> Author: Dave Jones <davej@redhat.com>
> Date:   Tue Apr 29 16:42:45 2014 -0400
>
>     non-biarch arches aren't necessarily 32-bit.
>
> diff --git a/children/random-syscalls.c b/children/random-syscalls.c
> index 82e49f5..1d7e7ce 100644
> --- a/children/random-syscalls.c
> +++ b/children/random-syscalls.c
> @@ -32,7 +32,6 @@ static bool choose_syscall_table(void)
>
>         if (biarch =3D=3D FALSE) {
>                 active_syscalls =3D shm->active_syscalls;
> -               do32 =3D TRUE;
>         } else {
>
>                 /* First, check that we have syscalls enabled in eith=
er table. */
>
>
>
>
> I do get :
>
>
> Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed, =
errno =3D 3
>
> CPU: 0 PID: 1303 Comm: trinity-c0 Not tainted 3.15.0-rc3 #1
> Stack:
>  085a4f54 085a4f54 4841fc48 00000004 086c8547 00002b58 00000003 00000=
011
>  4841fc58 084eae75 00000000 00000000 4841fc80 084e72e0 085b08e8 08700=
960
>  085ad7b4 4841fc90 00000000 00002b58 00000003 00000011 4841fcb4 08073=
4c5
> Call Trace:
>  [<080734c5>] ? run_syscall_stub+0x125/0x2c0
>  [<084eae75>] dump_stack+0x26/0x28
>  [<084e72e0>] panic+0x7a/0x194
>  [<080734c5>] run_syscall_stub+0x125/0x2c0
>  [<08073b15>] unmap+0xf5/0x110
>  [<08061047>] do_ops+0xb7/0x160
>  [<080615f8>] fix_range_common+0x448/0x480
>  [<080e50f4>] ? vma_interval_tree_insert+0x74/0x80
>  [<0806193e>] flush_tlb_range+0x3e/0x40
>  [<080f045e>] move_page_tables+0x24e/0x280
>  [<080f0577>] move_vma+0xe7/0x230
>  [<080eda20>] ? get_unmapped_area+0xa0/0xc0
>  [<080f08b8>] SyS_mremap+0x1f8/0x4c0
>  [<08062ab4>] handle_syscall+0x64/0x80
>  [<0849d4f1>] ? ptrace+0x31/0x80
>  [<080797a2>] ? get_fp_registers+0x22/0x40
>  [<08074815>] userspace+0x475/0x5f0
>  [<0849d4f1>] ? ptrace+0x31/0x80
>  [<08079d06>] ? os_set_thread_area+0x26/0x40
>  [<08078cd0>] ? do_set_thread_area+0x20/0x50
>  [<08078e48>] ? arch_switch_tls+0xb8/0x100
>  [<0805f770>] fork_handler+0x60/0x70
>
> /home/tfoerste/workspace/bin/start_uml.sh: line 110:  9558 Aborted   =
              (core dumped) $LINUX earlyprintk ubda=3D$ROOTFS ubdb=3D$S=
WAP eth0=3D$NET mem=3D$MEM $TTY umid=3Duml_$NAME rootfstype=3Dext4 "$AR=
GS"
>
>
> --
> Toralf
>
>
> ---------------------------------------------------------------------=
---------
> "Accelerate Dev Cycles with Automated Cross-Browser Testing - For FRE=
E
> Instantly run your Selenium tests across 300+ browser/OS combos.  Get
> unparalleled scalability from the best Selenium testing platform avai=
lable.
> Simple to use. Nothing to install. Get started now for free."
> http://p.sf.net/sfu/SauceLabs
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel



--=20
Thanks,
//richard
