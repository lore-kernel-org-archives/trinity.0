From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Thu, 11 Jul 2013 12:55:26 -0400
Message-ID: <1373561726.17876.48.camel@gandalf.local.home>
References: <51DC902F.3070403@oracle.com>
	 <20130709224706.GA13855@redhat.com> <51DC9379.9050408@oracle.com>
	 <20130709230316.GB13855@redhat.com> <51DC983F.2010409@oracle.com>
	 <20130710095210.GD17211@twins.programming.kicks-ass.net>
	 <1373459254.7458.49.camel@gandalf.local.home>
	 <20130710124245.GT25631@dyad.programming.kicks-ass.net>
	 <1373461091.7458.55.camel@gandalf.local.home>
	 <20130711164204.GK25631@dyad.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130711164204.GK25631@dyad.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Thu, 2013-07-11 at 18:42 +0200, Peter Zijlstra wrote:

> I'm afraid this is going to be hard to create and hard to keep correct :/

That's the nature of tracing functions ;-)

> 
> Other than that, a function tracer environment that is safer to use might be
> useful for other people as well.

Not sure how to make the environment safe, as the main purpose of the
function trace is to debug those hard to debug locations, like NMIs,
RCU, dynamic ticks, etc. To ensure a "safe" environment, it would
cripple the tracer.

Hmm, what would you state as a safe environment? How can we detect if
the environment is safe to trace or not?

-- Steve

