From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
Date: Thu, 13 Jun 2013 16:20:28 +0200
Message-ID: <20130613142026.GC16339@somewhere>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601182057.GA4861@redhat.com>
 <20130601182120.GB4861@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8qYODceAHfWj8izhPe0lhrKps0Y9fyGTHjOggp6a3nk=;
        b=eqxQGTqT2iqn6jwCtxgrPuSay/ZQcE1GqELVn6yE2cGnAAMJgRFWyob7UgC/I7TMnu
         29UMrBG4VYR0Kb/vj3eWknqTND0VUc/Rkp5d9utirq3sJDtVJ3rirwn26kPQsMC4/zLO
         FKUoOBHsDsWk7IylgWljUqYoz3dL0458Oj8xFVEUb4OOCn/vcLbQd2IyjKPCDHLkz/k7
         ODr0kiDer9NjbcQea4DFy46h50uCYjhb7671WAr7VYLM3oMVYtkGlGV5EE9S1SGu/5bd
         3QNa/3TzOKZomLje0Oojx6t44ihmYbYq77VPHwUzXbF3rTbobm7UhMdWmDlr421Kr7aE
         Ux8g==
Content-Disposition: inline
In-Reply-To: <20130601182120.GB4861@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sat, Jun 01, 2013 at 08:21:20PM +0200, Oleg Nesterov wrote:
> trinity fuzzer triggered WARN_ONCE("Can't find any breakpoint slot")
> in arch_install_hw_breakpoint() but the problem is not arch-specific.
> 
> The problem is, task_bp_pinned(cpu) checks "cpu == iter->cpu" but
> this doesn't account the "all cpus" events with iter->cpu < 0.
> 
> This means that, say, register_user_hw_breakpoint(tsk) can happily
> create the arbitrary number > HBP_NUM of breakpoints which can not
> be activated. toggle_bp_task_slot() is equally wrong by the same
> reason and nr_task_bp_pinned[] can have negative entries.
> 
> Simple test:
> 
> 	# perl -e 'sleep 1 while 1' &
> 	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 -p `pidof perl`
> 
> Before this patch this triggers the same problem/WARN_ON(), after
> the patch it correctly fails with -ENOSPC.
> 
> Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: <stable@vger.kernel.org>

Looks good, thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/events/hw_breakpoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index ed1c897..29d3abe 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -120,7 +120,7 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
>  	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
>  		if (iter->hw.bp_target == tsk &&
>  		    find_slot_idx(iter) == type &&
> -		    cpu == iter->cpu)
> +		    (iter->cpu < 0 || cpu == iter->cpu))
>  			count += hw_breakpoint_weight(iter);
>  	}
>  
> -- 
> 1.5.5.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
