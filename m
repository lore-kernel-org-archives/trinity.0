From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
Date: Tue, 28 May 2013 19:28:29 +0200
Message-ID: <20130528172829.GA2810@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130528170048.GA26906@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130528170048.GA26906@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>

OK, Jiri explained me how can I use perf to install the hwbp ;)

And indeed,

	# perl -e 'sleep 1 while 1' &
	[1] 507
	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 -p `pidof perl`
	
triggers the same warn/problem.

Interestingly,

	perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 true

correctly fails with ENOSPC, this is because perf installs NR_CPUS counters
for each cpu and the accounting works.

IIRC, I already tried to complain that perf could be smarter in this case
and install a single counter with event->cpu = -1, but this is offtopic.

Oleg.

On 05/28, Oleg Nesterov wrote:
>
> Well. I am not familiar with this code, and when I tried to read it
> I feel I will be never able to understand it ;)
>
> On 05/20, Vince Weaver wrote:
> >
> > on 3.10-rc1 with the trinity fuzzer patched to exercise the
> > perf_event_open() syscall I am triggering this WARN_ONCE:
> >
> > [   75.864822] ------------[ cut here ]------------
> > [   75.864830] WARNING: at arch/x86/kernel/hw_breakpoint.c:121 arch_install_hw_breakpoint+0x5b/0xcb()
> ...
> > [   75.864916]  [<ffffffff81006fff>] ? arch_install_hw_breakpoint+0x5b/0xcb
> > [   75.864919]  [<ffffffff810ab5a1>] ? event_sched_in+0x68/0x11c
>
> I am wondering if we should check attr->pinned before WARN_ONCE...
>
> But it seems that hw_breakpoint.c is buggy anyway.
>
> Suppose that attr.task != NULL and event->cpu = -1.
>
> __reserve_bp_slot() tries to calculate slots.pinned and calls
> fetch_bp_busy_slots().
>
> In this case fetch_bp_busy_slots() does
>
> 	for_each_online_cpu(cpu)
> 		...
> 		nr += task_bp_pinned(cpu, bp, type);
>
> And task_bp_pinned() (in particular) checks cpu == event->cpu,
> this will be never true.
>
> IOW, it seems that __reserve_bp_slot(task, cpu => -1) always
> succeeds because task_bp_pinned() returns 0 and thus we can
> create more than HWP_NUM breakpoints. Much more ;)
>
> As for _create, I guess we probably need something like
>
> --- x/kernel/events/hw_breakpoint.c
> +++ x/kernel/events/hw_breakpoint.c
> @@ -156,7 +156,7 @@ fetch_bp_busy_slots(struct bp_busy_slots
>  		if (!tsk)
>  			nr += max_task_bp_pinned(cpu, type);
>  		else
> -			nr += task_bp_pinned(cpu, bp, type);
> +			nr += task_bp_pinned(-1, bp, type);
>
>  		if (nr > slots->pinned)
>  			slots->pinned = nr;
>
> But I simply can't understand toggle_bp_task_slot()->task_bp_pinned().
>
> Oleg.
