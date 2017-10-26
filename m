From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open: update features to 4.14-rc6
Date: Thu, 26 Oct 2017 11:18:13 -0400 (EDT)
Message-ID: <alpine.DEB.2.20.1710261111210.26934@macbook-air>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:message-id:user-agent:mime-version;
        bh=kUVYI073dpLg1x9OhBIRaf4X5uqk49AudoRizU7VLpw=;
        b=Yn12+lDnVKSXjfCdLmWl5SY3AL+KbfQdC5YMjQdUBdlUjBQ3nRCM51m6szp7ld5kZg
         rEKwP/aBx4/gB1GT8v0d27bDykRwsub4Z/SAhi7xVVx3IT9PwMkkk5Qxi8khz4Z49jtA
         H9/QYyXJSVvT5IxKD+2cSBtx58zHPRQMmTU68=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

Hello

It might be too late to hit the release, but the e-mail reminded me to 
send this.

This patch brings perf_event_open() support up to date as of 4.14-rc6.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index cb0796fb..fd57a657 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -138,8 +138,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
 	PERF_SAMPLE_REGS_INTR			= 1U << 18,
+	PERF_SAMPLE_PHYS_ADDR			= 1U << 19,
 
-	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 20,		/* non-ABI */
 };
 
 /*
@@ -173,6 +174,8 @@ enum perf_branch_sample_type_shift {
 	PERF_SAMPLE_BRANCH_NO_FLAGS_SHIFT	= 14, /* no flags */
 	PERF_SAMPLE_BRANCH_NO_CYCLES_SHIFT	= 15, /* no cycles */
 
+	PERF_SAMPLE_BRANCH_TYPE_SAVE_SHIFT	= 16, /* save branch type */
+
 	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
 };
 
@@ -197,9 +200,30 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_NO_FLAGS	= 1U << PERF_SAMPLE_BRANCH_NO_FLAGS_SHIFT,
 	PERF_SAMPLE_BRANCH_NO_CYCLES	= 1U << PERF_SAMPLE_BRANCH_NO_CYCLES_SHIFT,
 
+	PERF_SAMPLE_BRANCH_TYPE_SAVE	=
+		1U << PERF_SAMPLE_BRANCH_TYPE_SAVE_SHIFT,
+
 	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
