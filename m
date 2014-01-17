From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] fix divide by zero in random/taviso()
Date: Fri, 17 Jan 2014 16:03:56 -0500
Message-ID: <20140117210356.GA10744@redhat.com>
References: <alpine.DEB.2.10.1401171519070.6751@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1401171541490.6771@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401171541490.6771@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Fri, Jan 17, 2014 at 03:41:58PM -0500, Vince Weaver wrote:

 > I'm not sure if this is the cleanest fix for the issue, but it seems to 
 > work for me.
 
Good enough.

 > In random.c the taviso() routine uses "rand() % rand()" which
 > can cause a floating point exception if rand() returns 0.
 > Add some tests to make sure that doesn't happen.
 > 
 > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
 > 
 > diff --git a/random.c b/random.c
 > index 7def9ff..a71fcea 100644
 > --- a/random.c
 > +++ b/random.c
 > @@ -42,6 +42,7 @@ static unsigned long randbits(int limit)
 >  static unsigned long taviso(void)
 >  {
 >  	unsigned long r = 0;
 > +	unsigned long temp;
 >  
 >  	switch (rand() % 4) {
 >  	case 0:	r = rand() & rand();
 > @@ -51,10 +52,14 @@ static unsigned long taviso(void)
 >  #endif
 >  		break;
 >  
 > -	case 1:	r = rand() % rand();
 > +	case 1:	temp = rand();
 > +		r = rand();
 > +		if (!temp) r %= temp;
 >  #if __WORDSIZE == 64
 >  		r <<= 32;
 > -		r |= rand() % rand();
 > +
 > +		temp = rand();
 > +		if (!temp) r |= rand() % temp;
 >  #endif
 >  		break;

Good catch.  Despite the function name, this is something I introduced,
not something that was in Tavis' original code in iknowthis.

Mea culpa.

	Dave

 
