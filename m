From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in
 {reserve,release}_bp_slot()
Date: Sat, 15 Jun 2013 14:46:41 +0200
Message-ID: <20130615124639.GA1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601182057.GA4861@redhat.com>
 <20130601182139.GC4861@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PzxW61ZyCePHw+r7H7ZJ3GwEsz+3CIxYT2PnFAmY+dI=;
        b=vae9aVIsBtZ4ifxr6xQ/hhnrUG++Yght0loQWmglLf1JFG4SAQIgI1yCUIOnJvNeZo
         6h3C+c38k166dAS/UBc35T1Qr7jikq+0KmN2FEc4PJ+qM4lczmEHaFHrThOe75fccpbD
         hMRQHCj/0383bhCuBw8MS75faiSnoQJRpJ47w+HfHii3aHuJn0htofpqRZ0VFabTJyTs
         kTyh9GApSsdZnK185wOmwb6n5wlBI/AN7Bi30ThO0zjz1D5MRm/Ms82P6dJd8Ckcmd2C
         729sAwDvGiIciWrYQ/OeksoQEEBVsR27I4P0usfrtNYtgypNYZ9YHTYpHLjxjUqlHtvf
         /JhA==
Content-Disposition: inline
In-Reply-To: <20130601182139.GC4861@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sat, Jun 01, 2013 at 08:21:39PM +0200, Oleg Nesterov wrote:
> fetch_bp_busy_slots() and toggle_bp_slot() use for_each_online_cpu(),
> this is obviously wrong wrt cpu_up() or cpu_down(), we can over/under
> account the per-cpu numbers.
> 
> For example:
> 
> 	# echo 0 >> /sys/devices/system/cpu/cpu1/online
> 	# perf record -e mem:0x10 -p 1 &
> 	# echo 1 >> /sys/devices/system/cpu/cpu1/online
> 	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10 -C1 -a &
> 	# taskset -p 0x2 1
> 
> triggers the same WARN_ONCE("Can't find any breakpoint slot") in
> arch_install_hw_breakpoint().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
