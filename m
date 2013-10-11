From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] wire up support for the Alpha architecture
Date: Fri, 11 Oct 2013 12:04:20 +0100
Message-ID: <20131011110419.GG14732@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1309101335200.30015@vincent-weaver-1.um.maine.edu>
 <20131010232132.GA27157@redhat.com>
 <alpine.DEB.2.10.1310102235240.11534@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1310102235240.11534@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Fri, Oct 11, 2013 at 03:38:27AM +0100, Vince Weaver wrote:
> On Thu, 10 Oct 2013, Dave Jones wrote:
> 
> >  > diff --git a/include/arch-syscalls.h b/include/arch-syscalls.h
> >  > index 509fd53..7824c13 100644
> >  > --- a/include/arch-syscalls.h
> >  > +++ b/include/arch-syscalls.h
> >  > @@ -32,5 +32,8 @@
> >  >  #ifdef __sh__
> >  >  #include "syscalls-sh.h"
> >  >  #endif
> >  > +#ifdef __alpha__
> >  > +#include "syscalls-alpha.h"
> >  > +#endif
> >  >  
> >  
> > I only just realised... syscalls-alpha.h is missing from this patch.
> > 
> 
> You're right, the patch was originally against perf_fuzzer which doesn't 
> need the various syscall includes.
> 
> I've cc'd Will Deacon, the original author, in case he's not on this list.

I'll try and find some time to generate that file.

> I wish I still had access to some actual Alpha hardware.

You can get some off ebay, but you'll probably be bidding against me :)

Will
