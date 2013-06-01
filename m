From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/3] hw_breakpoint: Simplify list/idx mess in
	toggle_bp_slot() paths
Date: Sat, 1 Jun 2013 21:45:48 +0200
Message-ID: <20130601194548.GB27149@redhat.com>
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

The enable/disable logic in toggle_bp_slot() is not symmetrical
and imho very confusing. "old_count" in toggle_bp_task_slot() is
actually new_count because this bp was already removed from the
list.

Change toggle_bp_slot() to always call list_add/list_del after
toggle_bp_task_slot(). This way old_idx is task_bp_pinned() and
this entry should be decremented, new_idx is +/-weight and we
need to increment this element. The code/logic looks obvious.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/hw_breakpoint.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index ed31fe1..21a3c88 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -185,26 +185,20 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 				enum bp_type_idx type, int weight)
 {
-	unsigned int *tsk_pinned;
-	int old_count = 0;
-	int old_idx = 0;
-	int idx = 0;
-
-	old_count = task_bp_pinned(cpu, bp, type);
-	old_idx = old_count - 1;
-	idx = old_idx + weight;
-
-	/* tsk_pinned[n] is the number of tasks having n breakpoints */
-	tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
-	if (enable) {
-		tsk_pinned[idx]++;
-		if (old_count > 0)
-			tsk_pinned[old_idx]--;
-	} else {
-		tsk_pinned[idx]--;
-		if (old_count > 0)
-			tsk_pinned[old_idx]++;
-	}
+	/* tsk_pinned[n-1] is the number of tasks having n>0 breakpoints */
+	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
+	int old_idx, new_idx;
+
+	old_idx = task_bp_pinned(cpu, bp, type) - 1;
+	if (enable)
+		new_idx = old_idx + weight;
+	else
+		new_idx = old_idx - weight;
+
+	if (old_idx >= 0)
+		tsk_pinned[old_idx]--;
+	if (new_idx >= 0)
+		tsk_pinned[new_idx]++;
 }
 
 /*
@@ -228,10 +222,6 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	}
 
 	/* Pinned counter task profiling */
-
-	if (!enable)
-		list_del(&bp->hw.bp_list);
-
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
@@ -241,6 +231,8 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 
 	if (enable)
 		list_add_tail(&bp->hw.bp_list, &bp_task_head);
+	else
+		list_del(&bp->hw.bp_list);
 }
 
 /*
-- 
1.5.5.1

