From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
Date: Sat, 1 Jun 2013 20:21:20 +0200
Message-ID: <20130601182120.GB4861@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130601182057.GA4861@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130601182057.GA4861@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

trinity fuzzer triggered WARN_ONCE("Can't find any breakpoint slot")
in arch_install_hw_breakpoint() but the problem is not arch-specific.

The problem is, task_bp_pinned(cpu) checks "cpu == iter->cpu" but
this doesn't account the "all cpus" events with iter->cpu < 0.

This means that, say, register_user_hw_breakpoint(tsk) can happily
create the arbitrary number > HBP_NUM of breakpoints which can not
be activated. toggle_bp_task_slot() is equally wrong by the same
reason and nr_task_bp_pinned[] can have negative entries.

Simple test:

	# perl -e 'sleep 1 while 1' &
	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 -p `pidof perl`

Before this patch this triggers the same problem/WARN_ON(), after
the patch it correctly fails with -ENOSPC.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
---
 kernel/events/hw_breakpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index ed1c897..29d3abe 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -120,7 +120,7 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
 		if (iter->hw.bp_target == tsk &&
 		    find_slot_idx(iter) == type &&
-		    cpu == iter->cpu)
+		    (iter->cpu < 0 || cpu == iter->cpu))
 			count += hw_breakpoint_weight(iter);
 	}
 
-- 
1.5.5.1

