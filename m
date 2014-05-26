From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] Fix buffer overflow in output() when pid slot is not
 found
Date: Mon, 26 May 2014 15:11:17 +1000
Message-ID: <1401081077.3839.3.camel@concordia>
References: <1400836143-22355-1-git-send-email-mpe@ellerman.id.au>
	 <20140524005102.GB7139@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140524005102.GB7139@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Fri, 2014-05-23 at 20:51 -0400, Dave Jones wrote:
> On Fri, May 23, 2014 at 07:09:03PM +1000, Michael Ellerman wrote:
>  > In output() we sprintf() the result of find_pid_slot(). We print the pid
>  > slot to the buffer with %u and have space for two digits of pid slot.
>  > find_pid_slot() potentially returns PIDSLOT_NOT_FOUND (-1), which when
>  > printed with %u is 4294967295 - ten digits.
>  > 
>  > Fix it two ways, use snprintf() - truncated output is better than a
>  > buffer overflow. And allocate more space in the buffer, 32 bytes is a
>  > nice round size, and gives us space for everything.
> 
> heh, this has been nagging me from time to time, but it wasn't a problem
> until recently.   I'm curious why you're hitting that PIDSLOT_NOT_FOUND
> case though, as it's a "should never happen" case.

Yeah, I figured it wasn't meant to happen.

> Anyway, it's the right thing to do, so I pushed this out.
> 
>  > @@ -311,7 +311,7 @@ void output(unsigned char level, const char *fmt, ...)
>  >  		unsigned int slot;
>  >  
>  >  		slot = find_pid_slot(pid);
>  > -		sprintf(child_prefix, "[child%u:%u]", slot, pid);
>  > +		snprintf(child_prefix, sizeof(child_prefix), "[child%u:%u]", slot, pid);
>  >  		prefix = child_prefix;
> 
> might be worth it to add something later to print PIDSLOT_NOT_FOUND entries as '?'
> rather than 4294967295.

I thought about it, but figured "4294967295" was actually a good eye-catcher.
If you'd prefer "?" then let me know and I can do a patch for that. I haven't
actually hit that case again though.

cheers

