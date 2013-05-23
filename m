From: Christoph Lameter <cl@linux.com>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 17:59:10 +0000
Message-ID: <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523104154.GA23650@twins.programming.kicks-ass.net> <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com> <20130523152458.GD23650@twins.programming.kicks-ass.net> <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130523163901.GG23650@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, 23 May 2013, Peter Zijlstra wrote:

> I know all that, and its completely irrelevant to the discussion.

What you said in the rest of the email seems to indicate that you
still do not know that and I am repeating what I have said before here.

> You now have double the amount of memory you can loose, once to actual
> mlock() and once through whatever generates pinned -- if it bothers with
> checking limits at all.

It was already doubled which was the reason for the patch. The patch
avoided the doubling that we saw and it allowed to distinguish between
mlocked and pinned pages.

> Where we had the guarantee that x < y; you did x := x1 + x2; which then
> should result in: x1 + x2 < y, instead you did: x1 < y && x2 < y, not
> the same and completely wrong.

We never had that guarantee. We were accounting many pages twice in
the same counter. Once for mlocking and once for pinning. Thus the problem
that the patch addresses. Read the changelog?

There are other sources that cause pages to be not evictable (like f.e.
dirtying). Mlock accounting is not accurate in any case. The mlocked page
limit is per thread which is another issue and so is the vm_pinned
counter. The pages actually may be shared between many processes and the
ownership of those pages is not clear. The accounting for mlock and
pinning also is a bit problematic as a result.