+/*
+ * Common flow change classification
+ */
+enum {
+	PERF_BR_UNKNOWN		= 0,	/* unknown */
+	PERF_BR_COND		= 1,	/* conditional */
+	PERF_BR_UNCOND		= 2,	/* unconditional  */
+	PERF_BR_IND		= 3,	/* indirect */
+	PERF_BR_CALL		= 4,	/* function call */
+	PERF_BR_IND_CALL	= 5,	/* indirect function call */
+	PERF_BR_RET		= 6,	/* function return */
+	PERF_BR_SYSCALL		= 7,	/* syscall */
+	PERF_BR_SYSRET		= 8,	/* syscall return */
+	PERF_BR_COND_CALL	= 9,	/* conditional function call */
+	PERF_BR_COND_RET	= 10,	/* conditional function return */
+	PERF_BR_MAX,
+};
+
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
 	(PERF_SAMPLE_BRANCH_USER|\
 	 PERF_SAMPLE_BRANCH_KERNEL|\
@@ -343,7 +367,8 @@ struct perf_event_attr {
 				use_clockid    :  1, /* use @clockid for time fields */
 				context_switch :  1, /* context switch data */
 				write_backward :  1, /* Write ring buffer from end to beginning */
-				__reserved_1   : 36;
+				namespaces     :  1, /* include namespaces data */
+				__reserved_1   : 35;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -609,6 +634,23 @@ struct perf_event_header {
 	__u16	size;
 };
 
+struct perf_ns_link_info {
+	__u64	dev;
+	__u64	ino;
+};
+
+enum {
+	NET_NS_INDEX		= 0,
+	UTS_NS_INDEX		= 1,
+	IPC_NS_INDEX		= 2,
+	PID_NS_INDEX		= 3,
+	USER_NS_INDEX		= 4,
+	MNT_NS_INDEX		= 5,
+	CGROUP_NS_INDEX		= 6,
+
+	NR_NAMESPACES,		/* number of available namespaces */
+};
+
 enum perf_event_type {
 
 	/*
@@ -772,6 +814,7 @@ enum perf_event_type {
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
 	 *	{ u64			abi; # enum perf_sample_regs_abi
 	 *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
+	 *	{ u64			phys_addr;} && PERF_SAMPLE_PHYS_ADDR
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -861,6 +904,18 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_SWITCH_CPU_WIDE		= 15,
 
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				pid;
+	 *	u32				tid;
+	 *	u64				nr_namespaces;
+	 *	{ u64				dev, inode; } [nr_namespaces];
+	 *	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_NAMESPACES			= 16,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -884,12 +939,14 @@ enum perf_callchain_context {
  */
 #define PERF_AUX_FLAG_TRUNCATED		0x01	/* record was truncated to fit */
 #define PERF_AUX_FLAG_OVERWRITE		0x02	/* snapshot from overwrite mode */
+#define PERF_AUX_FLAG_PARTIAL		0x04	/* record contains gaps */
 
 #define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
 #define PERF_FLAG_FD_OUTPUT		(1UL << 1)
 #define PERF_FLAG_PID_CGROUP		(1UL << 2) /* pid=cgroup id, per-cpu mode only */
 #define PERF_FLAG_FD_CLOEXEC		(1UL << 3) /* O_CLOEXEC */
 
+#if defined(__LITTLE_ENDIAN_BITFIELD)
 union perf_mem_data_src {
 	__u64 val;
 	struct {
@@ -898,9 +955,30 @@ union perf_mem_data_src {
 			mem_snoop:5,	/* snoop mode */
 			mem_lock:2,	/* lock instr */
 			mem_dtlb:7,	/* tlb access */
-			mem_rsvd:31;
+			mem_lvl_num:4,	/* memory hierarchy level number */
+			mem_remote:1,   /* remote */
+			mem_snoopx:2,	/* snoop mode, ext */
+			mem_rsvd:24;
 	};
 };
+#elif defined(__BIG_ENDIAN_BITFIELD)
+union perf_mem_data_src {
+	__u64 val;
+	struct {
+		__u64	mem_rsvd:24,
+			mem_snoopx:2,	/* snoop mode, ext */
+			mem_remote:1,   /* remote */
+			mem_lvl_num:4,	/* memory hierarchy level number */
+			mem_dtlb:7,	/* tlb access */
+			mem_lock:2,	/* lock instr */
+			mem_snoop:5,	/* snoop mode */
+			mem_lvl:14,	/* memory hierarchy level */
+			mem_op:5;	/* type of opcode */
+	};
+};
+#else
+#error "Unknown endianness"
+#endif
 
 /* type of opcode (load/store/prefetch,code) */
 #define PERF_MEM_OP_NA		0x01 /* not available */
@@ -927,6 +1005,22 @@ union perf_mem_data_src {
 #define PERF_MEM_LVL_UNC	0x2000 /* Uncached memory */
 #define PERF_MEM_LVL_SHIFT	5
 
+#define PERF_MEM_REMOTE_REMOTE	0x01  /* Remote */
+#define PERF_MEM_REMOTE_SHIFT	37
+
+#define PERF_MEM_LVLNUM_L1	0x01 /* L1 */
+#define PERF_MEM_LVLNUM_L2	0x02 /* L2 */
+#define PERF_MEM_LVLNUM_L3	0x03 /* L3 */
+#define PERF_MEM_LVLNUM_L4	0x04 /* L4 */
+/* 5-0xa available */
+#define PERF_MEM_LVLNUM_ANY_CACHE 0x0b /* Any cache */
+#define PERF_MEM_LVLNUM_LFB	0x0c /* LFB */
+#define PERF_MEM_LVLNUM_RAM	0x0d /* RAM */
+#define PERF_MEM_LVLNUM_PMEM	0x0e /* PMEM */
+#define PERF_MEM_LVLNUM_NA	0x0f /* N/A */
+
+#define PERF_MEM_LVLNUM_SHIFT	33
+
 /* snoop mode */
 #define PERF_MEM_SNOOP_NA	0x01 /* not available */
 #define PERF_MEM_SNOOP_NONE	0x02 /* no snoop */
@@ -935,6 +1029,10 @@ union perf_mem_data_src {
 #define PERF_MEM_SNOOP_HITM	0x10 /* snoop hit modified */
 #define PERF_MEM_SNOOP_SHIFT	19
 
+#define PERF_MEM_SNOOPX_FWD	0x01 /* forward */
+/* 1 free */
+#define PERF_MEM_SNOOPX_SHIFT	37
+
 /* locked instruction */
 #define PERF_MEM_LOCK_NA	0x01 /* not available */
 #define PERF_MEM_LOCK_LOCKED	0x02 /* locked transaction */
@@ -967,6 +1065,7 @@ union perf_mem_data_src {
  *     in_tx: running in a hardware transaction
  *     abort: aborting a hardware transaction
  *    cycles: cycles from last branch (or 0 if not supported)
+ *      type: branch type
  */
 struct perf_branch_entry {
 	__u64	from;
@@ -976,5 +1075,6 @@ struct perf_branch_entry {
 		in_tx:1,    /* in transaction */
 		abort:1,    /* transaction abort */
 		cycles:16,  /* cycle count to last branch */
-		reserved:44;
+		type:4,     /* branch type */
+		reserved:40;
 };
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 6cecee88..10106b59 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -879,6 +879,8 @@ static long long random_sample_type(void)
 		sample_type |= PERF_SAMPLE_TRANSACTION;
 	if (RAND_BOOL())
 		sample_type |= PERF_SAMPLE_REGS_INTR;
+	if (RAND_BOOL())
+		sample_type |= PERF_SAMPLE_PHYS_ADDR;
 
 	return sample_type;
 }
@@ -958,6 +960,16 @@ static long long random_branch_sample_type(void)
 		branch_sample |= PERF_SAMPLE_BRANCH_ANY_RETURN;
 	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_IND_CALL;
+
+	/* Transactional Memory Types */
+	if (RAND_BOOL())
+		branch_sample |= PERF_SAMPLE_BRANCH_ABORT_TX;
+	if (RAND_BOOL())
+		branch_sample |= PERF_SAMPLE_BRANCH_IN_TX;
+	if (RAND_BOOL())
+		branch_sample |= PERF_SAMPLE_BRANCH_NO_TX;
+
+
 	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_COND;
 	if (RAND_BOOL())
@@ -966,14 +978,13 @@ static long long random_branch_sample_type(void)
 		branch_sample |= PERF_SAMPLE_BRANCH_IND_JUMP;
 	if (RAND_BOOL())
 		branch_sample |= PERF_SAMPLE_BRANCH_CALL;
-
-	/* Transactional Memory Types */
 	if (RAND_BOOL())
-		branch_sample |= PERF_SAMPLE_BRANCH_ABORT_TX;
+		branch_sample |= PERF_SAMPLE_BRANCH_NO_FLAGS;
 	if (RAND_BOOL())
-		branch_sample |= PERF_SAMPLE_BRANCH_IN_TX;
+		branch_sample |= PERF_SAMPLE_BRANCH_NO_CYCLES;
 	if (RAND_BOOL())
-		branch_sample |= PERF_SAMPLE_BRANCH_NO_TX;
+		branch_sample |= PERF_SAMPLE_BRANCH_TYPE_SAVE;
+
 
 	return branch_sample;
 }
