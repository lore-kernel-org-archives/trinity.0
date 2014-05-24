From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix buffer overflow in output() when pid slot is not
 found
Date: Fri, 23 May 2014 20:51:02 -0400
Message-ID: <20140524005102.GB7139@redhat.com>
References: <1400836143-22355-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400836143-22355-1-git-send-email-mpe@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Fri, May 23, 2014 at 07:09:03PM +1000, Michael Ellerman wrote:
 > In output() we sprintf() the result of find_pid_slot(). We print the pid
 > slot to the buffer with %u and have space for two digits of pid slot.
 > find_pid_slot() potentially returns PIDSLOT_NOT_FOUND (-1), which when
 > printed with %u is 4294967295 - ten digits.
 > 
 > Fix it two ways, use snprintf() - truncated output is better than a
 > buffer overflow. And allocate more space in the buffer, 32 bytes is a
 > nice round size, and gives us space for everything.

heh, this has been nagging me from time to time, but it wasn't a problem
until recently.   I'm curious why you're hitting that PIDSLOT_NOT_FOUND
case though, as it's a "should never happen" case.

Anyway, it's the right thing to do, so I pushed this out.

 > @@ -311,7 +311,7 @@ void output(unsigned char level, const char *fmt, ...)
 >  		unsigned int slot;
 >  
 >  		slot = find_pid_slot(pid);
 > -		sprintf(child_prefix, "[child%u:%u]", slot, pid);
 > +		snprintf(child_prefix, sizeof(child_prefix), "[child%u:%u]", slot, pid);
 >  		prefix = child_prefix;

might be worth it to add something later to print PIDSLOT_NOT_FOUND entries as '?'
rather than 4294967295.

thanks,

	Dave
