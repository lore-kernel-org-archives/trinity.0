From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Mon, 3 Jun 2013 15:26:45 +0200
Message-ID: <20130603132645.GC8923@twins.programming.kicks-ass.net>
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
> > I'll go prod, thanks again!


OK the below builds and seems to survive both test cases and about 10 minutes
of fuzzing -- fingers crossed.

---
 include/linux/perf_event.h |    3 +-
 kernel/events/core.c       |  230 ++++++++++++++++++++++++++++++--------------
 kernel/events/internal.h   |    4 +
 3 files changed, 163 insertions(+), 74 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6fddac1..74a4e14 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -390,8 +390,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a0780b3..b8dcbf6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -198,9 +198,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
-
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -3023,6 +3020,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -3047,15 +3045,30 @@ static void free_event(struct perf_event *event)
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
+		 * Can happen when we close an event with re-directed output.
+		 *
+		 * Since we have a 0 refcount, perf_mmap_close() will skip
+		 * over us; possibly making our ring_buffer_put() the last.
+		 */
+		mutex_lock(&event->mmap_mutex);
+		rb = event->rb;
+		if (rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* could be last */
+		}
+		mutex_unlock(&event->mmap_mutex);
 	}
 
 	if (is_cgroup_event(event))
@@ -3293,30 +3306,13 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
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
+	 * Pin the event->rb by taking event->mmap_mutex; otherwise
+	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
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
@@ -3626,16 +3622,12 @@ static void ring_buffer_attach(struct perf_event *event,
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
 
@@ -3654,13 +3646,10 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
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
 
@@ -3689,18 +3678,10 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 static void ring_buffer_put(struct ring_buffer *rb)
 {
-	struct perf_event *event, *n;
-	unsigned long flags;
-
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
-		list_del_init(&event->rb_entry);
-		wake_up_all(&event->waitq);
-	}
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	WARN_ON_ONCE(!list_empty(&rb->event_list));
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
@@ -3710,26 +3691,100 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	atomic_inc(&event->mmap_count);
+	atomic_inc(&event->rb->mmap_count);
 }
 
+/*
+ * A buffer can be mmap()ed multiple times; either directly through the same
+ * event, or through other events by use of perf_event_set_output().
+ *
+ * In order to undo the VM accounting done by perf_mmap() we need to destroy
+ * the buffer here, where we still have a VM context. This means we need
+ * to detach all events redirecting to us.
+ */
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
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->rb, NULL);
-		ring_buffer_detach(event, rb);
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
+	 * into the now unreachable buffer. Somewhat complicated by the
+	 * fact that rb::event_lock otherwise nests inside mmap_mutex.
+	 */
+again:
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		if (!atomic_long_inc_not_zero(&event->refcount)) {
+			/*
+			 * This event is en-route to free_event() which will
+			 * detach it and remove it from the list.
+			 */
+			continue;
+		}
+		rcu_read_unlock();
+
+		mutex_lock(&event->mmap_mutex);
+		/*
+		 * Check we didn't race with perf_event_set_output() which can
+		 * swizzle the rb from under us while we were waiting to
+		 * acquire mmap_mutex. 
+		 *
+		 * If we find a different rb; ignore this event, a next
+		 * iteration will no longer find it on the list. We have to
+		 * still restart the iteration to make sure we're not now
+		 * iterating the wrong list.
+		 */
+		if (event->rb == rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* can't be last, we still have one */
+		}
 		mutex_unlock(&event->mmap_mutex);
+		put_event(event);
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		/*
+		 * Restart the iteration; either we're on the wrong list or
+		 * destroyed its integrity by doing a deletion.
+		 */
+		goto again;
 	}
+	rcu_read_unlock();
+
+	/*
+	 * It could be there's still a few 0-ref events on the list; they'll
+	 * get cleaned up by free_event() -- they'll also still have their
+	 * ref on the rb and will free it whenever they are done with it.
+	 *
+	 * Aside from that, this buffer is 'fully' detached and unmapped,
+	 * undo the VM accounting.
+	 */
+
+	atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+	vma->vm_mm->pinned_vm -= mmap_locked;
+	free_uid(mmap_user);
+
+	ring_buffer_put(rb); /* could be last */
 }
 
 static const struct vm_operations_struct perf_mmap_vmops = {
@@ -3779,12 +3834,21 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
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
+		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+			/*
+			 * Raced against perf_mmap_close() through
+			 * perf_event_set_output(). Try again, hope for better
+			 * luck.
+			 */
+			mutex_unlock(&event->mmap_mutex);
+			goto again;
+		}
 		goto unlock;
 	}
 
@@ -3825,12 +3889,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
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
 
@@ -3839,7 +3907,11 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	/*
+	 * Since pinned accounting is per vm we cannot allow fork() to copy our
+	 * vma.
+	 */
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
@@ -6565,6 +6637,8 @@ set:
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
 
+	old_rb = event->rb;
+
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb = ring_buffer_get(output_event);
@@ -6572,16 +6646,28 @@ set:
 			goto unlock;
 	}
 
-	old_rb = event->rb;
-	rcu_assign_pointer(event->rb, rb);
 	if (old_rb)
 		ring_buffer_detach(event, old_rb);
+
+	if (rb)
+		ring_buffer_attach(event, rb);
+
+	rcu_assign_pointer(event->rb, rb);
+
+	if (old_rb) {
+		ring_buffer_put(old_rb);
+		/*
+		 * Since we detached before setting the new rb, so that we
+		 * could attach the new rb, we could have missed a wakeup.
+		 * Provide it now.
+		 */
+		wake_up_all(&event->waitq);
+	}
+
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_rb)
-		ring_buffer_put(old_rb);
 out:
 	return ret;
 }
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
