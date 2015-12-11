From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] update perf_event_open support to 4.4-rc4
Date: Fri, 11 Dec 2015 00:03:43 -0500 (EST)
Message-ID: <alpine.DEB.2.20.1512110000460.30287@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=fSiEP2NEGHpxbIqyf0B3Sqz3DMMi8xtlxvj52nseCnA=;
        b=FD/qC+FDYc7SLNji/KQmsd9O35cLYB1R7cwQOj1+QFEMPYugSLJFC/K85l40fQjL37
         XPdwoKbG46hom8VAxooktbMTv68OJT6U5In0C25fQr4q0k/DVr7R8Ih13GpxlvM+lDtc
         2N1kRTr4L22aY+JVq6FSZTlw2Whwv5R1zWwnI=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org


Update the perf_event_open support to match the current 
4.4-rc4 kernel.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index 89edd64..356f3be 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -109,6 +109,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
 	PERF_COUNT_SW_DUMMY			= 9,
+	PERF_COUNT_SW_BPF_OUTPUT		= 10,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
@@ -166,6 +167,8 @@ enum perf_branch_sample_type_shift {
 	PERF_SAMPLE_BRANCH_COND_SHIFT		= 10, /* conditional branches */
 
 	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT	= 11, /* call/ret stack */
+	PERF_SAMPLE_BRANCH_IND_JUMP_SHIFT	= 12, /* indirect jumps */
+	PERF_SAMPLE_BRANCH_CALL_SHIFT		= 13, /* direct call */
 
 	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
 };
@@ -185,6 +188,8 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_COND		= 1U << PERF_SAMPLE_BRANCH_COND_SHIFT,
 
 	PERF_SAMPLE_BRANCH_CALL_STACK	= 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
+	PERF_SAMPLE_BRANCH_IND_JUMP	= 1U << PERF_SAMPLE_BRANCH_IND_JUMP_SHIFT,
+	PERF_SAMPLE_BRANCH_CALL		= 1U << PERF_SAMPLE_BRANCH_CALL_SHIFT,
 
 	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
@@ -327,7 +332,8 @@ struct perf_event_attr {
 				mmap2          :  1, /* include mmap with inode data     */
 				comm_exec      :  1, /* flag comm events that are due to an exec */
 				use_clockid    :  1, /* use @clockid for time fields */
-				__reserved_1   : 38;
+				context_switch :  1, /* context switch data */
+				__reserved_1   : 37;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -472,7 +478,7 @@ struct perf_event_mmap_page {
 	 *   u64 delta;
 	 *
 	 *   quot = (cyc >> time_shift);
-	 *   rem = cyc & ((1 << time_shift) - 1);
+	 *   rem = cyc & (((u64)1 << time_shift) - 1);
 	 *   delta = time_offset + quot * time_mult +
 	 *              ((rem * time_mult) >> time_shift);
 	 *
@@ -503,7 +509,7 @@ struct perf_event_mmap_page {
 	 * And vice versa:
 	 *
 	 *   quot = cyc >> time_shift;
-	 *   rem  = cyc & ((1 << time_shift) - 1);
+	 *   rem  = cyc & (((u64)1 << time_shift) - 1);
 	 *   timestamp = time_zero + quot * time_mult +
 	 *               ((rem * time_mult) >> time_shift);
 	 */
@@ -563,11 +569,17 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
 /*
+ * Indicates that /proc/PID/maps parsing are truncated by time out.
+ */
+#define PERF_RECORD_MISC_PROC_MAP_PARSE_TIMEOUT	(1 << 12)
+/*
  * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
  * different events so can reuse the same bit position.
+ * Ditto PERF_RECORD_MISC_SWITCH_OUT.
  */
 #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
 #define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
+#define PERF_RECORD_MISC_SWITCH_OUT		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
@@ -799,6 +811,44 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_ITRACE_START		= 12,
 
+	/*
+	 * Records the dropped/lost sample number.
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	u64				lost;
+	 *	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_LOST_SAMPLES		= 13,
+
+	/*
+	 * Records a context switch in or out (flagged by
+	 * PERF_RECORD_MISC_SWITCH_OUT). See also
+	 * PERF_RECORD_SWITCH_CPU_WIDE.
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_SWITCH			= 14,
+
+	/*
+	 * CPU-wide version of PERF_RECORD_SWITCH with next_prev_pid and
+	 * next_prev_tid that are the next (switching out) or previous
+	 * (switching in) pid/tid.
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				next_prev_pid;
+	 *	u32				next_prev_tid;
+	 *	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_SWITCH_CPU_WIDE		= 15,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -903,6 +953,7 @@ union perf_mem_data_src {
  *
  *     in_tx: running in a hardware transaction
  *     abort: aborting a hardware transaction
+ *    cycles: cycles from last branch (or 0 if not supported)
  */
 struct perf_branch_entry {
 	__u64	from;
@@ -911,5 +962,6 @@ struct perf_branch_entry {
 		predicted:1,/* target predicted */
 		in_tx:1,    /* in transaction */
 		abort:1,    /* transaction abort */
-		reserved:60;
+		cycles:16,  /* cycle count to last branch */
+		reserved:44;
 };
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 6ace250..97eb720 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -689,7 +689,7 @@ static long long random_event_config(__u32 *event_type,
 		}
 		break;
 	case PERF_TYPE_SOFTWARE:
-		switch (rand() % 11) {
+		switch (rand() % 12) {
 		case 0:
 			config = PERF_COUNT_SW_CPU_CLOCK;
 			break;
@@ -721,6 +721,9 @@ static long long random_event_config(__u32 *event_type,
 			config = PERF_COUNT_SW_DUMMY;
 			break;
 		case 10:
+			config = PERF_COUNT_SW_BPF_OUTPUT;
+			break;
+		case 11:
 			config = rand64();
 			break;
 		default:
@@ -956,6 +959,10 @@ static long long random_branch_sample_type(void)
 		branch_sample |= PERF_SAMPLE_BRANCH_COND;
 	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_CALL_STACK;
+	if (RAND_BOOL())
+		branch_sample |= PERF_SAMPLE_BRANCH_IND_JUMP;
+	if (RAND_BOOL())
+		branch_sample |= PERF_SAMPLE_BRANCH_CALL;
 
 	/* Transactional Memory Types */
 	if (RAND_BOOL())
@@ -1012,6 +1019,7 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 	attr->mmap2 = RAND_BOOL();
 	attr->comm_exec = RAND_BOOL();
 	attr->use_clockid = RAND_BOOL();
+	attr->context_switch = RAND_BOOL();
 
 	/* wakeup events not relevant */
 
@@ -1076,6 +1084,7 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 	attr->mmap2 = RAND_BOOL();
 	attr->comm_exec = RAND_BOOL();
 	attr->use_clockid = RAND_BOOL();
+	attr->context_switch = RAND_BOOL();
 
 	attr->wakeup_events = rand32();
 
