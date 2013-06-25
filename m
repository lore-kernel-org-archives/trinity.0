From: Sasha Levin <sasha.levin@oracle.com>
Subject: lockdep: WARNING: CPU: 28 PID: 10552 at kernel/lockdep.c:3539
Date: Tue, 25 Jun 2013 18:14:32 -0400
Message-ID: <51CA1648.50706@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: mingo@kernel.org, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
I've stumbled on the following:

[  263.899081] ------------[ cut here ]------------
[  263.900321] WARNING: CPU: 28 PID: 10552 at kernel/lockdep.c:3539 check_flags+0xe0/0x
220()
[  263.906199] DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)
[  263.906199] CPU: 28 PID: 10552 Comm: trinity-child28 Tainted: G        W    3.10.0-r
c7-next-20130625-sasha-00011-g7725abd #1124
[  263.906199]  0000000000000dd3 ffff880f4d105d78 ffffffff841214dc ffff880f4d105d78
[  263.906199]  ffff880f4d105dc8 ffff880f4d105db8 ffffffff8111bfd7 ffff880f4d105db8
[  263.906199]  ffff880f6a480000 0000000000000000 0000000000000002 0000000000000000
[  263.906199] Call Trace:
[  263.906199]  [<ffffffff841214dc>] dump_stack+0x52/0x87
[  263.906199]  [<ffffffff8111bfd7>] warn_slowpath_common+0x87/0xb0
[  263.906199]  [<ffffffff8111c0b6>] warn_slowpath_fmt+0x46/0x50
[  263.906199]  [<ffffffff81194020>] check_flags+0xe0/0x220
[  263.906199]  [<ffffffff8119b6a8>] lock_acquire+0x88/0x1e0
[  263.906199]  [<ffffffff8124e013>] ? might_fault+0x53/0xb0
[  263.906199]  [<ffffffff84125d40>] _raw_spin_lock+0x40/0x80
[  263.906199]  [<ffffffff812c6306>] ? __fd_install+0x36/0x100
[  263.906199]  [<ffffffff812c6306>] __fd_install+0x36/0x100
[  263.906199]  [<ffffffff812c63f5>] fd_install+0x25/0x30
[  263.906199]  [<ffffffff812b19bc>] SyS_pipe2+0x8c/0xb0
[  263.906199]  [<ffffffff84127ee1>] ? tracesys+0x7e/0xe2
[  263.906199]  [<ffffffff812b05b0>] SyS_pipe+0x10/0x20
[  263.906199]  [<ffffffff84127f40>] tracesys+0xdd/0xe2
[  263.906199] ---[ end trace d5eed34e44345976 ]---
[  263.906199] possible reason: unannotated irqs-on.
[  263.906199] irq event stamp: 45016
[  263.906199] hardirqs last  enabled at (45015): [<ffffffff8412750a>] paranoid_restore+0x15/0x70
[  263.906199] hardirqs last disabled at (45016): [<ffffffff8107ab14>] debug_stack_reset+0x94/0x1c0
[  263.906199] softirqs last  enabled at (44514): [<ffffffff81126de7>] __do_softirq+0x447/0x4d0
[  263.906199] softirqs last disabled at (44509): [<ffffffff81126fb6>] irq_exit+0x86/0x120

I've started seeing those after I switched the guest to use 128 vcpus (same as the host).


Thanks,
Sasha
