From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] update perf_event_open support to 3.14-rc3
Date: Tue, 18 Feb 2014 12:44:07 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1402181242180.31682@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


Update perf_event_open support to 3.14-rc3.
The only real change is the addition of the
PERF_FLAG_FD_CLOEXEC flag.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index 0f06246..98d2ab5 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -678,6 +678,7 @@ enum perf_event_type {
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -723,6 +724,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
@@ -785,7 +787,7 @@ union perf_mem_data_src {
 #define PERF_MEM_TLB_SHIFT	26
 
 #define PERF_MEM_S(a, s) \
-	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
+	(((__u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
 
 /*
  * single taken branch record layout:
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 2e4a1a3..024d3ee 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -1208,6 +1208,8 @@ void sanitise_perf_event_open(int childno)
 			flags |= PERF_FLAG_FD_OUTPUT;
 		if (rand_bool())
 			flags |= PERF_FLAG_PID_CGROUP;
+		if (rand_bool())
+			flags |= PERF_FLAG_FD_CLOEXEC;
 	}
 	shm->a5[childno] = flags;
 
