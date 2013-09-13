From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Fri, 13 Sep 2013 10:56:54 +0200
Message-ID: <20130913085654.GI31370@twins.programming.kicks-ass.net>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
 <20130912173617.GI18242@two.firstfloor.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130912173617.GI18242@two.firstfloor.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>

On Thu, Sep 12, 2013 at 07:36:17PM +0200, Andi Kleen wrote:
> > Your feature to export 'precise' requirements on events looks useful to 
> > me. We could implement it not by special casing it implicitly but by 
> > saying that if ../format/precise contains something like:
> > 
> >    attr:240-241

Since we currently have the pattern $name:bits to mean
perf_event_attr::$name the above would imply and create a possible
collision with perf_event_attr::attr.

If we're going to do this I'd propose using something like _:240-241,
for while '_' is a valid name in C its not something we're ever going to
allow in perf_event_attr.

> > then that's a natural extension of the config:X-Y format and should be 
> > interpreted to mean mean 2 bits in the perf attr field. I.e. we could go 
> > beyond the config bitfield.
> > 
> > Basically the whole perf_event_attr can be thought of as a 'giant 
> > bitfield', in which we can specify values to export an enumerated list of 
> > events from the kernel to tooling.
> > 
> > (Using attr:X-Y the config and config1 variants can be expressed as well, 
> > as the config fields are inside the attr structure.)
> > 
> > The positions within the perf_attr are an ABI, so this would work pretty 
> > well.
> 
> Wouldn't we need different bits for each architecture then?
> 32bit/64bit, some archs with weird alignment rules, maybe different for
> BE/LE too?

Typically PMU drivers are per arch and all the format stuff is per pmu
driver so I'd not worry about that just yet.

But yes, while the perf_event_attr thing is ABI its not identical across
archs.

> Ok I suppose it could be somehow auto generated in asm-offsets.c,
> although I'm not sure how to get a bitfield offset there.

Yes, that is an unfortunate situation. I (and either Acme or Jolsa)
tried wrapping the bitfield in an anonymous union to create a named
variable for the entire u64 but older GCC completely fails with that.
