From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Thu, 13 Feb 2014 22:32:53 +0100
Message-ID: <20140213213253.GF27965@twins.programming.kicks-ass.net>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
 <20140211152741.GA24490@htj.dyndns.org>
 <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
 <20140213212645.GG17608@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140213212645.GG17608@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Thu, Feb 13, 2014 at 04:26:45PM -0500, Tejun Heo wrote:
> > It seems to me that when the second time alloc_workqueue() is called
> > from the same code path, it would have two locks with the same key, but
> > not the same &wq->name, which doesn't meet lockdep's assumption.
> 
> Dang...  I reverted the previous patch for now.  Peter, does this
> approach sound good to you?

Whatever works I suppose; like Li said; a little ugly but not sure we
can do better.
