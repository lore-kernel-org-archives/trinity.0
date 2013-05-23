From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 05:48:03 +0100
Message-ID: <20130523044803.GA25399@ZenIV.linux.org.uk>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Wed, May 22, 2013 at 11:48:51PM -0400, Vince Weaver wrote:
> 
> In case anyone cares, the Oops is happening here:
> 
>     1a56:       48 c1 e8 0c             shr    $0xc,%rax
>     1a5a:       48 ff c0                inc    %rax
> >   1a5d:       f0 48 29 45 60          lock sub %rax,0x60(%rbp)
>     1a62:       49 8b 46 40             mov    0x40(%r14),%rax
> 
> Which maps to this in perf_mmap_close() in kernel/events/core.c:
> 
>                 atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
> 
> And "user" (%rbp) is RBP: 0000000000000000, hence the problem.
> 
> I'm having trouble tracking the problem back any further as the code is a 
> bit covoluted and is not commented at all.

FWIW, at least part of perf_mmap_close() is obvious garbage - increment of
->pinned_vm happens in mmap(), decrement - on the ->close() of the last
VMA clonal to one we'd created in that mmap(), regardless of the address
space it's in.  Not that handling of ->pinned_vm made any sense wrt fork()...

Actually...  What happens if you mmap() the same opened file of that
kind several times, each time with the same size?  AFAICS, on all
subsequent calls we'll get
        mutex_lock(&event->mmap_mutex);
        if (event->rb) {
                if (event->rb->nr_pages == nr_pages)
                        atomic_inc(&event->rb->refcount);
		else
			...
		goto unlock;
unlock:
        if (!ret)
                atomic_inc(&event->mmap_count);
        mutex_unlock(&event->mmap_mutex);

i.e. we bump event->mmap_count *and* event->rb->refcount.  munmap()
all of them and each will generate a call of perf_mmap_close(); ->mmap_count
will go down to zero and on all but the last call we'll have nothing else
done.  On the last call we'll hit ring_buffer_put(), which will decrement
event->rb->refcount once.  Note that by that point we simply don't know
how many times we'd incremented it in those mmap() calls - it's too late
to clean up.  IOW, unless I'm misreading that code, we've got a leak in
there.  Not the same bug, but...
