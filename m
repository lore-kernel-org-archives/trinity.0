From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Fri, 13 Sep 2013 11:50:57 +0200
Message-ID: <20130913095057.GB11611@gmail.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
 <20130912173617.GI18242@two.firstfloor.org>
 <20130913085654.GI31370@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YuJwt0dmEcB/ZlsogEso1HwggNQeSAaZuXJBqrBGyZQ=;
        b=was65fIidp2bhY9BWvxJG5GPVjlqYAPe2IaQv2/ElINiXGbm/YpBjSHqVf3ekdI4ng
         Rn6I/XPE3JuxyHWIk9wmcyL94wjVwO6CGUifwzCqHknseLqwOzX5ykAA62eGhHPizzC3
         +tY2Wrsfst3YH0PDaJSRMfOwHjTGB7hDcz1lCGaemySGHmOm5EFtv6txenuZ2Yw3Lqpu
         PEBFRHwX4HyBejKpcPIvjjSEbLiq4UDwbh1TmYj5Cnv5Vkz0BkSQcrzwmbOIoRU3OR3H
         +KqPZbqalUqu+JxFQ5qn2nvqiWIhyIzxnmwkkath1DuBNvfCwkan2xFcPM9oh6Sa4HQz
         0UUg==
Content-Disposition: inline
In-Reply-To: <20130913085654.GI31370@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Sep 12, 2013 at 07:36:17PM +0200, Andi Kleen wrote:
> > > Your feature to export 'precise' requirements on events looks useful to 
> > > me. We could implement it not by special casing it implicitly but by 
> > > saying that if ../format/precise contains something like:
> > > 
> > >    attr:240-241
> 
> Since we currently have the pattern $name:bits to mean 
> perf_event_attr::$name the above would imply and create a possible 
> collision with perf_event_attr::attr.
> 
> If we're going to do this I'd propose using something like _:240-241, 
> for while '_' is a valid name in C its not something we're ever going to 
> allow in perf_event_attr.

Ok - and I'm not against adding individual 'names' one by one as well, 
that allows us to expose only the fields that relate to event 
configuration.

For example if we added 'type' as well we could expose the generic, 
hardware-independent events via sysfs as well.

( Eventually this scheme would be fit to expose more advanced events as
  well: such as composite groups of events with simple arithmetic 
  operations between them. That would allow the exposure of E1+E2-E3 type 
  of simple calculations. )

> > Wouldn't we need different bits for each architecture then? 
> > 32bit/64bit, some archs with weird alignment rules, maybe different 
> > for BE/LE too?
> 
> Typically PMU drivers are per arch and all the format stuff is per pmu 
> driver so I'd not worry about that just yet.

ok.

> But yes, while the perf_event_attr thing is ABI its not identical across 
> archs.

Yeah, like syscalls - it's not an on-disk format.

> > Ok I suppose it could be somehow auto generated in asm-offsets.c, 
> > although I'm not sure how to get a bitfield offset there.
> 
> Yes, that is an unfortunate situation. I (and either Acme or Jolsa) 
> tried wrapping the bitfield in an anonymous union to create a named 
> variable for the entire u64 but older GCC completely fails with that.

We could be careful with bitfields and enumerate their offsets explicitly, 
with a build time testcase that makes sure that the offsets match reality.

Thanks,

	Ingo
