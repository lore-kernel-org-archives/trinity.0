From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open: update to features in 4.8-rc2
Date: Wed, 17 Aug 2016 20:23:49 -0400 (EDT)
Message-ID: <alpine.DEB.2.20.1608172022170.8191@macbook-air>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:message-id:user-agent:mime-version;
        bh=KESWYVpP/YDzXvnvO+pN95MPKeZhaSsqnulgoIaU6nI=;
        b=AHBKAfk5jIDhmtVItoydt1XfncyUZT1PS83KN5PFuGm+kdeVAfb7UhyPwYU99MSz2r
         6M5wyzSlMjmNW5SCY8nr8n5oEaIP6BdnXheJrlqgg3nrivKaEBe2dWe0wJeqOt9LbltQ
         yWsFeqhL86qxXGKdHxG163jU2MFuRisydzf2o=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@codemonkey.org.uk>


This patch adds in the new ABI features found in 4.7 and 4.8-rc

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>


diff --git a/include/perf_event.h b/include/perf_event.h
index 356f3be..cb0796f 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -170,6 +170,9 @@ enum perf_branch_sample_type_shift {
 	PERF_SAMPLE_BRANCH_IND_JUMP_SHIFT	= 12, /* indirect jumps */
 	PERF_SAMPLE_BRANCH_CALL_SHIFT		= 13, /* direct call */
 
+	PERF_SAMPLE_BRANCH_NO_FLAGS_SHIFT	= 14, /* no flags */
+	PERF_SAMPLE_BRANCH_NO_CYCLES_SHIFT	= 15, /* no cycles */
+
 	PERF_SAMPLE_BRANCH_MAX_SHIFT		/* non-ABI */
 };
 
@@ -191,6 +194,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_IND_JUMP	= 1U << PERF_SAMPLE_BRANCH_IND_JUMP_SHIFT,
 	PERF_SAMPLE_BRANCH_CALL		= 1U << PERF_SAMPLE_BRANCH_CALL_SHIFT,
 
+	PERF_SAMPLE_BRANCH_NO_FLAGS	= 1U << PERF_SAMPLE_BRANCH_NO_FLAGS_SHIFT,
+	PERF_SAMPLE_BRANCH_NO_CYCLES	= 1U << PERF_SAMPLE_BRANCH_NO_CYCLES_SHIFT,
+
 	PERF_SAMPLE_BRANCH_MAX		= 1U << PERF_SAMPLE_BRANCH_MAX_SHIFT,
 };
 
@@ -269,6 +275,9 @@ enum perf_event_read_format {
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
+ *
+ * @sample_max_stack: Max number of frame pointers in a callchain,
+ *		      should be < /proc/sys/kernel/perf_event_max_stack
  */
 struct perf_event_attr {
 
@@ -333,7 +342,8 @@ struct perf_event_attr {
 				comm_exec      :  1, /* flag comm events that are due to an exec */
 				use_clockid    :  1, /* use @clockid for time fields */
 				context_switch :  1, /* context switch data */
-				__reserved_1   : 37;
+				write_backward :  1, /* Write ring buffer from end to beginning */
+				__reserved_1   : 36;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -377,7 +387,8 @@ struct perf_event_attr {
 	 * Wakeup watermark for AUX area
 	 */
 	__u32	aux_watermark;
-	__u32	__reserved_2;	/* align to __u64 */
+	__u16	sample_max_stack;
+	__u16	__reserved_2;	/* align to __u64 */
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -394,6 +405,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 #define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
 #define PERF_EVENT_IOC_SET_BPF		_IOW('$', 8, __u32)
+#define PERF_EVENT_IOC_PAUSE_OUTPUT	_IOW('$', 9, __u32)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -853,6 +865,7 @@ enum perf_event_type {
 };
 
 #define PERF_MAX_STACK_DEPTH		127
+#define PERF_MAX_CONTEXTS_PER_STACK	  8
 
 enum perf_callchain_context {
 	PERF_CONTEXT_HV			= (__u64)-32,
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index dd434bb..3b28cae 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -1020,6 +1020,7 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 	attr->comm_exec = RAND_BOOL();
 	attr->use_clockid = RAND_BOOL();
 	attr->context_switch = RAND_BOOL();
+	attr->write_backward = RAND_BOOL();
 
 	/* wakeup events not relevant */
 
@@ -1036,6 +1037,10 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 	/* sample_regs_user not relevant if not sampling */
 
 	/* sample_stack_user not relevant if not sampling */
+
+	/* aux_watermark not relevant if not sampling */
+
+	/* sample_max_stack not relevant if not sampling */
 }
 
 static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
@@ -1085,6 +1090,7 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 	attr->comm_exec = RAND_BOOL();
 	attr->use_clockid = RAND_BOOL();
 	attr->context_switch = RAND_BOOL();
+	attr->write_backward = RAND_BOOL();
 
 	attr->wakeup_events = rand32();
 
@@ -1134,6 +1140,8 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 		}
 	}
 
+	attr->aux_watermark = rand32();
+	attr->sample_max_stack = rand32();
 }
 
 
