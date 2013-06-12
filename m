From: Vince Weaver <vincent.weaver@maine.edu>
Subject: perf: yet another fuzzer triggered crash
Date: Wed, 12 Jun 2013 19:19:57 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


Current git of my perf_fuzzer tool (recently enhanced to fork and prctl)
  https://github.com/deater/perf_event_tests/tree/master/fuzzer
rapidly crashes my machine with a 
Warning followed by NMI errors then an rcu_stall then stuck cpus.
This is on a core2 machine.

I don't think these traces look like the other perf RCU bugs that have 
been reported but it's hard to tell.

This is with linux 3.10-rc4 with the 
   [tip:perf/urgent] perf: Fix perf mmap bugs
patch applied. (What's the status of that patch?)

Vince


[ 2716.472065] ------------[ cut here ]------------
[ 2716.476035] WARNING: at kernel/events/core.c:2122 task_ctx_sched_out+0x3c/0x)
[ 2716.476035] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs locn
[ 2716.476035] CPU: 0 PID: 3164 Comm: perf_fuzzer Not tainted 3.10.0-rc4 #2
[ 2716.476035] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2716.476035]  0000000000000000 ffffffff8102e215 0000000000000000 ffff88011fc18
[ 2716.476035]  ffff8801175557f0 0000000000000000 ffff880119fda88c ffffffff810ad
[ 2716.476035]  ffff880119fda880 ffffffff810af02a 0000000000000009 ffff880117550
[ 2716.476035] Call Trace:
[ 2716.476035]  [<ffffffff8102e215>] ? warn_slowpath_common+0x5b/0x70
[ 2716.476035]  [<ffffffff810ab2bd>] ? task_ctx_sched_out+0x3c/0x5f
[ 2716.476035]  [<ffffffff810af02a>] ? perf_event_exit_task+0xbf/0x194
[ 2716.476035]  [<ffffffff81032a37>] ? do_exit+0x3e7/0x90c
[ 2716.476035]  [<ffffffff810cd5ab>] ? __do_fault+0x359/0x394
[ 2716.476035]  [<ffffffff81032fe6>] ? do_group_exit+0x66/0x98
[ 2716.476035]  [<ffffffff8103dbcd>] ? get_signal_to_deliver+0x479/0x4ad
[ 2716.476035]  [<ffffffff810ac05c>] ? __perf_event_task_sched_out+0x230/0x2d1
[ 2716.476035]  [<ffffffff8100205d>] ? do_signal+0x3c/0x432
[ 2716.476035]  [<ffffffff810abbf9>] ? ctx_sched_in+0x43/0x141
[ 2716.476035]  [<ffffffff810ac2ca>] ? perf_event_context_sched_in+0x7a/0x90
[ 2716.476035]  [<ffffffff810ac311>] ? __perf_event_task_sched_in+0x31/0x118
[ 2716.476035]  [<ffffffff81050dd9>] ? mmdrop+0xd/0x1c
[ 2716.476035]  [<ffffffff81051a39>] ? finish_task_switch+0x7d/0xa6
[ 2716.476035]  [<ffffffff81002473>] ? do_notify_resume+0x20/0x5d
[ 2716.476035]  [<ffffffff813654f5>] ? retint_signal+0x3d/0x78
[ 2716.476035] ---[ end trace 827178d8a5966c3d ]---
[ 2718.046014] hrtimer: interrupt took 7185 ns
[ 2738.441822] NOHZ: local_softirq_pending 100
[ 2748.725529] Uhhuh. NMI received for unknown reason 3d on CPU 0.
[ 2748.728006] Do you have a strange power saving mode enabled?
[ 2748.728006] Dazed and confused, but trying to continue
[ 2748.780067] Uhhuh. NMI received for unknown reason 2d on CPU 0.
[ 2748.784003] Do you have a strange power saving mode enabled?
[ 2748.784003] Dazed and confused, but trying to continue
[ 2756.248003] [sched_delayed] sched: RT throttling activated
[ 2777.263999] INFO: rcu_sched self-detected stall on CPU[ 2777.272002] INFO: r)
[ 2777.272005] sending NMI to all CPUs:
[ 2777.264001] NMI backtrace for cpu 0
[ 2777.264001] CPU: 0 PID: 3103 Comm: perf_fuzzer Tainted: G        W    3.10.02
[ 2777.264001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2777.264001] task: ffff88011766a040 ti: ffff880117400000 task.ti: ffff88011740
[ 2777.264001] RIP: 0010:[<ffffffff812450b8>]  [<ffffffff812450b8>] io_serial_i0
[ 2777.264001] RSP: 0000:ffff88011fc03ca0  EFLAGS: 00000002
[ 2777.264001] RAX: ffffffff81245000 RBX: ffffffff8183c7b0 RCX: 0000000000000000
[ 2777.264001] RDX: 00000000000003fd RSI: 00000000000003fd RDI: ffffffff8183c7b0
[ 2777.264001] RBP: 00000000000026c8 R08: 0000000000000000 R09: ffffffff817caa5f
[ 2777.264001] R10: 0000000000000000 R11: ffff88011f008400 R12: 0000000000000020
[ 2777.264001] R13: ffffffff81246509 R14: 0000000000000039 R15: 0000000000000039
[ 2777.264001] FS:  00007ff55cc8a700(0000) GS:ffff88011fc00000(0000) knlGS:00000
[ 2777.264001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2777.264001] CR2: 0000000000404850 CR3: 0000000119557000 CR4: 00000000000407f0
[ 2777.264001] DR0: 0000000000000020 DR1: 0000000000000020 DR2: 0000000000000000
[ 2777.264001] DR3: 0000000000001000 DR6: 00000000ffff0ff0 DR7: 00000000000f0602
[ 2777.264001] Stack:
[ 2777.264001]  ffffffff812464a4 ffffffff8183c7b0 0000000000000065 ffffffff81830
[ 2777.264001]  ffffffff8124651a ffffffff817caa71 ffffffff817caa50 ffffffff81249
[ 2777.264001]  ffffffff8183c7b0 0000000000000000 0000000000000016 0000000000001
[ 2777.264001] Call Trace:
[ 2777.264001]  <IRQ>  [<ffffffff812464a4>] ? wait_for_xmitr+0x1c/0x81
[ 2777.264001]  [<ffffffff8124651a>] ? serial8250_console_putchar+0x11/0x1f
[ 2777.264001]  [<ffffffff812421d9>] ? uart_console_write+0x35/0x47
[ 2777.264001]  [<ffffffff812465c6>] ? serial8250_console_write+0x9e/0xe9
[ 2777.264001]  [<ffffffff8102eb60>] ? call_console_drivers.constprop.21+0x9e/0e
[ 2777.264001]  [<ffffffff8102fa62>] ? console_unlock+0x12e/0x2f9
[ 2777.264001]  [<ffffffff81030158>] ? vprintk_emit+0x3ab/0x3d6
[ 2777.264001]  [<ffffffff8135fa26>] ? printk+0x4f/0x51
[ 2777.264001]  [<ffffffff810656a0>] ? ktime_get+0x5f/0x6b
[ 2777.264001]  [<ffffffff810926fa>] ? rcu_check_callbacks+0x106/0x4bb
[ 2777.264001]  [<ffffffff8106b8d6>] ? tick_sched_do_timer+0x25/0x25
[ 2777.264001]  [<ffffffff8103aa43>] ? update_process_times+0x31/0x5c
[ 2777.264001]  [<ffffffff8106b63a>] ? tick_sched_handle+0x3e/0x4a
[ 2777.264001]  [<ffffffff8106b906>] ? tick_sched_timer+0x30/0x4c
[ 2777.264001]  [<ffffffff8104bf18>] ? __run_hrtimer+0xa9/0x14e
[ 2777.264001]  [<ffffffff8104c525>] ? hrtimer_interrupt+0xbd/0x19e
[ 2777.264001]  [<ffffffff810a9c63>] ? perf_remove_from_context+0x89/0x89
[ 2777.264001]  [<ffffffff8101bca0>] ? smp_apic_timer_interrupt+0x6d/0x7e
[ 2777.264001]  [<ffffffff8136adca>] ? apic_timer_interrupt+0x6a/0x70
[ 2777.264001]  <EOI>  [<ffffffff810aa7de>] ? group_sched_out+0x62/0x62
[ 2777.264001]  [<ffffffff810a9cc7>] ? perf_event_disable+0x64/0x92
[ 2777.264001]  [<ffffffff810a82ce>] ? perf_event_for_each_child+0x62/0x83
[ 2777.264001]  [<ffffffff810ab398>] ? perf_event_task_disable+0x3f/0x6d
[ 2777.264001]  [<ffffffff8104190e>] ? SyS_prctl+0x16a/0x32f
[ 2777.264001]  [<ffffffff8136a212>] ? system_call_fastpath+0x16/0x1b
[ 2777.264001] Code: b6 4f 61 d3 e6 48 63 f6 48 03 77 10 89 16 c3 0f b6 4f 61 d 
[ 2777.272117] NMI backtrace for cpu 1
[ 2777.272119] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.10.0-rc4 2
[ 2777.272120] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2777.272121] task: ffff88011a1c2770 ti: ffff88011a1f0000 task.ti: ffff88011a10
[ 2777.272122] RIP: 0010:[<ffffffff811b8d30>]  [<ffffffff811b8d30>] __delay+0x79
[ 2777.272126] RSP: 0018:ffff88011fc83e60  EFLAGS: 00000847
[ 2777.272127] RAX: ffffffff811b8d67 RBX: 0000000000002710 RCX: 0000000000000040
[ 2777.272127] RDX: 000000000026587d RSI: 0000000000000200 RDI: 000000000026587e
[ 2777.272128] RBP: ffff88011fc8d9a0 R08: 0000000000000000 R09: ffffffff817b8cb4
[ 2777.272129] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81637dc0
[ 2777.272130] R13: 0000000000000001 R14: ffff88011a1f0000 R15: ffffffff81637e80
[ 2777.272131] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:00000
[ 2777.272132] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2777.272133] CR2: 000000000068ce30 CR3: 0000000117917000 CR4: 00000000000407e0
[ 2777.272134] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2777.272135] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2777.272135] Stack:
[ 2777.272136]  ffffffff8101c6bf ffffffff81637dc0 ffffffff810929d0 0000000000008
[ 2777.272138]  0000000000000083 0000000000000001 ffff88011a1c2770 0000000000000
[ 2777.272140]  0000000000000001 ffff88011fc8d370 ffffffff8106b8d6 ffff88011fc80
[ 2777.272141] Call Trace:
[ 2777.272142]  <IRQ>  [<ffffffff8101c6bf>] ? arch_trigger_all_cpu_backtrace+0xf
[ 2777.272145]  [<ffffffff810929d0>] ? rcu_check_callbacks+0x3dc/0x4bb
[ 2777.272148]  [<ffffffff8106b8d6>] ? tick_sched_do_timer+0x25/0x25
[ 2777.272149]  [<ffffffff8103aa43>] ? update_process_times+0x31/0x5c
[ 2777.272152]  [<ffffffff8106b63a>] ? tick_sched_handle+0x3e/0x4a
[ 2777.272153]  [<ffffffff8106b906>] ? tick_sched_timer+0x30/0x4c
[ 2777.272155]  [<ffffffff8104bf18>] ? __run_hrtimer+0xa9/0x14e
[ 2777.272157]  [<ffffffff8104c525>] ? hrtimer_interrupt+0xbd/0x19e
[ 2777.272159]  [<ffffffff8101bca0>] ? smp_apic_timer_interrupt+0x6d/0x7e
[ 2777.272161]  [<ffffffff8136adca>] ? apic_timer_interrupt+0x6a/0x70
[ 2777.272163]  <EOI>  [<ffffffff81008184>] ? default_idle+0x14/0x3a
[ 2777.272167]  [<ffffffff81064648>] ? cpu_startup_entry+0xbf/0x133
[ 2777.272169]  [<ffffffff813574b2>] ? start_secondary+0x1d9/0x1dd
[ 2777.272172] Code: c0 74 1d eb 06 66 0f 1f 44 00 00 eb 0e 66 66 66 66 66 2e 0 

