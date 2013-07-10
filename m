From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Wed, 10 Jul 2013 08:27:34 -0400
Message-ID: <1373459254.7458.49.camel@gandalf.local.home>
References: <51DC902F.3070403@oracle.com>
	 <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com>
	 <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com>
	 <20130710095210.GD17211@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130710095210.GD17211@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Wed, 2013-07-10 at 11:52 +0200, Peter Zijlstra wrote:

> Fun.. :-) we trace __local_bh_enable() and hit a ftrace callback between
> telling lockdep we enabled softirqs and actually doing so.
> 
> I'm just a tad confused by the trace; it says we go:
>   lock_is_held()
>     check_flags()
> 
> Looking at perf_tp_event() this would most likely be from:
> 
>   ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);

Function tracing should not be treated as a normal trace point. It is
much more invasive, and there's things that one should be weary about
when using it.

> 
> Where the lock_is_held() would be from rcu_dereference_check()'s
> rcu_read_lock_sched_held(). However, by there we've already passed
> rcu_read_lock() which includes rcu_lock_acquire() -> lock_acquire() ->
> check_flags(). So it should've triggered there.
> 
> Ideally we'd not trace __local_bh_enable() at all, seeing as how any RCU usage
> in there would be bound to trigger this.

I find it very useful to trace __local_bh_enable(). I also trace RCU
calls.

When using function tracing, you need to use
rcu_dereference_raw_notrace().

Also, function tracing callbacks should avoid rcu_read_lock(), as that's
traced as well. You can use preempt_disable_notrace() for rcu usage.

-- Steve

