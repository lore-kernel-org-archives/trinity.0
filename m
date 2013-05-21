From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] Re: a perf_event_open() update
Date: Tue, 21 May 2013 12:54:59 -0400
Message-ID: <20130521165459.GB9163@redhat.com>
References: <alpine.DEB.2.02.1305171115180.8633@vincent-weaver-1.um.maine.edu>
 <20130518010149.GA21455@redhat.com>
 <alpine.DEB.2.02.1305192329560.28551@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305192329560.28551@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Sun, May 19, 2013 at 11:34:53PM -0400, Vince Weaver wrote:
 > 
 > Here's an updated patch that more or less exercises all of the 
 > perf_event_open() bits, up to around the 3.6 kernel or so.
 > 
 > The patch is standalone against current trinity git.
 > 
 > It could definitely use some review and tuning.
 > 
 > I haven't turned up any issues with it, but that's partly because in my 
 > experience (the recent exploit being an exception) perf_event bugs rarely 
 > manifest with just an open call; they usually involve 
 > reads/writes/ioctls/mmaps/signals on the fd that is opened, as well as 
 > problems after fork/exec or else on complex events made of multiple 
 > perf_event_open() calls chained together (the call can take a previously 
 > opened fd as an argument).  Testing things like this will be more 
 > difficult.

Looks ok to me. I applied it after making some whitespace changes.

thanks,

	Dave
