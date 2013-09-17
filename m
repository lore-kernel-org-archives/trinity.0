From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] update perf_event support for 3.12-rc1
Date: Tue, 17 Sep 2013 15:11:57 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1309171509240.15599@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


This patch wires up PERF_COUNT_SW_DUMMY and PERF_SAMPLE_IDENTIFIER
which appear in 3.12-rc1

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index 0b1df41..40a1fb8 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -109,6 +109,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_DUMMY			= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
@@ -134,8 +135,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
+	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 
-	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
 };
 
 /*
@@ -275,8 +277,9 @@ struct perf_event_attr {
 
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
+				mmap2          :  1, /* include mmap with inode data     */
 
-				__reserved_1   : 41;
+				__reserved_1   : 40;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -321,6 +324,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -375,9 +379,12 @@ struct perf_event_mmap_page {
 	__u64	time_running;		/* time event on cpu */
 	union {
 		__u64	capabilities;
-		__u64	cap_usr_time  : 1,
-			cap_usr_rdpmc : 1,
-			cap_____res   : 62;
+		struct {
+			__u64	cap_usr_time		: 1,
+				cap_usr_rdpmc		: 1,
+				cap_usr_time_zero	: 1,
+				cap_____res		: 61;
+		};
 	};
 
 	/*
@@ -418,12 +425,29 @@ struct perf_event_mmap_page {
 	__u16	time_shift;
 	__u32	time_mult;
 	__u64	time_offset;
+	/*
+	 * If cap_usr_time_zero, the hardware clock (e.g. TSC) can be calculated
+	 * from sample timestamps.
+	 *
+	 *   time = timestamp - time_zero;
+	 *   quot = time / time_mult;
+	 *   rem  = time % time_mult;
+	 *   cyc = (quot << time_shift) + (rem << time_shift) / time_mult;
+	 *
+	 * And vice versa:
+	 *
+	 *   quot = cyc >> time_shift;
+	 *   rem  = cyc & ((1 << time_shift) - 1);
+	 *   timestamp = time_zero + quot * time_mult +
+	 *               ((rem * time_mult) >> time_shift);
+	 */
+	__u64	time_zero;
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[120];	/* align to 1k */
+	__u64	__reserved[119];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
@@ -471,13 +495,28 @@ enum perf_event_type {
 	/*
 	 * If perf_event_attr.sample_id_all is set then all event types will
 	 * have the sample_type selected fields related to where/when
-	 * (identity) an event took place (TID, TIME, ID, CPU, STREAM_ID)
-	 * described in PERF_RECORD_SAMPLE below, it will be stashed just after
-	 * the perf_event_header and the fields already present for the existing
-	 * fields, i.e. at the end of the payload. That way a newer perf.data
-	 * file will be supported by older perf tools, with these new optional
-	 * fields being ignored.
+	 * (identity) an event took place (TID, TIME, ID, STREAM_ID, CPU,
+	 * IDENTIFIER) described in PERF_RECORD_SAMPLE below, it will be stashed
+	 * just after the perf_event_header and the fields already present for
+	 * the existing fields, i.e. at the end of the payload. That way a newer
+	 * perf.data file will be supported by older perf tools, with these new
+	 * optional fields being ignored.
+	 *
+	 * struct sample_id {
+	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
+	 * 	{ u64			id;       } && PERF_SAMPLE_ID
+	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
+	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 *	{ u64			id;	  } && PERF_SAMPLE_IDENTIFIER
+	 * } && perf_event_attr::sample_id_all
 	 *
+	 * Note that PERF_SAMPLE_IDENTIFIER duplicates PERF_SAMPLE_ID.  The
+	 * advantage of PERF_SAMPLE_IDENTIFIER is that its position is fixed
+	 * relative to header.size.
+	 */
+
+	/*
 	 * The MMAP events record the PROT_EXEC mappings so that we can
 	 * correlate userspace IPs to code. They have the following structure:
 	 *
@@ -498,6 +537,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u64				id;
 	 *	u64				lost;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_LOST			= 2,
@@ -508,6 +548,7 @@ enum perf_event_type {
 	 *
 	 *	u32				pid, tid;
 	 *	char				comm[];
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_COMM			= 3,
@@ -518,6 +559,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_EXIT			= 4,
@@ -528,6 +570,7 @@ enum perf_event_type {
 	 *	u64				time;
 	 *	u64				id;
 	 *	u64				stream_id;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_THROTTLE			= 5,
@@ -539,6 +582,7 @@ enum perf_event_type {
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
 	 *	u64				time;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_FORK			= 7,
@@ -549,6 +593,7 @@ enum perf_event_type {
 	 *	u32				pid, tid;
 	 *
 	 *	struct read_format		values;
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_READ			= 8,
@@ -557,6 +602,13 @@ enum perf_event_type {
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
+	 *	#
+	 *	# Note that PERF_SAMPLE_IDENTIFIER duplicates PERF_SAMPLE_ID.
+	 *	# The advantage of PERF_SAMPLE_IDENTIFIER is that its position
+	 *	# is fixed relative to header.
+	 *	#
+	 *
+	 *	{ u64			id;	  } && PERF_SAMPLE_IDENTIFIER
 	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
 	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
 	 *	{ u64			time;     } && PERF_SAMPLE_TIME
@@ -596,11 +648,32 @@ enum perf_event_type {
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
-	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
 
+	/*
+	 * The MMAP2 records are an augmented version of MMAP, they add
+	 * maj, min, ino numbers to be used to uniquely identify each mapping
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	u32				pid, tid;
+	 *	u64				addr;
+	 *	u64				len;
+	 *	u64				pgoff;
+	 *	u32				maj;
+	 *	u32				min;
+	 *	u64				ino;
+	 *	u64				ino_generation;
+	 *	char				filename[];
+	 * 	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_MMAP2			= 10,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -685,4 +758,28 @@ union perf_mem_data_src {
 #define PERF_MEM_S(a, s) \
 	(((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
 
+/*
+ * single taken branch record layout:
+ *
+ *      from: source instruction (may not always be a branch insn)
+ *        to: branch target
+ *   mispred: branch target was mispredicted
+ * predicted: branch target was predicted
+ *
+ * support for mispred, predicted is optional. In case it
+ * is not supported mispred = predicted = 0.
+ *
+ *     in_tx: running in a hardware transaction
+ *     abort: aborting a hardware transaction
+ */
+struct perf_branch_entry {
+	__u64	from;
+	__u64	to;
+	__u64	mispred:1,  /* target mispredicted */
+		predicted:1,/* target predicted */
+		in_tx:1,    /* in transaction */
+		abort:1,    /* transaction abort */
+		reserved:60;
+};
+
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 05046f2..dfcec77 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -681,7 +681,7 @@ static long long random_event_config(__u32 *event_type,
 		}
 		break;
 	case PERF_TYPE_SOFTWARE:
-		switch (rand() % 10) {
+		switch (rand() % 11) {
 		case 0:
 			config = PERF_COUNT_SW_CPU_CLOCK;
 			break;
@@ -710,6 +710,9 @@ static long long random_event_config(__u32 *event_type,
 			config = PERF_COUNT_SW_EMULATION_FAULTS;
 			break;
 		case 9:
+			config = PERF_COUNT_SW_DUMMY;
+			break;
+		case 10:
 			config = rand64();
 			break;
 		default:
@@ -845,6 +848,8 @@ static long long random_sample_type(void)
 		sample_type |= PERF_SAMPLE_WEIGHT;
 	if (rand_bool())
 		sample_type |= PERF_SAMPLE_DATA_SRC;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_IDENTIFIER;
 
 	return sample_type;
 }
