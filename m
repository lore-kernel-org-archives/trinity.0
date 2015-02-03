From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] update perf_event_open() for Linux 3.19
Date: Tue, 3 Feb 2015 12:01:23 -0500 (EST)
Message-ID: <alpine.DEB.2.11.1502031159070.30766@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:subject:message-id:user-agent:mime-version
         :content-type;
        bh=U6EcN0Whd2rtRIopq/Nnjo8CzpLVechuFzSpZLGm8T0=;
        b=eQnBUPDgzmKI24sTGeMkP1fqRJdJzd9K0XQ13Ews1uxzr9zunwvVzffB8UvULn6gok
         R8LNwZhkFnxxTFaY1c4ZWzoJ6Jio/+kbinPYF5Jol2yxu6FZJnVnWv6OJog8riFRrxPY
         Lb5PyAgqiZvQ6GIVQmRaPCeJufHPOCqzqG9Q8=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


This updates the perf_event_open support to match changes made with the 
upcoming 3.19 release.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index 51cd111..b331ae4 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -136,8 +136,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_REGS_INTR			= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -237,6 +238,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -333,6 +335,15 @@ struct perf_event_attr {
 
 	/* Align to u64. */
 	__u32	__reserved_2;
+	/*
+	 * Defines set of regs to dump for each sample
+	 * state captured on:
+	 *  - precise = 0: PMU interrupt
+	 *  - precise > 0: sampled instruction
+	 *
+	 * See asm/perf_regs.h for details.
+	 */
+	__u64	sample_regs_intr;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -363,7 +374,7 @@ struct perf_event_mmap_page {
 	/*
 	 * Bits needed to read the hw events in user-space.
 	 *
-	 *   u32 seq, time_mult, time_shift, idx, width;
+	 *   u32 seq, time_mult, time_shift, index, width;
 	 *   u64 count, enabled, running;
 	 *   u64 cyc, time_offset;
 	 *   s64 pmc = 0;
@@ -382,11 +393,11 @@ struct perf_event_mmap_page {
 	 *       time_shift  = pc->time_shift;
 	 *     }
 	 *
-	 *     idx = pc->index;
+	 *     index = pc->index;
 	 *     count = pc->offset;
-	 *     if (pc->cap_usr_rdpmc && idx) {
+	 *     if (pc->cap_user_rdpmc && index) {
 	 *       width = pc->pmc_width;
-	 *       pmc = rdpmc(idx - 1);
+	 *       pmc = rdpmc(index - 1);
 	 *     }
 	 *
 	 *     barrier();
@@ -414,7 +425,7 @@ struct perf_event_mmap_page {
 	};
 
 	/*
-	 * If cap_usr_rdpmc this field provides the bit-width of the value
+	 * If cap_user_rdpmc this field provides the bit-width of the value
 	 * read using the rdpmc() or equivalent instruction. This can be used
 	 * to sign extend the result like:
 	 *
@@ -438,10 +449,10 @@ struct perf_event_mmap_page {
 	 *
 	 * Where time_offset,time_mult,time_shift and cyc are read in the
 	 * seqcount loop described above. This delta can then be added to
-	 * enabled and possible running (if idx), improving the scaling:
+	 * enabled and possible running (if index), improving the scaling:
 	 *
 	 *   enabled += delta;
-	 *   if (idx)
+	 *   if (index)
 	 *     running += delta;
 	 *
 	 *   quot = count / running;
@@ -685,6 +696,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			abi; # enum perf_sample_regs_abi
+	 *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 12bc04a..7f68375 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -870,6 +870,8 @@ static long long random_sample_type(void)
 		sample_type |= PERF_SAMPLE_IDENTIFIER;
 	if (rand_bool())
 		sample_type |= PERF_SAMPLE_TRANSACTION;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_REGS_INTR;
 
 	return sample_type;
 }
@@ -898,7 +900,7 @@ static int random_attr_size(void) {
 
 	int size=0;
 
-	switch(rand() % 8) {
+	switch(rand() % 9) {
 	case 0:	size = PERF_ATTR_SIZE_VER0;
 		break;
 	case 1: size = PERF_ATTR_SIZE_VER1;
@@ -907,13 +909,15 @@ static int random_attr_size(void) {
 		break;
 	case 3: size = PERF_ATTR_SIZE_VER3;
 		break;
-	case 4: size = sizeof(struct perf_event_attr);
+	case 4: size = PERF_ATTR_SIZE_VER4;
+		break;
+	case 5: size = sizeof(struct perf_event_attr);
 		break;
-	case 5: size = rand32();
+	case 6: size = rand32();
 		break;
-	case 6:	size = get_len();
+	case 7:	size = get_len();
 		break;
-	case 7: size = 0;
+	case 8: size = 0;
 		break;
 	default:
 		break;
