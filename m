From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Expected 0x
Date: Wed, 3 Jul 2013 14:43:30 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307031435440.12584@vincent-weaver-1.um.maine.edu>
References: <20130703182141.GA13149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130703182141.GA13149@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, 3 Jul 2013, Dave Jones wrote:

> Linus' current tree seems to trigger this in perf_event_open on startup:
> 
>                         if (value[ptr]!='0') fprintf(stderr,"Expected 0x\n");
>                         ptr++;
>                         if (value[ptr]!='x') fprintf(stderr,"Expected 0x\n");
>                         ptr++;
> 
> I think it's from this..
> 
> /sys/bus/event_source/devices/cpu/events/mem-loads
> event=0xcd,umask=0x1,ldlat=3
> 
> Looks like that field isn't always hex.

Ugh, I would have thought they were using sprintf() or something
to generate these, but they just hard-code the string in the kernel.

  EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");

The only documentation for what to expect are the lex/yacc files in
tools/perf/util/parse-events.*

I can sort of muddle my way through lex/yacc enough to see that it looks 
like both hex and decimal are allowed, so I'll update the parser for 
trinity.

I guess I should reverse-engineer what the lex/yacc is doing and document 
it in the manpage since this is an official ABI.  Fun times.


Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
