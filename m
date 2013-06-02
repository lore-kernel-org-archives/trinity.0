From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/2] hw_breakpoint: more cleanups
Date: Sun, 2 Jun 2013 21:49:12 +0200
Message-ID: <20130602194912.GA3277@redhat.com>
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

More cleanups, on top of "[PATCH 0/3] hw_breakpoint: cleanups".

Oleg.

 kernel/events/hw_breakpoint.c |  103 +++++++++++++++++++----------------------
 1 files changed, 47 insertions(+), 56 deletions(-)
