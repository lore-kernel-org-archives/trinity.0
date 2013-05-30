From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 30 May 2013 08:51:00 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
References: <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523125218.GB23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu> <20130528085548.GA12193@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu> <20130530072532.GF4341@laptop>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130530072532.GF4341@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, 30 May 2013, Peter Zijlstra wrote:
> 
> Awesome! How specific is it to perf? I mean, would that tool work
> equally well for other tinity report?

No, it's fairly specific to my perf_fuzzer.  I only use trinity code to 
set up the perf_event_open() attr parameters, everything else I use my own 
code for.

The logging output from perf_fuzzer is fairly straightforward.  Just a 
single char indicating which syscall and a space separated list of 
the result (if relevant) and then all the syscall parameters.

The logging output can then be used by both the replayer and the 
sample-code generator.

While in theory this could be extended to something generic, currently it 
only works for perf_event_open/close/ioctl/read/write/mmap/munmap, and
even then it takes some shortcuts because I know it will only be run when 
finding perf_event problems.

The code for all of this is here if anyone else wants to play with it.
https://github.com/deater/perf_event_tests/tree/master/fuzzer

> I'll go prod, thanks again!

The bug looks related to hw breakpoints, not sure if the bugs Oleg 
Nesterov has been reporting in this area might be relevant or not.

Vince
