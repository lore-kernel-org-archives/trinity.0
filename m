From: Tejun Heo <tj@kernel.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Tue, 11 Feb 2014 10:27:41 -0500
Message-ID: <20140211152741.GA24490@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=D+i6ZDE5BeY/10LPjDHPu7C7xDFMJJfKa3X11Pbahkk=;
        b=sLTxXUHEFuXyAzNthMOggzHLAoafpajAJY23tWvxQrtvVc5oZrBhCFE474qBK4FdSs
         lg/rH2Z1MhOgcfx2OWVP6evsJhW8lVtvnkgOWVZ4diHmoXE6XsjuUIOmEYsb0vzlrIEO
         DRQ7HXoovHAepvb2ItK6ZfeQsdANF5lZLDUJAPvMmHo8cMNy3l6IyzW8gWfmE8x9XxXj
         QUImX2Qgw38GgHySe4k63sc0tmaTDYcCjluoiOuNLBXuCLAmBgEo+pgmmazD2BLpc0K7
         XblfeGJB/JvxOZKMypWNZh8tlFwt5s+6Z2TDPdwzhJKAlGYxtUk/bJQLDEC7tueXd8CC
         BlJQ==
Content-Disposition: inline
In-Reply-To: <20140211110036.GT9987@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Tue, Feb 11, 2014 at 12:00:36PM +0100, Peter Zijlstra wrote:
> > Looks good to me.  Can you please post the patch with SOB?
> 
> ---
> Subject: workqueue: Fix workqueue lockdep name
> 
> Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired in
> process_one_work(). It turns out that commit b196be89cdc14 forgot to
> change the lockdep_init_map() when it changed the @lock_name argument
> from a string to a format.
> 
> Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf fmt and args for name")
> Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Applied to wq/for-3.14-fixes.

Thanks!

-- 
tejun
