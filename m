From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Wed, 10 Jul 2013 11:52:10 +0200
Message-ID: <20130710095210.GD17211@twins.programming.kicks-ass.net>
References: <51DC902F.3070403@oracle.com>
 <20130709224706.GA13855@redhat.com>
 <51DC9379.9050408@oracle.com>
 <20130709230316.GB13855@redhat.com>
 <51DC983F.2010409@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51DC983F.2010409@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, rostedt@goodmis.org

On Tue, Jul 09, 2013 at 07:09:51PM -0400, Sasha Levin wrote:
> perf huh? I also have this spew I'm currently working on, it seems related:
> 
> [ 1443.380407] ------------[ cut here ]------------
> [ 1443.381713] WARNING: CPU: 20 PID: 49263 at kernel/lockdep.c:3552 check_flags+0x16b/0x220()
> [ 1443.383988] DEBUG_LOCKS_WARN_ON(current->softirqs_enabled)
> [ 1443.385452] Modules linked in:
> [ 1443.386459] CPU: 20 PID: 49263 Comm: trinity-child50 Tainted: G        W
> 3.10.0-next-20130709-sasha #3953
> [ 1443.388735]  0000000000000de0 ffff880805e03ab8 ffffffff84191329 ffffffff8519f386
> [ 1443.390082]  ffff880805e03b08 ffff880805e03af8 ffffffff811279cc ffffffff8519f386
> [ 1443.390082]  0000000000000000 ffff8807cf898000 ffffffff85a66940 0000000000000082
> [ 1443.390082] Call Trace:
> [ 1443.390082]  <IRQ>  [<ffffffff84191329>] dump_stack+0x52/0x87
> [ 1443.390082]  [<ffffffff811279cc>] warn_slowpath_common+0x8c/0xc0
> [ 1443.390082]  [<ffffffff81127ab6>] warn_slowpath_fmt+0x46/0x50
> [ 1443.390082]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
> [ 1443.390082]  [<ffffffff811a192b>] check_flags+0x16b/0x220
> [ 1443.390082]  [<ffffffff811a2ee7>] lock_is_held+0x77/0x110
> [ 1443.390082]  [<ffffffff8419d644>] ? sub_preempt_count+0x4/0xf0
> [ 1443.390082]  [<ffffffff8122dafe>] perf_tp_event+0xbe/0x450
> [ 1443.390082]  [<ffffffff8122de62>] ? perf_tp_event+0x422/0x450
> [ 1443.390082]  [<ffffffff8419d644>] ? sub_preempt_count+0x4/0xf0
> [ 1443.390082]  [<ffffffff812185f2>] perf_ftrace_function_call+0xc2/0xe0
> [ 1443.390082]  [<ffffffff811f8c78>] ? ftrace_ops_control_func+0xc8/0x140
> [ 1443.427495]  [<ffffffff8419d644>] ? sub_preempt_count+0x4/0xf0
> [ 1443.427495]  [<ffffffff81131917>] ? __local_bh_enable+0xc7/0xd0
> [ 1443.427495]  [<ffffffff811f8c78>] ftrace_ops_control_func+0xc8/0x140
> [ 1443.427495]  [<ffffffff841a1c3c>] ftrace_call+0x5/0x2f
> [ 1443.427495]  [<ffffffff841a1c3c>] ? ftrace_call+0x5/0x2f
> [ 1443.427495]  [<ffffffff81175b87>] ? vtime_account_irq_exit+0x67/0x80
> [ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
> [ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
> [ 1443.427495]  [<ffffffff8113185e>] ? __local_bh_enable+0xe/0xd0
> [ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
> [ 1443.427495]  [<ffffffff81131917>] __local_bh_enable+0xc7/0xd0
> [ 1443.427495]  [<ffffffff81132d07>] __do_softirq+0x447/0x4d0
> [ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
> [ 1443.427495]  [<ffffffff81132ed6>] irq_exit+0x86/0x120
> [ 1443.427495]  [<ffffffff841a43ea>] smp_apic_timer_interrupt+0x4a/0x60
> [ 1443.427495]  [<ffffffff841a2d32>] apic_timer_interrupt+0x72/0x80
> [ 1443.427495]  <EOI>  [<ffffffff81130542>] ? do_setitimer+0x242/0x2a0
> [ 1443.427495]  [<ffffffff8419871c>] ? _raw_spin_unlock_irq+0x4c/0x80
> [ 1443.427495]  [<ffffffff84198700>] ? _raw_spin_unlock_irq+0x30/0x80
> [ 1443.427495]  [<ffffffff81130542>] do_setitimer+0x242/0x2a0
> [ 1443.427495]  [<ffffffff811306fa>] alarm_setitimer+0x3a/0x70
> [ 1443.427495]  [<ffffffff8113b41e>] SyS_alarm+0xe/0x20
> [ 1443.427495]  [<ffffffff841a2240>] tracesys+0xdd/0xe2
> [ 1443.427495] ---[ end trace e3b9a6b9c7462a51 ]---

Fun.. :-) we trace __local_bh_enable() and hit a ftrace callback between
telling lockdep we enabled softirqs and actually doing so.

I'm just a tad confused by the trace; it says we go:
  lock_is_held()
    check_flags()

Looking at perf_tp_event() this would most likely be from:

  ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);

Where the lock_is_held() would be from rcu_dereference_check()'s
rcu_read_lock_sched_held(). However, by there we've already passed
rcu_read_lock() which includes rcu_lock_acquire() -> lock_acquire() ->
check_flags(). So it should've triggered there.

Ideally we'd not trace __local_bh_enable() at all, seeing as how any RCU usage
in there would be bound to trigger this.

Steven?
