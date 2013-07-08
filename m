From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
Date: Mon, 8 Jul 2013 11:55:33 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307081154110.2449@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
 <20130703074929.GE23916@twins.programming.kicks-ass.net> <20130708135048.GA1069@krava.brq.redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130708135048.GA1069@krava.brq.redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Mon, 8 Jul 2013, Jiri Olsa wrote:

> On Wed, Jul 03, 2013 at 09:49:29AM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 02, 2013 at 11:15:59PM -0400, Vince Weaver wrote:
> need to check if that does not break anything else ;-)

I've applied your patch to stock 3.10 and am now unable to hang my Core2 
machine that was exhibiting the problem in the first place.

I've also run the various test suites I have and haven't seen any 
regressions from the patch.

Vince
