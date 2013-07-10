From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Wed, 10 Jul 2013 08:58:11 -0400
Message-ID: <1373461091.7458.55.camel@gandalf.local.home>
References: <51DC902F.3070403@oracle.com>
	 <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com>
	 <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com>
	 <20130710095210.GD17211@twins.programming.kicks-ass.net>
	 <1373459254.7458.49.camel@gandalf.local.home>
	 <20130710124245.GT25631@dyad.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130710124245.GT25631@dyad.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Wed, 2013-07-10 at 14:42 +0200, Peter Zijlstra wrote:

> but but but preempt_disable_notrace() isn't an rcu_read_lock().. You can only
> do that for rcu_sched.

Right. And not even rcu_sched is safe, as function tracing can trace
functions out of rcu scope. That's why I had to add that code to do a
schedule_on_each_cpu() in ftrace.

> 
> Anyway, I don't see a nice way out of this mess :/ the entire perf core uses
> regular RCU and converting all that is going to me a nasty big patch.

There is an easier way. We can add a way to have perf not trace specific
functions. Now there's already infrastructure there to pick and choose
what to trace and what not to for individual function tracing users like
perf. The trick will be how to annotate them.

If there's a way to mark a function without moving it to a section, this
would be possible. Perhaps similar to EXPORT_SYMBOL(). We could add a
PERF_NOTRACE().

static void __local_bh_enable()
{
	[...]
}
PERF_NOTRACE(__local_bh_enable);

And add these to a black list of functions that perf should not trace.

How's that sound?

-- Steve

