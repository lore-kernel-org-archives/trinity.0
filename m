From: Tommi Rantala <tt.rantala@gmail.com>
Subject: WARNING: at kernel/events/core.c:913 add_event_to_ctx+0x5b/0x1c0()
Date: Sun, 9 Jun 2013 21:55:58 +0300
Message-ID: <CA+ydwto81E5KvkMEZ3WDKHxwdT0mtqOTKNU2_DUJPf1a-nc7mg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=wO96Ik+ue8JoszUrVhpDA9IDiZpRuuEElXEiqnn9ZmA=;
        b=MKkOkM1jjg36qK71lrEUQmCzC3xESjeu24nFkH/c6p5B5fRawXopFOLdLFuZKjYZ/i
         xEWW7RMrB3Ql2XcyEyElARR7HzyOVsJx7ZIe1FI6teZQZymuM+QGZctBkXgJ4mCsfMhS
         d67Zug0EUDtvel7Lcnjpse3cFRKHpA9axr4g+5CpLzADGtnh9gLIHL269GFhrg6TIWi5
         o6TDHSs6TK0LJa6j9CDKykYjwq8iYP2N91QnhZDCn2/XrqakKVle90ryGllFos+z3Gbu
         2kRbPujYzzQhuoBJaUDKTLPwfokjx4Y6KQQC01wnHPK3QRCrQ/WkLBtlCMYTZhyK5frE
         arlQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Patrick McHardy <kaber@trash.net>, Dave Jones <davej@redhat.com>

Hello,

One of my trinity boxes was not responding, this is what was logged.

The kernel is v3.10-rc4-214-g1612e11 (plus a one-liner NETLINK_MMAP
patch from Patrick McHardy, that I hope is not related to this).

Tommi

[186635.051311] ------------[ cut here ]------------
[186635.052009] WARNING: at /build/linux-one/kernel/events/core.c:913
add_event_to_ctx+0x5b/0x1c0()
[186635.058255] CPU: 0 PID: 20302 Comm: trinity-child38 Not tainted
3.10.0-rc4+ #1
[186635.058255] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.058255]  0000000000000009 ffff880055751dd0 ffffffff8228faa9
ffff880055751e08
[186635.058255]  ffffffff81110de6 ffff880089bdb480 ffff880091318948
ffff880091318948
[186635.058255]  0000000000000000 00000000ffffffff ffff880055751e18
ffffffff81110ee5
[186635.058255] Call Trace:
[186635.058255]  [<ffffffff8228faa9>] dump_stack+0x19/0x1b
[186635.058255]  [<ffffffff81110de6>] warn_slowpath_common+0x66/0x90
[186635.058255]  [<ffffffff81110ee5>] warn_slowpath_null+0x15/0x20
[186635.058255]  [<ffffffff811c9d4b>] add_event_to_ctx+0x5b/0x1c0
[186635.058255]  [<ffffffff811c9f73>] perf_install_in_context+0xc3/0x100
[186635.058255]  [<ffffffff811d200e>] SYSC_perf_event_open+0x87e/0xa50
[186635.058255]  [<ffffffff811d21e9>] SyS_perf_event_open+0x9/0x10
[186635.058255]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.058255] ---[ end trace 4a6bb77c3080aa1a ]---
[186635.721492] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000088
[186635.722420] IP: [<ffffffff811cd775>] group_sched_in+0x55/0x1c0
[186635.722420] PGD 5e2c9067 PUD 5e04c067 PMD 0
[186635.722420] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[186635.722420] CPU: 1 PID: 20285 Comm: trinity-child21 Tainted: G
   W    3.10.0-rc4+ #1
[186635.722420] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.722420] task: ffff880097da8000 ti: ffff88006ba06000 task.ti:
ffff88006ba06000
[186635.722420] RIP: 0010:[<ffffffff811cd775>]  [<ffffffff811cd775>]
group_sched_in+0x55/0x1c0
[186635.722420] RSP: 0018:ffff88006ba07b70  EFLAGS: 00010096
[186635.722420] RAX: 0000000000000000 RBX: ffff880089bd8348 RCX:
ffffffff82c1e2c0
[186635.722420] RDX: 0000000000000000 RSI: ffff88009d7d67c8 RDI:
0000000000000000
[186635.722420] RBP: ffff88006ba07bd0 R08: ffffffff8314c8c0 R09:
0000000000000000
[186635.722420] R10: 0000000000000004 R11: 0000000000000004 R12:
ffff880089bd8348
[186635.722420] R13: ffff88009d7d6970 R14: ffff88009d7d6974 R15:
ffff880089bd8458
[186635.722420] FS:  00007f29cd971700(0000) GS:ffff88009d600000(0000)
knlGS:0000000000000000
[186635.722420] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[186635.722420] CR2: 0000000000000088 CR3: 000000005d053000 CR4:
00000000000007e0
[186635.722420] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[186635.722420] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[186635.722420] Stack:
[186635.722420]  0000000000000000 00000000001d56c0 0000000000000001
0000000000000046
[186635.722420]  0000000000000086 0000000000000000 ffff880089bdb590
ffff880089bd8348
[186635.722420]  ffff880089bdb590 0000000000000001 ffff88009d7d67c8
ffff880089bd8458
[186635.722420] Call Trace:
[186635.722420]  [<ffffffff811cda50>] ctx_sched_in.isra.52+0x170/0x1d0
[186635.722420]  [<ffffffff811cdb08>] perf_event_sched_in.isra.54+0x58/0x80
[186635.722420]  [<ffffffff811cdcd2>]
perf_event_context_sched_in.isra.55+0x92/0xd0
[186635.722420]  [<ffffffff811cdd35>] __perf_event_task_sched_in+0x25/0x2f0
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff8106659c>] ? __switch_to+0x20c/0x4f0
[186635.722420]  [<ffffffff8114906c>] finish_task_switch+0xfc/0x120
[186635.722420]  [<ffffffff822a11a1>] __schedule+0x8a1/0xa00
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff822a1355>] schedule+0x55/0x60
[186635.722420]  [<ffffffff81277475>] inotify_read+0x285/0x390
[186635.722420]  [<ffffffff8113ead0>] ? abort_exclusive_wait+0xb0/0xb0
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff8122fefd>] do_loop_readv_writev+0x4d/0x90
[186635.722420]  [<ffffffff812317a9>] do_readv_writev+0x159/0x270
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff81172f85>] ? trace_hardirqs_on_caller+0x185/0x220
[186635.722420]  [<ffffffff812318f7>] vfs_readv+0x37/0x60
[186635.722420]  [<ffffffff812319d0>] SyS_readv+0x50/0xd0
[186635.722420]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.722420] Code: c8 48 89 55 a0 75 0f 31 c0 e9 78 01 00 00 0f 1f
84 00 00 00 00 00 48 8b 7d c8 49 89 f6 4d 8d ae a8 01 00 00 49 81 c6
ac 01 00 00 <ff> 97 88 00 00 00 48 8b 7d d0 4c 89 e1 4c 89 f2 4c 89 ee
e8 43
[186635.722420] RIP  [<ffffffff811cd775>] group_sched_in+0x55/0x1c0
[186635.722420]  RSP <ffff88006ba07b70>
[186635.722420] CR2: 0000000000000088
[186635.722420] ---[ end trace 4a6bb77c3080aa1b ]---
[186635.722420] BUG: sleeping function called from invalid context at
/build/linux-one/kernel/rwsem.c:20
[186635.722420] in_atomic(): 1, irqs_disabled(): 1, pid: 20285, name:
trinity-child21
[186635.722420] INFO: lockdep is turned off.
[186635.722420] irq event stamp: 3232
[186635.722420] hardirqs last  enabled at (3231): [<ffffffff822a0065>]
__mutex_unlock_slowpath+0x155/0x180
[186635.722420] hardirqs last disabled at (3232): [<ffffffff822a2f4a>]
_raw_spin_lock_irq+0x1a/0x90
[186635.722420] softirqs last  enabled at (2932): [<ffffffff8111a0c3>]
__do_softirq+0x353/0x420
[186635.722420] softirqs last disabled at (2927): [<ffffffff8111a2d9>]
irq_exit+0x59/0xb0
[186635.722420] CPU: 1 PID: 20285 Comm: trinity-child21 Tainted: G
 D W    3.10.0-rc4+ #1