[ 2777.264001]  { 0}  (t=5696 jiffies g=963 c=962 q=24)
[ 2777.264001] sending NMI to all CPUs:
[ 2777.264001] NMI backtrace for cpu 0
[ 2777.264001] CPU: 0 PID: 3103 Comm: perf_fuzzer Tainted: G        W    3.10.02
[ 2777.264001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2777.264001] task: ffff88011766a040 ti: ffff880117400000 task.ti: ffff88011740
[ 2777.264001] RIP: 0010:[<ffffffff811b8d77>]  [<ffffffff811b8d77>] delay_tsc+06
[ 2777.264001] RSP: 0000:ffff88011fc03e60  EFLAGS: 00000847
[ 2777.264001] RAX: 00000000e3cac8fa RBX: 0000000000002710 RCX: 0000000000000040
[ 2777.264001] RDX: 000000000000066e RSI: 0000000000000000 RDI: 000000000026587e
[ 2777.264001] RBP: ffff88011fc0d9a0 R08: 0000000000000000 R09: 0000000000000000
[ 2777.264001] R10: ffffffffffffffff R11: 0000000000000000 R12: ffffffff81637dc0
[ 2777.264001] R13: ffff88011fc0d370 R14: ffff880117400000 R15: 0000000000000000
[ 2777.264001] FS:  00007ff55cc8a700(0000) GS:ffff88011fc00000(0000) knlGS:00000
[ 2777.264001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2777.264001] CR2: 0000000000404850 CR3: 0000000119557000 CR4: 00000000000407f0
[ 2777.264001] DR0: 0000000000000020 DR1: 0000000000000020 DR2: 0000000000000000
[ 2777.264001] DR3: 0000000000001000 DR6: 00000000ffff0ff0 DR7: 00000000000f0602
[ 2777.264001] Stack:
[ 2777.264001]  ffffffff8101c6bf ffffffff81637dc0 ffffffff81092798 0000000000008
[ 2777.264001]  00000000000af4f1 0000000000000000 ffff88011766a040 0000000000000
[ 2777.264001]  0000000000000000 ffff88011fc0d370 ffffffff8106b8d6 ffff88011fc00
[ 2777.264001] Call Trace:
[ 2777.264001]  <IRQ> 
[ 2777.264001]  [<ffffffff8101c6bf>] ? arch_trigger_all_cpu_backtrace+0x76/0x7f
[ 2777.264001]  [<ffffffff81092798>] ? rcu_check_callbacks+0x1a4/0x4bb
[ 2777.264001]  [<ffffffff8106b8d6>] ? tick_sched_do_timer+0x25/0x25
[ 2777.264001]  [<ffffffff8103aa43>] ? update_process_times+0x31/0x5c
[ 2777.264001]  [<ffffffff8106b63a>] ? tick_sched_handle+0x3e/0x4a
[ 2777.264001]  [<ffffffff8106b906>] ? tick_sched_timer+0x30/0x4c
[ 2777.264001]  [<ffffffff8104bf18>] ? __run_hrtimer+0xa9/0x14e
[ 2777.264001]  [<ffffffff8104c525>] ? hrtimer_interrupt+0xbd/0x19e
[ 2777.264001]  [<ffffffff810a9c63>] ? perf_remove_from_context+0x89/0x89
[ 2777.264001]  [<ffffffff8101bca0>] ? smp_apic_timer_interrupt+0x6d/0x7e
[ 2777.264001]  [<ffffffff8136adca>] ? apic_timer_interrupt+0x6a/0x70
[ 2777.264001]  <EOI> 
[ 2777.264001]  [<ffffffff810aa7de>] ? group_sched_out+0x62/0x62
[ 2777.264001]  [<ffffffff810a9cc7>] ? perf_event_disable+0x64/0x92
[ 2777.264001]  [<ffffffff810a82ce>] ? perf_event_for_each_child+0x62/0x83
[ 2777.264001]  [<ffffffff810ab398>] ? perf_event_task_disable+0x3f/0x6d
[ 2777.264001]  [<ffffffff8104190e>] ? SyS_prctl+0x16a/0x32f
[ 2777.264001]  [<ffffffff8136a212>] ? system_call_fastpath+0x16/0x1b
[ 2777.264001] Code: 01 e9 d7 ff ff ff 48 69 ff c7 10 00 00 e9 d4 ff ff ff 48 8 
[ 2779.076001] NMI backtrace for cpu 1
[ 2779.076001] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.10.0-rc4 2
[ 2779.076001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2779.076001] task: ffff88011a1c2770 ti: ffff88011a1f0000 task.ti: ffff88011a10
[ 2779.076001] RIP: 0010:[<ffffffff81008184>]  [<ffffffff81008184>] default_idla
[ 2779.076001] RSP: 0018:ffff88011a1f1f20  EFLAGS: 00000246               
[ 2779.076001] RAX: 0000000000000000 RBX: ffff88011a1f1fd8 RCX: 00000000ffffffff
[ 2779.076001] RDX: 0100000000000000 RSI: 0000000000000001 RDI: ffff88011fc8d81c
[ 2779.076001] RBP: ffff88011a1f1fd8 R08: 0000000000000000 R09: 0000000000000000
[ 2779.076001] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[ 2779.076001] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 2779.076001] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:00000
[ 2779.076001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b          
[ 2779.076001] CR2: 000000000068ce30 CR3: 0000000117917000 CR4: 00000000000407e0
[ 2779.076001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2779.076001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2779.076001] Stack:                                                     
[ 2779.076001]  ffffffff81064648 0000000000000001 0000000000000000 ffffffff81352
[ 2779.076001]  06d775b6cc484548 0000000000000000 0000000000000000 0000000000000
[ 2779.076001]  0000000000000000 0000000000000000 0000000000000000 0000000000000
[ 2779.076001] Call Trace:                                                
[ 2779.076001]  [<ffffffff81064648>] ? cpu_startup_entry+0xbf/0x133
[ 2779.076001]  [<ffffffff813574b2>] ? start_secondary+0x1d9/0x1dd
[ 2779.076001] Code: 08 00 48 8b 7b 08 44 89 e2 89 ee ff 13 48 83 c3 10 48 83 3 
[ 2804.244000] BUG: soft lockup - CPU#0 stuck for 22s! [perf_fuzzer:3103]
[ 2804.244000] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs locn
[ 2804.244000] CPU: 0 PID: 3103 Comm: perf_fuzzer Tainted: G        W    3.10.02
[ 2804.244000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2804.244000] task: ffff88011766a040 ti: ffff880117400000 task.ti: ffff88011740
[ 2804.244000] RIP: 0010:[<ffffffff810a9cc7>]  [<ffffffff810a9cc7>] perf_event_2
[ 2804.244000] RSP: 0000:ffff880117401ed0  EFLAGS: 00000282
[ 2804.244000] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[ 2804.244000] RDX: 0000000000008b6a RSI: ffffffff810aa7de RDI: ffff8801179069cc
[ 2804.244000] RBP: ffff8801179069cc R08: 0000000000000000 R09: 0000000000000000
[ 2804.244000] R10: 0000000000000000 R11: ffff88011f008440 R12: 0000000000000000
[ 2804.244000] R13: ffff8801179069cc R14: 0000000000000000 R15: ffff88011f008440
[ 2804.244000] FS:  00007ff55cc8a700(0000) GS:ffff88011fc00000(0000) knlGS:00000
[ 2804.244000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2804.244000] CR2: 0000000000404850 CR3: 0000000119557000 CR4: 00000000000407f0
[ 2804.244000] DR0: 0000000000000020 DR1: 0000000000000020 DR2: 0000000000000000
[ 2804.244000] DR3: 0000000000001000 DR6: 00000000ffff0ff0 DR7: 00000000000f0602
[ 2804.244000] Stack:
[ 2804.244000]  ffff8801195ac000 ffff8801168b5000 ffff8801195ac1d0 ffffffff810ae
[ 2804.244000]  ffff8801195ac000 ffff88011766a040 ffff88011766a6c8 00007ff55ca74
[ 2804.244000]  ffffffff810ab398 00007ff55ca700f4 00007fffe6c59c2c ffff880117660
[ 2804.244000] Call Trace:
[ 2804.244000]  [<ffffffff810a82ce>] ? perf_event_for_each_child+0x62/0x83
[ 2804.244000]  [<ffffffff810ab398>] ? perf_event_task_disable+0x3f/0x6d
[ 2804.244000]  [<ffffffff8104190e>] ? SyS_prctl+0x16a/0x32f
[ 2804.244000]  [<ffffffff8136a212>] ? system_call_fastpath+0x16/0x1b
[ 2804.244000] Code: 48 89 da 48 c7 c6 de a7 0a 81 e8 cc e4 ff ff 85 c0 74 41 4 
[ 2832.244001] BUG: soft lockup - CPU#0 stuck for 22s! [perf_fuzzer:3103]
[ 2832.244001] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs locn
[ 2832.244001] CPU: 0 PID: 3103 Comm: perf_fuzzer Tainted: G        W    3.10.02
[ 2832.244001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 2832.244001] task: ffff88011766a040 ti: ffff880117400000 task.ti: ffff88011740
[ 2832.244001] RIP: 0010:[<ffffffff810a8177>]  [<ffffffff810a8177>] perf_event_9
[ 2832.244001] RSP: 0000:ffff880117401ec8  EFLAGS: 00000202
[ 2832.244001] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[ 2832.244001] RDX: ffff8801168b5000 RSI: ffffffff810aa7de RDI: ffff880118416770
[ 2832.244001] RBP: ffff8801179069cc R08: 0000000000000000 R09: 0000000000000000
[ 2832.244001] R10: 0000000000000000 R11: ffff88011f008440 R12: 0000000000000000
[ 2832.244001] R13: ffff88011f008440 R14: 0000000000000000 R15: ffff8801179069cc
[ 2832.244001] FS:  00007ff55cc8a700(0000) GS:ffff88011fc00000(0000) knlGS:00000
[ 2832.244001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2832.244001] CR2: 0000000000404850 CR3: 0000000119557000 CR4: 00000000000407f0
[ 2832.244001] DR0: 0000000000000020 DR1: 0000000000000020 DR2: 0000000000000000
[ 2832.244001] DR3: 0000000000001000 DR6: 00000000ffff0ff0 DR7: 00000000000f0602
[ 2832.244001] Stack:
[ 2832.244001]  ffffffff810a9cab ffff8801195ac000 ffff8801168b5000 ffff8801195a0
[ 2832.244001]  ffffffff810a82ce ffff8801195ac000 ffff88011766a040 ffff880117668
[ 2832.244001]  00007ff55ca700e4 ffffffff810ab398 00007ff55ca700f4 00007fffe6c5c
[ 2832.244001] Call Trace:
[ 2832.244001]  [<ffffffff810a9cab>] ? perf_event_disable+0x48/0x92
[ 2832.244001]  [<ffffffff810a82ce>] ? perf_event_for_each_child+0x62/0x83
[ 2832.244001]  [<ffffffff810ab398>] ? perf_event_task_disable+0x3f/0x6d
[ 2832.244001]  [<ffffffff8104190e>] ? SyS_prctl+0x16a/0x32f
[ 2832.244001]  [<ffffffff8136a212>] ? system_call_fastpath+0x16/0x1b
[ 2832.244001] Code: 48 89 47 38 c3 c7 87 68 01 00 00 00 00 00 00 c3 c7 87 68 0 
