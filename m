From: Oleg Nesterov <oleg@redhat.com>
Subject: [MAYBEPATCH] : WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
Date: Wed, 29 May 2013 18:32:57 +0200
Message-ID: <20130529163257.GA31720@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130528170048.GA26906@redhat.com> <20130528172829.GA2810@redhat.com> <20130528184702.GA6455@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130528184702.GA6455@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>

OK, I seem to understand what toggle_bp_task_slot() does, and
it looks equally wrong.

I think we need something like the patch below... I'll try to
recheck/test tomorrow, but I would not mind if someone who knows
this code makes the authoritative fix.

Even if this patch is right, I think this all needs more cleanups,
at least. For example, every DEFINE_PER_CPU() looks bogus. This
is not pcpu memory.

Oleg.

--- x/kernel/events/hw_breakpoint.c
+++ x/kernel/events/hw_breakpoint.c
@@ -111,7 +111,7 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
  * Count the number of breakpoints of the same type and same task.
  * The given event must be not on the list.
  */
-static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
+static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
 {
 	struct task_struct *tsk = bp->hw.bp_target;
 	struct perf_event *iter;
@@ -120,7 +120,7 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
 		if (iter->hw.bp_target == tsk &&
 		    find_slot_idx(iter) == type &&
-		    cpu == iter->cpu)
+		    bp->cpu == iter->cpu)
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -137,13 +137,17 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 {
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->hw.bp_target;
+	int task_pinned;
+
+	if (tsk)
+		task_pinned = task_bp_pinned(bp, type);
 
 	if (cpu >= 0) {
 		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
 		if (!tsk)
 			slots->pinned += max_task_bp_pinned(cpu, type);
 		else
-			slots->pinned += task_bp_pinned(cpu, bp, type);
+			slots->pinned += task_pinned;
 		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
 
 		return;
@@ -156,7 +160,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			nr += max_task_bp_pinned(cpu, type);
 		else
-			nr += task_bp_pinned(cpu, bp, type);
+			nr += task_pinned;
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -182,15 +186,13 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 /*
  * Add a pinned breakpoint for the given task in our constraint table
  */
-static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
+static void toggle_bp_task_slot(int old_count, int cpu, bool enable,
 				enum bp_type_idx type, int weight)
 {
 	unsigned int *tsk_pinned;
-	int old_count = 0;
 	int old_idx = 0;
 	int idx = 0;
 
-	old_count = task_bp_pinned(cpu, bp, type);
 	old_idx = old_count - 1;
 	idx = old_idx + weight;
 
@@ -216,6 +218,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 {
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->hw.bp_target;
+	int task_pinned;
 
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
@@ -232,11 +235,13 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	if (!enable)
 		list_del(&bp->hw.bp_list);
 
+	task_pinned = task_bp_pinned(bp, type);
+
 	if (cpu >= 0) {
-		toggle_bp_task_slot(bp, cpu, enable, type, weight);
+		toggle_bp_task_slot(task_pinned, cpu, enable, type, weight);
 	} else {
 		for_each_online_cpu(cpu)
-			toggle_bp_task_slot(bp, cpu, enable, type, weight);
+			toggle_bp_task_slot(task_pinned, cpu, enable, type, weight);
 	}
 
 	if (enable)
