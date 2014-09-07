From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: f2fs get_dnode_of_data oops
Date: Sun, 7 Sep 2014 22:20:44 +0300
Message-ID: <CA+ydwtrtyb5wQXCmyBigqufVz10UkKS76hVOY8mKc4FOyYmECw@mail.gmail.com>
References: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=49ls4zkHIzZdlNz61SKsxMeCp0K+7EgLg4VdNCaDPIY=;
        b=uWIZMjP0UDLwG0XaxKWeOdWd00ET0WRgkBW0QQuiVvdDU+p6Qt8HE/0xXJ4W+AETXO
         botA6zpAyLfgyWqo0Rl5s4Kn3CHpHxZFmsJOl4ecKEwbb9ZlvXUbLKIgF0sHwVTNsRgh
         hLanSUAAkyYiUaz5rhoGQ/L1G2SKGWZIGUxiSTcc+iRnawhb5/3vnK1SQJlkZxdzZnDw
         3GszOO2cuqCUTebehT/DezqRXH1IjLMbvxs8VFxv6NohwEMKi6HszE5Mk+JmIz827sSS
         JcnAaJrxWyqNpzY09ElS53gNsdRF6YOKAG5q5ktOTOGLj9g/88p/iAqJz0GGFc3QtnlU
         Pmlw==
In-Reply-To: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

2014-09-07 22:14 GMT+03:00 Tommi Rantala <tt.rantala@gmail.com>:
> Hello,
>
> Hit this oops while fuzzing v3.17-rc3-176-g2b12164 with Trinity.
>
> Tommi
>
>
> BUG: unable to handle kernel paging request at ffff8804338717a8
> IP: [<ffffffff81779039>] get_dnode_of_data+0x3a9/0x440
> PGD 4594067 PUD 0
> Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> CPU: 0 PID: 4719 Comm: trinity-c3 Not tainted 3.17.0-rc3+ #33
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> task: ffff880015630000 ti: ffff88000724c000 task.ti: ffff88000724c000
> RIP: 0010:[<ffffffff81779039>]  [<ffffffff81779039>]
> get_dnode_of_data+0x3a9/0x440
> RSP: 0018:ffff88000724fe08  EFLAGS: 00010246
> RAX: ffff880033874000 RBX: 00000000000000f8 RCX: 00000000fffff590
> RDX: ffff880033874168 RSI: ffff88000724fd98 RDI: ffff88000724fef0
> RBP: ffff88000724feb8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: ffffffff83b33f90 R12: fffffffffffff590
> R13: 0000000000000000 R14: ffffea0000ce1d00 R15: ffff8800209f8000
> FS:  00007f2bd22dc700(0000) GS:ffff88003fa00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff8804338717a8 CR3: 00000000346c0000 CR4: 00000000000006f0
> DR0: 000000000185d000 DR1: 000000000185d000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000b0602
> Stack:
>  ffff88000724fef0 ffff88000724fe30 ffff880036c18000 0000000000000004
>  ffff8800209f80f0 00000002fffff590 ffffffff81189f1d ffff8800fffff590
>  0000000000000246 ffffffff00000000 ffffffff81189ce0 ffffffff000000f8
> Call Trace:
>  [<ffffffff81189f1d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81189ce0>] ? mark_held_locks+0x90/0xa0
>  [<ffffffff81189e75>] ? trace_hardirqs_on_caller+0x185/0x220
>  [<ffffffff81763417>] f2fs_llseek+0xf7/0x420
>  [<ffffffff8127e4d5>] SyS_lseek+0x65/0xa0
>  [<ffffffff8259b229>] system_call_fastpath+0x16/0x1b
> Code: ba 00 00 00 00 00 88 ff ff 48 c1 f8 06 48 c1 e0 0c 48 01 d0 8b
> 98 ec 0f 00 00 39 98 e8 0f 00 00 48 8d 90 68 01 00 00 48 0f 45 d0 <8b>
> 04 8a 89 47 24 31 c0 eb 75 41 bc e4 ff ff ff 4d 85 f6 74 19
> RIP  [<ffffffff81779039>] get_dnode_of_data+0x3a9/0x440
>  RSP <ffff88000724fe08>
> CR2: ffff8804338717a8
> ---[ end trace bed7b35d1c48e9c3 ]---

If it helps, here is the location of the crash:

(gdb) list *0xffffffff81779039
0xffffffff81779039 is in get_dnode_of_data (fs/f2fs/f2fs.h:950).
945     {
946             struct f2fs_node *raw_node;
947             __le32 *addr_array;
948             raw_node = F2FS_NODE(node_page);
949             addr_array = blkaddr_in_node(raw_node);
950             return le32_to_cpu(addr_array[offset]);
951     }
952
953     static inline int f2fs_test_bit(unsigned int nr, char *addr)
954     {
(gdb)

Tommi
