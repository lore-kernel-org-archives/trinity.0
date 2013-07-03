From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
Date: Wed, 3 Jul 2013 09:49:29 +0200
Message-ID: <20130703074929.GE23916@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Tue, Jul 02, 2013 at 11:15:59PM -0400, Vince Weaver wrote:
> 
> OK, I have bisected this problem to the following change:
> 
> commit 8dc85d547285668e509f86c177bcd4ea055bcaaf
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Thu Sep 2 16:50:03 2010 +0200
> 
>     perf: Multiple task contexts
>     
>     Provide the infrastructure for multiple task contexts.
> 

Thanks, that narrows down the scope a bit. As it happens I was also
narrowing down on that particular area so that's good.
