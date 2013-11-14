From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open more likely tracepoint values
Date: Thu, 14 Nov 2013 12:33:52 -0500
Message-ID: <20131114173352.GA5855@redhat.com>
References: <alpine.DEB.2.10.1311141230450.8746@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311141230450.8746@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Thu, Nov 14, 2013 at 12:35:27PM -0500, Vince Weaver wrote:
 
 > Tracepoint ids tend to be relatively small (less than 1024 or so).
 > This change makes it more likely to hit valid ones.
 > 
 > Once the fix to avoid the troublesome 0x18 (irq_work_exit)
 > tracepoint gets into the kernel maybe we can start stressing
 > things with trinity again.
 
applied, though fyi, this (and some other boolean choices) could
be shorter with just

	if (rand_bool())
		foo
	else
		bar

guess it depends if you foresee adding further case's though.

thanks,

	Dave
