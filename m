From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Wed, 29 May 2013 09:44:33 +0200
Message-ID: <20130529074433.GB12193@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Tue, May 28, 2013 at 02:22:11PM -0400, Vince Weaver wrote:
> On Tue, 28 May 2013, Vince Weaver wrote:
> 
> > It looks like this is already in tip, but I can confirm that this 
> > patch seems to fix things on my machine and holds up against longer 
> > fuzzing runs.
> 
> OK, I take it back.  Even with the new patch applied, my fuzzer can still 
> make the kernel leak user->locked_vm
> 
> I assume that the locked_vm value should go back to 0 once a process that 
> has a bunch of mmap'd perf_events opened exits?

Yep.

> I admit this is sort of an obscure corner case, but it does mean that a 
> user can leak user->locked_vm to the point that "perf record" no longer 
> works.

Hurm.. I don't suppose you have an easy reproducer handy eh? I'll go
stare at it. At least the current state is better than before, but
clearly we're not quite there yet.
