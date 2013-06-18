From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] hw_breakpoint: Simplify
 *register_wide_hw_breakpoint()
Date: Tue, 18 Jun 2013 02:12:16 +0200
Message-ID: <20130618001214.GA15563@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130602194912.GA3277@redhat.com>
 <20130602195011.GB3277@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=A7io6vxgR15S4DKf/eaX3pDigTgnW2IyWi4XEkK66cc=;
        b=ubzqvW/kmWRJX5CqEv+3ODCYnzvat8FGxteeRMjrVuRaAH1jlJLAIJw7XGqek+I7E9
         ztjIoDgU3tqn3RJRbj3M/Vm4KT9DF14qAByrjGEKpUgXqUPEIj1LgRiuySCaOgtoRRo/
         GmJJLJFlDsuL44oVal+GxzbAOw7THYB3Gjy1PrXEm8Kb5vtsJTMA1MD2pF1rsDY9aBtb
         q6YCNy/70auhrNByCyMxAaYYM8iw/mz0ciVTFmt6rhG1eXe92a+JCsVDA3EuxDSrOnrY
         yNYK03KOquT+l7f7ezx75HkXyiYSvibSD0k3oV3RXyNPGl17LHkzqR1J2jppV5tcTwhM
         tV4w==
Content-Disposition: inline
In-Reply-To: <20130602195011.GB3277@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sun, Jun 02, 2013 at 09:50:11PM +0200, Oleg Nesterov wrote:
> 1. register_wide_hw_breakpoint() can use unregister_ if failure,
>    no need to duplicate the code.
> 
> 2. "struct perf_event **pevent" adds the unnecesary lever of
>    indirection and complication, use per_cpu(*cpu_events, cpu).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
