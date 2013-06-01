From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/3] hw_breakpoint: Simplify the "weight" usage in
	toggle_bp_slot() paths
Date: Sat, 1 Jun 2013 21:46:06 +0200
Message-ID: <20130601194606.GC27149@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130601194526.GA27149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130601194526.GA27149@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

Change toggle_bp_slot() to make "weight" negative if !enable. This
way we can always use "+ weight" without additional "if (enable)"
check and toggle_bp_task_slot() no longer needs this arg.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/hw_breakpoint.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 21a3c88..2f4d7c4 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -182,7 +182,7 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 /*
  * Add a pinned breakpoint for the given task in our constraint table
  */
-static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
+static void toggle_bp_task_slot(struct perf_event *bp, int cpu,
 				enum bp_type_idx type, int weight)
 {
 	/* tsk_pinned[n-1] is the number of tasks having n>0 breakpoints */
@@ -190,10 +190,7 @@ static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 	int old_idx, new_idx;
 
 	old_idx = task_bp_pinned(cpu, bp, type) - 1;
-	if (enable)
-		new_idx = old_idx + weight;
-	else
-		new_idx = old_idx - weight;
+	new_idx = old_idx + weight;
 
 	if (old_idx >= 0)
 		tsk_pinned[old_idx]--;
@@ -211,22 +208,21 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->hw.bp_target;
 
+	if (!enable)
+		weight = -weight;
+
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
-
-		if (enable)
-			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
-		else
-			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) -= weight;
+		per_cpu(nr_cpu_bp_pinned[type], cpu) += weight;
 		return;
 	}
 
 	/* Pinned counter task profiling */
 	if (cpu >= 0) {
-		toggle_bp_task_slot(bp, cpu, enable, type, weight);
+		toggle_bp_task_slot(bp, cpu, type, weight);
 	} else {
 		for_each_possible_cpu(cpu)
-			toggle_bp_task_slot(bp, cpu, enable, type, weight);
+			toggle_bp_task_slot(bp, cpu, type, weight);
 	}
 
 	if (enable)
-- 
1.5.5.1

