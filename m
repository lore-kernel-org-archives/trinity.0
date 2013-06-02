From: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] hw_breakpoint: Simplify *register_wide_hw_breakpoint()
Date: Sun, 2 Jun 2013 21:50:11 +0200
Message-ID: <20130602195011.GB3277@redhat.com>
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

1. register_wide_hw_breakpoint() can use unregister_ if failure,
   no need to duplicate the code.

2. "struct perf_event **pevent" adds the unnecesary lever of
   indirection and complication, use per_cpu(*cpu_events, cpu).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/hw_breakpoint.c |   34 +++++++++++-----------------------
 1 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 74d739b..17d8093 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -497,8 +497,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context)
 {
-	struct perf_event * __percpu *cpu_events, **pevent, *bp;
-	long err;
+	struct perf_event * __percpu *cpu_events, *bp;
+	long err = 0;
 	int cpu;
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
@@ -507,31 +507,21 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
 		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
 						      triggered, context);
-
-		*pevent = bp;
-
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
-			goto fail;
+			break;
 		}
-	}
-	put_online_cpus();
-
-	return cpu_events;
 
-fail:
-	for_each_online_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
-		if (IS_ERR(*pevent))
-			break;
-		unregister_hw_breakpoint(*pevent);
+		per_cpu(*cpu_events, cpu) = bp;
 	}
 	put_online_cpus();
 
-	free_percpu(cpu_events);
+	if (likely(!err))
+		return cpu_events;
+
+	unregister_wide_hw_breakpoint(cpu_events);
 	return (void __percpu __force *)ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
@@ -543,12 +533,10 @@ EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 {
 	int cpu;
-	struct perf_event **pevent;
 
-	for_each_possible_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
-		unregister_hw_breakpoint(*pevent);
-	}
+	for_each_possible_cpu(cpu)
+		unregister_hw_breakpoint(per_cpu(*cpu_events, cpu));
+
 	free_percpu(cpu_events);
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
-- 
1.5.5.1

