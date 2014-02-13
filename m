From: Tejun Heo <tj@kernel.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Thu, 13 Feb 2014 16:26:45 -0500
Message-ID: <20140213212645.GG17608@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
 <20140211110036.GT9987@twins.programming.kicks-ass.net>
 <20140211152741.GA24490@htj.dyndns.org>
 <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VW8vv3LlgepDcW7cGmQdi/wyWv5Dc0fMf+qcae1x8lQ=;
        b=krxCITskp2piDmw4ZotxmDetVjRaqSgRTl+JDGJtz5UmoYF/uuBtpwT38d3U9FEekV
         JV/RbDbHdzPYRFHcHcRaH26JVrpPgPnjX6WawziONfSzT5PCXS2nz4po0tIrjR0jaK5a
         4t2NF4QMsqQnNiBcarI8XqFQfhbXzmEI4SQ8MXSaA+ONUqQQXEjsoJtdNrUcUo8RZczo
         UvD6lr4QDoSExmSTeeQoxnpR1diaAEns96D9XRr7OpqfB+PBzjFz8WofcFXT90+ZHKKe
         2AYXaSVf6w6uyCVigFA+Irwa61iU2tpPu76AO8xv9Fsh4jY/VLbNM7pSq8XZdJ8AdVzg
         J74g==
Content-Disposition: inline
In-Reply-To: <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Thu, Feb 13, 2014 at 12:35:24PM +0800, Li Zhong wrote:
> [    5.251993] ------------[ cut here ]------------
> [    5.252019] WARNING: CPU: 0 PID: 221 at kernel/locking/lockdep.c:710 __lock_acquire+0x1761/0x1f60()
> [    5.252019] Modules linked in: e1000
> [    5.252019] CPU: 0 PID: 221 Comm: lvm Not tainted 3.14.0-rc2-next-20140212 #1
> [    5.252019] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [    5.252019]  0000000000000009 ffff880118e91938 ffffffff8155fe12 ffff880118e91978
> [    5.252019]  ffffffff8105c195 ffff880118e91958 ffffffff81eb33d0 0000000000000002
> [    5.252019]  ffff880118dd2318 0000000000000000 0000000000000000 ffff880118e91988
> [    5.252019] Call Trace:
> [    5.252019]  [<ffffffff8155fe12>] dump_stack+0x19/0x1b
> [    5.252019]  [<ffffffff8105c195>] warn_slowpath_common+0x85/0xb0
> [    5.252019]  [<ffffffff8105c1da>] warn_slowpath_null+0x1a/0x20
> [    5.252019]  [<ffffffff810a1721>] __lock_acquire+0x1761/0x1f60
> [    5.252019]  [<ffffffff8109ec2e>] ? mark_held_locks+0xae/0x120
> [    5.252019]  [<ffffffff8109ef4e>] ? debug_check_no_locks_freed+0x8e/0x160
> [    5.252019]  [<ffffffff810a264c>] ? lockdep_init_map+0xac/0x600
> [    5.252019]  [<ffffffff810a251a>] lock_acquire+0x9a/0x120
> [    5.252019]  [<ffffffff810793f5>] ? flush_workqueue+0x5/0x750
> [    5.252019]  [<ffffffff810794f9>] flush_workqueue+0x109/0x750
> [    5.252019]  [<ffffffff810793f5>] ? flush_workqueue+0x5/0x750
> [    5.252019]  [<ffffffff81566890>] ? _raw_spin_unlock_irq+0x30/0x40
> [    5.252019]  [<ffffffff810b7720>] ? srcu_reschedule+0xe0/0xf0
> [    5.252019]  [<ffffffff81405889>] dm_suspend+0xe9/0x1e0
> [    5.252019]  [<ffffffff8140a853>] dev_suspend+0x1e3/0x270
> [    5.252019]  [<ffffffff8140a670>] ? table_load+0x350/0x350
> [    5.252019]  [<ffffffff8140b40c>] ctl_ioctl+0x26c/0x510
> [    5.252019]  [<ffffffff810a03dc>] ? __lock_acquire+0x41c/0x1f60
> [    5.252019]  [<ffffffff810923d8>] ? vtime_account_user+0x98/0xb0
> [    5.252019]  [<ffffffff8140b6c3>] dm_ctl_ioctl+0x13/0x20
> [    5.252019]  [<ffffffff811986c8>] do_vfs_ioctl+0x88/0x570
> [    5.252019]  [<ffffffff811a5579>] ? __fget_light+0x129/0x150
> [    5.252019]  [<ffffffff81198c41>] SyS_ioctl+0x91/0xb0
> [    5.252019]  [<ffffffff8157049d>] tracesys+0xcf/0xd4
> [    5.252019] ---[ end trace ff1fa506f34be3bc ]---
> 
> It seems to me that when the second time alloc_workqueue() is called
> from the same code path, it would have two locks with the same key, but
> not the same &wq->name, which doesn't meet lockdep's assumption.

Dang...  I reverted the previous patch for now.  Peter, does this
approach sound good to you?

Thanks.

-- 
tejun
