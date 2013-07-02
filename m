From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [testcase] perf: yet another fuzzer triggered crash
Date: Tue, 2 Jul 2013 16:32:42 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Mon, 1 Jul 2013, Vince Weaver wrote:

> I'm in the process of kernel bisecting this, though all I can tell you so 
> far is 2.6.32 is unaffected by the bug but 3.2 and later are.

well, I spent 2 days bisecting between 3.1 and 3.2 (after 
wasting time bisecting between 3.0 and 3.1 by mistake) 
(also, a pox on whoever introduced that ethernet .config change between 
3.1. 3.2).

and of course what it gives me is
   a240f76165e6255384d4bdb8139895fac7988799

   perf, core: Introduce attrs to count in either host or guest mode

so the test case wasn't crashing because the auto-generated file
was setting exclude_guest and exclude_host causing perf_event_open() 
to fail.  If I drop setting those bits it still crashes.  

I guess back to the drawing board.

Vince
