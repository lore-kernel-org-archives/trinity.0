From: Sasha Levin <sasha.levin@oracle.com>
Subject: softirq: soft lockup in __do_softirq
Date: Sun, 08 Sep 2013 10:43:51 -0400
Message-ID: <522C8D27.30600@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: fweisbec@gmail.com, tglx@linutronix.de
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest, running latest -next kernel, I've
stumbled on the following:

[ 8096.714511] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child16:37848]
[ 8096.715952] Modules linked in:
[ 8096.716630] CPU: 0 PID: 37848 Comm: trinity-child16 Tainted: G        W 
3.11.0-next-20130906-sasha #3985
[ 8096.718709] task: ffff880e80b83000 ti: ffff880e7f0c0000 task.ti: ffff880e7f0c0000
[ 8096.720639] RIP: 0010:[<ffffffff8112b12c>]  [<ffffffff8112b12c>] __do_softirq+0xdc/0x320
[ 8096.722457] RSP: 0018:ffff880fdf603eb8  EFLAGS: 00000282
[ 8096.723694] RAX: ffff880e7f0c0000 RBX: ffff880e80b83610 RCX: 0000000010000002
[ 8096.724284] RDX: ffff880e7f0c0010 RSI: 0000000000000000 RDI: 0000000000000100
[ 8096.724284] RBP: ffff880fdf603f58 R08: 00000000e272dc53 R09: 0000000000000001
[ 8096.724284] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880fdf603e28
[ 8096.724284] R13: ffffffff8411335d R14: ffff880fdf603f58 R15: 0000000000000000
[ 8096.724284] FS:  00007faf073b4700(0000) GS:ffff880fdf600000(0000) knlGS:0000000000000000
[ 8096.724284] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8096.724284] CR2: 00007faf073b8000 CR3: 0000000e7ff8a000 CR4: 00000000000006f0
[ 8096.724284] DR0: 00007f90b2937000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8096.724284] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 8096.724284] Stack:
[ 8096.724284]  ffff880e80b83628 0040604081168f4b ffff880e7f0c0000 0000000000000082
[ 8096.724284]  ffff880e7f0c0010 00000001000bdcb6 ffff880e7f0c0010 ffff880e7f0c0010
[ 8096.724284]  ffff880e7f0c0000 ffff880e7f0c0000 0000000a00000000 ffff880e80b83610
[ 8096.724284] Call Trace:
[ 8096.724284]  <IRQ>
[ 8096.724284]  [<ffffffff84109bee>] ? _raw_spin_unlock+0x4e/0x60
[ 8096.724284]  [<ffffffff8112b4be>] irq_exit+0x8e/0x140
[ 8096.724284]  [<ffffffff84114975>] do_IRQ+0xb5/0xe0
[ 8096.724284]  [<ffffffff8410a06d>] common_interrupt+0x6d/0x6d
[ 8096.724284]  <EOI>
[ 8096.724284]  [<ffffffff8115f19d>] ? finish_task_switch+0xad/0x150
[ 8096.724284]  [<ffffffff84109acc>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8096.724284]  [<ffffffff84109aab>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8096.724284]  [<ffffffff8115f19d>] finish_task_switch+0xad/0x150
[ 8096.724284]  [<ffffffff8115f160>] ? finish_task_switch+0x70/0x150
[ 8096.724284]  [<ffffffff84106a29>] __schedule+0x719/0x7c0
[ 8096.724284]  [<ffffffff84107114>] preempt_schedule_irq+0xb4/0x100
[ 8096.724284]  [<ffffffff8410a226>] retint_kernel+0x26/0x30
[ 8096.724284]  [<ffffffff812220c5>] ? context_tracking_user_enter+0x175/0x180
[ 8096.724284]  [<ffffffff810768cf>] syscall_trace_leave+0xff/0x130
[ 8096.724284]  [<ffffffff84112985>] int_check_syscall_exit_work+0x34/0x3d
[ 8096.724284] Code: 48 89 55 80 0f 1f 00 65 c7 04 25 40 47 1d 00 00 00 00 00 48 83 3d dc b6 91 04 
00 75 0a 0f 0b eb fe 66 0f 1f 44 00 00 fb 66 66 90 <66> 66 90 65 4c 8b 34 25 48 da 00 00 31 db 49 8d 
96 28 e0 ff ff


Thanks,
sasha
