From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
Date: Tue, 2 Jul 2013 23:15:59 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


OK, I have bisected this problem to the following change:

commit 8dc85d547285668e509f86c177bcd4ea055bcaaf
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Sep 2 16:50:03 2010 +0200

    perf: Multiple task contexts
    
    Provide the infrastructure for multiple task contexts.
