From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Tue, 11 Jun 2013 18:25:14 -0400
Message-ID: <20130611222514.GC17585@redhat.com>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
 <20130611210542.GA17585@redhat.com>
 <alpine.DEB.2.10.1306111720440.28238@vincent-weaver-1.um.maine.edu>
 <20130611213230.GB17585@redhat.com>
 <alpine.DEB.2.10.1306111815001.6833@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306111815001.6833@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Tue, Jun 11, 2013 at 06:21:08PM -0400, Vince Weaver wrote:
 > On Tue, 11 Jun 2013, Dave Jones wrote:
 > 
 > > yeah, that's what I've done in a lot of other places (actually BUG() in those cases).
 > > For the most part they're present just to shut up -Wswitch-default, which
 > > has caught a few cases in the past where I've missed an option.
 > 
 > I'll go back through and check out all of the switch statements (there 
 > are a lot of them) and make sure they handle the default case 
 > consistently.
 >   
 > > ok, I'll apply what you sent so far. (and hold off on running it through Lindent for now,
 > > you really don't like whitespace huh? ;)
 > 
 > Not enough whitespace?  Or over-use of tabs?

Mostly stuff like this. ..

	if((foo&bar)==0) i=rand();

instead of

	if ((foo & bar) == 0)
		i = rand();

indent -kr gets it mostly right. I tried bending the kernels scripts/Lindent to fit,
but I'm still not 100% happy.  It's good for a start point though.

	Dave
 
