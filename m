From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [testcase] perf: yet another fuzzer triggered crash
Date: Mon, 1 Jul 2013 11:13:01 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130701090713.GO6626@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Mon, 1 Jul 2013, Peter Zijlstra wrote:


> OK, so on my westmere it triggers that WARN in task_ctx_sched_out() a
> _lot_ (I removed the ONCE for easier debugging earlier -- still kinda
> stumped there).
> 
> Then this thing causes an RCU stall and starts triggering NMI watchdog
> msgs.. so YAY! :-)

I'm glad it's not just me.

I'm in the process of kernel bisecting this, though all I can tell you so 
far is 2.6.32 is unaffected by the bug but 3.2 and later are.

Vince
