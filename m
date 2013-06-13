From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/3] hw_breakpoint: cleanups
Date: Thu, 13 Jun 2013 17:15:46 +0200
Message-ID: <20130613151546.GA30062@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130601194526.GA27149@redhat.com> <20130613140112.GB16339@somewhere>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130613140112.GB16339@somewhere>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On 06/13, Frederic Weisbecker wrote:
>
> On Sat, Jun 01, 2013 at 09:45:26PM +0200, Oleg Nesterov wrote:
> > Hello.
> >
> > Cleanups, on top of
> >
> > 	[PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
>
> So this series doesn't have the fix for the warning?

I don't understand the question ;)

The previous series

	[PATCH 1/2] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
	[PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

tried to fix the bugs which lead to this (correct) warning.

This and the next one try to cleanup the code.

Oleg.
