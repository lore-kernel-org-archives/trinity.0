From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] hw_breakpoint: cleanups
Date: Thu, 13 Jun 2013 16:01:13 +0200
Message-ID: <20130613140112.GB16339@somewhere>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HRxIPkezCCJl88CqilXPXadmqEIuXgOwawc1yAhYTAw=;
        b=KcN3G/1ePam8CsTXZ3rPug5vZybYUDzcYdDxj4aDW0T4rqO1luZvSOs/JGMx7gXSxt
         JWZfh5jxl4V+qzj1wS2BbiWQdYso6/aC0Hw07OiYoikKIPb/QeshrB1GV57hVny/aOQQ
         wtmrUMWZ5a6RS+8EFZLLkBt434JPXOSH5bdoJnfbO9AqVQYBj9qJZcp4WkJ13XwZCGOL
         QWbrRpoMJv/KfXTWW4yf9ujJ8k9IF8p8LqRVUMvqC3qTFCeEwLyRFCUTag5mA9AKhAY8
         y0oNk3T1MzKTFdqSHG/XSZB11Uim5TVP3o76/T78LneYRh8rSxw9rXupbbgFtBkhqTB6
         LNxw==
Content-Disposition: inline
In-Reply-To: <20130601194526.GA27149@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sat, Jun 01, 2013 at 09:45:26PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> Cleanups, on top of
> 
> 	[PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c

So this series doesn't have the fix for the warning?

> 
> series.
> 
> Oleg.
> 
>  kernel/events/hw_breakpoint.c |   91 ++++++++++++++++-------------------------
>  1 files changed, 35 insertions(+), 56 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
