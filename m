From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/2] hw_breakpoint: Introduce "struct bp_cpuinfo"
Date: Sun, 2 Jun 2013 21:50:57 +0200
Message-ID: <20130602195057.GC3277@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130602194912.GA3277@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130602194912.GA3277@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

This patch simply moves all per-cpu variables into the new single
per-cpu "struct bp_cpuinfo".

To me this looks more logical and clean, but this can also simplify
the further potential changes. In particular, I do not think this
memory should be per-cpu, it is never used "locally". After this
change it is trivial to turn it into, say, bootmem[nr_cpu_ids].

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/hw_breakpoint.c |   69 +++++++++++++++++++++-------------------
 1 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 17d8093..42c47a8 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -46,23 +46,26 @@
 #include <linux/smp.h>
 
 #include <linux/hw_breakpoint.h>
-
-
 /*
  * Constraints data
  */
+struct bp_cpuinfo {
+	/* Number of pinned cpu breakpoints in a cpu */
+	unsigned int	cpu_pinned;
+	/* tsk_pinned[n] is the number of tasks having n+1 breakpoints */
+	unsigned int	*tsk_pinned;
+	/* Number of non-pinned cpu/task breakpoints in a cpu */
+	unsigned int	flexible; /* XXX: placeholder, see fetch_this_slot() */
+};
 
-/* Number of pinned cpu breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
-
-/* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int *, nr_task_bp_pinned[TYPE_MAX]);
-
-/* Number of non-pinned cpu/task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
-
+static DEFINE_PER_CPU(struct bp_cpuinfo, bp_cpuinfo[TYPE_MAX]);
 static int nr_slots[TYPE_MAX];
 
+static struct bp_cpuinfo *get_bp_info(int cpu, enum bp_type_idx type)
+{
+	return per_cpu_ptr(bp_cpuinfo + type, cpu);
+}
+
 /* Keep track of the breakpoints attached to tasks */
 static LIST_HEAD(bp_task_head);
 
@@ -96,8 +99,8 @@ static inline enum bp_type_idx find_slot_idx(struct perf_event *bp)
  */
 static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
 {
+	unsigned int *tsk_pinned = get_bp_info(cpu, type)->tsk_pinned;
 	int i;
-	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 
 	for (i = nr_slots[type] - 1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
@@ -146,8 +149,10 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 	int cpu;
 
 	for_each_cpu(cpu, cpumask) {
-		unsigned int nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
+		struct bp_cpuinfo *info = get_bp_info(cpu, type);
+		int nr;
 
+		nr = info->cpu_pinned;
 		if (!bp->hw.bp_target)
 			nr += max_task_bp_pinned(cpu, type);
 		else
@@ -156,8 +161,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (nr > slots->pinned)
 			slots->pinned = nr;
 
-		nr = per_cpu(nr_bp_flexible[type], cpu);
-
+		nr = info->flexible;
 		if (nr > slots->flexible)
 			slots->flexible = nr;
 	}
@@ -180,8 +184,7 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 static void toggle_bp_task_slot(struct perf_event *bp, int cpu,
 				enum bp_type_idx type, int weight)
 {
-	/* tsk_pinned[n-1] is the number of tasks having n>0 breakpoints */
-	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
+	unsigned int *tsk_pinned = get_bp_info(cpu, type)->tsk_pinned;
 	int old_idx, new_idx;
 
 	old_idx = task_bp_pinned(cpu, bp, type) - 1;
@@ -208,7 +211,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 
 	/* Pinned counter cpu profiling */
 	if (!bp->hw.bp_target) {
-		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
+		get_bp_info(bp->cpu, type)->cpu_pinned += weight;
 		return;
 	}
 
@@ -240,8 +243,8 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to a single cpu, check:
  *
- *       (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
- *           + max(per_cpu(nr_task_bp_pinned, cpu)))) < HBP_NUM
+ *       (per_cpu(info->flexible, cpu) || (per_cpu(info->cpu_pinned, cpu)
+ *           + max(per_cpu(info->tsk_pinned, cpu)))) < HBP_NUM
  *
  *       -> If there are already non-pinned counters in this cpu, it means
  *          there is already a free slot for them.
@@ -251,8 +254,8 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to every cpus, check:
  *
- *       (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
- *           + max(per_cpu(nr_task_bp_pinned, *)))) < HBP_NUM
+ *       (per_cpu(info->flexible, *) || (max(per_cpu(info->cpu_pinned, *))
+ *           + max(per_cpu(info->tsk_pinned, *)))) < HBP_NUM
  *
  *       -> This is roughly the same, except we check the number of per cpu
  *          bp for every cpu and we keep the max one. Same for the per tasks
@@ -263,16 +266,16 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to a single cpu, check:
  *
- *       ((per_cpu(nr_bp_flexible, cpu) > 1) + per_cpu(nr_cpu_bp_pinned, cpu)
- *            + max(per_cpu(nr_task_bp_pinned, cpu))) < HBP_NUM
+ *       ((per_cpu(info->flexible, cpu) > 1) + per_cpu(info->cpu_pinned, cpu)
+ *            + max(per_cpu(info->tsk_pinned, cpu))) < HBP_NUM
  *
- *       -> Same checks as before. But now the nr_bp_flexible, if any, must keep
+ *       -> Same checks as before. But now the info->flexible, if any, must keep
  *          one register at least (or they will never be fed).
  *
  *   - If attached to every cpus, check:
  *
- *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
- *            + max(per_cpu(nr_task_bp_pinned, *))) < HBP_NUM
+ *       ((per_cpu(info->flexible, *) > 1) + max(per_cpu(info->cpu_pinned, *))
+ *            + max(per_cpu(info->tsk_pinned, *))) < HBP_NUM
  */
 static int __reserve_bp_slot(struct perf_event *bp)
 {
@@ -617,7 +620,6 @@ static struct pmu perf_breakpoint = {
 
 int __init init_hw_breakpoint(void)
 {
-	unsigned int **task_bp_pinned;
 	int cpu, err_cpu;
 	int i;
 
@@ -626,10 +628,11 @@ int __init init_hw_breakpoint(void)
 
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < TYPE_MAX; i++) {
-			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
-			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
-						  GFP_KERNEL);
-			if (!*task_bp_pinned)
+			struct bp_cpuinfo *info = get_bp_info(cpu, i);
+
+			info->tsk_pinned = kcalloc(nr_slots[i], sizeof(int),
+							GFP_KERNEL);
+			if (!info->tsk_pinned)
 				goto err_alloc;
 		}
 	}
@@ -643,7 +646,7 @@ int __init init_hw_breakpoint(void)
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
 		for (i = 0; i < TYPE_MAX; i++)
-			kfree(per_cpu(nr_task_bp_pinned[i], err_cpu));
+			kfree(get_bp_info(err_cpu, i)->tsk_pinned);
 		if (err_cpu == cpu)
 			break;
 	}
-- 
1.5.5.1

