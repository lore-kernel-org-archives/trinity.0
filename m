From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Mon, 3 Jun 2013 19:18:05 +0200
Message-ID: <20130603171805.GF8923@twins.programming.kicks-ass.net>
References: <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
 <20130530072532.GF4341@laptop>
 <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
 <20130603132645.GC8923@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130603132645.GC8923@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Mon, Jun 03, 2013 at 03:26:45PM +0200, Peter Zijlstra wrote:
> On Thu, May 30, 2013 at 08:51:00AM -0400, Vince Weaver wrote:
> > > I'll go prod, thanks again!
> 
> 
> OK the below builds and seems to survive both test cases and about 10 minutes
> of fuzzing -- fingers crossed.

OK, looks like I still drop something somewhere. mmap()s still goes to
0. Stupid thing!
