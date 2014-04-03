From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Thu, 03 Apr 2014 16:43:33 -0400
Message-ID: <533DC7F5.9090202@oracle.com>
References: <51DC9379.9050408@oracle.com> <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com> <20130710095210.GD17211@twins.programming.kicks-ass.net> <1373459254.7458.49.camel@gandalf.local.home> <20130710124245.GT25631@dyad.programming.kicks-ass.net> <1373461091.7458.55.camel@gandalf.local.home> <20130711164204.GK25631@dyad.programming.kicks-ass.net> <1373561726.17876.48.camel@gandalf.local.home> <1373561972.17876.51.camel@gandalf.local.home> <20130711171157.GL25631@dyad.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130711171157.GL25631@dyad.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On 07/11/2013 01:11 PM, Peter Zijlstra wrote:
> On Thu, Jul 11, 2013 at 12:59:32PM -0400, Steven Rostedt wrote:
>> On Thu, 2013-07-11 at 12:55 -0400, Steven Rostedt wrote:
>>
>>>>
>>>> Other than that, a function tracer environment that is safer to use might be
>>>> useful for other people as well.
>>>
>>> Not sure how to make the environment safe, as the main purpose of the
>>> function trace is to debug those hard to debug locations, like NMIs,
>>> RCU, dynamic ticks, etc. To ensure a "safe" environment, it would
>>> cripple the tracer.
>>>
>>> Hmm, what would you state as a safe environment? How can we detect if
>>> the environment is safe to trace or not?
>>
>> Maybe I misunderstood you. You mean to have this environment be
>> something for not just perf, and have the macro be:
>>
>> NONSAFE_TRACE(__local_bh_enable);
>>
>> ?
>>
>> Then, any ftrace user could set a flag in the registering of its ops to
>> 'safe_only_functions'. And it will ignore all of these locations.
>> There's really not many of them, so it may not be too hard to weed out.
> 
> Yah, like that. But that doesn't invalidate your question as to what 'safe'
> would encompass. I think RCU/lockdep would be the big thing for perf, not
> sure it should be wider than that.

Ping? There was no conclusion here and this issue is still ongoing in -next.


Thanks,
Sasha