[186635.722420] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.722420]  ffffffff82a108a8 ffff88006ba077e8 ffffffff8228faa9
ffff88006ba07810
[186635.722420]  ffffffff811516bb ffff880097770468 ffff8800977704c8
ffff880097da8000
[186635.722420]  ffff88006ba07838 ffffffff822a04e5 ffff880097da8000
ffff880097da8000
[186635.722420] Call Trace:
[186635.722420]  [<ffffffff8228faa9>] dump_stack+0x19/0x1b
[186635.722420]  [<ffffffff811516bb>] __might_sleep+0x1fb/0x210
[186635.722420]  [<ffffffff822a04e5>] down_read+0x25/0xa0
[186635.722420]  [<ffffffff8112a77f>] exit_signals+0x1f/0x140
[186635.722420]  [<ffffffff81116f78>] do_exit+0x108/0xb40
[186635.722420]  [<ffffffff81114388>] ? kmsg_dump+0x1f8/0x220
[186635.722420]  [<ffffffff811141b0>] ? kmsg_dump+0x20/0x220
[186635.722420]  [<ffffffff8106af58>] oops_end+0xd8/0xf0
[186635.722420]  [<ffffffff822873a1>] no_context+0x261/0x28c
[186635.722420]  [<ffffffff82287592>] __bad_area_nosemaphore+0x1c6/0x1e4
[186635.722420]  [<ffffffff822875be>] bad_area_nosemaphore+0xe/0x10
[186635.722420]  [<ffffffff8109aa2a>] __do_page_fault+0x47a/0x530
[186635.722420]  [<ffffffff81076f95>] ? x86_pmu_add+0x125/0x140
[186635.722420]  [<ffffffff8106f495>] ? native_sched_clock+0x35/0x80
[186635.722420]  [<ffffffff8106f4e9>] ? sched_clock+0x9/0x10
[186635.722420]  [<ffffffff8115219d>] ? sched_clock_local+0x1d/0x90
[186635.722420]  [<ffffffff814d791d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[186635.722420]  [<ffffffff8109ab09>] do_page_fault+0x9/0x10
[186635.722420]  [<ffffffff822a4148>] page_fault+0x28/0x30
[186635.722420]  [<ffffffff811cd775>] ? group_sched_in+0x55/0x1c0
[186635.722420]  [<ffffffff811cda50>] ctx_sched_in.isra.52+0x170/0x1d0
[186635.722420]  [<ffffffff811cdb08>] perf_event_sched_in.isra.54+0x58/0x80
[186635.722420]  [<ffffffff811cdcd2>]
perf_event_context_sched_in.isra.55+0x92/0xd0
[186635.722420]  [<ffffffff811cdd35>] __perf_event_task_sched_in+0x25/0x2f0
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff8106659c>] ? __switch_to+0x20c/0x4f0
[186635.722420]  [<ffffffff8114906c>] finish_task_switch+0xfc/0x120
[186635.722420]  [<ffffffff822a11a1>] __schedule+0x8a1/0xa00
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff822a1355>] schedule+0x55/0x60
[186635.722420]  [<ffffffff81277475>] inotify_read+0x285/0x390
[186635.722420]  [<ffffffff8113ead0>] ? abort_exclusive_wait+0xb0/0xb0
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff8122fefd>] do_loop_readv_writev+0x4d/0x90
[186635.722420]  [<ffffffff812317a9>] do_readv_writev+0x159/0x270
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff81172f85>] ? trace_hardirqs_on_caller+0x185/0x220
[186635.722420]  [<ffffffff812318f7>] vfs_readv+0x37/0x60
[186635.722420]  [<ffffffff812319d0>] SyS_readv+0x50/0xd0
[186635.722420]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.722420] note: trinity-child21[20285] exited with preempt_count 4
[186635.724015] ------------[ cut here ]------------
[186635.724015] WARNING: at /build/linux-one/kernel/watchdog.c:245
watchdog_overflow_callback+0x9a/0xd0()
[186635.724015] Watchdog detected hard LOCKUP on cpu 0
[186635.724015] CPU: 0 PID: 20263 Comm: trinity-main Tainted: G      D
W    3.10.0-rc4+ #1
[186635.724015] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.724015]  0000000000000009 ffff88009d407c78 ffffffff8228faa9
ffff88009d407cb0
[186635.724015]  ffffffff81110de6 ffff88009d01dcd0 0000000000000000
ffff88009d407db8
[186635.724015]  0000000000000000 ffff88009d407ef8 ffff88009d407d10
ffffffff81110e77
[186635.724015] Call Trace:
[186635.724015]  <NMI>  [<ffffffff8228faa9>] dump_stack+0x19/0x1b
[186635.724015]  [<ffffffff81110de6>] warn_slowpath_common+0x66/0x90
[186635.724015]  [<ffffffff81110e77>] warn_slowpath_fmt+0x47/0x50
[186635.724015]  [<ffffffff81173058>] ? trace_hardirqs_off_caller+0x28/0xe0
[186635.724015]  [<ffffffff8119f100>] ? watchdog_should_run+0x30/0x30
[186635.724015]  [<ffffffff8119f19a>] watchdog_overflow_callback+0x9a/0xd0
[186635.724015]  [<ffffffff811cf618>] __perf_event_overflow+0x158/0x2e0
[186635.724015]  [<ffffffff811cc8f0>] ? perf_event_update_userpage+0x230/0x280
[186635.724015]  [<ffffffff811cc6c0>] ? perf_event_task_disable+0x90/0x90
[186635.724015]  [<ffffffff811cffb4>] perf_event_overflow+0x14/0x20
[186635.724015]  [<ffffffff810786d2>] x86_pmu_handle_irq+0x112/0x160
[186635.724015]  [<ffffffff81077b52>] ? x86_pmu_enable_all+0xa2/0xc0
[186635.724015]  [<ffffffff81076a09>] perf_event_nmi_handler+0x19/0x20
[186635.724015]  [<ffffffff8106b1fe>] nmi_handle.isra.1+0x10e/0x1e0
[186635.724015]  [<ffffffff8106b0f0>] ? die+0x80/0x80
[186635.724015]  [<ffffffff8106b6bd>] do_nmi+0xcd/0x390
[186635.724015]  [<ffffffff822a4541>] end_repeat_nmi+0x1e/0x2e
[186635.724015]  [<ffffffff814d6673>] ? delay_tsc+0x43/0xb0
[186635.724015]  [<ffffffff814d6673>] ? delay_tsc+0x43/0xb0
[186635.724015]  [<ffffffff814d6673>] ? delay_tsc+0x43/0xb0
[186635.724015]  <<EOE>>  <IRQ>  [<ffffffff814d673a>] __delay+0xa/0x10
[186635.724015]  [<ffffffff814deccd>] do_raw_spin_lock+0xdd/0x110
[186635.724015]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.724015]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.724015]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.724015]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.724015]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.724015]  [<ffffffff811a6c3b>] rcu_report_qs_rnp+0x11b/0x130
[186635.724015]  [<ffffffff822a2f1c>] ? _raw_spin_lock_irqsave+0x8c/0xa0
[186635.724015]  [<ffffffff811a84d2>] rcu_process_callbacks+0x242/0x7e0
[186635.724015]  [<ffffffff81119f26>] __do_softirq+0x1b6/0x420
[186635.724015]  [<ffffffff8111a2d9>] irq_exit+0x59/0xb0
[186635.724015]  [<ffffffff8108caaa>] smp_apic_timer_interrupt+0x8a/0xa0
[186635.724015]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.724015]  <EOI>  [<ffffffff812492a0>] ? d_lookup+0x20/0x60
[186635.724015]  [<ffffffff8124932b>] d_hash_and_lookup+0x4b/0x50
[186635.724015]  [<ffffffff8129fbae>] proc_flush_task+0x8e/0x190
[186635.724015]  [<ffffffff811155d0>] release_task+0x170/0x5f0
[186635.724015]  [<ffffffff81115480>] ? release_task+0x20/0x5f0
[186635.724015]  [<ffffffff811161d5>] wait_consider_task+0x785/0xe80
[186635.724015]  [<ffffffff81115b4f>] ? wait_consider_task+0xff/0xe80
[186635.724015]  [<ffffffff81116a7d>] do_wait+0x1ad/0x380
[186635.724015]  [<ffffffff81117d7f>] SyS_wait4+0xaf/0xf0
[186635.724015]  [<ffffffff81115030>] ? put_task_struct+0x20/0x20
[186635.724015]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.724015] ---[ end trace 4a6bb77c3080aa1c ]---
[186635.724015] BUG: spinlock lockup suspected on CPU#0, trinity-main/20263
[186635.724015]  lock: 0xffff88009d7d4c40, .magic: dead4ead, .owner:
swapper/1/0, .owner_cpu: 1
[186635.724015] CPU: 0 PID: 20263 Comm: trinity-main Tainted: G      D
W    3.10.0-rc4+ #1
[186635.724015] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.724015]  ffff88009d7d4c40 ffff88009d403cd8 ffffffff8228faa9
ffff88009d403cf8
[186635.724015]  ffffffff8228fb8a ffff88009d7d4c40 0000000082cce8b8
ffff88009d403d28
[186635.724015]  ffffffff814dec8d ffff88009d7d4c58 ffff88009d7d4c40
ffff88009d7d4c58
[186635.724015] Call Trace:
[186635.724015]  <IRQ>  [<ffffffff8228faa9>] dump_stack+0x19/0x1b
[186635.724015]  [<ffffffff8228fb8a>] spin_dump+0x8c/0x91
[186635.724015]  [<ffffffff814dec8d>] do_raw_spin_lock+0x9d/0x110
[186635.724015]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.724015]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.724015]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.724015]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.724015]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.724015]  [<ffffffff811a6c3b>] rcu_report_qs_rnp+0x11b/0x130
[186635.724015]  [<ffffffff822a2f1c>] ? _raw_spin_lock_irqsave+0x8c/0xa0
[186635.724015]  [<ffffffff811a84d2>] rcu_process_callbacks+0x242/0x7e0
[186635.724015]  [<ffffffff81119f26>] __do_softirq+0x1b6/0x420
[186635.724015]  [<ffffffff8111a2d9>] irq_exit+0x59/0xb0
[186635.724015]  [<ffffffff8108caaa>] smp_apic_timer_interrupt+0x8a/0xa0
[186635.724015]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.724015]  <EOI>  [<ffffffff812492a0>] ? d_lookup+0x20/0x60
[186635.724015]  [<ffffffff8124932b>] d_hash_and_lookup+0x4b/0x50
[186635.724015]  [<ffffffff8129fbae>] proc_flush_task+0x8e/0x190
[186635.724015]  [<ffffffff811155d0>] release_task+0x170/0x5f0
[186635.724015]  [<ffffffff81115480>] ? release_task+0x20/0x5f0
[186635.724015]  [<ffffffff811161d5>] wait_consider_task+0x785/0xe80
[186635.724015]  [<ffffffff81115b4f>] ? wait_consider_task+0xff/0xe80
[186635.724015]  [<ffffffff81116a7d>] do_wait+0x1ad/0x380
[186635.724015]  [<ffffffff81117d7f>] SyS_wait4+0xaf/0xf0
[186635.724015]  [<ffffffff81115030>] ? put_task_struct+0x20/0x20
[186635.724015]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.724015] sending NMI to all CPUs:
[186635.724015] NMI backtrace for cpu 0
[186635.724015] CPU: 0 PID: 20263 Comm: trinity-main Tainted: G      D
W    3.10.0-rc4+ #1
[186635.724015] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.724015] task: ffff880098b723e0 ti: ffff880087974000 task.ti:
ffff880087974000
[186635.724015] RIP: 0010:[<ffffffff8108d9d5>]  [<ffffffff8108d9d5>]
arch_trigger_all_cpu_backtrace+0x65/0x80
[186635.724015] RSP: 0018:ffff88009d403cf0  EFLAGS: 00000006
[186635.724015] RAX: 0000000003000000 RBX: 0000000000002710 RCX:
0000000000000006
[186635.724015] RDX: 0000000000000c00 RSI: ffffffff81090e85 RDI:
0000000000418958
[186635.724015] RBP: ffff88009d403cf8 R08: 0000000000000002 R09:
0000000000000000
[186635.724015] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000082cce8b8
[186635.724015] R13: 0000000082cce8b8 R14: 0000000000000086 R15:
ffff88009d7d4c40
[186635.724015] FS:  00007f29cd971700(0000) GS:ffff88009d400000(0000)
knlGS:0000000000000000
[186635.724015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[186635.724015] CR2: 00007f29cd978008 CR3: 000000007d4a6000 CR4:
00000000000007f0
[186635.724015] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[186635.724015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[186635.724015] Stack:
[186635.724015]  ffff88009d7d4c40 ffff88009d403d28 ffffffff814dec92
ffff88009d7d4c58
[186635.724015]  ffff88009d7d4c40 ffff88009d7d4c58 0000000000000000
ffff88009d403d50
[186635.724015]  ffffffff822a2e71 ffffffff8114f86f ffff880099caa3e0
ffff880099caa9f8
[186635.724015] Call Trace:
[186635.724015]  <IRQ>
[186635.724015]  [<ffffffff814dec92>] do_raw_spin_lock+0xa2/0x110
[186635.724015]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.724015]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.724015]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.724015]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.724015]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.724015]  [<ffffffff811a6c3b>] rcu_report_qs_rnp+0x11b/0x130
[186635.724015]  [<ffffffff822a2f1c>] ? _raw_spin_lock_irqsave+0x8c/0xa0
[186635.724015]  [<ffffffff811a84d2>] rcu_process_callbacks+0x242/0x7e0
[186635.724015]  [<ffffffff81119f26>] __do_softirq+0x1b6/0x420
[186635.724015]  [<ffffffff8111a2d9>] irq_exit+0x59/0xb0
[186635.724015]  [<ffffffff8108caaa>] smp_apic_timer_interrupt+0x8a/0xa0
[186635.724015]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.724015]  <EOI>
[186635.724015]  [<ffffffff812492a0>] ? d_lookup+0x20/0x60
[186635.724015]  [<ffffffff8124932b>] d_hash_and_lookup+0x4b/0x50
[186635.724015]  [<ffffffff8129fbae>] proc_flush_task+0x8e/0x190
[186635.724015]  [<ffffffff811155d0>] release_task+0x170/0x5f0
[186635.724015]  [<ffffffff81115480>] ? release_task+0x20/0x5f0
[186635.724015]  [<ffffffff811161d5>] wait_consider_task+0x785/0xe80
[186635.724015]  [<ffffffff81115b4f>] ? wait_consider_task+0xff/0xe80
[186635.724015]  [<ffffffff81116a7d>] do_wait+0x1ad/0x380
[186635.724015]  [<ffffffff81117d7f>] SyS_wait4+0xaf/0xf0
[186635.724015]  [<ffffffff81115030>] ? put_task_struct+0x20/0x20
[186635.724015]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.724015] Code: 05 c9 a7 d8 01 bf 02 00 00 00 ff 90 e8 00 00 00
48 83 3d 1e a6 d8 01 00 75 0c f0 80 25 8c 42 0e 02 fe 5b 5d eb 11 bf
58 89 41 00 <e8> 66 8d 44 00 83 eb 01 75 db eb e3 f3 c3 66 2e 0f 1f 84
00 00
[186635.722420] NMI backtrace for cpu 1
[186635.722420] CPU: 1 PID: 20285 Comm: trinity-child21 Tainted: G
 D W    3.10.0-rc4+ #1
