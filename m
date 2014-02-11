From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Tue, 11 Feb 2014 12:00:36 +0100
Message-ID: <20140211110036.GT9987@twins.programming.kicks-ass.net>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
 <20140210215224.GB25350@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140210215224.GB25350@mtj.dyndns.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

> Looks good to me.  Can you please post the patch with SOB?

---
Subject: workqueue: Fix workqueue lockdep name

Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired in
process_one_work(). It turns out that commit b196be89cdc14 forgot to
change the lockdep_init_map() when it changed the @lock_name argument
from a string to a format.

Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf fmt and args for name")
Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3b7473..861d8ddd92a2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4202,7 +4202,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 	INIT_LIST_HEAD(&wq->maydays);
 
-	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
+	lockdep_init_map(&wq->lockdep_map, wq->name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
 	if (alloc_and_link_pwqs(wq) < 0)
