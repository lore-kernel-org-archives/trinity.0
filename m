From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] update perf_event_open() for Linux 3.19
Date: Wed, 4 Feb 2015 15:41:17 -0500 (EST)
Message-ID: <alpine.DEB.2.11.1502041538420.5222@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1502031159070.30766@vincent-weaver-1.umelst.maine.edu> <20150204203100.GA1842@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=DsFu7aI/lMqPjScbLox6EREVCViy29ic8q6/nkV8Vus=;
        b=ZLIhnRb7DX3QnIm1VEgzuGYZdwfFTgB3pkQi8LXgl2OWSec1A8DFxscnrQkSz+0RXX
         xbSjuKTUXWq72J5ttJ1VZ5lDX2jvlguNG+Iiso6DR5rOHqGUxQH2CIABKUAmI2CU6dlV
         OyZaRxpu3wx9UHi0vbd0lqlUpoJvTZLvcX3qo=
In-Reply-To: <20150204203100.GA1842@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

On Wed, 4 Feb 2015, Dave Jones wrote:

> On Tue, Feb 03, 2015 at 12:01:23PM -0500, Vince Weaver wrote:
> 
> 
>  > @@ -237,6 +238,7 @@ enum perf_event_read_format {
>  >  #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
>  >  #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
>  >  					/* add: sample_stack_user */
>  > +#define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */
> 
> I've not given this a lot of thought before, but I'm assuming these
> are the 64-bit struct sizes.  It might be interesting to also
> throw some 32-bit sizes in the mix.  Who knows what horrors
> lie in wait for the compat syscalls.

I might be misunderstanding, but I think the attr structure is defined in 
a way that it has the same size on 32 and 64 bit.

Now, there are bitfields mixed into the interface so it causes some 
unspeakable horrors if you try to do cross-endian stuff (as some powerpc 
people have discovered), but I think as far as structure size goes the 
interface is clear.

I do have to admit though that at least the perf_fuzzer only does native 
calls to the system calls so I never stress the compat code at all.

Vince
