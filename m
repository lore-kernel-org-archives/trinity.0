From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch v2] perf_event_open() Linux 3.16 additions
Date: Tue, 5 Aug 2014 00:08:04 -0400 (EDT)
Message-ID: <alpine.DEB.2.11.1408050007040.10700@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:subject:message-id:user-agent:mime-version
         :content-type;
        bh=VactcrjnfpaiiU/LZi1HJ64bwfUhMJ+PU2Vs0DG+epU=;
        b=eJxPLTjRApBgr/gy6VeOh5CvmIFWpd2Rc9NIXNtslj0bFocw00bNt18hhzP1Mz8Zij
         Y4N2vr8EGT3Y2sTEjsARaCoN5t8qI54lsujKVzTVgxk9e/K84gCUEnMkdVXdfzFUZeM4
         nVOU9Jwxb7J/WF2wJK2WbSMtPx2pyoKXudc6U=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


Update perf_event_open support to add new features from the recent Linux 
3.16 release.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index 98d2ab5..51cd111 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -162,8 +162,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
 	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
 	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
+	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
@@ -300,8 +301,8 @@ struct perf_event_attr {
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
-
-				__reserved_1   : 40;
+				comm_exec      :  1, /* flag comm events that are due to an exec */
+				__reserved_1   : 39;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -500,7 +501,12 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
+/*
+ * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
+ * different events so can reuse the same bit position.
+ */
 #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
+#define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
@@ -698,6 +704,7 @@ enum perf_event_type {
 	 *	u32				min;
 	 *	u64				ino;
 	 *	u64				ino_generation;
+	 *	u32				prot, flags;
 	 *	char				filename[];
 	 * 	struct sample_id		sample_id;
 	 * };
@@ -721,10 +728,10 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
-#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
-#define PERF_FLAG_FD_OUTPUT		(1U << 1)
-#define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
-#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
+#define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
+#define PERF_FLAG_FD_OUTPUT		(1UL << 1)
+#define PERF_FLAG_PID_CGROUP		(1UL << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1UL << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 1ac959d..6dba16f 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -945,6 +945,8 @@ static long long random_branch_sample_type(void)
 		branch_sample |= PERF_SAMPLE_BRANCH_ANY_RETURN;
 	if (rand_bool())
 		branch_sample |= PERF_SAMPLE_BRANCH_IND_CALL;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_COND;
 
 	/* Transactional Memory Types */
 	if (rand_bool())
@@ -998,6 +1000,8 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 	attr->exclude_guest = rand_bool();
 	attr->exclude_callchain_kernel = rand_bool();
 	attr->exclude_callchain_user = rand_bool();
+	attr->mmap2 = rand_bool();
+	attr->comm_exec = rand_bool();
 
 	/* wakeup events not relevant */
 
@@ -1059,6 +1063,8 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 	attr->exclude_guest = rand_bool();
 	attr->exclude_callchain_kernel = rand_bool();
 	attr->exclude_callchain_user = rand_bool();
+	attr->mmap2 = rand_bool();
+	attr->comm_exec = rand_bool();
 
 	attr->wakeup_events = rand32();
 
@@ -1161,6 +1167,8 @@ static void create_random_event(struct perf_event_attr *attr)
 	attr->exclude_guest = rand_bool();
 	attr->exclude_callchain_kernel = rand_bool();
 	attr->exclude_callchain_user = rand_bool();
+	attr->mmap2 = rand_bool();
+	attr->comm_exec = rand_bool();
 
 	attr->wakeup_events=rand32();
 
