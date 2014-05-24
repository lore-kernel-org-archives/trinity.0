From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Compat fixes for DRM & prctl()
Date: Fri, 23 May 2014 20:48:18 -0400
Message-ID: <20140524004818.GA7139@redhat.com>
References: <1400836165-23714-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400836165-23714-1-git-send-email-mpe@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Fri, May 23, 2014 at 07:09:25PM +1000, Michael Ellerman wrote:
 > ---
 >  include/compat.h | 9 +++++++++
 >  ioctls/drm.c     | 2 ++
 >  2 files changed, 11 insertions(+)
 > 
 > diff --git a/include/compat.h b/include/compat.h
 > index 51f0936..8bdaf92 100644
 > --- a/include/compat.h
 > +++ b/include/compat.h
 > @@ -257,10 +257,19 @@ enum {
 >  
 >  #ifndef PR_SET_MM
 >  #define PR_SET_MM               35
 > +#endif
 > +
 > +#ifndef PR_SET_CHILD_SUBREAPER
 >  #define PR_SET_CHILD_SUBREAPER  36
 >  #define PR_GET_CHILD_SUBREAPER  37
 > +#endif
 > +
 > +#ifndef PR_SET_NO_NEW_PRIVS
 >  #define PR_SET_NO_NEW_PRIVS     38
 >  #define PR_GET_NO_NEW_PRIVS     39
 > +#endif
 > +
 > +#ifndef PR_GET_TID_ADDRESS
 >  #define PR_GET_TID_ADDRESS      40
 >  #endif

I applied Vinson's variant of this, which I think should be
sufficient, because iirc, those all got added at the same time.
Can you send a follow up if needed ?

I edited your diff and applied the DRM part separately.

thanks,

	Dave
