From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 10:10:36 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130523125218.GB23650@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


I can confirm your patch avoids the oops on my machine.

It does lead to interesting behavior if I run the sample program
multiple times (with added printfs):

vince@core2:~$ ./perf_mmap_close_bug 
mmap1=0x7f06a6e90000
mmap2=0x7f06a6e7f000
vince@core2:~$ ./perf_mmap_close_bug 
mmap1=0x7f878a138000
mmap2=0x7f878a127000
vince@core2:~$ ./perf_mmap_close_bug 
mmap1=0xffffffffffffffff
Error opening fd2 Invalid argument

and then it never successfully completes again.  Is this unexpected 
behavior?  Or just a normal mmap/perf interaction that I don't understand?

Vince
