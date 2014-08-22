From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: drm_mode_create_dumb_ioctl: divide error
Date: Fri, 22 Aug 2014 12:38:49 +0200
Message-ID: <CANq1E4TZPZQSP2wWLG2LJmf1YXyRnv0rtMyKGkjsfSV50RDSnA@mail.gmail.com>
References: <CA+ydwtoGKP622R5XSSSvibd_5PtsQxtsijrdD23c-7waQvjC=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=kFtuzv420QJ/TvcILUgdQP4PF9tsPYj8Gs28cYkd4Hk=;
        b=bA1pn2B8ZJtPrtfRkKiIfb8OnlcijuJRWvx8Pj0EXidTwLv/h7c6M236ArPuUJ2DN/
         SvJFYCAfskbff5Uu37AcuL3dYMOB1ArM0KLRPFCbG2SmjCPrvLMX0I5A8d3WlzKO6nE5
         3Ohyg7ekEjNA06Tzd5lAba8YC1pqJF23K0zM3qxFrMMQhQuRxknis8KAp7Xfm4QtLLhG
         E8DFYOHzvBPQf5P8gD/SXpdIse0fl/zp3shn+0ebUiFfuV6hlNqhTdwUw4bfQtDYxVq4
         ORIAV2MKS234GQMrOW/YrcewhDUNhBuDpebjEaMAJUK97tuhIve1xsYdrAI+KgPqte6l
         L78A==
In-Reply-To: <CA+ydwtoGKP622R5XSSSvibd_5PtsQxtsijrdD23c-7waQvjC=g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: David Airlie <airlied@linux.ie>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

Hi

On Thu, Aug 21, 2014 at 8:18 PM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> Hello,
>
> Triggered this while fuzzing v3.17-rc1-51-g372b1db with Trinity.
>
> Tommi
>
>
> [drm:drm_mode_legacy_fb_format] *ERROR* bad bpp, assuming x8r8g8b8 pixel format
> divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
> CPU: 0 PID: 2854 Comm: trinity-c7 Not tainted 3.17.0-rc1+ #14
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> task: ffff88003926cac0 ti: ffff8800356b4000 task.ti: ffff8800356b4000
> RIP: 0010:[<ffffffff816688e3>]  [<ffffffff816688e3>]
> drm_mode_create_dumb_ioctl+0x53/0xa0
> RSP: 0018:ffff8800356b7dc0  EFLAGS: 00010246
> RAX: 00000000ffffffff RBX: ffff88003545da68 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff8800356b7e18 RDI: ffff88003d5c67b0
> RBP: ffff8800356b7dc8 R08: 0000000000000000 R09: 00000000ffffffff
> R10: 00000000ffffffff R11: ffffffff817f6d30 R12: 00000000000000b2
> R13: fffffffffffffff2 R14: ffff88003d5c67b0 R15: ffff88003545da68
> FS:  00007f06208fa700(0000) GS:ffff88003fa00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000001903108 CR3: 0000000036efa000 CR4: 00000000000006f0
> Stack:
>  ffff8800356b7e18 ffff8800356b7ec8 ffffffff8165ac60 ffff8800356b7df8
>  ffff8800356b7e18 ffff8800356b7e18 ffffffff824e1440 0000000000d52000
>  0000000000000020 00000000c02064b2 00000000fffffff2 ffffffffffffffff
> Call Trace:
>  [<ffffffff8165ac60>] drm_ioctl+0x3b0/0x640
>  [<ffffffff814b81b8>] ? avc_has_perm+0x218/0x2f0
>  [<ffffffff814b7fc0>] ? avc_has_perm+0x20/0x2f0
>  [<ffffffff81170bb8>] ? sched_clock_cpu+0xa8/0xf0
>  [<ffffffff812922a0>] do_vfs_ioctl+0x4d0/0x510
>  [<ffffffff814ba745>] ? selinux_file_ioctl+0xf5/0x100
>  [<ffffffff8129232e>] SyS_ioctl+0x4e/0x80
>  [<ffffffff822b10e9>] system_call_fastpath+0x16/0x1b
> Code: 55 41 b9 ff ff ff ff 41 83 c0 07 44 89 c8 41 c1 e8 03 48 89 e5
> 53 48 89 d3 31 d2 f7 f1 41 39 c0 77 46 41 0f af c8 31 d2 44 89 c8 <f7>
> f1 41 39 c2 77 36 41 0f af ca b8 ea ff ff ff 81 c1 ff 0f 00
> RIP  [<ffffffff816688e3>] drm_mode_create_dumb_ioctl+0x53/0xa0
>  RSP <ffff8800356b7dc0>
> ---[ end trace 6919129b71d9bf98 ]---
> [drm:drm_mode_legacy_fb_format] *ERROR* bad bpp, assuming x8r8g8b8 pixel format
>
>
>
> (gdb) list *0xffffffff816688e3
> 0xffffffff816688e3 is in drm_mode_create_dumb_ioctl
> (drivers/gpu/drm/drm_crtc.c:4703).
> 4698            /* overflow checks for 32bit size calculations */
> 4699            cpp = DIV_ROUND_UP(args->bpp, 8);
> 4700            if (cpp > 0xffffffffU / args->width)
> 4701                    return -EINVAL;
> 4702            stride = cpp * args->width;
> 4703            if (args->height > 0xffffffffU / stride)
> 4704                    return -EINVAL;

