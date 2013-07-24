From: Vince Weaver <vince@deater.net>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Wed, 24 Jul 2013 14:47:03 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1307241433380.8230@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130723225150.GT6123@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org

On Wed, 24 Jul 2013, Andi Kleen wrote:

> On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> > 

> So format/precise would be 
> 
> flags:15-16
> 
> on little endian. Looks good?

I'd prefer if it were

  precise_ip:0-1

as the code you use to set the value looks like 
   attr->precise_ip=2;
I don't think you can even set bits 15-16 of flags directly, can you?

Althought having to have a parser being able to parse the names of all 50+
perf_event->attr arguments, then parse hex/decimal strings from another
file in sysfs, then trying to map that to binary fields in a complicated
structure that is then passed to a syscall gets a bit stupid at some 
point; this is one of the silliest interfaces I've had to deal with and 
I've done low-level X11 programming before.

Ideally we could do something sane, such as maybe having the event 
descriptions in a library in userspace where it belongs but it's a bit
late to close the barn door now.

> > I'm a bit grumpy about this because I just finished fixing the fallout 
> > from your last time breaking the ABI a few weeks ago when your broken code 
> > started dumping non-hex fields into the sysfs event strings.  I've learned 
> 
> Not sure what you're talking about?

I'm pretty sure it was one of your patches that added the new memory stuff 
which had "ldlat=1" in one of the events, and that was not a hex value 
prefixed by 0x as specified in the ABI documentation and thus broke
various parsers.

By the time I caught this the perf_event maintainers declared it was too 
late to do anything about it.

Vince
