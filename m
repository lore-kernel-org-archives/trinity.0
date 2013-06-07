From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: GPF at fsnotify_clear_marks_by_group_flags()
Date: Fri, 7 Jun 2013 22:20:26 +0300
Message-ID: <CA+ydwtoCbm3UkLaj9z7d3phDKNNhUpT+=jHxr4OApm1_KLSPdA@mail.gmail.com>
References: <CA+ydwtqfJmD4aVcuDS6u96SiYT3Wg5Zj_5oXOkzHptG-TiG-_Q@mail.gmail.com>
	<51B21A5F.5050201@gmx.de>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=KT4v3TwJioG82NRpURzeC+oNOhyt9Z6JPHWLcVe+eRs=;
        b=PYaN5pL/yPDhiKnIfuQ914IdaarPvhOfUZ+gPm8MxqP0preMR0l4CEF4AgjM29b6X+
         +h5JvpGR5s2CgYrie3Y2K1YGAAMeKDDczPLpYLG2Xbn8LXPoTZcTHeEVeM1jJHtvG4eH
         aanB6xiTTdhMnyloTLuzPTFKofFB6BgAK+r8uzj/0Q6BT6yyIzWdlsZaGna2uBeuQmdC
         XRCwSRpnIQOTWGqfe9PK44IF98yTvDkIkB7IRwP2ks7KPEPHMotx8k92r8eOWMDJ3xT2
         XxXBhgsMEQWvzFH8XpjxlRyOYkvL5lwBxwHjFsYAI/pnUe3/+UBscol3OrNiH+rvp1SL
         JsmQ==
In-Reply-To: <51B21A5F.5050201@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

2013/6/7 Lino Sanfilippo <LinoSanfilippo@gmx.de>:
> On 03.06.2013 10:03, Tommi Rantala wrote:
>>
>> Hello,
>>
>> Hit this while fuzzing v3.10-rc4-0-gd683b96 with trinity.
>>
>> Looks similar to what I reported back in March:
>> https://lkml.org/lkml/2013/3/13/222
>>
>
> Hi Tommi,
>
> thank you for reporting. Do you know a way how to reproduce this?

OK, looks like I can reproducible this with a small hackish
modification to trinity.

I just pushed a single commit to github in a "fanotify-fds" branch,
try something like:

git clone -b fanotify-fds git://github.com/rantala/trinity.git
cd trinity && ./configure.sh && make -j4

Then, fuzz the fanotify_mark() syscall as the root user in some
suitable environment:

   # ./trinity -C20 -q -l off -c fanotify_mark --dangerous

I just tried that three times in a virtual machine, and at every
attempt I'm getting either the GPF or a "soft lockup" almost
instantly:

# ./trinity -q -l off -C20 -c fanotify_mark --dangerous
Trinity v1.2pre  Dave Jones <davej@redhat.com>
[3423] Marking syscall fanotify_mark (64bit:301 32bit:339) as to be enabled.
Done parsing arguments.
[3423] 32-bit syscalls: 1 enabled, 350 disabled.  64-bit syscalls: 1
enabled, 313 disabled.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious
problems such as overwriting CMOS
or similar which could potentially make this machine unbootable
without a firmware reset.

ctrl-c now unless you really know what you are doing.
Using pid_max = 32768ds..
[3424] Watchdog is alive
[3423] Started watchdog process, PID is 3424
[3425] Main thread is alive.
Cachefile is stale. Need to regenerate.
created 375 sockets
Generating file descriptors
Added 132 filenames from /dev
Added 26622 filenames from /proc
Added 18318 filenames from /sys
[3425] Random reseed: 2990238257
[  100.135012] BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child11:3437]
[  100.135012] irq event stamp: 186108
[  100.135012] hardirqs last  enabled at (186107):
[<ffffffff822a2c33>] restore_args+0x0/0x30
[  100.135012] hardirqs last disabled at (186108):
[<ffffffff822a41ed>] apic_timer_interrupt+0x6d/0x80
[  100.135012] softirqs last  enabled at (186106):
[<ffffffff8111a0c3>] __do_softirq+0x353/0x420
[  100.135012] softirqs last disabled at (186101):
[<ffffffff8111a2d9>] irq_exit+0x59/0xb0
[  100.135012] CPU: 0 PID: 3437 Comm: trinity-child11 Not tainted 3.10.0-rc4+ #1
[  100.135012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  100.135012] task: ffff8800ae418000 ti: ffff8800ae43a000 task.ti:
ffff8800ae43a000
[  100.135012] RIP: 0010:[<ffffffff81177b0e>]  [<ffffffff81177b0e>]
lock_release+0x28e/0x340
[  100.135012] RSP: 0000:ffff8800ae43be38  EFLAGS: 00000246
[  100.135012] RAX: ffff8800ae418000 RBX: 00000000001d56c0 RCX: 00000000000061a0
[  100.135012] RDX: ffff8800bf6392e0 RSI: ffffffff8115251a RDI: 0000000000000246
[  100.135012] RBP: ffff8800ae43be60 R08: 0000000000000038 R09: 0000000000000000
[  100.135012] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8115219d
[  100.135012] R13: ffff8800ae43bdc0 R14: ffffffff8106f4e9 R15: ffff8800ae43bd98
[  100.135012] FS:  00007fb5c16b0700(0000) GS:ffff8800bf600000(0000)
knlGS:0000000000000000
[  100.135012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.135012] CR2: 0000000000f16418 CR3: 00000000ae413000 CR4: 00000000000006f0
[  100.135012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  100.135012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  100.135012] Stack:
[  100.135012]  ffff8800aed90608 ffff8800b7d40fd8 ffff8800aed90608
0000000000000001
[  100.135012]  ffff8800b7d411b8 ffff8800ae43be78 ffffffff822a1e0a
ffff8800aed905e8
[  100.135012]  ffff8800ae43beb0 ffffffff81275671 ffff8800aed905e8
ffff8800aed905e8
[  100.135012] Call Trace:
[  100.135012]  [<ffffffff822a1e0a>] _raw_spin_unlock+0x1a/0x40
[  100.135012]  [<ffffffff81275671>] fsnotify_destroy_mark_locked+0x51/0x190
[  100.135012]  [<ffffffff81275bab>]
fsnotify_clear_marks_by_group_flags+0x8b/0xb0
[  100.135012]  [<ffffffff8127503e>]
fsnotify_clear_inode_marks_by_group+0xe/0x10
[  100.135012]  [<ffffffff812793a5>] SyS_fanotify_mark+0x515/0x590
[  100.135012]  [<ffffffff822a3569>] system_call_fastpath+0x16/0x1b
[  100.135012] Code: 12 0f 1f 40 00 4c 89 ea 4c 89 e6 48 89 df e8 9a
e6 ff ff 65 48 8b 04 25 40 c9 00 00 4c 89 f7 c7 80 d4 06 00 00 00 00
00 00 57 9d <0f> 1f 44 00 00 e9 88 00 00 00 65 48 8b 04 25 30 c9 00 00
83 80

Tommi
