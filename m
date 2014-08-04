From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open() Linux 3.16 additions
Date: Mon, 4 Aug 2014 17:55:18 -0400
Message-ID: <20140804215518.GA15670@redhat.com>
References: <alpine.DEB.2.11.1408040012001.630@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408040012001.630@vincent-weaver-1.umelst.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Mon, Aug 04, 2014 at 12:16:18AM -0400, Vince Weaver wrote:
 > 
 > Update perf_event_open support to add new features from the recent Linux 
 > 3.16 release.
 > 
 > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
 > 
 > diff --git a/include/perf_event.h b/include/perf_event.h
 > index 98d2ab5..9269de2 100644
 > --- a/include/perf_event.h
 > +++ b/include/perf_event.h
 > ....
 > @@ -812,3 +820,5 @@ struct perf_branch_entry {
 >  		abort:1,    /* transaction abort */
 >  		reserved:60;
 >  };
 > +
 > +#endif /* _UAPI_LINUX_PERF_EVENT_H */

I think this endif is bogus..

$ make
  CC	syscalls/perf_event_open.o
In file included from syscalls/perf_event_open.c:16:0:
include/perf_event.h:823:2: error: #endif without #if
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
  ^
make: *** [syscalls/perf_event_open.o] Error 1


Luckily I hadn't pushed that out yet. Care to respin it with that fixed,
and have a quick eyeball to make sure nothing else made it in that shouldn't have ?

thanks,

	Dave
