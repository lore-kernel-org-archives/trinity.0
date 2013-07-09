From: Dave Jones <davej@redhat.com>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Tue, 9 Jul 2013 19:03:16 -0400
Message-ID: <20130709230316.GB13855@redhat.com>
References: <51DC902F.3070403@oracle.com>
 <20130709224706.GA13855@redhat.com>
 <51DC9379.9050408@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51DC9379.9050408@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Tue, Jul 09, 2013 at 06:49:29PM -0400, Sasha Levin wrote:
 > On 07/09/2013 06:47 PM, Dave Jones wrote:
 
 > >   > [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run:
 > >   > 697182.008 msecs
 > >
 > > I've been reporting these (and other traces) for a while https://lkml.org/lkml/2013/7/5/185 [1]
 > > on bare-metal.
 > 
 > Interesting. It's the first time I'm seeing these, but I haven't really changed
 > anything in my configuration.
 > 
 > Are you also seeing the "NMI handler took too long" messages?

Now that I look closer, one difference is you're seeing arch_trigger_all_cpu_backtrace_handler
in that message. I'm seeing them from perf_event_nmi_handler.

	Dave

