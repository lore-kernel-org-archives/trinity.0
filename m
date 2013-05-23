From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 14:52:18 +0200
Message-ID: <20130523125218.GB23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130523044803.GA25399@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


The below fixes things for me.

---
Subject: perf: Fix perf mmap issues

Vince reported a problem found by his perf specific trinity fuzzer. Al noticed
perf's mmap() has issues against fork() -- since we use vma->vm_mm -- and
double mmap() -- we leak an rb refcount.

While staring at this code I also found the introduction of
mm_struct::pinned_vm wrecked accounting against RLIMIT_LOCKED.

Aside from the rb reference leak spotted by Al, Vince's example prog was indeed
doing a double mmap() through the use of perf_event_set_output(). When cloning
the buffer of another event we should also copy their mmap_{user,locked}
settings, because as it turns out, this second event might be the last to get
unmapped, meaning it will hit perf_mmap_close() and needs to undo whatever the
initial mmap() did.

This means perf_event_set_output() now needs to hold both events their
mmap_mutex.

Cc: Christoph Lameter <cl@linux.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/events/core.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..b736ad2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3676,9 +3676,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
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
@@ -3699,7 +3697,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
-	locked = vma->vm_mm->pinned_vm + extra;
+	locked = vma->vm_mm->locked_vm + vma->vm_mm->pinned_vm + extra;
 
 	if ((locked > lock_limit) && perf_paranoid_tracepoint_raw() &&
 		!capable(CAP_IPC_LOCK)) {
@@ -3734,7 +3732,7 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
@@ -6381,14 +6379,26 @@ err_size:
 	goto out;
 }
 
+static void mutex_lock_double(struct mutex *m1, struct mutex *m2)
+{
+	if (m2 < m1) swap(m1, m2);
+
+	mutex_lock(m1);
+	mutex_lock_nested(m2, SINGLE_DEPTH_NESTING);
+}
+
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
 	struct ring_buffer *rb = NULL, *old_rb = NULL;
+	struct user_struct *mmap_user = NULL;
+	int mmap_locked = 0;
 	int ret = -EINVAL;
 
-	if (!output_event)
+	if (!output_event) {
+		mutex_lock(&event->mmap_mutex);
 		goto set;
+	}
 
 	/* don't allow circular references */
 	if (event == output_event)
@@ -6406,8 +6416,9 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
 
+	mutex_lock_double(&event->mmap_mutex, &output_event->mmap_mutex);
 set:
-	mutex_lock(&event->mmap_mutex);
+
 	/* Can't redirect output if we've got an active mmap() */
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
@@ -6417,15 +6428,32 @@ set:
 		rb = ring_buffer_get(output_event);
 		if (!rb)
 			goto unlock;
+
+		/*
+		 * If we're going to copy the rb, we need also copy
+		 * mmap_{user,locked} in case we'll hit perf_mmap_close().
+		 */
+		mmap_user = output_event->mmap_user;
+		mmap_locked = output_event->mmap_locked;
 	}
 
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
 	if (old_rb)
 		ring_buffer_detach(event, old_rb);
+
+	/*
+	 * Per the above check we cannot have an active mmap on event,
+	 * therefore mmap_{user,locked} must be clear.
+	 */
+	event->mmap_user = mmap_user;
+	event->mmap_locked = mmap_locked;
+
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
+	if (output_event)
+		mutex_unlock(&output_event->mmap_mutex);
 
 	if (old_rb)
 		ring_buffer_put(old_rb);
