From: Vince Weaver <vincent.weaver@maine.edu>
Subject: x32 BUG found with perf_fuzzer
Date: Thu, 6 Feb 2014 11:27:19 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1402061122250.17478@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: trinity@vger.kernel.org

Hello,

In wake of the recent x32 bug reports, I tried compiling my perf_fuzzer in 
x32 mode and running it.  It's turning up a lot of issues.  One was a 
reboot with no debug messages.  

This is a core2 system running 3.14-rc1

Here's the BUG message:

[  150.555653] BUG: unable to handle kernel paging request at 0000000100000000
[  150.556002] IP: [<0000000100000000>] 0x100000000
[  150.556002] PGD 0 
[  150.556002] Oops: 0010 [#1] SMP 
[  150.556002] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet acpi_cpufreq evdev psmouse serio_raw video coretemp pcspkr ohci_pci wmi ohci_hcd processor i2c_nforce2 button thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  150.556002] CPU: 0 PID: 9165 Comm: perf_fuzzer Not tainted 3.14.0-rc1 #1
[  150.556002] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  150.556002] task: ffff8800ca2c87e0 ti: ffff8800c4bc2000 task.ti: ffff8800c4bc2000
[  150.556002] RIP: 0010:[<0000000100000000>]  [<0000000100000000>] 0x100000000
[  150.556002] RSP: 0000:ffff8800c4bc3cb0  EFLAGS: 00010206
[  150.556002] RAX: 0000000100000000 RBX: ffff8800c340e440 RCX: 000000000000073d
[  150.556002] RDX: 0000000000000000 RSI: ffff880037ec2540 RDI: ffff8800c340e440
[  150.556002] RBP: ffff880037ec2540 R08: ffff88011fbf6f40 R09: 0000000000000000
[  150.556002] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  150.556002] R13: 0077ffffffffffff R14: 0000000000000000 R15: 0000000000000009
[  150.556002] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  150.556002] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  150.556002] CR2: 0000000100000000 CR3: 0000000001a0c000 CR4: 00000000000407f0
[  150.556002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  150.556002] DR3: 00000000022a1000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  150.556002] Stack:
[  150.556002]  ffffffff81102dd7 ffff880037ec2540 ffff880037fbc2c0 0000000000000000
[  150.556002]  ffffffff81119c81 ffff8800cb2c0780 ffff8800ca2c87e0 ffff8800ca2c8de4
[  150.556002]  ffff8800cb2c0780 0000000000000000 ffff8800cb2c07e0 0000000000000001
[  150.556002] Call Trace:
[  150.556002]  [<ffffffff81102dd7>] ? filp_close+0x36/0x65
[  150.556002]  [<ffffffff81119c81>] ? put_files_struct+0x62/0xb2
[  150.556002]  [<ffffffff8103dd08>] ? do_exit+0x3c9/0x959
[  150.556002]  [<ffffffff810e2447>] ? __do_fault+0x355/0x392
[  150.556002]  [<ffffffff8103e30d>] ? do_group_exit+0x75/0x9f
[  150.556002]  [<ffffffff8104aaba>] ? get_signal_to_deliver+0x464/0x481
[  150.556002]  [<ffffffff81002404>] ? do_signal+0x3a/0x5a7
[  150.556002]  [<ffffffff814ea7b2>] ? trace_page_fault+0x22/0x30
[  150.556002]  [<ffffffff81002996>] ? do_notify_resume+0x25/0x5e
[  150.556002]  [<ffffffff814ea675>] ? retint_signal+0x3d/0x78
[  150.556002] Code:  Bad RIP value.
[  150.556002] RIP  [<0000000100000000>] 0x100000000
[  150.556002]  RSP <ffff8800c4bc3cb0>
[  150.556002] CR2: 0000000100000000
[  150.556002] ---[ end trace c733264161a3819f ]---
[  150.556002] Fixing recursive fault but reboot is needed!
