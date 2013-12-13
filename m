From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open update to 3.13-rc3
Date: Fri, 13 Dec 2013 15:40:43 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1312131537010.9957@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


Update perf_event_open support to Linux 3.13-rc3

This mostly just enables Haswell PERF_SAMPLE_TRANSACTION
support.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index 40a1fb8..e1802d6 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -136,8 +136,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
+	PERF_SAMPLE_TRANSACTION			= 1U << 17,
 
-	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
 };
 
 /*
@@ -181,6 +182,28 @@ enum perf_sample_regs_abi {
 };
 
 /*
+ * Values for the memory transaction event qualifier, mostly for
+ * abort events. Multiple bits can be set.
+ */
+enum {
+	PERF_TXN_ELISION        = (1 << 0), /* From elision */
+	PERF_TXN_TRANSACTION    = (1 << 1), /* From transaction */
+	PERF_TXN_SYNC           = (1 << 2), /* Instruction is related */
+	PERF_TXN_ASYNC          = (1 << 3), /* Instruction not related */
+	PERF_TXN_RETRY          = (1 << 4), /* Retry possible */
+	PERF_TXN_CONFLICT       = (1 << 5), /* Conflict abort */
+	PERF_TXN_CAPACITY_WRITE = (1 << 6), /* Capacity write abort */
+	PERF_TXN_CAPACITY_READ  = (1 << 7), /* Capacity read abort */
+
+	PERF_TXN_MAX	        = (1 << 8), /* non-ABI */
+
+	/* bits 32..63 are reserved for the abort code */
+
+	PERF_TXN_ABORT_MASK  = (0xffffffffULL << 32),
+	PERF_TXN_ABORT_SHIFT = 32,
+};
+
+/*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
  *
@@ -380,10 +403,13 @@ struct perf_event_mmap_page {
 	union {
 		__u64	capabilities;
 		struct {
-			__u64	cap_usr_time		: 1,
-				cap_usr_rdpmc		: 1,
-				cap_usr_time_zero	: 1,
-				cap_____res		: 61;
+			__u64	cap_bit0		: 1, /* Always 0, deprecated, see commit 860f085b74e9 */
+				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
+
+				cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
+				cap_user_time		: 1, /* The time_* fields are used */
+				cap_user_time_zero	: 1, /* The time_zero field is used */
+				cap_____res		: 59;
 		};
 	};
 
@@ -442,23 +468,26 @@ struct perf_event_mmap_page {
 	 *               ((rem * time_mult) >> time_shift);
 	 */
 	__u64	time_zero;
+	__u32	size;			/* Header size up to __reserved[] fields. */
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[119];	/* align to 1k */
+	__u8	__reserved[118*8+4];	/* align to 1k. */
 
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading the @data_head value should issue an rmb(), on
-	 * SMP capable platforms, after reading this value -- see
-	 * perf_event_wakeup().
+	 * User-space reading the @data_head value should issue an smp_rmb(),
+	 * after reading this value.
 	 *
 	 * When the mapping is PROT_WRITE the @data_tail value should be
-	 * written by userspace to reflect the last read data. In this case
-	 * the kernel will not over-write unread data.
+	 * written by userspace to reflect the last read data, after issueing
+	 * an smp_mb() to separate the data read from the ->data_tail store.
+	 * In this case the kernel will not over-write unread data.
+	 *
+	 * See perf_output_put_handle() for the data ordering.
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
@@ -528,6 +557,7 @@ enum perf_event_type {
 	 *	u64				len;
 	 *	u64				pgoff;
 	 *	char				filename[];
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_MMAP			= 1,
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 516172a..f7d6187 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -863,6 +863,8 @@ static long long random_sample_type(void)
 		sample_type |= PERF_SAMPLE_DATA_SRC;
 	if (rand_bool())
 		sample_type |= PERF_SAMPLE_IDENTIFIER;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_TRANSACTION;
 
 	return sample_type;
 }