[186635.722420] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.722420] task: ffff880097da8000 ti: ffff88006ba06000 task.ti:
ffff88006ba06000
[186635.722420] RIP: 0010:[<ffffffff814d6676>]  [<ffffffff814d6676>]
delay_tsc+0x46/0xb0
[186635.722420] RSP: 0018:ffff88009d603c88  EFLAGS: 00000002
[186635.722420] RAX: 000174d11a2a3464 RBX: ffff88006ba07fd8 RCX:
0000000000000000
[186635.722420] RDX: 000174d11a2a3464 RSI: ffffffff82a43694 RDI:
0000000000000001
[186635.722420] RBP: ffff88009d603ca8 R08: 0000000000000002 R09:
0000000000000001
[186635.722420] R10: 0000000000000000 R11: 0000000000000000 R12:
000000001a2a3464
[186635.722420] R13: 0000000000000001 R14: 0000000000000001 R15:
ffff88009d7d4c40
[186635.722420] FS:  00007f29cd971700(0000) GS:ffff88009d600000(0000)
knlGS:0000000000000000
[186635.722420] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[186635.722420] CR2: 0000000000000088 CR3: 000000005d053000 CR4:
00000000000007e0
[186635.722420] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[186635.722420] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[186635.722420] Stack:
[186635.722420]  ffff88009d7d4c40 0000000082aede7d 0000000082cce8b8
0000000000000086
[186635.722420]  ffff88009d603cb8 ffffffff814d673a ffff88009d603ce8
ffffffff814deccd
[186635.722420]  ffff88009d7d4c58 ffff88009d7d4c40 ffff88009d7d4c58
0000000000000000
[186635.722420] Call Trace:
[186635.722420]  <IRQ>
[186635.722420]  [<ffffffff814d673a>] __delay+0xa/0x10
[186635.722420]  [<ffffffff814deccd>] do_raw_spin_lock+0xdd/0x110
[186635.722420]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.722420]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.722420]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.722420]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.722420]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.722420]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.722420]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.722420]  [<ffffffff8111344d>] wake_up_klogd_work_func+0x5d/0x60
[186635.722420]  [<ffffffff811c78ac>] __irq_work_run+0x6c/0x90
[186635.722420]  [<ffffffff811c7ab9>] irq_work_run+0x29/0x30
[186635.722420]  [<ffffffff8112473d>] update_process_times+0x5d/0x80
[186635.722420]  [<ffffffff8116e5d9>] tick_sched_handle.isra.9+0x49/0x60
[186635.722420]  [<ffffffff8116e737>] tick_sched_timer+0x47/0x70
[186635.722420]  [<ffffffff81141941>] __run_hrtimer+0x261/0x4a0
[186635.722420]  [<ffffffff8116e6f0>] ? tick_sched_do_timer+0x40/0x40
[186635.722420]  [<ffffffff81142929>] hrtimer_interrupt+0x109/0x200
[186635.722420]  [<ffffffff8108caa5>] smp_apic_timer_interrupt+0x85/0xa0
[186635.722420]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.722420]  <EOI>
[186635.722420]  [<ffffffff822a3127>] ? _raw_spin_unlock_irq+0x27/0x50
[186635.722420]  [<ffffffff822a312b>] ? _raw_spin_unlock_irq+0x2b/0x50
[186635.722420]  [<ffffffff81180edf>] acct_collect+0x15f/0x1c0
[186635.722420]  [<ffffffff81117946>] do_exit+0xad6/0xb40
[186635.722420]  [<ffffffff81114388>] ? kmsg_dump+0x1f8/0x220
[186635.722420]  [<ffffffff811141b0>] ? kmsg_dump+0x20/0x220
[186635.722420]  [<ffffffff8106af58>] oops_end+0xd8/0xf0
[186635.722420]  [<ffffffff822873a1>] no_context+0x261/0x28c
[186635.722420]  [<ffffffff82287592>] __bad_area_nosemaphore+0x1c6/0x1e4
[186635.722420]  [<ffffffff822875be>] bad_area_nosemaphore+0xe/0x10
[186635.722420]  [<ffffffff8109aa2a>] __do_page_fault+0x47a/0x530
[186635.722420]  [<ffffffff81076f95>] ? x86_pmu_add+0x125/0x140
[186635.722420]  [<ffffffff8106f495>] ? native_sched_clock+0x35/0x80
[186635.722420]  [<ffffffff8106f4e9>] ? sched_clock+0x9/0x10
[186635.722420]  [<ffffffff8115219d>] ? sched_clock_local+0x1d/0x90
[186635.722420]  [<ffffffff814d791d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[186635.722420]  [<ffffffff8109ab09>] do_page_fault+0x9/0x10
[186635.722420]  [<ffffffff822a4148>] page_fault+0x28/0x30
[186635.722420]  [<ffffffff811cd775>] ? group_sched_in+0x55/0x1c0
[186635.722420]  [<ffffffff811cda50>] ctx_sched_in.isra.52+0x170/0x1d0
[186635.722420]  [<ffffffff811cdb08>] perf_event_sched_in.isra.54+0x58/0x80
[186635.722420]  [<ffffffff811cdcd2>]
perf_event_context_sched_in.isra.55+0x92/0xd0
[186635.722420]  [<ffffffff811cdd35>] __perf_event_task_sched_in+0x25/0x2f0
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff8106659c>] ? __switch_to+0x20c/0x4f0
[186635.722420]  [<ffffffff8114906c>] finish_task_switch+0xfc/0x120
[186635.722420]  [<ffffffff822a11a1>] __schedule+0x8a1/0xa00
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff822a1355>] schedule+0x55/0x60
[186635.722420]  [<ffffffff81277475>] inotify_read+0x285/0x390
[186635.722420]  [<ffffffff8113ead0>] ? abort_exclusive_wait+0xb0/0xb0
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff8122fefd>] do_loop_readv_writev+0x4d/0x90
[186635.722420]  [<ffffffff812317a9>] do_readv_writev+0x159/0x270
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff81172f85>] ? trace_hardirqs_on_caller+0x185/0x220
[186635.722420]  [<ffffffff812318f7>] vfs_readv+0x37/0x60
[186635.722420]  [<ffffffff812319d0>] SyS_readv+0x50/0xd0
[186635.722420]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.722420] Code: ff ff 01 65 44 8b 34 25 1c b0 00 00 0f ae f0 66
66 90 e8 8e 8e b9 ff 66 90 41 89 c4 66 0f 1f 84 00 00 00 00 00 0f ae
f0 66 66 90 <e8> 75 8e b9 ff 66 90 89 c2 44 29 e2 44 39 ea 73 39 48 8d
93 28
[186635.722420] BUG: spinlock lockup suspected on CPU#1, trinity-child21/20285
[186635.722420]  lock: 0xffff88009d7d4c40, .magic: dead4ead, .owner:
swapper/1/0, .owner_cpu: 1
[186635.722420] CPU: 1 PID: 20285 Comm: trinity-child21 Tainted: G
 D W    3.10.0-rc4+ #1
