From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH ] workqueue: add args to workqueue lockdep name
Date: Fri, 14 Feb 2014 09:06:13 -0500
Message-ID: <20140214140613.GA29516@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
 <20140211152741.GA24490@htj.dyndns.org>
 <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
 <20140213212645.GG17608@htj.dyndns.org>
 <20140213213253.GF27965@twins.programming.kicks-ass.net>
 <20140213221515.GL17608@htj.dyndns.org>
 <1392346377.4744.8.camel@ThinkPad-T5421.cn.ibm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7e0QILH4QrGzoOQ0eGd6RIdGA/A9m0jnTmqCHVud9pU=;
        b=NaBtedElOmSjWgFqVCcrfZqjEPOBoFdUqebGZAUT9/FldiDaSRChsWyxdWZ6Wqy0eq
         efPRsi2CkzZ9rQX//hwlW3shP4bJ06ubZgyrDIVe8qzEv+y6qqhYj2sQkO/FFlZsyICY
         2un2kLNRTQMCzxdns/d28ZfLtXD0otkOBVy+UuLA+UjSpW+rOp5pSklyfxq8ISH8Q3EW
         okQY1CdIoHbevEh+OOUsoZyx3zwXeZEtUNa5WnGSn2oNl0Y+IU2QhbzycECaeUhDCkdJ
         igNLcfPSOTRN2nx6+21Bs6XGXKC+oc/e9FWzvFtzfMsXTEjO6YEtx9DBxMFWnRPZy9h1
         0L+A==
Content-Disposition: inline
In-Reply-To: <1392346377.4744.8.camel@ThinkPad-T5421.cn.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Fri, Feb 14, 2014 at 10:52:57AM +0800, Li Zhong wrote:
> Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired in
> process_one_work().
> 
> Maybe #fmt plus #args could be used as the lock_name to give some more
> information for some fmt string like the above. 
> 
> __builtin_constant_p() check is removed (as there seems no good way to
> check all the variables in args list). However, by removing the check,
> it only adds two additional "s for those constants.
> 
> Some lockdep name examples printed out after the change:
> 
> lockdep name                    wq->name
> 
> "events_long"                   events_long
> "%s"("khelper")                 khelper
> "xfs-data/%s"mp->m_fsname       xfs-data/dm-3
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Applied to wq/for-3.14-fixes.

Thanks.

-- 
tejun
