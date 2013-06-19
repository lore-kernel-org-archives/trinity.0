From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Introduce "struct bp_cpuinfo"
Date: Wed, 19 Jun 2013 17:54:04 +0200
Message-ID: <20130619155404.GB9176@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130602194912.GA3277@redhat.com> <20130602195057.GC3277@redhat.com> <20130618123741.GC17619@somewhere.redhat.com> <20130618144225.GA26920@redhat.com> <20130618170145.GI17619@somewhere.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130618170145.GI17619@somewhere.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On 06/18, Frederic Weisbecker wrote:
>
> On Tue, Jun 18, 2013 at 04:42:25PM +0200, Oleg Nesterov wrote:
> >
> > Simplest example,
> >
> > 	for_each_possible_cpu(cpu)
> > 		total_count = per_cpu(per_cpu_count, cpu);
> >
> > Every per_cpu() likely means the cache miss. Not to mention we need the
> > additional math to calculate the address of the local counter.
> >
> > 	for_each_possible_cpu(cpu)
> > 		total_count = bootmem_or_kmalloc_array[cpu];
> >
> > is much better in this respect.
> >
> > And note also that per_cpu_count above can share the cacheline with
> > another "hot" per-cpu variable.
>
> Ah I see, that's good to know.
>
> But these variables are supposed to only be touched from slow path
> (perf events syscall, ptrace breakpoints creation, etc...), right?
> So this is probably not a problem?

Yes, sure. But please note that this can also penalize other CPUs.
For example, toggle_bp_slot() writes to per_cpu(nr_cpu_bp_pinned),
this invalidates the cachline which can contain another per-cpu
variable.

But let me clarify. I agree, this all is minor, I am not trying to
say this change can actually improve the performance.

The main point of this patch is to make the code look a bit better,
and you seem to agree. The changelog mentions s/percpu/array/ only
as a potential change which obviously needs more discussion, I didnt
mean that we should necessarily do this.

Although yes, personally I really dislike per-cpu in this case, but
of course this is subjective and I won't argue ;)

Oleg.
