From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: workaround/blacklist/exclude perf?
Date: Thu, 10 Oct 2013 17:31:44 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1310101725550.6748@vincent-weaver-1.um.maine.edu>
References: <20131008152209.GZ7782@lakka.kapsi.fi> <20131008173159.GA20593@redhat.com> <20131009065850.GC7782@lakka.kapsi.fi>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131009065850.GC7782@lakka.kapsi.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Wed, 9 Oct 2013, Mikko Rapeli wrote:

> On Tue, Oct 08, 2013 at 01:31:59PM -0400, Dave Jones wrote:
>
> > The perf bugs are nasty.  You can try -x perf_event_open, (and also edit
> > open_perf_fds in perf.c to just return instantly, but in my experience even
> > with this, somehow we still end up triggering perf stuff. I've no explanation for it.
> 
> Thanks, trying this but will follow the lkml thread
> ( https://lkml.org/lkml/2013/10/8/527 ) too if there's something more that
> can be done.

For what it's worth, I've been pounding on one of my machines with my 
perf_fuzzer generating traces to try to get a small reproducible test case 
for these bugs.  

It's tricky as even when I find a random seed that triggers things early 
and record a trace, it only triggers the bug on replay maybe 1 in 5 times.  
Which makes any sort of bisection hard :(

Also I keep turning up bugs in my fuzzer due to sillyness in the 
perf_event interface.  I wasted a whole day figuring out that
  a). perf_event_open lets you specify any size for the size field
      as long as it's between 64 and 4096
  b). however, if the value is larger than the kernel expects you
      better have all zeros as padding. (good luck if you allocated
      the struct on the stack and so have leftover garbage at replay
      that wasn't there at record)
  c). if you don't have the right size, the kernel will helpfully 
      over-write your "size" field with its own idea of the size field, 
      so if you try to print things to see what's wrong after the fact 
      you'll always get a good value and pull your hair out trying to 
      figure out what is going on.

Also it returns E2BIG if the value is too small.  Fun times.

Vince