[186635.722420] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.722420]  ffff88009d7d4c40 ffff88009d603c98 ffffffff8228faa9
ffff88009d603cb8
[186635.722420]  ffffffff8228fb8a ffff88009d7d4c40 0000000082cce8b8
ffff88009d603ce8
[186635.722420]  ffffffff814dec8d ffff88009d7d4c58 ffff88009d7d4c40
ffff88009d7d4c58
[186635.722420] Call Trace:
[186635.722420]  <IRQ>  [<ffffffff8228faa9>] dump_stack+0x19/0x1b
[186635.722420]  [<ffffffff8228fb8a>] spin_dump+0x8c/0x91
[186635.722420]  [<ffffffff814dec8d>] do_raw_spin_lock+0x9d/0x110
[186635.722420]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.722420]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.722420]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.722420]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.722420]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.722420]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.722420]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.722420]  [<ffffffff8111344d>] wake_up_klogd_work_func+0x5d/0x60
[186635.722420]  [<ffffffff811c78ac>] __irq_work_run+0x6c/0x90
[186635.722420]  [<ffffffff811c7ab9>] irq_work_run+0x29/0x30
[186635.722420]  [<ffffffff8112473d>] update_process_times+0x5d/0x80
[186635.722420]  [<ffffffff8116e5d9>] tick_sched_handle.isra.9+0x49/0x60
[186635.722420]  [<ffffffff8116e737>] tick_sched_timer+0x47/0x70
[186635.722420]  [<ffffffff81141941>] __run_hrtimer+0x261/0x4a0
[186635.722420]  [<ffffffff8116e6f0>] ? tick_sched_do_timer+0x40/0x40
[186635.722420]  [<ffffffff81142929>] hrtimer_interrupt+0x109/0x200
[186635.722420]  [<ffffffff8108caa5>] smp_apic_timer_interrupt+0x85/0xa0
[186635.722420]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.722420]  <EOI>  [<ffffffff822a3127>] ? _raw_spin_unlock_irq+0x27/0x50
[186635.722420]  [<ffffffff822a312b>] ? _raw_spin_unlock_irq+0x2b/0x50
[186635.722420]  [<ffffffff81180edf>] acct_collect+0x15f/0x1c0
[186635.722420]  [<ffffffff81117946>] do_exit+0xad6/0xb40
[186635.722420]  [<ffffffff81114388>] ? kmsg_dump+0x1f8/0x220
[186635.722420]  [<ffffffff811141b0>] ? kmsg_dump+0x20/0x220
[186635.722420]  [<ffffffff8106af58>] oops_end+0xd8/0xf0
[186635.722420]  [<ffffffff822873a1>] no_context+0x261/0x28c
[186635.722420]  [<ffffffff82287592>] __bad_area_nosemaphore+0x1c6/0x1e4
[186635.722420]  [<ffffffff822875be>] bad_area_nosemaphore+0xe/0x10
[186635.722420]  [<ffffffff8109aa2a>] __do_page_fault+0x47a/0x530
[186635.722420]  [<ffffffff81076f95>] ? x86_pmu_add+0x125/0x140
[186635.722420]  [<ffffffff8106f495>] ? native_sched_clock+0x35/0x80
[186635.722420]  [<ffffffff8106f4e9>] ? sched_clock+0x9/0x10
[186635.722420]  [<ffffffff8115219d>] ? sched_clock_local+0x1d/0x90
[186635.722420]  [<ffffffff814d791d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[186635.722420]  [<ffffffff8109ab09>] do_page_fault+0x9/0x10
[186635.722420]  [<ffffffff822a4148>] page_fault+0x28/0x30
[186635.722420]  [<ffffffff811cd775>] ? group_sched_in+0x55/0x1c0
[186635.722420]  [<ffffffff811cda50>] ctx_sched_in.isra.52+0x170/0x1d0
[186635.722420]  [<ffffffff811cdb08>] perf_event_sched_in.isra.54+0x58/0x80
[186635.722420]  [<ffffffff811cdcd2>]
perf_event_context_sched_in.isra.55+0x92/0xd0
[186635.722420]  [<ffffffff811cdd35>] __perf_event_task_sched_in+0x25/0x2f0
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff8106659c>] ? __switch_to+0x20c/0x4f0
[186635.722420]  [<ffffffff8114906c>] finish_task_switch+0xfc/0x120
[186635.722420]  [<ffffffff822a11a1>] __schedule+0x8a1/0xa00
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff822a1355>] schedule+0x55/0x60
[186635.722420]  [<ffffffff81277475>] inotify_read+0x285/0x390
[186635.722420]  [<ffffffff8113ead0>] ? abort_exclusive_wait+0xb0/0xb0
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff8122fefd>] do_loop_readv_writev+0x4d/0x90
[186635.722420]  [<ffffffff812317a9>] do_readv_writev+0x159/0x270
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff81172f85>] ? trace_hardirqs_on_caller+0x185/0x220
[186635.722420]  [<ffffffff812318f7>] vfs_readv+0x37/0x60
[186635.722420]  [<ffffffff812319d0>] SyS_readv+0x50/0xd0
[186635.722420]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.722420] sending NMI to all CPUs:
[186635.724015] NMI backtrace for cpu 0
[186635.724015] CPU: 0 PID: 20263 Comm: trinity-main Tainted: G      D
W    3.10.0-rc4+ #1
[186635.724015] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.724015] task: ffff880098b723e0 ti: ffff880087974000 task.ti:
ffff880087974000
[186635.724015] RIP: 0010:[<ffffffff810959e2>]  [<ffffffff810959e2>]
__ticket_spin_lock+0x22/0x30
[186635.724015] RSP: 0018:ffff88009d403cf8  EFLAGS: 00000097
[186635.724015] RAX: 0000000000000074 RBX: ffff88009d7d4c40 RCX:
0000000000000006
[186635.724015] RDX: 0000000000000075 RSI: ffffffff81090e85 RDI:
ffff88009d7d4c40
[186635.724015] RBP: ffff88009d403cf8 R08: 0000000000000002 R09:
0000000000000000
[186635.724015] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000082cce8b8
[186635.724015] R13: 0000000082cce8b8 R14: 0000000000000086 R15:
ffff88009d7d4c40
[186635.724015] FS:  00007f29cd971700(0000) GS:ffff88009d400000(0000)
knlGS:0000000000000000
[186635.724015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[186635.724015] CR2: 00007f29cd978008 CR3: 000000007d4a6000 CR4:
00000000000007f0
[186635.724015] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[186635.724015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[186635.724015] Stack:
[186635.724015]  ffff88009d403d28 ffffffff814dec9a ffff88009d7d4c58
ffff88009d7d4c40
[186635.724015]  ffff88009d7d4c58 0000000000000000 ffff88009d403d50
ffffffff822a2e71
[186635.724015]  ffffffff8114f86f ffff880099caa3e0 ffff880099caa9f8
ffff88009d403da0
[186635.724015] Call Trace:
[186635.724015]  <IRQ>
[186635.724015]  [<ffffffff814dec9a>] do_raw_spin_lock+0xaa/0x110
[186635.724015]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.724015]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.724015]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.724015]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.724015]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.724015]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.724015]  [<ffffffff811a6c3b>] rcu_report_qs_rnp+0x11b/0x130
[186635.724015]  [<ffffffff822a2f1c>] ? _raw_spin_lock_irqsave+0x8c/0xa0
[186635.724015]  [<ffffffff811a84d2>] rcu_process_callbacks+0x242/0x7e0
[186635.724015]  [<ffffffff81119f26>] __do_softirq+0x1b6/0x420
[186635.724015]  [<ffffffff8111a2d9>] irq_exit+0x59/0xb0
[186635.724015]  [<ffffffff8108caaa>] smp_apic_timer_interrupt+0x8a/0xa0
[186635.724015]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.724015]  <EOI>
[186635.724015]  [<ffffffff812492a0>] ? d_lookup+0x20/0x60
[186635.724015]  [<ffffffff8124932b>] d_hash_and_lookup+0x4b/0x50
[186635.724015]  [<ffffffff8129fbae>] proc_flush_task+0x8e/0x190
[186635.724015]  [<ffffffff811155d0>] release_task+0x170/0x5f0
[186635.724015]  [<ffffffff81115480>] ? release_task+0x20/0x5f0
[186635.724015]  [<ffffffff811161d5>] wait_consider_task+0x785/0xe80
[186635.724015]  [<ffffffff81115b4f>] ? wait_consider_task+0xff/0xe80
[186635.724015]  [<ffffffff81116a7d>] do_wait+0x1ad/0x380
[186635.724015]  [<ffffffff81117d7f>] SyS_wait4+0xaf/0xf0
[186635.724015]  [<ffffffff81115030>] ? put_task_struct+0x20/0x20
[186635.724015]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.724015] Code: 00 00 00 00 00 0f 1f 40 00 55 b8 00 01 00 00 48
89 e5 f0 66 0f c1 07 0f b6 d4 38 c2 75 0b 0f 1f 00 5d c3 66 0f 1f 44
00 00 f3 90 <0f> b6 07 38 d0 75 f7 eb ed 0f 1f 44 00 00 0f b7 17 55 31
c0 48
[186635.722420] NMI backtrace for cpu 1
[186635.722420] CPU: 1 PID: 20285 Comm: trinity-child21 Tainted: G
 D W    3.10.0-rc4+ #1
