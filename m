From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Thu, 12 Sep 2013 19:59:36 +0200
Message-ID: <20130912175935.GA32511@gmail.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
 <20130912173617.GI18242@two.firstfloor.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OCwuhWghyAFbkmcuareUEMVaK+lI7tUCQLQ0V55/I/8=;
        b=sXGJHl7MvNIlQt0YPO6Cpi5VW9Fguauy1y4U1WGHjnmmgNi5L60889+b37lssZ/rgV
         /l8d/AcAd+znKqdLsyUhA0NzCB0omh1KTxkMrXR1SZaFNz3UP4iO2bZX1hcaE3VtBDKe
         O2d5KPvR3m+0tDeMS9BtOoLMZKdn9xSe87qHFbU1NmQqq5SEhTBryHQW4cnCS2Ssw9dg
         8MGIP+kN4UPQRvP7d7AqE7lWpsbhWt+LZNEDlE6bUqJbJB9LzIihutbP93aPgFwrd4rT
         OKFEhdubLlJ9zZxc3UOUuIdZRsne25ACcuwDnk21ZVxnjnTXO6Q5hgXbRaBW8i/g+xKg
         0ZjQ==
Content-Disposition: inline
In-Reply-To: <20130912173617.GI18242@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>


* Andi Kleen <andi@firstfloor.org> wrote:

> > Your feature to export 'precise' requirements on events looks useful to 
> > me. We could implement it not by special casing it implicitly but by 
> > saying that if ../format/precise contains something like:
> > 
> >    attr:240-241
> > 
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
> Wouldn't we need different bits for each architecture then? 32bit/64bit, 
> some archs with weird alignment rules, maybe different for BE/LE too?
> 
> Ok I suppose it could be somehow auto generated in asm-offsets.c, 
> although I'm not sure how to get a bitfield offset there.

That, or we could indeed start adding specific field names as well, which 
would have a natural position and order.

Thanks,

	Ingo
