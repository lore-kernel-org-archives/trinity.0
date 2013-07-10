From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Wed, 10 Jul 2013 10:47:40 -0400
Message-ID: <51DD740C.5090000@oracle.com>
References: <51DC902F.3070403@oracle.com> <20130710095459.GE17211@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130710095459.GE17211@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On 07/10/2013 05:54 AM, Peter Zijlstra wrote:
> On Tue, Jul 09, 2013 at 06:35:27PM -0400, Sasha Levin wrote:
>> While going through the NMI dump, I noticed that it's very incomplete, and full of:
>>
>> [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler)
>> took too long to run: 697182.008 msecs
>
> Now I would actually expect arch_trigger_all_cpu_backtrace_handler() to
> issue this warning, that said, ~700 seconds is a bit long, I'm fairly
> sure it didn't actually take that long, you'd have noticed your vm being
> 'away' for 10+ minutes I'd think, no?
>
>
> There's something entirely fishy with that stuff, let me to stare at it.

Yeah, it didn't actually hang that long - that number is bogus.


Thanks,
Sasha
