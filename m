From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Tue, 28 May 2013 10:55:48 +0200
Message-ID: <20130528085548.GA12193@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


Take 2.. :-)

Leaving the locked vs pinned debacle for another time. The below patch
survives many non-priv execution of the problem prog.

---
Subject: perf: Fix perf mmap issues

Vince reported a problem found by his perf specific trinity fuzzer. 

Al noticed 2 problems with perf's mmap(): 
 - it has issues against fork() since we use vma->vm_mm for accounting.
 - it has an rb refcount leak on double mmap().

We fix the issues against fork() by using VM_DONTCOPY; I don't think there's
code out there that uses this; we didn't hear about weird accounting
problems/crashes. If we do need this to work, the previously proposed VM_PINNED
could make this work.

Aside from the rb reference leak spotted by Al, Vince's example prog was indeed
doing a double mmap() through the use of perf_event_set_output(). 

This exposes another problem, since we now have 2 events with one buffer, the
accounting gets screwy because we account per event. Fix this by making the
buffer responsible for its own accounting.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/perf_event.h |    3 +--
 kernel/events/core.c       |   37 ++++++++++++++++++++-----------------
 kernel/events/internal.h   |    3 +++
 3 files changed, 24 insertions(+), 19 deletions(-)

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
index 9dc297f..ae752cd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2917,7 +2917,7 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
+static bool ring_buffer_put(struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -3582,13 +3582,13 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+static bool ring_buffer_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
 
 	if (!atomic_dec_and_test(&rb->refcount))
-		return;
+		return false;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
 	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
@@ -3598,6 +3598,7 @@ static void ring_buffer_put(struct ring_buffer *rb)
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
+	return true;
 }
 
 static void perf_mmap_open(struct vm_area_struct *vma)
@@ -3612,18 +3613,20 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->rb);
-		struct user_struct *user = event->mmap_user;
 		struct ring_buffer *rb = event->rb;
+		struct user_struct *mmap_user = rb->mmap_user;
+		int mmap_locked = rb->mmap_locked;
+		unsigned long size = perf_data_size(rb);
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
 		rcu_assign_pointer(event->rb, NULL);
 		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		if (ring_buffer_put(rb)) {
+			atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+			vma->vm_mm->pinned_vm -= mmap_locked;
+			free_uid(mmap_user);
+		}
 	}
 }
 
@@ -3676,9 +3679,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages == nr_pages)
-			atomic_inc(&event->rb->refcount);
-		else
+		if (event->rb->nr_pages != nr_pages)
 			ret = -EINVAL;
 		goto unlock;
 	}
@@ -3720,12 +3721,14 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->rb, rb);
+
+	rb->mmap_locked = extra;
+	rb->mmap_user = get_current_user();
 
 	atomic_long_add(user_extra, &user->locked_vm);
-	event->mmap_locked = extra;
-	event->mmap_user = get_current_user();
-	vma->vm_mm->pinned_vm += event->mmap_locked;
+	vma->vm_mm->pinned_vm += extra;
+
+	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_update_userpage(event);
 
@@ -3734,7 +3737,7 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index eb675c4..5bc6c8e 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -31,6 +31,9 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	int				mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
