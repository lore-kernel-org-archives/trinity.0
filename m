From: Sasha Levin <sasha.levin@oracle.com>
Subject: timer: lockup in run_timer_softirq()
Date: Tue, 09 Jul 2013 18:35:27 -0400
Message-ID: <51DC902F.3070403@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, tglx@linutronix.de
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next, I've
stumbled on the following spew:

[ 2536.440007] BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child86:12368]
[ 2536.440007] Modules linked in:
[ 2536.440007] irq event stamp: 1572135
[ 2536.440007] hardirqs last  enabled at (1572134): [<ffffffff84198ef7>] restore_args+0x0/0x30
[ 2536.440007] hardirqs last disabled at (1572135): [<ffffffff841a2d2d>] apic_timer_interrupt+0x6d/0x80
[ 2536.440007] softirqs last  enabled at (431824): [<ffffffff81132d07>] __do_softirq+0x447/0x4d0
[ 2536.440007] softirqs last disabled at (431969): [<ffffffff81132ed6>] irq_exit+0x86/0x120
[ 2536.440007] CPU: 0 PID: 12368 Comm: trinity-child86 Tainted: G        W 
3.10.0-next-20130709-sasha #3953
[ 2536.440007] task: ffff8807dea03000 ti: ffff8807d7c14000 task.ti: ffff8807d7c14000
[ 2536.440007] RIP: 0010:[<ffffffff8419871c>]  [<ffffffff8419871c>] _raw_spin_unlock_irq+0x4c/0x80
[ 2536.440007] RSP: 0000:ffff880807603e08  EFLAGS: 00000286
[ 2536.440007] RAX: ffff8807dea03000 RBX: ffffffff84198ef7 RCX: 0000000000000000
[ 2536.440007] RDX: ffff8807dea03000 RSI: 0000000000000000 RDI: ffff8807dea03000
[ 2536.440007] RBP: ffff880807603e18 R08: 0000000000000000 R09: 0000000000000000
[ 2536.440007] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880807603d78
[ 2536.440007] R13: ffffffff841a2d32 R14: ffff880807603e18 R15: ffffffff86c81980
[ 2536.440007] FS:  00007f33dd6e5700(0000) GS:ffff880807600000(0000) knlGS:0000000000000000
[ 2536.440007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2536.440007] CR2: 00000000024523c8 CR3: 00000007d255a000 CR4: 00000000000006f0
[ 2536.440007] Stack:
[ 2536.440007]  ffffffff86c829e8 ffffffff86c81980 ffff880807603eb8 ffffffff8113d180
[ 2536.440007]  ffff8807dea03000 ffff880807603e38 ffffffff86c835e8 ffffffff86c831e8
[ 2536.440007]  ffff8807d7c14010 ffffffff86c82de8 ffff8807d7c14000 ffff8807d7c14000
[ 2536.440007] Call Trace:
[ 2536.440007]  <IRQ>
[ 2536.440007]  [<ffffffff8113d180>] run_timer_softirq+0x2d0/0x330
[ 2536.440007]  [<ffffffff8113b400>] ? lock_timer_base+0x70/0x70
[ 2536.440007]  [<ffffffff81132b21>] __do_softirq+0x261/0x4d0
[ 2536.440007]  [<ffffffff81132ed6>] irq_exit+0x86/0x120
[ 2536.440007]  [<ffffffff841a43ea>] smp_apic_timer_interrupt+0x4a/0x60
[ 2536.440007]  [<ffffffff841a2d32>] apic_timer_interrupt+0x72/0x80
[ 2536.440007]  <EOI>
[ 2536.440007]  [<ffffffff84198ef7>] ? retint_restore_args+0x13/0x13
[ 2536.440007]  [<ffffffff812355e5>] ? user_enter+0x135/0x150
[ 2536.440007]  [<ffffffff81077d6d>] syscall_trace_leave+0x12d/0x160
[ 2536.440007]  [<ffffffff841a2337>] int_check_syscall_exit_work+0x34/0x3d
[ 2536.440007] Code: 01 fd 48 89 df e8 45 5b 8f fd e8 b0 f1 00 fd 48 83 3d 30 e6 8a 01 00 75 0e 0f 
0b 0f 1f 40 00 eb fe 66 0f 1f 44 00 00 fb 66 66 90 <66> 66 90 bf 01 00 00 00 e8 17 4f 00 00 65 48 8b 
04 25 88 d9 00

While going through the NMI dump, I noticed that it's very incomplete, and full of:

[ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 
697182.008 msecs


Thanks,
Sasha
