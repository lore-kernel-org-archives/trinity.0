From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] hw_breakpoint: Introduce cpumask_of_bp()
Date: Sat, 15 Jun 2013 15:29:28 +0200
Message-ID: <20130615132927.GD1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
 <20130601194626.GD27149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=g5PZgcGohNKkeeqemIc2F+HofWPV/vJFlGndM8FJqlY=;
        b=TxRv4KAfI4NGxKkcIl57JVBQLjzKJI9pdy2d2176F+Dfhd8Jg99Vs8542Wa+aOulfX
         56dTDcQOYF9HtbBIurPsY4dj9JdRhZnAeWFpGw1rK0xSWZR+XiiZeDQ+B+QrmM2CkN4i
         l1tI0/5Y8vGa51Aa2uRqHvUmbPlo2Zo6Vd1SGKV0Pni1GXX1UxWpmJxm2/XEpWiW8kC0
         nxWUV6GnvHyZ5E2NOxc1Wjcv8UrwbHNSZxR5UEC+x2X4ePPb0Us0dUUHMeDLwcI569Nx
         ny6JyT8O6iD3AEuiC3kFeV5FvBJr+GOnADE6JHAKAxLmuBgwKOB6UwqEG/PLc60nu4Ia
         b8Vw==
Content-Disposition: inline
In-Reply-To: <20130601194626.GD27149@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sat, Jun 01, 2013 at 09:46:26PM +0200, Oleg Nesterov wrote:
> Add the trivial helper which simply returns cpumask_of() or
> cpu_possible_mask depending on bp->cpu.
> 
> Change fetch_bp_busy_slots() and toggle_bp_slot() to always do
> for_each_cpu(cpumask_of_bp) to simplify the code and avoid the
> code duplication.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
