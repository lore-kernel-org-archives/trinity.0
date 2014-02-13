From: Tejun Heo <tj@kernel.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Thu, 13 Feb 2014 17:15:15 -0500
Message-ID: <20140213221515.GL17608@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
 <20140211152741.GA24490@htj.dyndns.org>
 <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
 <20140213212645.GG17608@htj.dyndns.org>
 <20140213213253.GF27965@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5kDLDzrWssgAyN81j8fYWlSvXHk7SEbDQ+NFIWf4IB8=;
        b=q546iKpPw7qP2lXWl0YyU2Tr9vZ1MgZmGCOGj+uAXYYyWa5wo0mUxZo15H80xmCcu6
         EKvA/GV4iJJFNMO9nOfd75PuwHuBxTty1tCSGsfvP0m6fFAQgRvUhGNN21jedhEpQiFA
         YV9t7xxjxEWZH/1MY+85wNGCY9o9Zd+BNLu0JvRTO+M0o+p1E5zTxTT1Xb/sRrqH8h0W
         l+xAxojJKJ+xoRZ3yD3bBy8oO50oUi/NHc5nAs9waN7Uvt4mV9owPCW33JVCnZerwuCa
         Fwffxbza56f02Z7y4f5OCdghAx8mx76V1YhhCxHdEQ3zW2txuXi6orhJlgo/J/9oGqsh
         Ud4A==
Content-Disposition: inline
In-Reply-To: <20140213213253.GF27965@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Thu, Feb 13, 2014 at 10:32:53PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 13, 2014 at 04:26:45PM -0500, Tejun Heo wrote:
> > > It seems to me that when the second time alloc_workqueue() is called
> > > from the same code path, it would have two locks with the same key, but
> > > not the same &wq->name, which doesn't meet lockdep's assumption.
> > 
> > Dang...  I reverted the previous patch for now.  Peter, does this
> > approach sound good to you?
> 
> Whatever works I suppose; like Li said; a little ugly but not sure we
> can do better.

Cool, Li, can you please spin it on top of v3.14-rc1 w/ SOB and
description.

Thanks.

-- 
tejun
