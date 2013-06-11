From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Tue, 11 Jun 2013 17:24:37 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306111720440.28238@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu> <20130611210542.GA17585@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130611210542.GA17585@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Tue, 11 Jun 2013, Dave Jones wrote:

> On Tue, Jun 11, 2013 at 12:33:23AM -0400, Vince Weaver wrote:
> 
>  > @@ -80,7 +519,7 @@ static int random_event_type(void)
>  >  
>  >  	int type;
>  >  
>  > -	switch (rand() % 6) {
>  > +	switch (rand() % 8) {
>  >  	case 0:
>  >  		type = PERF_TYPE_HARDWARE;
>  >  		break;
>  > @@ -99,6 +538,9 @@ static int random_event_type(void)
>  >  	case 5:
>  >  		type = PERF_TYPE_BREAKPOINT;
>  >  		break;
>  > +	case 6:
>  > +		type = PERF_TYPE_READ_FROM_SYSFS;
>  > +		break;
>  >  	default:
>  >  		type = rand();
>  >  		break;
> 
> is 8 correct here ? not 7 ?

If you pick 7 then the default case never gets called, correct?  
I think that's a minor bug in the existing implementation, the default
case was never called.

Perhaps proper coding convention would be to have the 
make-the-type-field-completely-random case be an explicit value and use 
the default case only for error handling.

I should also maybe have the completely-random case be 
"completely radom but with preference to values < 256" as that's more
likely to trigger actual valid types.

Vince
