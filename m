From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [testcase] perf: yet another fuzzer triggered crash
Date: Mon, 1 Jul 2013 11:07:13 +0200
Message-ID: <20130701090713.GO6626@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Fri, Jun 28, 2013 at 05:07:38PM -0400, Vince Weaver wrote:
> On Fri, 28 Jun 2013, Vince Weaver wrote:
> 
> > On Fri, 14 Jun 2013, Vince Weaver wrote:
> >  
> > > OK, I haven't managed to get a small reproducible test case for the system 
> > > crash yet
> > 
> > I wasted the last 2 days bisecting a 10000 syscall trace, but below is a 
> > 20-syscall testcase that rapidly makes a core2 machine running 3.10-rc7 
> > unusable.
> 
> and it turns out I might have bisected down too much, as though that 
> crashes my core2 system it doesn't crash newer machines.
> 
> I'm too lazy to re-bisect today, but the much longer program here:
>    http://web.eece.maine.edu/~vweaver/files/nmi_bug_snb.c
> reliably causes the same crash on a Sandybridge machine I have running 3.9

OK, so on my westmere it triggers that WARN in task_ctx_sched_out() a
_lot_ (I removed the ONCE for easier debugging earlier -- still kinda
stumped there).

Then this thing causes an RCU stall and starts triggering NMI watchdog
msgs.. so YAY! :-)

I'll see what I can find.

