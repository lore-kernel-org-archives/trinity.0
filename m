From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 30 May 2013 09:25:32 +0200
Message-ID: <20130530072532.GF4341@laptop>
References: <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Wed, May 29, 2013 at 03:18:32PM -0400, Vince Weaver wrote:
> On Wed, 29 May 2013, Peter Zijlstra wrote:
> > 
> > Hurm.. I don't suppose you have an easy reproducer handy eh? I'll go
> > stare at it. At least the current state is better than before, but
> > clearly we're not quite there yet.
> 
> OK, below is an easy reproducer.  Just run it two or three times.
> It leaks 129 pages in user->locked_vm each time you run it.
> 
> It took me a while to bisect this down from 10,000 syscalls to just 3.
> I now have a tool that can generate valid perf test_cases from my fuzzer 
> traces, which should be useful.

Awesome! How specific is it to perf? I mean, would that tool work
equally well for other tinity report?

I'll go prod, thanks again!
