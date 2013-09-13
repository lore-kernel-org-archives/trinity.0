From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Fri, 13 Sep 2013 13:29:56 +0200
Message-ID: <20130913112956.GA21832@twins.programming.kicks-ass.net>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
 <20130912173617.GI18242@two.firstfloor.org>
 <20130913085654.GI31370@twins.programming.kicks-ass.net>
 <20130913095057.GB11611@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130913095057.GB11611@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>

On Fri, Sep 13, 2013 at 11:50:57AM +0200, Ingo Molnar wrote:
> For example if we added 'type' as well we could expose the generic, 
> hardware-independent events via sysfs as well.

Type is already fully implied by where you'll find the event in sysfs:

  /sys/bus/event_sources/devices/$PMU/events/

needs

  perf_event_attr::type := /sys/bus/event_sources/devices/$PMU/type
