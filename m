From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
Date: Sat, 1 Jun 2013 20:20:57 +0200
Message-ID: <20130601182057.GA4861@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On 05/20, Vince Weaver wrote:
>
> on 3.10-rc1 with the trinity fuzzer patched to exercise the
> perf_event_open() syscall I am triggering this WARN_ONCE:
>
> [   75.864822] ------------[ cut here ]------------
> [   75.864830] WARNING: at arch/x86/kernel/hw_breakpoint.c:121 arch_install_hw_breakpoint+0x5b/0xcb()

Ingo,

I am not sure about -stable, but probably this is 3.10 material.

Oleg.
