From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Wed, 5 Jun 2013 18:54:52 +0200
Message-ID: <20130605165452.GY27176@twins.programming.kicks-ass.net>
References: <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu>
 <20130529074433.GB12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
 <20130530072532.GF4341@laptop>
 <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu>
 <20130603132645.GC8923@twins.programming.kicks-ass.net>
 <20130603192505.GH8923@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1306051151570.6484@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306051151570.6484@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Wed, Jun 05, 2013 at 11:54:52AM -0400, Vince Weaver wrote:
> On Mon, 3 Jun 2013, Peter Zijlstra wrote:
> 
> > Seems to cure it... I'm going to let it run over night.
> 
> [sorry for the delay in testing, was at the hospital waiting for
>  a new baby, and the free wi-fi had the ssh port blocked]

Congrats!!
