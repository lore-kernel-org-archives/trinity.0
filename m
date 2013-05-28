From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
Date: Tue, 28 May 2013 20:47:02 +0200
Message-ID: <20130528184702.GA6455@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130528170048.GA26906@redhat.com> <20130528172829.GA2810@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130528172829.GA2810@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>

On 05/28, Oleg Nesterov wrote:
>
> IIRC, I already tried to complain that perf could be smarter in this case
> and install a single counter with event->cpu = -1, but this is offtopic.

Just in case, please see my old email

	http://marc.info/?l=linux-kernel&m=136017983113299

I didn't check if perf was changed since then. And I forgot everything
(not too much ;) I learned after I briefly looked into tools/perf/.

But, again, this is off-topic.

Oleg.
