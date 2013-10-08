From: Dave Jones <davej@redhat.com>
Subject: Re: workaround/blacklist/exclude perf?
Date: Tue, 8 Oct 2013 13:31:59 -0400
Message-ID: <20131008173159.GA20593@redhat.com>
References: <20131008152209.GZ7782@lakka.kapsi.fi>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131008152209.GZ7782@lakka.kapsi.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: trinity@vger.kernel.org

On Tue, Oct 08, 2013 at 06:22:09PM +0300, Mikko Rapeli wrote:
 > Is there some simple trick to exclude a single test case which produces
 > an oops?
 > 
 > I'm hitting one of the perf issues after few minutes but would like to
 > continue testing other kernel subsystems.

The perf bugs are nasty.  You can try -x perf_event_open, (and also edit
open_perf_fds in perf.c to just return instantly, but in my experience even
with this, somehow we still end up triggering perf stuff. I've no explanation for it.

	Dave

