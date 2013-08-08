From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: perf,arm -- another (different) fuzzer oops
Date: Wed, 7 Aug 2013 22:31:28 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1308072227060.16962@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com> <5202D5B0.9020107@codeaurora.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <5202D5B0.9020107@codeaurora.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Wed, 7 Aug 2013, Stephen Boyd wrote:

> ---8<----
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index d9f5cd4..21f7790 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -53,7 +53,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
>  static int
>  armpmu_map_hw_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
>  {
> -       int mapping = (*event_map)[config];
> +       int mapping;
> +
> +       if (config >= PERF_COUNT_HW_MAX)
> +               return -ENOENT;
> +
> +       mapping = (*event_map)[config];
>         return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
>  }

I've tested this patch and my testcase no longer causes the kernel to 
oops, so 

Tested-by: Vince Weaver <vincent.weaver@maine.edu>

Thanks,

Vince
