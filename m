From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Introduce "struct bp_cpuinfo"
Date: Tue, 18 Jun 2013 14:37:42 +0200
Message-ID: <20130618123741.GC17619@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130602194912.GA3277@redhat.com>
 <20130602195057.GC3277@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nyLElBvPV/Kv+iZXILwMvFQ5kXflIJ86AS1coM6srto=;
        b=A/drbZbW00pq0G0Y0QHKozXi+0daUdworLEjGq6X/tn/mEkSNcciuVwhdMWjjK1jYL
         SUsoC9NHe2diDU/rneVKllixchg1C6HdPSUzc3p/7xTHtwLdgRfNs3JU2RzotAuiEExr
         mVyn3PnJgpoxTKohzvY/C6zyTEm3bPaSU/B5WML5Abh0QLQH1SxxBrwVamGEgXWNB4pF
         refLfHH70RhAphOzgPv3EeJEzVZ/pahnSpdNQ55njvi+Yifzy+VvNhjGFc94v6ctmwJN
         4Nj35hLcqISB/PKxcUQ9rTpJT+CKRb4pPO/4okOvFOtkEc0i36VsIpAE8qdtVzjkuASi
         vLrA==
Content-Disposition: inline
In-Reply-To: <20130602195057.GC3277@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sun, Jun 02, 2013 at 09:50:57PM +0200, Oleg Nesterov wrote:
> This patch simply moves all per-cpu variables into the new single
> per-cpu "struct bp_cpuinfo".
> 
> To me this looks more logical and clean, but this can also simplify
> the further potential changes. In particular, I do not think this
> memory should be per-cpu, it is never used "locally". After this
> change it is trivial to turn it into, say, bootmem[nr_cpu_ids].
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I'm ok with the patch because it's indeed more logical and clean to pack the info
to a single struct.

But I'm not sure why you think using per-cpu is a problem. It's not only
deemed for optimized local uses, it's also convenient for allocations and
de-allocation, or static definitions. I'm not sure why bootmem would make
more sense.

Other than this in the changelog, the patch is nice, thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
