From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] update perf_event_open support for Linux 4.1
Date: Wed, 6 May 2015 12:50:29 -0400 (EDT)
Message-ID: <alpine.DEB.2.11.1505061246340.12262@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=5d//M7MQBk3oCV0JE1frQe5PMUT3/Yvuy6OIyfJcA8o=;
        b=JpcdWGFoD4hMh6zYugLMA/zxM4sponUhP+jWXlYuKgE7Mxs/C9CEEdLiAr+yDIDp7f
         fqLacDEpWONmQhmIQF3iCQZu0UwIwCw4bDdvr6u+Rssqfve9cfsW/U9jz5GAd26GuqXn
         ThDcUmKhkQokKiIbLPQpJBinkDY5Lrvf5YnxU=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@codemonkey.org.uk>


This patch updates trinity support for perf_event_open to the features
added in Linux 4.1-rc1.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index b331ae4..89edd64 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -151,21 +151,42 @@ enum perf_event_sample_format {
  * The branch types can be combined, however BRANCH_ANY covers all types
  * of branches and therefore it supersedes all the other types.
  */
+enum perf_branch_sample_type_shift {
+	PERF_SAMPLE_BRANCH_USER_SHIFT		= 0, /* user branches */
+	PERF_SAMPLE_BRANCH_KERNEL_SHIFT		= 1, /* kernel branches */
+	PERF_SAMPLE_BRANCH_HV_SHIFT		= 2, /* hypervisor branches */
+
+	PERF_SAMPLE_BRANCH_ANY_SHIFT		= 3, /* any branch types */
+	PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT	= 4, /* any call branch */
+	PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT	= 5, /* any return branch */
+	PERF_SAMPLE_BRANCH_IND_CALL_SHIFT	= 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT	= 7, /* transaction aborts */
+	PERF_SAMPLE_BRANCH_IN_TX_SHIFT		= 8, /* in transaction */
+	PERF_SAMPLE_BRANCH_NO_TX_SHIFT		= 9, /* not in transaction */
+	PERF_SAMPLE_BRANCH_COND_SHIFT		= 10, /* conditional branches */
+
+	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT	= 11, /* call/ret stack */
+
+	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
+};
+
 enum perf_branch_sample_type {
-	PERF_SAMPLE_BRANCH_USER		= 1U << 0, /* user branches */
-	PERF_SAMPLE_BRANCH_KERNEL	= 1U << 1, /* kernel branches */
-	PERF_SAMPLE_BRANCH_HV		= 1U << 2, /* hypervisor branches */
-
-	PERF_SAMPLE_BRANCH_ANY		= 1U << 3, /* any branch types */
-	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
-	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
-	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
-	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
-	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
-	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
-	PERF_SAMPLE_BRANCH_COND		= 1U << 10, /* conditional branches */
-
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 11, /* non-ABI */
+	PERF_SAMPLE_BRANCH_USER		= 1U << PERF_SAMPLE_BRANCH_USER_SHIFT,
+	PERF_SAMPLE_BRANCH_KERNEL	= 1U << PERF_SAMPLE_BRANCH_KERNEL_SHIFT,
+	PERF_SAMPLE_BRANCH_HV		= 1U << PERF_SAMPLE_BRANCH_HV_SHIFT,
+
+	PERF_SAMPLE_BRANCH_ANY		= 1U << PERF_SAMPLE_BRANCH_ANY_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << PERF_SAMPLE_BRANCH_ANY_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << PERF_SAMPLE_BRANCH_ANY_RETURN_SHIFT,
+	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << PERF_SAMPLE_BRANCH_IND_CALL_SHIFT,
+	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << PERF_SAMPLE_BRANCH_ABORT_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_IN_TX	= 1U << PERF_SAMPLE_BRANCH_IN_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_NO_TX	= 1U << PERF_SAMPLE_BRANCH_NO_TX_SHIFT,
+	PERF_SAMPLE_BRANCH_COND		= 1U << PERF_SAMPLE_BRANCH_COND_SHIFT,
+
+	PERF_SAMPLE_BRANCH_CALL_STACK	= 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
+
+	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
@@ -239,6 +260,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
 #define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */
+#define PERF_ATTR_SIZE_VER5	112	/* add: aux_watermark */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -304,7 +326,8 @@ struct perf_event_attr {
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
 				comm_exec      :  1, /* flag comm events that are due to an exec */
-				__reserved_1   : 39;
+				use_clockid    :  1, /* use @clockid for time fields */
+				__reserved_1   : 38;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -333,8 +356,7 @@ struct perf_event_attr {
 	 */
 	__u32	sample_stack_user;
 
-	/* Align to u64. */
-	__u32	__reserved_2;
+	__s32	clockid;
 	/*
 	 * Defines set of regs to dump for each sample
 	 * state captured on:
@@ -344,6 +366,12 @@ struct perf_event_attr {
 	 * See asm/perf_regs.h for details.
 	 */
 	__u64	sample_regs_intr;
+
+	/*
+	 * Wakeup watermark for AUX area
+	 */
+	__u32	aux_watermark;
+	__u32	__reserved_2;	/* align to __u64 */
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -359,6 +387,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 #define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
+#define PERF_EVENT_IOC_SET_BPF		_IOW('$', 8, __u32)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -499,9 +528,30 @@ struct perf_event_mmap_page {
 	 * In this case the kernel will not over-write unread data.
 	 *
 	 * See perf_output_put_handle() for the data ordering.
+	 *
+	 * data_{offset,size} indicate the location and size of the perf record
+	 * buffer within the mmapped area.
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
+	__u64	data_offset;		/* where the buffer starts */
+	__u64	data_size;		/* data buffer size */
+
+	/*
+	 * AUX area is defined by aux_{offset,size} fields that should be set
+	 * by the userspace, so that
+	 *
+	 *   aux_offset >= data_offset + data_size
+	 *
+	 * prior to mmap()ing it. Size of the mmap()ed area should be aux_size.
+	 *
+	 * Ring buffer pointers aux_{head,tail} have the same semantics as
+	 * data_{head,tail} and same ordering rules apply.
+	 */
+	__u64	aux_head;
+	__u64	aux_tail;
+	__u64	aux_offset;
+	__u64	aux_size;
 };
 
 #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
@@ -724,6 +774,31 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_MMAP2			= 10,
 
+	/*
+	 * Records that new data landed in the AUX buffer part.
+	 *
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 *
+	 * 	u64				aux_offset;
+	 * 	u64				aux_size;
+	 *	u64				flags;
+	 * 	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_AUX				= 11,
+
+	/*
+	 * Indicates that instruction trace has started
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				pid;
+	 *	u32				tid;
+	 * };
+	 */
+	PERF_RECORD_ITRACE_START		= 12,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -741,6 +816,12 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
+/**
+ * PERF_RECORD_AUX::flags bits
+ */
+#define PERF_AUX_FLAG_TRUNCATED		0x01	/* record was truncated to fit */
+#define PERF_AUX_FLAG_OVERWRITE		0x02	/* snapshot from overwrite mode */
+
 #define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
 #define PERF_FLAG_FD_OUTPUT		(1UL << 1)
 #define PERF_FLAG_PID_CGROUP		(1UL << 2) /* pid=cgroup id, per-cpu mode only */
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 7b9fa69..1518651 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -20,6 +20,7 @@
 #include "syscall.h"
 #include "trinity.h"
 #include "compat.h"
+#include <time.h>
 
 #define SYSFS "/sys/bus/event_source/devices/"
 
@@ -900,7 +901,7 @@ static int random_attr_size(void) {
 
 	int size=0;
 
-	switch(rand() % 9) {
+	switch(rand() % 10) {
 	case 0:	size = PERF_ATTR_SIZE_VER0;
 		break;
 	case 1: size = PERF_ATTR_SIZE_VER1;
@@ -911,13 +912,15 @@ static int random_attr_size(void) {
 		break;
 	case 4: size = PERF_ATTR_SIZE_VER4;
 		break;
-	case 5: size = sizeof(struct perf_event_attr);
+	case 5: size = PERF_ATTR_SIZE_VER5;
 		break;
-	case 6: size = rand32();
+	case 6: size = sizeof(struct perf_event_attr);
 		break;
-	case 7:	size = get_len();
+	case 7: size = rand32();
 		break;
-	case 8: size = 0;
+	case 8:	size = get_len();
+		break;
+	case 9: size = 0;
 		break;
 	default:
 		break;
@@ -951,6 +954,8 @@ static long long random_branch_sample_type(void)
 		branch_sample |= PERF_SAMPLE_BRANCH_IND_CALL;
 	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_COND;
+	if (RAND_BOOL())
+		branch_sample |= PERF_SAMPLE_BRANCH_CALL_STACK;
 
 	/* Transactional Memory Types */
 	if (RAND_BOOL())
@@ -1006,6 +1011,7 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 	attr->exclude_callchain_user = RAND_BOOL();
 	attr->mmap2 = RAND_BOOL();
 	attr->comm_exec = RAND_BOOL();
+	attr->use_clockid = RAND_BOOL();
 
 	/* wakeup events not relevant */
 
@@ -1069,6 +1075,7 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 	attr->exclude_callchain_user = RAND_BOOL();
 	attr->mmap2 = RAND_BOOL();
 	attr->comm_exec = RAND_BOOL();
+	attr->use_clockid = RAND_BOOL();
 
 	attr->wakeup_events = rand32();
 
@@ -1100,6 +1107,24 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 	/* if we pick too large of a value the kernel in theory truncates */
 	attr->sample_stack_user = rand32();
 
+	if (attr->use_clockid) {
+		switch(rand()%6) {
+			case 0:	attr->clockid = CLOCK_MONOTONIC;
+				break;
+			case 1: attr->clockid = CLOCK_MONOTONIC_RAW;
+				break;
+			case 2: attr->clockid = CLOCK_REALTIME;
+				break;
+			case 3: attr->clockid = CLOCK_BOOTTIME;
+				break;
+			/* Most possible values < 32 */
+			case 4: attr->clockid = RAND_BYTE();
+				break;
+			case 5:	attr->clockid = rand();
+				break;
+		}
+	}
+
 }
 
 