Hm, this doesn't make sense to me. args->bpp/width/height are
guaranteed to be non-zero and 32bit. Therefore, DIV_ROUND_UP() cannot
return 0 and "cpp" is thus non-zero. The overflow check makes sure
"cpp * args->width" cannot overflow, both are non-zero so "stride" is
non-zero and valid.

I cannot make much sense out of the x86 assembly below, so help welcome.

Thanks
David

> 4705
> 4706            /* test for wrap-around */
> 4707            size = args->height * stride;
> (gdb) disassemble drm_mode_create_dumb_ioctl
> Dump of assembler code for function drm_mode_create_dumb_ioctl:
>    0xffffffff81668890 <+0>:     mov    0x20(%rdi),%rax
>    0xffffffff81668894 <+4>:     mov    0x160(%rax),%r11
>    0xffffffff8166889b <+11>:    test   %r11,%r11
>    0xffffffff8166889e <+14>:    je     0xffffffff8166890f
> <drm_mode_create_dumb_ioctl+127>
>    0xffffffff816688a0 <+16>:    mov    0x4(%rsi),%ecx
>    0xffffffff816688a3 <+19>:    test   %ecx,%ecx
>    0xffffffff816688a5 <+21>:    je     0xffffffff81668918
> <drm_mode_create_dumb_ioctl+136>
>    0xffffffff816688a7 <+23>:    mov    (%rsi),%r10d
>    0xffffffff816688aa <+26>:    test   %r10d,%r10d
>    0xffffffff816688ad <+29>:    je     0xffffffff81668918
> <drm_mode_create_dumb_ioctl+136>
>    0xffffffff816688af <+31>:    mov    0x8(%rsi),%r8d
>    0xffffffff816688b3 <+35>:    test   %r8d,%r8d
>    0xffffffff816688b6 <+38>:    je     0xffffffff81668918
> <drm_mode_create_dumb_ioctl+136>
>    0xffffffff816688b8 <+40>:    push   %rbp
>    0xffffffff816688b9 <+41>:    mov    $0xffffffff,%r9d
>    0xffffffff816688bf <+47>:    add    $0x7,%r8d
>    0xffffffff816688c3 <+51>:    mov    %r9d,%eax
>    0xffffffff816688c6 <+54>:    shr    $0x3,%r8d
>    0xffffffff816688ca <+58>:    mov    %rsp,%rbp
>    0xffffffff816688cd <+61>:    push   %rbx
>    0xffffffff816688ce <+62>:    mov    %rdx,%rbx
>    0xffffffff816688d1 <+65>:    xor    %edx,%edx
>    0xffffffff816688d3 <+67>:    div    %ecx
>    0xffffffff816688d5 <+69>:    cmp    %eax,%r8d
>    0xffffffff816688d8 <+72>:    ja     0xffffffff81668920
> <drm_mode_create_dumb_ioctl+144>
>    0xffffffff816688da <+74>:    imul   %r8d,%ecx
>    0xffffffff816688de <+78>:    xor    %edx,%edx
>    0xffffffff816688e0 <+80>:    mov    %r9d,%eax
>    0xffffffff816688e3 <+83>:    div    %ecx
>    0xffffffff816688e5 <+85>:    cmp    %eax,%r10d
>    0xffffffff816688e8 <+88>:    ja     0xffffffff81668920
> <drm_mode_create_dumb_ioctl+144>
>    0xffffffff816688ea <+90>:    imul   %r10d,%ecx
>    0xffffffff816688ee <+94>:    mov    $0xffffffea,%eax
>    0xffffffff816688f3 <+99>:    add    $0xfff,%ecx
>    0xffffffff816688f9 <+105>:   and    $0xfffff000,%ecx
>    0xffffffff816688ff <+111>:   je     0xffffffff81668928
> <drm_mode_create_dumb_ioctl+152>
>    0xffffffff81668901 <+113>:   mov    %rsi,%rdx
>    0xffffffff81668904 <+116>:   mov    %rdi,%rsi
>    0xffffffff81668907 <+119>:   mov    %rbx,%rdi
>    0xffffffff8166890a <+122>:   callq  *%r11
>    0xffffffff8166890d <+125>:   jmp    0xffffffff81668928
> <drm_mode_create_dumb_ioctl+152>
>    0xffffffff8166890f <+127>:   mov    $0xffffffda,%eax
>    0xffffffff81668914 <+132>:   retq
>    0xffffffff81668915 <+133>:   nopl   (%rax)
>    0xffffffff81668918 <+136>:   mov    $0xffffffea,%eax
>    0xffffffff8166891d <+141>:   retq
>    0xffffffff8166891e <+142>:   xchg   %ax,%ax
>    0xffffffff81668920 <+144>:   mov    $0xffffffea,%eax
>    0xffffffff81668925 <+149>:   nopl   (%rax)
>    0xffffffff81668928 <+152>:   pop    %rbx
>    0xffffffff81668929 <+153>:   pop    %rbp
>    0xffffffff8166892a <+154>:   retq
> End of assembler dump.
> (gdb)
