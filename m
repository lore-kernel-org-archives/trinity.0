From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
Date: Sat, 25 May 2013 21:11:21 -0400
Message-ID: <CAHGf_=r4sqQKELPh48z=KPyuyAM3uz5Az9RpssUwnK4QRoamHQ@mail.gmail.com>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523104154.GA23650@twins.programming.kicks-ass.net>
 <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com>
 <20130523152458.GD23650@twins.programming.kicks-ass.net> <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net> <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net> <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=Jx9cMTfl5m4LaGB8Swtmv4xwap7wZf3k7oac47aApY0=;
        b=YGgzO5LU615PcQ/ucEdq0Ct9CRUMqoBePrpQxwyMiQz9FNoBArXTkdL9aOsKMiorkF
         FYtKHkOSjnDBCuZ0K38ZrnP6m/WBF2si1djMdJ80rgGNxZvDsPoBIsvrYZ2GDi/bn4sP
         gvi4Z9IOsCUz5u5dg49E/+2E2WoqT2GTggTHBglCaa2tn5WGDY/XcghlzDS0amBkDN+i
         vWs64YNneI47BmgH8Uyokm8hzhM1hIC6n3X2C37b1DD8KvZx3ZaFCi0Nh732drUzLEPO
         ePJddDR8ETeKxMBRG+kbUnJzafuUATXKLS/nFrmuh5iH1H/MgKQ2Oj3VjPeZjrD+iza0
         WfTg==
In-Reply-To: <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
Sender: owner-linux-mm@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roland Dreier <roland@kernel.org>, infinipath@qlogic.com, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-rdma@vger.kernel.org, Or Gerlitz <or.gerlitz@gmail.com>

On Fri, May 24, 2013 at 11:40 AM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 24 May 2013, Peter Zijlstra wrote:
>
>> Patch bc3e53f682 ("mm: distinguish between mlocked and pinned pages")
>> broke RLIMIT_MEMLOCK.
>
> Nope the patch fixed a problem with double accounting.
>
> The problem that we seem to have is to define what mlocked and pinned mean
> and how this relates to RLIMIT_MEMLOCK.
>
> mlocked pages are pages that are movable (not pinned!!!) and that are
> marked in some way by user space actions as mlocked (POSIX semantics).
> They are marked with a special page flag (PG_mlocked).
>
> Pinned pages are pages that have an elevated refcount because the hardware
> needs to use these pages for I/O. The elevated refcount may be temporary
> (then we dont care about this) or for a longer time (such as the memory
> registration of the IB subsystem). That is when we account the memory as
> pinned. The elevated refcount stops page migration and other things from
> trying to move that memory.
>
> Pages can be both pinned and mlocked. Before my patch some pages those two
> issues were conflated since the same counter was used and therefore these
>
pages were counted twice. If an RDMA application was running using
> mlockall() and was performing large scale I/O then the counters could show
> extraordinary large numbers and the VM would start to behave erratically.
>
> It is important for the VM to know which pages cannot be evicted but that
> involves many more pages due to dirty pages etc etc.
>
> So far the assumption has been that RLIMIT_MEMLOCK is a limit on the pages
> that userspace has mlocked.
>
> You want the counter to mean something different it seems. What is it?
>
> I think we need to be first clear on what we want to accomplish and what
> these counters actually should count before changing things.

Hm.
If pinned and mlocked are totally difference intentionally, why IB uses
RLIMIT_MEMLOCK. Why don't IB uses IB specific limit and why only IB raise up
number of pinned pages and other gup users don't.
I can't guess IB folk's intent.

And now ever IB code has duplicated RLIMIT_MEMLOCK
check and at least __ipath_get_user_pages() forget to check
capable(CAP_IPC_LOCK).
That's bad.


> Certainly would appreciate improvements in this area but resurrecting the
> conflation between mlocked and pinned pages is not the way to go.
>
>> This patch proposes to properly fix the problem by introducing
>> VM_PINNED. This also provides the groundwork for a possible mpin()
>> syscall or MADV_PIN -- although these are not included.
>
> Maybe add a new PIN page flag? Pages are not pinned per vma as the patch
> seems to assume.

Generically, you are right. But if VM_PINNED is really only for IB,
this is acceptable
limitation. They can split vma for their own purpose.

Anyway, I agree we should clearly understand the semantics of IB pinning and
the userland usage and assumption.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
