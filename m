From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Wed, 10 Jul 2013 11:54:59 +0200
Message-ID: <20130710095459.GE17211@twins.programming.kicks-ass.net>
References: <51DC902F.3070403@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51DC902F.3070403@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Tue, Jul 09, 2013 at 06:35:27PM -0400, Sasha Levin wrote:
> While going through the NMI dump, I noticed that it's very incomplete, and full of:
> 
> [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler)
> took too long to run: 697182.008 msecs

Now I would actually expect arch_trigger_all_cpu_backtrace_handler() to
issue this warning, that said, ~700 seconds is a bit long, I'm fairly
sure it didn't actually take that long, you'd have noticed your vm being
'away' for 10+ minutes I'd think, no?


There's something entirely fishy with that stuff, let me to stare at it.
