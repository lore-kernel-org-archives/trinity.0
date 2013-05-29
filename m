From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: OOPS in perf_mmap_close()
Date: Wed, 29 May 2013 09:17:13 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305290915400.2479@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu> <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu> <20130529074433.GB12193@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130529074433.GB12193@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Wed, 29 May 2013, Peter Zijlstra wrote:

> Hurm.. I don't suppose you have an easy reproducer handy eh? I'll go
> stare at it. At least the current state is better than before, but
> clearly we're not quite there yet.

I've been working on a reproducible test case.  Simple modifications to 
the existing testcase don't seem to trigger things.  I have a 100k-300k 
syscall trace that triggers things, I'm working on trying to get that down 
to something reasonable.

Vince
