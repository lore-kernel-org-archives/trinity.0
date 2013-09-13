From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Fri, 13 Sep 2013 10:31:59 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1309131021540.31072@vincent-weaver-1.um.maine.edu>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com> <20130912173617.GI18242@two.firstfloor.org> <20130913085654.GI31370@twins.programming.kicks-ass.net> <20130913095057.GB11611@gmail.com> <20130913112956.GA21832@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130913112956.GA21832@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>

On Fri, 13 Sep 2013, Peter Zijlstra wrote:

> On Fri, Sep 13, 2013 at 11:50:57AM +0200, Ingo Molnar wrote:
> > For example if we added 'type' as well we could expose the generic, 
> > hardware-independent events via sysfs as well.
> 
> Type is already fully implied by where you'll find the event in sysfs:
> 
>   /sys/bus/event_sources/devices/$PMU/events/
> 
> needs
> 
>   perf_event_attr::type := /sys/bus/event_sources/devices/$PMU/type


OK, fine, another question then.

Is there any reason these values have to be human-readable?

The only reason you are using this crazy format I can see is because it 
makes maintaining your personal userspace implementation (perf) easier at 
the expense of everyone else who want to use this interface.

Honestly, an interface like
cat   /sys/bus/event_sources/devices/$PMU/events/new_event

   size=320,0xdeadbeef,0xcafef00d,....,0x000000

when you just set up an array, copy in the values, then memcpy() it into
place on top of a struct attr is a million times easier than what you are 
propsing:
   1. A huge complicated LEX/YACC parser
   2. The parser has to read in many different files under ../format/..
      and build up a tree of names and shift/masks
   3. The event is read in and then text has to be parsed, values read,
      and then shifting-masking to get a value for each register
   4. A mapping has to be in the code of the various (of the over 40+)
      fields in the struct perf_attr field, and each value has to
      be put at the proper offset
   5. If ever a new field is added to struct perf_attr, then any event
      using it breaks until your parser is updated with all the info
      about this field.

It's huge, takes up non-swappable kernel mem with lots of individual sysfs
files, requires a complex parser for what should be just a simple
config setup, and is fragile when new fields are added.

But of course since perf is tightly coupled into the kernel source tree 
you can get away with it.  I guess I should just be glad you aren't 
exporting it as XML or something.

Vince
