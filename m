From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Fri, 13 Sep 2013 10:48:02 -0700
Message-ID: <20130913174802.GU11427@tassilo.jf.intel.com>
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
Content-Disposition: inline
In-Reply-To: <20130913085654.GI31370@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>, Vince Weaver <vince@deater.net>, acme@infradead.org, linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>

> Typically PMU drivers are per arch and all the format stuff is per pmu
> driver so I'd not worry about that just yet.

That's a good point. So hard coded numbers would be fine for now.

> Yes, that is an unfortunate situation. I (and either Acme or Jolsa)
> tried wrapping the bitfield in an anonymous union to create a named
> variable for the entire u64 but older GCC completely fails with that.

In theory it's possible by parsing readelf output.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
