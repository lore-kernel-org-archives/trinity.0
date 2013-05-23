From: Tommi Rantala <tt.rantala@gmail.com>
Subject: NULL pointer deref after vmalloc() failure in fill_files_note()
Date: Thu, 23 May 2013 21:50:47 +0300
Message-ID: <CA+ydwtrRc4ADTk8WhLaA01p=J4+j5Dn-SO9uPEFCCW3bZj8Fjw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=ogNANgClpW4xsbc0ULIxjxRT+kWIGLj3W657yn3tHuU=;
        b=ecRc3cf/OepOJbmvmxGe3CjdstZ9LUi7vRRtrA6f05/a0hBlNFuM0YNBR3w8QWPMkj
         kc1qHGfS7sesaLZN9JOHMRYMoliW/Oy5M+tneqOaO53qsx0chcyVnPPsBZhM5IJIaJvQ
         +pIKyGOVkcToEM2v8cuQ/AWkjd++vv5JMsPexz28KWcsflTZyD8kpIxMgWNw/y8RuRI/
         +YAFSRRnPhZLFrFry1LVZr1vsH57YHHPHRP23QYAXKb08hVzgFYkN7XyGtIm2pDMoXiC
         1tl734sRuWBCS66CKHS1bd3JOlOTag8TKfMAwhycY6OTuDmqwpQ4nRRvVcw8qchFYwRO
         MigQ==
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>, Denys Vlasenko <vda.linux@googlemail.com>, linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

Hello,

Noticed while fuzzing with trinity, that if the vmalloc() in
fill_files_note() fails, we Oops.

I can easily reproduce the bug with this applied:

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8a0b0e..11b444f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1432,7 +1432,7 @@ static void fill_files_note(struct memelfnote *note)
        if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
                goto err;
        size = round_up(size, PAGE_SIZE);
-       data = vmalloc(size);
+       data = NULL;
        if (!data)
                goto err;


Tommi

[   69.144390] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000246
[   69.145015] IP: [<ffffffff814d22f0>] strim+0x80/0x80
[   69.145015] PGD b7ceb067 PUD b7df7067 PMD 0
[   69.145015] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   69.145015] CPU: 0 PID: 3412 Comm: cat Not tainted 3.10.0-rc2+ #20
[   69.145015] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   69.145015] task: ffff8800b6a00000 ti: ffff8800b7d78000 task.ti:
ffff8800b7d78000
[   69.145015] RIP: 0010:[<ffffffff814d22f0>]  [<ffffffff814d22f0>]
strim+0x80/0x80
[   69.145015] RSP: 0018:ffff8800b7d799b0  EFLAGS: 00010206
[   69.145015] RAX: 0000000000000144 RBX: 0000000000000000 RCX: ffff8800b44c0000
[   69.145015] RDX: ffff8800b7d79b20 RSI: 0000000000000000 RDI: 0000000000000246
[   69.145015] RBP: ffff8800b7d799c0 R08: 0000000000000000 R09: 0000000000000000
[   69.145015] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800b7d79b88
[   69.145015] R13: 00007ffffffff000 R14: 00007fffbf94cee6 R15: ffffffff8241fde8
[   69.145015] FS:  00007fa54cb2d700(0000) GS:ffff8800bf600000(0000)
knlGS:0000000000000000
[   69.145015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   69.145015] CR2: 0000000000000246 CR3: 00000000b7e41000 CR4: 00000000000006f0
[   69.145015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.145015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.145015] Stack:
[   69.145015]  ffffffff8128784c 00000000000003d8 ffff8800b7d79a70
ffffffff81289490
[   69.145015]  ffffffff812891e7 0000000000000246 0000000000000000
ffff8800b6a00000
[   69.145015]  ffff8800b7d79e78 ffff8800b6bea410 ffff8800b7d79fd8
ffff8800b7d79fd8
[   69.145015] Call Trace:
[   69.145015]  [<ffffffff8128784c>] ? notesize.isra.6+0xc/0x30
[   69.145015]  [<ffffffff81289490>] fill_note_info.isra.8+0xc60/0xcc0
[   69.145015]  [<ffffffff812891e7>] ? fill_note_info.isra.8+0x9b7/0xcc0
[   69.145015]  [<ffffffff812895a8>] elf_core_dump+0xb8/0x960
[   69.145015]  [<ffffffff81173028>] ? trace_hardirqs_off_caller+0x28/0xe0
[   69.145015]  [<ffffffff811730ed>] ? trace_hardirqs_off+0xd/0x10
[   69.145015]  [<ffffffff8228892f>] ? __slab_free+0x1a1/0x380
[   69.145015]  [<ffffffff81172f55>] ? trace_hardirqs_on_caller+0x185/0x220
[   69.145015]  [<ffffffff814dfb7c>] ? debug_check_no_obj_freed+0x16c/0x220
[   69.145015]  [<ffffffff814c959a>] ? argv_free+0x1a/0x20
[   69.145015]  [<ffffffff81225226>] ? kfree+0x256/0x2c0
[   69.145015]  [<ffffffff8128fb9b>] do_coredump+0x8db/0xcd0
[   69.145015]  [<ffffffff81173028>] ? trace_hardirqs_off_caller+0x28/0xe0
[   69.145015]  [<ffffffff81172f55>] ? trace_hardirqs_on_caller+0x185/0x220
[   69.145015]  [<ffffffff8112a65a>] get_signal_to_deliver+0x81a/0x920
[   69.145015]  [<ffffffff8106f4e9>] ? sched_clock+0x9/0x10
[   69.145015]  [<ffffffff810673e2>] do_signal+0x52/0x590
[   69.145015]  [<ffffffff81172f55>] ? trace_hardirqs_on_caller+0x185/0x220
[   69.145015]  [<ffffffff822a1858>] ? retint_swapgs+0x13/0x1b
[   69.145015]  [<ffffffff8159e3d7>] ? tty_ldisc_deref+0x67/0xc0
[   69.145015]  [<ffffffff81594a86>] ? tty_read+0xa6/0x120
[   69.145015]  [<ffffffff822a2231>] ? sysret_signal+0x5/0x4e
[   69.145015]  [<ffffffff81067947>] do_notify_resume+0x27/0x70
[   69.145015]  [<ffffffff822a24e2>] int_signal+0x12/0x17
[   69.145015] Code: 20 74 18 0f 1f 84 00 00 00 00 00 48 83 c0 01 0f
b6 10 f6 82 40 00 48 82 20 75 f0 5d c3 66 66 66 66 66 2e 0f 1f 84 00
00 00 00 00 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0
01 80
[   69.145015] RIP  [<ffffffff814d22f0>] strim+0x80/0x80
[   69.145015]  RSP <ffff8800b7d799b0>
[   69.145015] CR2: 0000000000000246
[   69.225239] ---[ end trace 5d63690e960d7c7c ]---
