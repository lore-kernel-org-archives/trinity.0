From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Fri, 24 May 2013 11:21:00 +0200
Message-ID: <20130524092100.GI23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, May 23, 2013 at 07:40:12PM -0400, Vince Weaver wrote:
> On Thu, 23 May 2013, Peter Zijlstra wrote:
> 
> > On Thu, May 23, 2013 at 10:10:36AM -0400, Vince Weaver wrote:
> > > 
> > > I can confirm your patch avoids the oops on my machine.
> > > 
> > > It does lead to interesting behavior if I run the sample program
> > > multiple times (with added printfs):
> > > 
> > > vince@core2:~$ ./perf_mmap_close_bug 
> > > mmap1=0x7f06a6e90000
> > > mmap2=0x7f06a6e7f000
> > > vince@core2:~$ ./perf_mmap_close_bug 
> > > mmap1=0x7f878a138000
> > > mmap2=0x7f878a127000
> > > vince@core2:~$ ./perf_mmap_close_bug 
> > > mmap1=0xffffffffffffffff
> > > Error opening fd2 Invalid argument
> > > 
> > > and then it never successfully completes again.  Is this unexpected 
> > > behavior?  
> > 
> > Sounds weird to me, I'll see if I can reproduce/understand.
> 
> I tracked this down in case you haven't already.
> 
> The problem is that in the kernel patched 
> with your patch locked_vm is getting decremented twice in the sample code 
> and going negative.  I'm not sure why this isn't a problem until the 
> third time through.  Here are my crude debug printk 
> results from kernel/events/core.c

D'uh I think I see what's happening.. we haev split the mmap state
between the ringbuffer and event objects and since we have two events
and one ringbuffer we're hosed.

Let me try and straighten this out.
