From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Expected 0x
Date: Wed, 3 Jul 2013 23:07:45 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307032258290.13409@vincent-weaver-1.um.maine.edu>
References: <20130703182141.GA13149@redhat.com> <alpine.DEB.2.10.1307031435440.12584@vincent-weaver-1.um.maine.edu> <1372905759.12381.3.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372905759.12381.3.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, ak@linux.intel.com

On Thu, 4 Jul 2013, Michael Ellerman wrote:

> On Wed, 2013-07-03 at 14:43 -0400, Vince Weaver wrote:
> > 
> > The only documentation for what to expect are the lex/yacc files in
> > tools/perf/util/parse-events.*
> 
> It's sort of documented here:
> 
> Documentation/ABI/testing/sysfs-bus-event_source-devices-events
>  
> Though strictly speaking that only applies to the events listed in that
> file, which doesn't include mem-loads.
> 
> And it says it should be hex.

now don't I look silly, I had just sent a patch to linux-kernel 
documenting the files but putting it in 
    Documentation/ABI/stable/sysfs-bus-event_source-devices
rather than testing.  My search through git log somehow missed when this 
got added.

Oh I see, it came through the Power people and not through perf_event, 
that's how I missed it.

I guess I should complain about the non-hex value.  I'm more worried that 
the perf people are going to start leaking more complex perf-tool specific 
syntax into the files.

Vince
