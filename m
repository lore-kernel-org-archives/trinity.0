From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] perf_event_open more likely tracepoint values
Date: Fri, 15 Nov 2013 15:45:44 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1311151544140.12594@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311141230450.8746@vincent-weaver-1.um.maine.edu> <20131114173352.GA5855@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131114173352.GA5855@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Thu, 14 Nov 2013, Dave Jones wrote:

> On Thu, Nov 14, 2013 at 12:35:27PM -0500, Vince Weaver wrote:
>  
>  > Tracepoint ids tend to be relatively small (less than 1024 or so).
>  > This change makes it more likely to hit valid ones.
>  > 
>  > Once the fix to avoid the troublesome 0x18 (irq_work_exit)
>  > tracepoint gets into the kernel maybe we can start stressing
>  > things with trinity again.
>  
> applied, though fyi, this (and some other boolean choices) could
> be shorter with just
> 
> 	if (rand_bool())
> 		foo
> 	else
> 		bar
> 
> guess it depends if you foresee adding further case's though.

I wasn't sure of rand_bool() was only meant for setting boolean flag 
variables or if it should be also used as the generic "choose one of two 
options" selector.  

I'll start using it instead of rand()%2 in future patches.

Vince
