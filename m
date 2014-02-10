From: Tejun Heo <tj@kernel.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Mon, 10 Feb 2014 16:52:24 -0500
Message-ID: <20140210215224.GB25350@mtj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ok8No2/WmG9j27bMzouZudtTvFBrnIVJIUZlFAI/PoE=;
        b=VC53VNBTw11Smmx0EbKXBmeZaAv9HO1FkEhbzNyISqI+n4L8pqW1tVA5vytDtc38jp
         68GVToZgYoljtnP9N+WzZVmeVuhYloVif7+6/Y8ffwtm2geDpOAMMbvm8lRNpnaC+Zgu
         EOl+XXUE3WVB8N4yaa7EG9Ot+x9Hx5V/WuCOAfTZ7Wap3wn6IrDqaNaD5R6EzRdwj6iS
         sIBQczxAjGTLFcK9y/JKRfSBTKWQNy3nR2bL/fQqQ10R4Oxz6EHu+sfozEu2bOFJ+0Ur
         I/FMeS2QR27wTBImFqbssGTPWiTlMtWZmhcJChhW5T9vXFJqcdDegoGKt5u9ZhAzCLHW
         XKBA==
Content-Disposition: inline
In-Reply-To: <20140210192846.GF27965@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Mon, Feb 10, 2014 at 08:28:46PM +0100, Peter Zijlstra wrote:
> Lol.. its correct afaict:
> 
> struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
> 					       unsigned int flags,
> 					       int max_active,
> 					       struct lock_class_key *key,
> 					       const char *lock_name, ...)
> {
> 	...
> 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
> 
> 
> 
> So while its called lock_name, it looks like the argument is a format.

Heh, yeah, that's silly.

> I suppose the below was what was intended...
> 
> ---
>  kernel/workqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 82ef9f3b7473..861d8ddd92a2 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4202,7 +4202,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>  	INIT_LIST_HEAD(&wq->flusher_overflow);
>  	INIT_LIST_HEAD(&wq->maydays);
>  
> -	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
> +	lockdep_init_map(&wq->lockdep_map, wq->name, key, 0);

Looks good to me.  Can you please post the patch with SOB?

Thanks!

-- 
tejun
