From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Wed, 24 Jul 2013 21:05:37 +0200
Message-ID: <20130724190537.GW6123@two.firstfloor.org>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <alpine.DEB.2.02.1307241433380.8230@pianoman.cluster.toy>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307241433380.8230@pianoman.cluster.toy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org

> I'd prefer if it were
> 
>   precise_ip:0-1
> 
> as the code you use to set the value looks like 
>    attr->precise_ip=2;
> I don't think you can even set bits 15-16 of flags directly, can you?

Sorry I meant flags as an alias of "the 64bits currently occupied by the
bitfield". Perhaps the name choice was not very good.

"flags_bitfield" ?

So the tool would only need to know that, not every bit.

In theory it could be also generalized as a byte offset to perf_event,
but that may be overengineered.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
