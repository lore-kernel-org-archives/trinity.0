From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: WARNING in arch/x86/kernel/cpu/perf_event.c
Date: Thu, 23 May 2013 17:26:57 +0200
Message-ID: <20130523152657.GF23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305231023240.17701@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305231023240.17701@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, May 23, 2013 at 10:29:07AM -0400, Vince Weaver wrote:
> Hello,
> 
> so now that I got past the OOPS in perf_mmap_close() I re-ran
> the fuzzer and quickly encountered the following WARNing.
> 
> It happens here:
> 
> static void x86_pmu_start(struct perf_event *event, int flags)
> {
>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>         int idx = event->hw.idx;
> 
>         if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>                 return;
> 
> 
> Is it worth trying to come up with a reproducible case for this one?
> 
> I never know how seriously to take WARN_ON_ONCE dumps.

Its not supposed to happen, you're trying to start an already running
event. I'll put it on the todo list.
