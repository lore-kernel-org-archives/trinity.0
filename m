From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Fri, 31 May 2013 17:46:04 +0200
Message-ID: <20130531154604.GF27176@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
 <20130530072532.GF4341@laptop>
 <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, May 30, 2013 at 08:51:00AM -0400, Vince Weaver wrote:
> On Thu, 30 May 2013, Peter Zijlstra wrote:
> > I'll go prod, thanks again!
> 
> The bug looks related to hw breakpoints, not sure if the bugs Oleg 
> Nesterov has been reporting in this area might be relevant or not.

Nah its not. I figured out what happened but I'm having a bit of a hard
time closing it without making a mess :-)

The 'new' issue (above all the previous things) is that when we redirect an
events output that event has a reference to the buffer and will keep the buffer
alive after the last munmap() of said buffer.

By the time we close() the last event and drop the last reference to the buffer
we don't have enough context left to properly unaccount things.

So what I've been trying to do is always attach events to the rb through the
ring_buffer::even_list -- which was previously only used for poll() wakeups --
and on the last munmap() explicitly detach all events and destroy the buffer.

While that sounds 'simple' we run into lock inversion between the
perf_event::mmap_mutex and ring_buffer::event_lock and things becomes nasty.

There's also the additional ring_buffer::mmap_count; which I use to keep track
of the total amount of mmap()s still out there, as opposed to the
perf_event::mmap_count which only counts the mmap()s for that particular event.
This leaves us with two atomics and a few 'nice' races.

The below is my current hackery which compiles but I know must have some issues
because I'm too tired to think straight atm. Completely untested.

I'm only posting this so that someone can tell me; you're being an idiot! if
you do _foo_ its all fixed much easier :-)

If this better approach fails to materialize, I'll continue onwards and try and
get this working ;-)

---
 include/linux/perf_event.h |    3 +-
 kernel/events/core.c       |  173 ++++++++++++++++++++++++++------------------
 kernel/events/internal.h   |    4 +
 3 files changed, 109 insertions(+), 71 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f463a46..c5b6dbf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -389,8 +389,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..2eb0d81 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -196,9 +196,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
-
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -2917,7 +2914,8 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
+static bool ring_buffer_put(struct ring_buffer *rb);
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -2942,15 +2940,27 @@ static void free_event(struct perf_event *event)
 		if (has_branch_stack(event)) {
 			static_key_slow_dec_deferred(&perf_sched_events);
 			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK))
+			if (!(event->attach_state & PERF_ATTACH_TASK)) {
 				atomic_dec(&per_cpu(perf_branch_stack_events,
 						    event->cpu));
+			}
 		}
 	}
 
 	if (event->rb) {
-		ring_buffer_put(event->rb);
-		event->rb = NULL;
+		struct ring_buffer *rb;
+
+		/*
+		 * XXX should not happen ?!
+		 */
+		mutex_lock(&event->mmap_mutex);
+		rb = event->rb;
+		if (rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb);
+		}
+		mutex_unlock(&event->mmap_mutex);
 	}
 
 	if (is_cgroup_event(event))
@@ -3188,30 +3198,12 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	unsigned int events = POLL_HUP;
 
 	/*
-	 * Race between perf_event_set_output() and perf_poll(): perf_poll()
-	 * grabs the rb reference but perf_event_set_output() overrides it.
-	 * Here is the timeline for two threads T1, T2:
-	 * t0: T1, rb = rcu_dereference(event->rb)
-	 * t1: T2, old_rb = event->rb
-	 * t2: T2, event->rb = new rb
-	 * t3: T2, ring_buffer_detach(old_rb)
-	 * t4: T1, ring_buffer_attach(rb1)
-	 * t5: T1, poll_wait(event->waitq)
-	 *
-	 * To avoid this problem, we grab mmap_mutex in perf_poll()
-	 * thereby ensuring that the assignment of the new ring buffer
-	 * and the detachment of the old buffer appear atomic to perf_poll()
+	 * Pin the event->rb by taking event->mmap_mutex.
 	 */
 	mutex_lock(&event->mmap_mutex);
-
-	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
-	if (rb) {
-		ring_buffer_attach(event, rb);
+	rb = event->rb;
+	if (rb)
 		events = atomic_xchg(&rb->poll, 0);
-	}
-	rcu_read_unlock();
-
 	mutex_unlock(&event->mmap_mutex);
 
 	poll_wait(file, &event->waitq, wait);
