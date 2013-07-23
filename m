From: Vince Weaver <vince@deater.net>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Tue, 23 Jul 2013 17:27:43 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130723060108.GA18396@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org


I hate having to justify why breaking the ABI is unacceptable.


On Mon, 22 Jul 2013, Andi Kleen wrote:

> On Tue, Jul 23, 2013 at 01:40:40AM -0400, Vince Weaver wrote:
> > On Mon, 22 Jul 2013, Andi Kleen wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Add a precise qualifier, like cpu/event=0x3c,precise=1/
> > 
> > So you're adding this to "events/" but not to "format/"?
> 
> Fair point, but note that precise_ip is a bitfield. Since there is no
> way to express that currently the parser would need to special case it anyways.

It breaks the ABI.  The events/* sysfs files are documented as only 
holding values for the bitfields described in format/*.

The perf_event ABI is there for all tools, not to just be a thin shim
for the perf tool.

Even if the maintainers for whatever are going to just ignore the ABI, 
then fine, but then I'd like to see a patch also updating the sysfs
ABI documentation and a patch to the perf_event_open.2 manpage would be 
nice as well.

> > This will break various existing programs.
> 
> Like what?

Why does it matter?  It breaks multiple programs I work on.

A major one is the trinity fuzzer, which parses perf_event sysfs to 
construct valid events.

The code won't segfault because I wrote the parser to be robust, but it 
will spit a warning when invalid junk is put in the sysfs events
files, and I'll get e-mails about it spamming trinity runs with warning 
messages within hours of such a commit hitting linus-git.

I'm a bit grumpy about this because I just finished fixing the fallout 
from your last time breaking the ABI a few weeks ago when your broken code 
started dumping non-hex fields into the sysfs event strings.  I've learned 
now that I have to go over your patches with a fine-tooth code because you 
have no regard for the ABI.

Vince

