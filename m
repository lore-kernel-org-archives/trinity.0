From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in
	{reserve,release}_bp_slot()
Date: Sat, 1 Jun 2013 20:21:39 +0200
Message-ID: <20130601182139.GC4861@redhat.com>
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

fetch_bp_busy_slots() and toggle_bp_slot() use for_each_online_cpu(),
this is obviously wrong wrt cpu_up() or cpu_down(), we can over/under
account the per-cpu numbers.

For example:

	# echo 0 >> /sys/devices/system/cpu/cpu1/online
	# perf record -e mem:0x10 -p 1 &
	# echo 1 >> /sys/devices/system/cpu/cpu1/online
	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10 -C1 -a &
	# taskset -p 0x2 1

triggers the same WARN_ONCE("Can't find any breakpoint slot") in
arch_install_hw_breakpoint().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
---
 kernel/events/hw_breakpoint.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 29d3abe..4407e43 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -149,7 +149,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		return;
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -235,7 +235,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 
-- 
1.5.5.1

