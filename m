From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Tue, 11 Jun 2013 17:05:42 -0400
Message-ID: <20130611210542.GA17585@redhat.com>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Tue, Jun 11, 2013 at 12:33:23AM -0400, Vince Weaver wrote:

 > @@ -80,7 +519,7 @@ static int random_event_type(void)
 >  
 >  	int type;
 >  
 > -	switch (rand() % 6) {
 > +	switch (rand() % 8) {
 >  	case 0:
 >  		type = PERF_TYPE_HARDWARE;
 >  		break;
 > @@ -99,6 +538,9 @@ static int random_event_type(void)
 >  	case 5:
 >  		type = PERF_TYPE_BREAKPOINT;
 >  		break;
 > +	case 6:
 > +		type = PERF_TYPE_READ_FROM_SYSFS;
 > +		break;
 >  	default:
 >  		type = rand();
 >  		break;

is 8 correct here ? not 7 ?

	Dave
