From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Tue, 09 Jul 2013 19:09:51 -0400
Message-ID: <51DC983F.2010409@oracle.com>
References: <51DC902F.3070403@oracle.com> <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com> <20130709230316.GB13855@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130709230316.GB13855@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On 07/09/2013 07:03 PM, Dave Jones wrote:
> On Tue, Jul 09, 2013 at 06:49:29PM -0400, Sasha Levin wrote:
>   > On 07/09/2013 06:47 PM, Dave Jones wrote:
>
>   > >   > [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run:
>   > >   > 697182.008 msecs
>   > >
>   > > I've been reporting these (and other traces) for a while https://lkml.org/lkml/2013/7/5/185 [1]
>   > > on bare-metal.
>   >
>   > Interesting. It's the first time I'm seeing these, but I haven't really changed
>   > anything in my configuration.
>   >
>   > Are you also seeing the "NMI handler took too long" messages?
>
> Now that I look closer, one difference is you're seeing arch_trigger_all_cpu_backtrace_handler
> in that message. I'm seeing them from perf_event_nmi_handler.

perf huh? I also have this spew I'm currently working on, it seems related:

[ 1443.380407] ------------[ cut here ]------------
[ 1443.381713] WARNING: CPU: 20 PID: 49263 at kernel/lockdep.c:3552 check_flags+0x16b/0x220()
[ 1443.383988] DEBUG_LOCKS_WARN_ON(current->softirqs_enabled)
[ 1443.385452] Modules linked in:
[ 1443.386459] CPU: 20 PID: 49263 Comm: trinity-child50 Tainted: G        W 
3.10.0-next-20130709-sasha #3953
[ 1443.388735]  0000000000000de0 ffff880805e03ab8 ffffffff84191329 ffffffff8519f386
[ 1443.390082]  ffff880805e03b08 ffff880805e03af8 ffffffff811279cc ffffffff8519f386
[ 1443.390082]  0000000000000000 ffff8807cf898000 ffffffff85a66940 0000000000000082
[ 1443.390082] Call Trace:
[ 1443.390082]  <IRQ>  [<ffffffff84191329>] dump_stack+0x52/0x87
[ 1443.390082]  [<ffffffff811279cc>] warn_slowpath_common+0x8c/0xc0
[ 1443.390082]  [<ffffffff81127ab6>] warn_slowpath_fmt+0x46/0x50
[ 1443.390082]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
[ 1443.390082]  [<ffffffff811a192b>] check_flags+0x16b/0x220
[ 1443.390082]  [<ffffffff811a2ee7>] lock_is_held+0x77/0x110
[ 1443.390082]  [<ffffffff8419d644>] ? sub_preempt_count+0x4/0xf0
[ 1443.390082]  [<ffffffff8122dafe>] perf_tp_event+0xbe/0x450
[ 1443.390082]  [<ffffffff8122de62>] ? perf_tp_event+0x422/0x450
[ 1443.390082]  [<ffffffff8419d644>] ? sub_preempt_count+0x4/0xf0
[ 1443.390082]  [<ffffffff812185f2>] perf_ftrace_function_call+0xc2/0xe0
[ 1443.390082]  [<ffffffff811f8c78>] ? ftrace_ops_control_func+0xc8/0x140
[ 1443.427495]  [<ffffffff8419d644>] ? sub_preempt_count+0x4/0xf0
[ 1443.427495]  [<ffffffff81131917>] ? __local_bh_enable+0xc7/0xd0
[ 1443.427495]  [<ffffffff811f8c78>] ftrace_ops_control_func+0xc8/0x140
[ 1443.427495]  [<ffffffff841a1c3c>] ftrace_call+0x5/0x2f
[ 1443.427495]  [<ffffffff841a1c3c>] ? ftrace_call+0x5/0x2f
[ 1443.427495]  [<ffffffff81175b87>] ? vtime_account_irq_exit+0x67/0x80
[ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
[ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
[ 1443.427495]  [<ffffffff8113185e>] ? __local_bh_enable+0xe/0xd0
[ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
[ 1443.427495]  [<ffffffff81131917>] __local_bh_enable+0xc7/0xd0
[ 1443.427495]  [<ffffffff81132d07>] __do_softirq+0x447/0x4d0
[ 1443.427495]  [<ffffffff8419d649>] ? sub_preempt_count+0x9/0xf0
[ 1443.427495]  [<ffffffff81132ed6>] irq_exit+0x86/0x120
[ 1443.427495]  [<ffffffff841a43ea>] smp_apic_timer_interrupt+0x4a/0x60
[ 1443.427495]  [<ffffffff841a2d32>] apic_timer_interrupt+0x72/0x80
[ 1443.427495]  <EOI>  [<ffffffff81130542>] ? do_setitimer+0x242/0x2a0
[ 1443.427495]  [<ffffffff8419871c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 1443.427495]  [<ffffffff84198700>] ? _raw_spin_unlock_irq+0x30/0x80
[ 1443.427495]  [<ffffffff81130542>] do_setitimer+0x242/0x2a0
[ 1443.427495]  [<ffffffff811306fa>] alarm_setitimer+0x3a/0x70
[ 1443.427495]  [<ffffffff8113b41e>] SyS_alarm+0xe/0x20
[ 1443.427495]  [<ffffffff841a2240>] tracesys+0xdd/0xe2
[ 1443.427495] ---[ end trace e3b9a6b9c7462a51 ]---
