From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/3] hw_breakpoint: cleanups
Date: Sat, 1 Jun 2013 21:45:26 +0200
Message-ID: <20130601194526.GA27149@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

Hello.

Cleanups, on top of

	[PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c

series.

Oleg.

 kernel/events/hw_breakpoint.c |   91 ++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 56 deletions(-)
