From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] wire up support for the Alpha architecture
Date: Thu, 10 Oct 2013 19:21:32 -0400
Message-ID: <20131010232132.GA27157@redhat.com>
References: <alpine.DEB.2.10.1309101335200.30015@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1309101335200.30015@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Tue, Sep 10, 2013 at 01:43:04PM -0400, Vince Weaver wrote:
 
 > Will Deacon has more exotic hardware than I do: he sent this patch
 > against my perf_fuzzer to add Alpha support (he already used it to find a 
 > kernel bug).
 > 
 > Anyway since I use the trinity headers, the patch applies equally well 
 > against trinity.  
 > 
 > I'm not sure enough with my git skills to know if sending a patch like 
 > this will preserve attributions properly, so I apologize if this breaks 
 > somehow.
 > 
 > ...
 >
 > diff --git a/include/arch-syscalls.h b/include/arch-syscalls.h
 > index 509fd53..7824c13 100644
 > --- a/include/arch-syscalls.h
 > +++ b/include/arch-syscalls.h
 > @@ -32,5 +32,8 @@
 >  #ifdef __sh__
 >  #include "syscalls-sh.h"
 >  #endif
 > +#ifdef __alpha__
 > +#include "syscalls-alpha.h"
 > +#endif
 >  
 
I only just realised... syscalls-alpha.h is missing from this patch.

	Dave
