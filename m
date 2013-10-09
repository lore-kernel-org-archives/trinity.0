From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: workaround/blacklist/exclude perf?
Date: Wed, 9 Oct 2013 09:58:50 +0300
Message-ID: <20131009065850.GC7782@lakka.kapsi.fi>
References: <20131008152209.GZ7782@lakka.kapsi.fi>
 <20131008173159.GA20593@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131008173159.GA20593@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Tue, Oct 08, 2013 at 01:31:59PM -0400, Dave Jones wrote:
> On Tue, Oct 08, 2013 at 06:22:09PM +0300, Mikko Rapeli wrote:
>  > Is there some simple trick to exclude a single test case which produces
>  > an oops?
>  > 
>  > I'm hitting one of the perf issues after few minutes but would like to
>  > continue testing other kernel subsystems.
> 
> The perf bugs are nasty.  You can try -x perf_event_open, (and also edit
> open_perf_fds in perf.c to just return instantly, but in my experience even
> with this, somehow we still end up triggering perf stuff. I've no explanation for it.

Thanks, trying this but will follow the lkml thread
( https://lkml.org/lkml/2013/10/8/527 ) too if there's something more that
can be done.

-Mikko
