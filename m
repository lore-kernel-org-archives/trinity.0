From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Introduce "struct bp_cpuinfo"
Date: Tue, 18 Jun 2013 16:42:25 +0200
Message-ID: <20130618144225.GA26920@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130602194912.GA3277@redhat.com> <20130602195057.GC3277@redhat.com> <20130618123741.GC17619@somewhere.redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130618123741.GC17619@somewhere.redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On 06/18, Frederic Weisbecker wrote:
>
> On Sun, Jun 02, 2013 at 09:50:57PM +0200, Oleg Nesterov wrote:
> > This patch simply moves all per-cpu variables into the new single
> > per-cpu "struct bp_cpuinfo".
> >
> > To me this looks more logical and clean, but this can also simplify
> > the further potential changes. In particular, I do not think this
> > memory should be per-cpu, it is never used "locally". After this
> > change it is trivial to turn it into, say, bootmem[nr_cpu_ids].
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> I'm ok with the patch because it's indeed more logical and clean to pack the info
> to a single struct.

Great,

> But I'm not sure why you think using per-cpu is a problem. It's not only
> deemed for optimized local uses,

But it is.

Simplest example,

	for_each_possible_cpu(cpu)
		total_count = per_cpu(per_cpu_count, cpu);

Every per_cpu() likely means the cache miss. Not to mention we need the
additional math to calculate the address of the local counter.

	for_each_possible_cpu(cpu)
		total_count = bootmem_or_kmalloc_array[cpu];

is much better in this respect.

And note also that per_cpu_count above can share the cacheline with
another "hot" per-cpu variable.

> it's also convenient for allocations and
> de-allocation, or static definitions.

Yes, this is advantage. But afaics the only one.

> I'm not sure why bootmem would make
> more sense.

Or kcalloc(nr_cpu_ids), I didn't really mean that alloc_bootmem() is
necessarily the best option.

> Other than this in the changelog, the patch is nice, thanks!
>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks ;)

Oleg.
