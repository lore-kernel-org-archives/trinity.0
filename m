From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Tue, 11 Jun 2013 17:32:30 -0400
Message-ID: <20130611213230.GB17585@redhat.com>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
 <20130611210542.GA17585@redhat.com>
 <alpine.DEB.2.10.1306111720440.28238@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306111720440.28238@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Tue, Jun 11, 2013 at 05:24:37PM -0400, Vince Weaver wrote:
 > On Tue, 11 Jun 2013, Dave Jones wrote:
 > 
 > > On Tue, Jun 11, 2013 at 12:33:23AM -0400, Vince Weaver wrote:
 > > 
 > >  > @@ -80,7 +519,7 @@ static int random_event_type(void)
 > >  >  
 > >  >  	int type;
 > >  >  
 > >  > -	switch (rand() % 6) {
 > >  > +	switch (rand() % 8) {
 > >  >  	case 0:
 > >  >  		type = PERF_TYPE_HARDWARE;
 > >  >  		break;
 > >  > @@ -99,6 +538,9 @@ static int random_event_type(void)
 > >  >  	case 5:
 > >  >  		type = PERF_TYPE_BREAKPOINT;
 > >  >  		break;
 > >  > +	case 6:
 > >  > +		type = PERF_TYPE_READ_FROM_SYSFS;
 > >  > +		break;
 > >  >  	default:
 > >  >  		type = rand();
 > >  >  		break;
 > > 
 > > is 8 correct here ? not 7 ?
 > 
 > If you pick 7 then the default case never gets called, correct?  
 > I think that's a minor bug in the existing implementation, the default
 > case was never called.

ah, yeah, I see.

 > Perhaps proper coding convention would be to have the 
 > make-the-type-field-completely-random case be an explicit value and use 
 > the default case only for error handling.

yeah, that's what I've done in a lot of other places (actually BUG() in those cases).
For the most part they're present just to shut up -Wswitch-default, which
has caught a few cases in the past where I've missed an option.
 
 > I should also maybe have the completely-random case be 
 > "completely radom but with preference to values < 256" as that's more
 > likely to trigger actual valid types.

ok, I'll apply what you sent so far. (and hold off on running it through Lindent for now,
you really don't like whitespace huh? ;)

	Dave
