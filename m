From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] fix divide by zero in random/taviso()
Date: Tue, 21 Jan 2014 14:07:03 -0500
Message-ID: <20140121190703.GA27774@redhat.com>
References: <alpine.DEB.2.10.1401171519070.6751@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1401171541490.6771@vincent-weaver-1.um.maine.edu>
 <20140117210356.GA10744@redhat.com>
 <CAKB9nXvQmAU-PXjqbezf7G5bWfrjMTD5LjoFnj98K8Tyy5eQ2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKB9nXvQmAU-PXjqbezf7G5bWfrjMTD5LjoFnj98K8Tyy5eQ2Q@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Honig <ahonig@google.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, trinity@vger.kernel.org

On Tue, Jan 21, 2014 at 11:03:43AM -0800, Andrew Honig wrote:
 
 > >  > In random.c the taviso() routine uses "rand() % rand()" which
 > >  > can cause a floating point exception if rand() returns 0.
 > >  > Add some tests to make sure that doesn't happen.
 > >  >
 > >  > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
 > >  >
 > >  > diff --git a/random.c b/random.c
 > >  > index 7def9ff..a71fcea 100644
 > >  > --- a/random.c
 > >  > +++ b/random.c
 > >  > @@ -42,6 +42,7 @@ static unsigned long randbits(int limit)
 > >  >  static unsigned long taviso(void)
 > >  >  {
 > >  >      unsigned long r = 0;
 > >  > +    unsigned long temp;
 > >  >
 > >  >      switch (rand() % 4) {
 > >  >      case 0: r = rand() & rand();
 > >  > @@ -51,10 +52,14 @@ static unsigned long taviso(void)
 > >  >  #endif
 > >  >              break;
 > >  >
 > >  > -    case 1: r = rand() % rand();
 > >  > +    case 1: temp = rand();
 > >  > +            r = rand();
 > >
 > 
 > Perhaps, I'm reading this wrong, but this looks backwards to me.  This will
 > perform the mod operation only when temp is 0.  Shouldn't this be
 > if (temp) r %= temp;

clang seems to agree.

random.c:57:16: warning: Division by zero
                if (!temp) r %= temp;
                           ~~^~~~~~~
random.c:62:26: warning: Division by zero
                if (!temp) r |= rand() % temp;
                                ~~~~~~~^~~~~~

Vince, want to send a follow-up fix ?

	Dave
