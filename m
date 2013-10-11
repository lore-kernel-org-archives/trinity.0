From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] wire up support for the Alpha architecture
Date: Thu, 10 Oct 2013 22:38:27 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1310102235240.11534@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1309101335200.30015@vincent-weaver-1.um.maine.edu> <20131010232132.GA27157@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131010232132.GA27157@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: will.deacon@arm.com, trinity@vger.kernel.org

On Thu, 10 Oct 2013, Dave Jones wrote:

>  > diff --git a/include/arch-syscalls.h b/include/arch-syscalls.h
>  > index 509fd53..7824c13 100644
>  > --- a/include/arch-syscalls.h
>  > +++ b/include/arch-syscalls.h
>  > @@ -32,5 +32,8 @@
>  >  #ifdef __sh__
>  >  #include "syscalls-sh.h"
>  >  #endif
>  > +#ifdef __alpha__
>  > +#include "syscalls-alpha.h"
>  > +#endif
>  >  
>  
> I only just realised... syscalls-alpha.h is missing from this patch.
> 

You're right, the patch was originally against perf_fuzzer which doesn't 
need the various syscall includes.

I've cc'd Will Deacon, the original author, in case he's not on this list.

I wish I still had access to some actual Alpha hardware.

Vince
