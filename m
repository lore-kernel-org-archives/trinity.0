From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: Expected 0x
Date: Thu, 04 Jul 2013 12:42:39 +1000
Message-ID: <1372905759.12381.3.camel@concordia>
References: <20130703182141.GA13149@redhat.com>
	 <alpine.DEB.2.10.1307031435440.12584@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1307031435440.12584@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, ak@linux.intel.com

On Wed, 2013-07-03 at 14:43 -0400, Vince Weaver wrote:
> On Wed, 3 Jul 2013, Dave Jones wrote:
> 
> > Linus' current tree seems to trigger this in perf_event_open on startup:
> > 
> >                         if (value[ptr]!='0') fprintf(stderr,"Expected 0x\n");
> >                         ptr++;
> >                         if (value[ptr]!='x') fprintf(stderr,"Expected 0x\n");
> >                         ptr++;
> > 
> > I think it's from this..
> > 
> > /sys/bus/event_source/devices/cpu/events/mem-loads
> > event=0xcd,umask=0x1,ldlat=3
> > 
> > Looks like that field isn't always hex.
> 
> Ugh, I would have thought they were using sprintf() or something
> to generate these, but they just hard-code the string in the kernel.
> 
>   EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
> 
> The only documentation for what to expect are the lex/yacc files in
> tools/perf/util/parse-events.*

It's sort of documented here:

Documentation/ABI/testing/sysfs-bus-event_source-devices-events


Though strictly speaking that only applies to the events listed in that
file, which doesn't include mem-loads.

And it says it should be hex.

cheers