@@ -3521,16 +3513,12 @@ static void ring_buffer_attach(struct perf_event *event,
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	if (!list_empty(&event->rb_entry))
-		goto unlock;
-
-	list_add(&event->rb_entry, &rb->event_list);
-unlock:
+	if (list_empty(&event->rb_entry))
+		list_add(&event->rb_entry, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event,
-			       struct ring_buffer *rb)
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
 	unsigned long flags;
 
@@ -3549,13 +3537,10 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (!rb)
-		goto unlock;
-
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
-		wake_up_all(&event->waitq);
-
-unlock:
+	if (rb) {
+		list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
+			wake_up_all(&event->waitq);
+	}
 	rcu_read_unlock();
 }
 
@@ -3582,22 +3567,15 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+static bool ring_buffer_put(struct ring_buffer *rb)
 {
-	struct perf_event *event, *n;
-	unsigned long flags;
-
 	if (!atomic_dec_and_test(&rb->refcount))
-		return;
+		return false;
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
-		list_del_init(&event->rb_entry);
-		wake_up_all(&event->waitq);
-	}
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	WARN_ON_ONCE(!list_empty(&rb->event_list));
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
+	return true;
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -3605,26 +3583,72 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	atomic_inc(&event->mmap_count);
+	atomic_inc(&event->rb->mmap_count);
 }
 
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->rb);
-		struct user_struct *user = event->mmap_user;
-		struct ring_buffer *rb = event->rb;
+	struct ring_buffer *rb = event->rb;
+	struct user_struct *mmap_user = rb->mmap_user;
+	int mmap_locked = rb->mmap_locked;
+	unsigned long size = perf_data_size(rb);
+
+	atomic_dec(&rb->mmap_count);
+
+	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
+		return;
+
+	/* Detach current event from the buffer. */
+	rcu_assign_pointer(event->rb, NULL);
+	ring_buffer_detach(event, rb);
+	mutex_unlock(&event->mmap_mutex);
+
+	/* If there's still other mmap()s of this buffer, we're done. */
+	if (atomic_read(&rb->mmap_count)) {
+		ring_buffer_put(rb); /* can't be last */
+		return;
+	}
+
+	/* 
+	 * No other mmap()s, detach from all other events that might redirect
+	 * into the now unreachable buffer.
+	 */
+again:
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		bool restart = false;
+
+		if (!atomic_long_inc_not_zero(&event->refcount))
+			continue;
+		rcu_read_unlock();
+
+		mutex_lock(&event->mmap_mutex);
+		if (event->rb != rb)
+			goto unlock_next;
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
 		ring_buffer_detach(event, rb);
+		ring_buffer_put(rb); /* can't be last, we still have one */
+		restart = true;
+
+unlock_next:
 		mutex_unlock(&event->mmap_mutex);
+		put_event(event);
+		if (restart) /* iteration isn't safe against removal */
+			goto again;
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
+
+	/* OK, buffer is fully detached and unmapped, undo accounting */
+	atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+	vma->vm_mm->pinned_vm -= mmap_locked;
+	free_uid(mmap_user);
+
+	ring_buffer_put(rb); /* must be last */
 }
 
 static const struct vm_operations_struct perf_mmap_vmops = {
@@ -3674,12 +3698,19 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
+again:
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages == nr_pages)
-			atomic_inc(&event->rb->refcount);
-		else
+		if (event->rb->nr_pages != nr_pages)
 			ret = -EINVAL;
+
+		/*
+		 * XXX raced against perf_mmap_close() through perf_event_set_output().
+		 */
+		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+			mutex_unlock(&event->mmap_mutex);
+			goto again;
+		}
 		goto unlock;
 	}
 
@@ -3720,12 +3751,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->rb, rb);
+
+	atomic_set(&rb->mmap_count, 1);
+	rb->mmap_locked = extra;
+	rb->mmap_user = get_current_user();
 
 	atomic_long_add(user_extra, &user->locked_vm);
-	event->mmap_locked = extra;
-	event->mmap_user = get_current_user();
-	vma->vm_mm->pinned_vm += event->mmap_locked;
+	vma->vm_mm->pinned_vm += extra;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_update_userpage(event);
 
@@ -3734,7 +3769,7 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index eb675c4..41f5685 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -31,6 +31,10 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	atomic_t			mmap_count;
+	int				mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
