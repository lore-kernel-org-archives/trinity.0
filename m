From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Introduce "struct bp_cpuinfo"
Date: Tue, 18 Jun 2013 19:01:48 +0200
Message-ID: <20130618170145.GI17619@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130602194912.GA3277@redhat.com>
 <20130602195057.GC3277@redhat.com>
 <20130618123741.GC17619@somewhere.redhat.com>
 <20130618144225.GA26920@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5S5JGbA1BxhjbOY54BOsrG5A0697EdZqksWtU4/+Tss=;
        b=aYl9b1Wwqq59S08kb6kXQu3zIckqHXKBYQC9W0hw98fPy4FnKAYbGMfD8QuscuuHzc
         AZCpMR3HvWOyuAAgMohj5zcqL5q8TIzByDqzF9cnLBRWgbJYWH2c312vYBJHw+4O/9Ua
         32dLqg0ZW5MT7GG77xZe7dvqLFcs8cI/PjAWgdMEBweqk1MrZ6eNu8CSvRUWMVTd71hQ
         JUWQIu72MPT+V28bpoFZ4LhT1ZDF2O6uD70fTtDdISsskfhtT2kaSBhgN1CFd5Tae4DF
         rVfYRBRPYfwE2dBLdgy4KvleB5F/bjO4Pfs4hrV5/n4HUzQoDPMooWn4LiPD29P1dHqs
         nUXw==
Content-Disposition: inline
In-Reply-To: <20130618144225.GA26920@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Tue, Jun 18, 2013 at 04:42:25PM +0200, Oleg Nesterov wrote:
> On 06/18, Frederic Weisbecker wrote:
> >
> > On Sun, Jun 02, 2013 at 09:50:57PM +0200, Oleg Nesterov wrote:
> > > This patch simply moves all per-cpu variables into the new single
> > > per-cpu "struct bp_cpuinfo".
> > >
> > > To me this looks more logical and clean, but this can also simplify
> > > the further potential changes. In particular, I do not think this
> > > memory should be per-cpu, it is never used "locally". After this
> > > change it is trivial to turn it into, say, bootmem[nr_cpu_ids].
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > I'm ok with the patch because it's indeed more logical and clean to pack the info
> > to a single struct.
> 
> Great,
> 
> > But I'm not sure why you think using per-cpu is a problem. It's not only
> > deemed for optimized local uses,
> 
> But it is.
> 
> Simplest example,
> 
> 	for_each_possible_cpu(cpu)
> 		total_count = per_cpu(per_cpu_count, cpu);
> 
> Every per_cpu() likely means the cache miss. Not to mention we need the
> additional math to calculate the address of the local counter.
> 
> 	for_each_possible_cpu(cpu)
> 		total_count = bootmem_or_kmalloc_array[cpu];
> 
> is much better in this respect.
> 
> And note also that per_cpu_count above can share the cacheline with
> another "hot" per-cpu variable.

Ah I see, that's good to know.

But these variables are supposed to only be touched from slow path
(perf events syscall, ptrace breakpoints creation, etc...), right?
So this is probably not a problem?

> 
> > it's also convenient for allocations and
> > de-allocation, or static definitions.
> 
> Yes, this is advantage. But afaics the only one.
> 
> > I'm not sure why bootmem would make
> > more sense.
> 
> Or kcalloc(nr_cpu_ids), I didn't really mean that alloc_bootmem() is
> necessarily the best option.

Ok.

Well if there are any real performance issue I don't mind using arrays
of course.

> 
> > Other than this in the changelog, the patch is nice, thanks!
> >
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks ;)
> 
> Oleg.
> 
