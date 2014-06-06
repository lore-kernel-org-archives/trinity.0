From: Dave Jones <davej@redhat.com>
Subject: Re: breakage on master.
Date: Fri, 6 Jun 2014 13:54:01 -0400
Message-ID: <20140606175401.GA22525@redhat.com>
References: <20140603205411.GA32313@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140603205411.GA32313@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

On Tue, Jun 03, 2014 at 04:54:11PM -0400, Dave Jones wrote:
 > I just committed some code changing how logging works so that the
 > post-mortem dumping has a possibility of actually working.
 > It looks a lot closer to how I want it to be, but it does seem to have
 > a number of bugs right now which may take a couple days to nail down.

The good news: That work is pretty much done. Next week I'll add
the interesting parts to tainted_postmortem().
It's actually really handy to be able to do something like

	output(0, "%s\n", rec->prebuffer);

and get what would have been dumped to the screen/logs if you hadn't
passed in -q or -l off.


The bad news: While working on this stuff the last few days I found
a bunch of other bugs that I've also committed fixes/workarounds for.
With that stuff out of the way, I'm seeing pretty regular corruption
of the pid map.  This *might* be the bugs that Michael reported last
week has become easier to hit, or it might be that this weeks hacking
has introduced some new damage.

So far I've not had luck tracking it down, so I've pushed out everything
I had pending in the hopes someone else spots something obvious.

When it fails, it's interesting to note that the corrupted values in
the pid map are nearly always the same. I see either -943208505 or
943208504.  Which are 0xc7c7c7c7 and 0x38383838.

Which smells like something has called rand32() -> rept8 on a
stale/wrong pointer somewhere, or we're walking past the end of a buffer.
(though it's curious that that function would nearly always pick those values,
 so maybe my guess is off).

	Dave
