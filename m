From: Will Deacon <will.deacon@arm.com>
Subject: Re: perf,arm -- another (different) fuzzer oops
Date: Thu, 8 Aug 2013 13:09:39 +0100
Message-ID: <20130808120939.GB18724@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu>
 <20130807223129.GA17118@mudshark.cambridge.arm.com>
 <5202D5B0.9020107@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5202D5B0.9020107@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Thu, Aug 08, 2013 at 12:18:08AM +0100, Stephen Boyd wrote:
> Is config some really big value? It looks like config (or more
> specifically event->attr.config) is ecececec which is larger than 9
> (PERF_COUNT_HW_MAX). I'm fairly certain r4 is event->attr.type
> (PERF_TYPE_HARDWARE) and so we're out of bounds on that array access in
> armpmu_map_hw_event(). Does the below patch fix that?
> 
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

Well spotted, thanks. If you make that return -EINVAL instead of -ENOENT (to
match what we do for cache events) then:

  Acked-by: Will Deacon <will.deacon@arm.com>

Could you stick it in the patch system please?

Thanks Stephen,

Will
