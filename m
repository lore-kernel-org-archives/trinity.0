From: Christoph Lameter <cl@linux.com>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 16:12:14 +0000
Message-ID: <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523104154.GA23650@twins.programming.kicks-ass.net> <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com> <20130523152458.GD23650@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130523152458.GD23650@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, 23 May 2013, Peter Zijlstra wrote:

> The patch completely fails to explain how RLIMIT_LOCKED is supposed to
> deal with pinned vs locked. Perf used to account its pages against
> RLIMIT_LOCKED, with the patch it compares pinned against RLIMIT_LOCKED
> but completely discards any possible locked pages.

Pinned pages are different from mlock. Mlock semantics means that the
pages are kept in memory but the pages are movable (subject to page
migration f.e.).

Pinned pages have to stay where they are since the physical addresses may
be used for device I/O or other stuff.

Both pinned and mlocked pages cannot be evicted from memory. If one wants
to account for unevictable pages then both are contributing. However,
since a pinned page may be mlocked simply adding up the counter may cause
problems. The sum could be used as a worst case estimate though.

We could mlock all pinned pages but then the issue arises on how to track
that properly in order to unpin when the I/O action is done since the app
may have also mlocked pages.