[186635.722420] Hardware name: Hewlett-Packard HP Compaq dc5750 Small
Form Factor/0A64h, BIOS 786E3 v02.10 01/25/2007
[186635.722420] task: ffff880097da8000 ti: ffff88006ba06000 task.ti:
ffff88006ba06000
[186635.722420] RIP: 0010:[<ffffffff814d6741>]  [<ffffffff814d6741>]
__const_udelay+0x1/0x30
[186635.722420] RSP: 0018:ffff88009d603ca0  EFLAGS: 00000006
[186635.722420] RAX: 0000000003000000 RBX: 0000000000002710 RCX:
0000000000000006
[186635.722420] RDX: 0000000000000c00 RSI: ffffffff81090e85 RDI:
0000000000418958
[186635.722420] RBP: ffff88009d603cb8 R08: 0000000000000002 R09:
0000000000000000
[186635.722420] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000082cce8b8
[186635.722420] R13: 0000000082cce8b8 R14: 0000000000000086 R15:
ffff88009d7d4c40
[186635.722420] FS:  00007f29cd971700(0000) GS:ffff88009d600000(0000)
knlGS:0000000000000000
[186635.722420] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[186635.722420] CR2: 0000000000000088 CR3: 000000005d053000 CR4:
00000000000007e0
[186635.722420] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[186635.722420] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[186635.722420] Stack:
[186635.722420]  ffff88009d603cb8 ffffffff8108d9da ffff88009d7d4c40
ffff88009d603ce8
[186635.722420]  ffffffff814dec92 ffff88009d7d4c58 ffff88009d7d4c40
ffff88009d7d4c58
[186635.722420]  0000000000000000 ffff88009d603d10 ffffffff822a2e71
ffffffff8114f86f
[186635.722420] Call Trace:
[186635.722420]  <IRQ>
[186635.722420]  [<ffffffff8108d9da>] ? arch_trigger_all_cpu_backtrace+0x6a/0x80
[186635.722420]  [<ffffffff814dec92>] do_raw_spin_lock+0xa2/0x110
[186635.722420]  [<ffffffff822a2e71>] _raw_spin_lock+0x61/0x80
[186635.722420]  [<ffffffff8114f86f>] ? try_to_wake_up+0x2af/0x340
[186635.722420]  [<ffffffff8114f86f>] try_to_wake_up+0x2af/0x340
[186635.722420]  [<ffffffff8114f90d>] default_wake_function+0xd/0x10
[186635.722420]  [<ffffffff8113eae8>] autoremove_wake_function+0x18/0x40
[186635.722420]  [<ffffffff81147825>] __wake_up_common+0x55/0x90
[186635.722420]  [<ffffffff8114d8d3>] __wake_up+0x43/0x70
[186635.722420]  [<ffffffff8111344d>] wake_up_klogd_work_func+0x5d/0x60
[186635.722420]  [<ffffffff811c78ac>] __irq_work_run+0x6c/0x90
[186635.722420]  [<ffffffff811c7ab9>] irq_work_run+0x29/0x30
[186635.722420]  [<ffffffff8112473d>] update_process_times+0x5d/0x80
[186635.722420]  [<ffffffff8116e5d9>] tick_sched_handle.isra.9+0x49/0x60
[186635.722420]  [<ffffffff8116e737>] tick_sched_timer+0x47/0x70
[186635.722420]  [<ffffffff81141941>] __run_hrtimer+0x261/0x4a0
[186635.722420]  [<ffffffff8116e6f0>] ? tick_sched_do_timer+0x40/0x40
[186635.722420]  [<ffffffff81142929>] hrtimer_interrupt+0x109/0x200
[186635.722420]  [<ffffffff8108caa5>] smp_apic_timer_interrupt+0x85/0xa0
[186635.722420]  [<ffffffff822a5432>] apic_timer_interrupt+0x72/0x80
[186635.722420]  <EOI>
[186635.722420]  [<ffffffff822a3127>] ? _raw_spin_unlock_irq+0x27/0x50
[186635.722420]  [<ffffffff822a312b>] ? _raw_spin_unlock_irq+0x2b/0x50
[186635.722420]  [<ffffffff81180edf>] acct_collect+0x15f/0x1c0
[186635.722420]  [<ffffffff81117946>] do_exit+0xad6/0xb40
[186635.722420]  [<ffffffff81114388>] ? kmsg_dump+0x1f8/0x220
[186635.722420]  [<ffffffff811141b0>] ? kmsg_dump+0x20/0x220
[186635.722420]  [<ffffffff8106af58>] oops_end+0xd8/0xf0
[186635.722420]  [<ffffffff822873a1>] no_context+0x261/0x28c
[186635.722420]  [<ffffffff82287592>] __bad_area_nosemaphore+0x1c6/0x1e4
[186635.722420]  [<ffffffff822875be>] bad_area_nosemaphore+0xe/0x10
[186635.722420]  [<ffffffff8109aa2a>] __do_page_fault+0x47a/0x530
[186635.722420]  [<ffffffff81076f95>] ? x86_pmu_add+0x125/0x140
[186635.722420]  [<ffffffff8106f495>] ? native_sched_clock+0x35/0x80
[186635.722420]  [<ffffffff8106f4e9>] ? sched_clock+0x9/0x10
[186635.722420]  [<ffffffff8115219d>] ? sched_clock_local+0x1d/0x90
[186635.722420]  [<ffffffff814d791d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[186635.722420]  [<ffffffff8109ab09>] do_page_fault+0x9/0x10
[186635.722420]  [<ffffffff822a4148>] page_fault+0x28/0x30
[186635.722420]  [<ffffffff811cd775>] ? group_sched_in+0x55/0x1c0
[186635.722420]  [<ffffffff811cda50>] ctx_sched_in.isra.52+0x170/0x1d0
[186635.722420]  [<ffffffff811cdb08>] perf_event_sched_in.isra.54+0x58/0x80
[186635.722420]  [<ffffffff811cdcd2>]
perf_event_context_sched_in.isra.55+0x92/0xd0
[186635.722420]  [<ffffffff811cdd35>] __perf_event_task_sched_in+0x25/0x2f0
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff8106659c>] ? __switch_to+0x20c/0x4f0
[186635.722420]  [<ffffffff8114906c>] finish_task_switch+0xfc/0x120
[186635.722420]  [<ffffffff822a11a1>] __schedule+0x8a1/0xa00
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff822a1355>] schedule+0x55/0x60
[186635.722420]  [<ffffffff81277475>] inotify_read+0x285/0x390
[186635.722420]  [<ffffffff8113ead0>] ? abort_exclusive_wait+0xb0/0xb0
[186635.722420]  [<ffffffff812771f0>] ? inotify_free_mark+0x20/0x20
[186635.722420]  [<ffffffff8122fefd>] do_loop_readv_writev+0x4d/0x90
[186635.722420]  [<ffffffff812317a9>] do_readv_writev+0x159/0x270
[186635.722420]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[186635.722420]  [<ffffffff81172f85>] ? trace_hardirqs_on_caller+0x185/0x220
[186635.722420]  [<ffffffff812318f7>] vfs_readv+0x37/0x60
[186635.722420]  [<ffffffff812319d0>] SyS_readv+0x50/0xd0
[186635.722420]  [<ffffffff822a47a9>] system_call_fastpath+0x16/0x1b
[186635.722420] Code: 53 48 89 fb e8 d1 8d b9 ff 66 90 48 89 03 31 c0
5b 5d f3 c3 66 0f 1f 44 00 00 55 48 89 e5 ff 15 9e 93 7a 01 5d c3 0f
1f 40 00 55 <48> 8d 04 bd 00 00 00 00 65 48 8b 14 25 60 40 1d 00 48 89
e5 48
