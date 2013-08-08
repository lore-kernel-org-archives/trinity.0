From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: perf,arm -- another (different) fuzzer oops
Date: Thu, 08 Aug 2013 10:44:16 -0700
Message-ID: <5203D8F0.9050602@codeaurora.org>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com> <5202D5B0.9020107@codeaurora.org> <20130808120939.GB18724@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130808120939.GB18724@mudshark.cambridge.arm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On 08/08/13 05:09, Will Deacon wrote:
> Well spotted, thanks. If you make that return -EINVAL instead of -ENOENT (to
> match what we do for cache events) then:
>
>   Acked-by: Will Deacon <will.deacon@arm.com>
>
> Could you stick it in the patch system please?

Submitted as 7810/1

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
