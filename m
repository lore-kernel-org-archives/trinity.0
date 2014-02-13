From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: lockdep: strange %s#5 lock name
Date: Thu, 13 Feb 2014 12:35:24 +0800
Message-ID: <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
	 <20140210192846.GF27965@twins.programming.kicks-ass.net>
	 <20140210215224.GB25350@mtj.dyndns.org>
	 <20140211110036.GT9987@twins.programming.kicks-ass.net>
	 <20140211152741.GA24490@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140211152741.GA24490@htj.dyndns.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Tue, 2014-02-11 at 10:27 -0500, Tejun Heo wrote:
> On Tue, Feb 11, 2014 at 12:00:36PM +0100, Peter Zijlstra wrote:
> > > Looks good to me.  Can you please post the patch with SOB?
> > 
> > ---
> > Subject: workqueue: Fix workqueue lockdep name
> > 
> > Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired in
> > process_one_work(). It turns out that commit b196be89cdc14 forgot to
> > change the lockdep_init_map() when it changed the @lock_name argument
> > from a string to a format.
> > 
> > Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf fmt and args for name")
> > Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> 
> Applied to wq/for-3.14-fixes.

Hi Tejun, Peter,

I found following lockdep warning caused by this commit in next-tree:

[    5.251993] ------------[ cut here ]------------
[    5.252019] WARNING: CPU: 0 PID: 221 at kernel/locking/lockdep.c:710 __lock_acquire+0x1761/0x1f60()
[    5.252019] Modules linked in: e1000
[    5.252019] CPU: 0 PID: 221 Comm: lvm Not tainted 3.14.0-rc2-next-20140212 #1
[    5.252019] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    5.252019]  0000000000000009 ffff880118e91938 ffffffff8155fe12 ffff880118e91978
[    5.252019]  ffffffff8105c195 ffff880118e91958 ffffffff81eb33d0 0000000000000002
[    5.252019]  ffff880118dd2318 0000000000000000 0000000000000000 ffff880118e91988
[    5.252019] Call Trace:
[    5.252019]  [<ffffffff8155fe12>] dump_stack+0x19/0x1b
[    5.252019]  [<ffffffff8105c195>] warn_slowpath_common+0x85/0xb0
[    5.252019]  [<ffffffff8105c1da>] warn_slowpath_null+0x1a/0x20
[    5.252019]  [<ffffffff810a1721>] __lock_acquire+0x1761/0x1f60
[    5.252019]  [<ffffffff8109ec2e>] ? mark_held_locks+0xae/0x120
[    5.252019]  [<ffffffff8109ef4e>] ? debug_check_no_locks_freed+0x8e/0x160
[    5.252019]  [<ffffffff810a264c>] ? lockdep_init_map+0xac/0x600
[    5.252019]  [<ffffffff810a251a>] lock_acquire+0x9a/0x120
[    5.252019]  [<ffffffff810793f5>] ? flush_workqueue+0x5/0x750
[    5.252019]  [<ffffffff810794f9>] flush_workqueue+0x109/0x750
[    5.252019]  [<ffffffff810793f5>] ? flush_workqueue+0x5/0x750
[    5.252019]  [<ffffffff81566890>] ? _raw_spin_unlock_irq+0x30/0x40
[    5.252019]  [<ffffffff810b7720>] ? srcu_reschedule+0xe0/0xf0
[    5.252019]  [<ffffffff81405889>] dm_suspend+0xe9/0x1e0
[    5.252019]  [<ffffffff8140a853>] dev_suspend+0x1e3/0x270
[    5.252019]  [<ffffffff8140a670>] ? table_load+0x350/0x350
[    5.252019]  [<ffffffff8140b40c>] ctl_ioctl+0x26c/0x510
[    5.252019]  [<ffffffff810a03dc>] ? __lock_acquire+0x41c/0x1f60
[    5.252019]  [<ffffffff810923d8>] ? vtime_account_user+0x98/0xb0
[    5.252019]  [<ffffffff8140b6c3>] dm_ctl_ioctl+0x13/0x20
[    5.252019]  [<ffffffff811986c8>] do_vfs_ioctl+0x88/0x570
[    5.252019]  [<ffffffff811a5579>] ? __fget_light+0x129/0x150
[    5.252019]  [<ffffffff81198c41>] SyS_ioctl+0x91/0xb0
[    5.252019]  [<ffffffff8157049d>] tracesys+0xcf/0xd4
[    5.252019] ---[ end trace ff1fa506f34be3bc ]---

It seems to me that when the second time alloc_workqueue() is called
from the same code path, it would have two locks with the same key, but
not the same &wq->name, which doesn't meet lockdep's assumption.

Maybe we could use the #fmt plus #args as the lock_name to avoid the
above issue? It could also give some more information for some string
like %s#5. Draft code attached below.

I removed __builtin_constant_p() check (I don't know how to check all
the args). However, by removing the check, it only adds two additional
two "s for those constants.

Some lockdep name examples I printed out after the change:

lockdep name                    wq->name

"events_long"                   events_long
"%s"("khelper")                 khelper
"xfs-data/%s"mp->m_fsname       xfs-data/dm-3
...

A little bit ugly, not sure whether we could generate some better names
here?

Thanks, 
Zhong

---
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..704f4f6 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -419,10 +419,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	static struct lock_class_key __key;				\
 	const char *__lock_name;					\
 									\
-	if (__builtin_constant_p(fmt))					\
-		__lock_name = (fmt);					\
-	else								\
-		__lock_name = #fmt;					\
+	__lock_name = #fmt#args;					\
 									\
 	__alloc_workqueue_key((fmt), (flags), (max_active),		\
 			      &__key, __lock_name, ##args);		\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 861d8dd..82ef9f3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4202,7 +4202,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 	INIT_LIST_HEAD(&wq->maydays);
 
-	lockdep_init_map(&wq->lockdep_map, wq->name, key, 0);
+	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
 	if (alloc_and_link_pwqs(wq) < 0)

