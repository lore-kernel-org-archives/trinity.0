From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 12:41:54 +0200
Message-ID: <20130523104154.GA23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130523044803.GA25399@ZenIV.linux.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, cl@linux.com

On Thu, May 23, 2013 at 05:48:03AM +0100, Al Viro wrote:
> On Wed, May 22, 2013 at 11:48:51PM -0400, Vince Weaver wrote:
> > 
> > In case anyone cares, the Oops is happening here:
> > 
> >     1a56:       48 c1 e8 0c             shr    $0xc,%rax
> >     1a5a:       48 ff c0                inc    %rax
> > >   1a5d:       f0 48 29 45 60          lock sub %rax,0x60(%rbp)
> >     1a62:       49 8b 46 40             mov    0x40(%r14),%rax
> > 
> > Which maps to this in perf_mmap_close() in kernel/events/core.c:
> > 
> >                 atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
> > 
> > And "user" (%rbp) is RBP: 0000000000000000, hence the problem.
> > 
> > I'm having trouble tracking the problem back any further as the code is a 
> > bit covoluted and is not commented at all.
> 
> FWIW, at least part of perf_mmap_close() is obvious garbage - increment of
> ->pinned_vm happens in mmap(), decrement - on the ->close() of the last
> VMA clonal to one we'd created in that mmap(), regardless of the address
> space it's in.  Not that handling of ->pinned_vm made any sense wrt fork()...

Right it doesn't. I think the easiest solution for now is to not copy the VMA
on fork(). 

But I totally missed patch bc3e53f682d that introduced pinned_vm, AFAICT that
also wrecked some accounting. We should still account both against
RLIMIT_MEMLOCK.

> Actually...  What happens if you mmap() the same opened file of that
> kind several times, each time with the same size?  AFAICS, on all
> subsequent calls we'll get
>         mutex_lock(&event->mmap_mutex);
>         if (event->rb) {
>                 if (event->rb->nr_pages == nr_pages)
>                         atomic_inc(&event->rb->refcount);
> 		else
> 			...
> 		goto unlock;
> unlock:
>         if (!ret)
>                 atomic_inc(&event->mmap_count);
>         mutex_unlock(&event->mmap_mutex);
> 
> i.e. we bump event->mmap_count *and* event->rb->refcount.  munmap()
> all of them and each will generate a call of perf_mmap_close(); ->mmap_count
> will go down to zero and on all but the last call we'll have nothing else
> done.  On the last call we'll hit ring_buffer_put(), which will decrement
> event->rb->refcount once.  Note that by that point we simply don't know
> how many times we'd incremented it in those mmap() calls - it's too late
> to clean up.  IOW, unless I'm misreading that code, we've got a leak in
> there.  Not the same bug, but...

Quite so, lets remove that rb->refcount.

Now I don't think any of this explains Vince's splat, I'll go stare at that
next.

---
 kernel/events/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..c75b9c6 100644
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
@@ -3734,7 +3732,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
