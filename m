From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: perf,arm -- oops in validate_event
Date: Wed, 7 Aug 2013 16:05:57 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1308071605060.14098@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu> <20130806111932.GA25383@e106331-lin.cambridge.arm.com> <20130806115921.GA14798@mudshark.cambridge.arm.com>
 <20130806130815.GC25383@e106331-lin.cambridge.arm.com> <20130807130027.GA16474@mudshark.cambridge.arm.com> <20130807135437.GD28558@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130807135437.GD28558@e106331-lin.cambridge.arm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Wed, 7 Aug 2013, Mark Rutland wrote:

> On Wed, Aug 07, 2013 at 02:00:27PM +0100, Will Deacon wrote:
> > On Tue, Aug 06, 2013 at 02:08:15PM +0100, Mark Rutland wrote:
> > > On Tue, Aug 06, 2013 at 12:59:21PM +0100, Will Deacon wrote:
> > Ok, so the following quick hack below should solve the issue (can you confirm
> > it please, since I don't have access to any hardware atm?)
> 
> It works for me when running Vince's test case.
> 
> Tested-by: Mark Rutland <mark.rutland@arm.com>

I've also tested it and the fix works for the various test cases I've 
constructed for this issue.

Tested-by: Vince Weaver <vincent.weaver@maine.edu>
