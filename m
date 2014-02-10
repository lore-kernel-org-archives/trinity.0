From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: lockdep: strange %s#5 lock name
Date: Mon, 10 Feb 2014 20:28:46 +0100
Message-ID: <20140210192846.GF27965@twins.programming.kicks-ass.net>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, tj@kernel.org

On Mon, Feb 10, 2014 at 09:19:43PM +0200, Tommi Rantala wrote:
> Hello,
> 
> Noticed a suspicious "%s#5" lock name in a lockdep splat while fuzzing
> with trinity.
> 
> [249844.531638]  #0:  (%s#5){.+.+.+}, at: [<ffffffff8115af70>]
> process_one_work+0x240/0x690

Lol.. its correct afaict:

struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
					       unsigned int flags,
					       int max_active,
					       struct lock_class_key *key,
					       const char *lock_name, ...)
{
	...
	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);



So while its called lock_name, it looks like the argument is a format.

I suppose the below was what was intended...

---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
