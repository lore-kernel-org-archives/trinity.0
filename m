From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] more perf_event_open cleanups
Date: Wed, 12 Jun 2013 14:34:26 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306121428440.9450@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


This has some cleanups for the perf_event_open call
+ Makes the switch statements all have explicit case statements
  for all the cases we care about (instead of sometimes relying
  on default)
+ Uses rand32() or rand64() over rand() when appropriate
+ Adds a lot more coverage to the create_random_event() function
+ Some other fine tuning

In the end I didn't run lindent on it.  I agree the file could use it,
but I didn't want to mix indentation changes in with functionality 
changes.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 32c11cf..aebf5e4 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -479,8 +479,11 @@ static long long random_cache_config(void)
 	case 6:
 		cache_id = PERF_COUNT_HW_CACHE_NODE;
 		break;
+	case 7:
+		cache_id = rand() % 256;
+		break;
 	default:
-		cache_id = rand();
+		cache_id = 0;
 		break;
 	}
 
@@ -494,8 +497,11 @@ static long long random_cache_config(void)
 	case 2:
 		hw_cache_op_id = PERF_COUNT_HW_CACHE_OP_PREFETCH;
 		break;
+	case 3:
+		hw_cache_op_id = rand() % 256;
+		break;
 	default:
-		hw_cache_op_id = rand();
+		hw_cache_op_id = 0;
 		break;
 	}
 
@@ -506,8 +512,11 @@ static long long random_cache_config(void)
 	case 1:
 		hw_cache_op_result_id = PERF_COUNT_HW_CACHE_RESULT_MISS;
 		break;
+	case 2:
+		hw_cache_op_result_id = rand() % 256;
+		break;
 	default:
-		hw_cache_op_result_id = rand();
+		hw_cache_op_result_id = 0;
 		break;
 	}
 
@@ -517,7 +526,7 @@ static long long random_cache_config(void)
 static int random_event_type(void)
 {
 
-	int type;
+	int type=0;
 
 	switch (rand() % 8) {
 	case 0:
@@ -541,8 +550,10 @@ static int random_event_type(void)
 	case 6:
 		type = PERF_TYPE_READ_FROM_SYSFS;
 		break;
+	case 7:
+		type = rand32();
+		break;
 	default:
-		type = rand();
 		break;
 	}
 	return type;
@@ -550,7 +561,7 @@ static int random_event_type(void)
 
 static long long random_event_config(__u32 *event_type, __u64 *config1)
 {
-	unsigned long long config;
+	unsigned long long config=0;
 
 	switch (*event_type) {
 	case PERF_TYPE_HARDWARE:
@@ -585,9 +596,11 @@ static long long random_event_config(__u32 *event_type, __u64 *config1)
 		case 9:
 			config = PERF_COUNT_HW_REF_CPU_CYCLES;
 			break;
-		default:
+		case 10:
 			config = rand64();
 			break;
+		default:
+			break;
 		}
 		break;
 	case PERF_TYPE_SOFTWARE:
@@ -619,14 +632,17 @@ static long long random_event_config(__u32 *event_type, __u64 *config1)
 		case 8:
 			config = PERF_COUNT_SW_EMULATION_FAULTS;
 			break;
-		default:
+		case 9:
 			config = rand64();
 			break;
+		default:
+			break;
 		}
 		break;
 	case PERF_TYPE_TRACEPOINT:
 		/* Actual values to use can be found under */
-		/* debugfs tracing/events// *//*/id         */
+		/* debugfs tracing/events// *//*/id        */
+		/* usually a small < 1024 number           */
 		config = rand64();
 		break;
 	case PERF_TYPE_HW_CACHE:
@@ -654,6 +670,7 @@ static long long random_event_config(__u32 *event_type, __u64 *config1)
 
 	default:
 		config = rand64();
+		*config1 = rand64();
 		break;
 	}
 	return config;
@@ -678,15 +695,17 @@ static void setup_breakpoints(struct perf_event_attr *attr)
 	case 4:
 		attr->bp_type = HW_BREAKPOINT_X;
 		break;
+	case 5:
+		attr->bp_type = rand32();
+		break;
 	default:
-		attr->bp_type = rand();
 		break;
 	}
 
 	/* This might be more interesting if this were    */
 	/* a valid executable address for HW_BREAKPOINT_X */
 	/* or a valid mem location for R/W/RW             */
-	attr->bp_addr = rand();
+	attr->bp_addr = (long)get_address();
 
 	switch (rand() % 5) {
 	case 0:
@@ -701,8 +720,10 @@ static void setup_breakpoints(struct perf_event_attr *attr)
 	case 3:
 		attr->bp_len = HW_BREAKPOINT_LEN_8;
 		break;
+	case 4:
+		attr->bp_len = rand64();
+		break;
 	default:
-		attr->bp_len = rand();
 		break;
 	}
 }
@@ -713,7 +734,7 @@ static long long random_sample_type(void)
 	long long sample_type = 0;
 
 	if (rand() % 2)
-		return rand();
+		return rand64();
 
 	if (rand_bool())
 		sample_type |= PERF_SAMPLE_IP;
@@ -752,8 +773,8 @@ static long long random_read_format(void)
 
 	long long read_format = 0;
 
-	if (rand_bool())
-		return rand();
+	if (rand() % 2)
+		return rand64();
 
 	if (rand_bool())
 		read_format |= PERF_FORMAT_GROUP;
@@ -767,25 +788,53 @@ static long long random_read_format(void)
 	return read_format;
 }
 
-static void create_mostly_valid_counting_event(struct perf_event_attr *attr)
+static int random_attr_size(void) {
+
+	int size=0;
+
+	switch(rand() % 8) {
+	case 0:	size = PERF_ATTR_SIZE_VER0;
+		break;
+	case 1: size = PERF_ATTR_SIZE_VER1;
+		break;
+	case 2: size = PERF_ATTR_SIZE_VER2;
+		break;
+	case 3: size = PERF_ATTR_SIZE_VER3;
+		break;
+	case 4: size = sizeof(struct perf_event_attr);
+		break;
+	case 5: size = rand32();
+		break;
+	case 6:	size = get_len();
+		break;
+	case 7: size = 0;
+		break;
+	default:
+		break;
+	}
+
+	return size;
+}
+
+static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
+						int group_leader)
 {
 
 	attr->type = random_event_type();
+	attr->size = random_attr_size();
+	attr->config = random_event_config(&attr->type,&attr->config1);
 
-	attr->size = sizeof(struct perf_event_attr);
-	/* FIXME: can typically be 64,72,80,or 96 depending on kernel */
-	/* Other values will likely not create a valid event       */
+	/* no freq for counting event */
+	/* no sample type for counting event */
 
-	attr->config = random_event_config(&attr->type,&attr->config1);
-	if (attr->type == PERF_TYPE_BREAKPOINT) {
-		setup_breakpoints(attr);
-	}
 	attr->read_format = random_read_format();
 
-	/* Boolean parameters */
+	/* Bitfield parameters, mostly boolean */
 	attr->disabled = rand_bool();
 	attr->inherit = rand_bool();
-	attr->pinned = rand_bool();
+	if (group_leader) {
+		attr->pinned = rand_bool();
+	}
 	attr->exclusive = rand_bool();
 	attr->exclude_user = rand_bool();
 	attr->exclude_kernel = rand_bool();
@@ -793,7 +842,7 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr)
 	attr->exclude_idle = rand_bool();
 	attr->mmap = rand_bool();
 	attr->comm = rand_bool();
-	// freq not relevant
+	attr->freq = rand_bool();
 	attr->inherit_stat = rand_bool();
 	attr->enable_on_exec = rand_bool();
 	attr->task = rand_bool();
@@ -806,35 +855,40 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr)
 	attr->exclude_callchain_kernel = rand_bool();
 	attr->exclude_callchain_user = rand_bool();
 
-	attr->wakeup_events = rand();	// also wakeup_watermark
-
-	//attr->config1 = rand64();
-	//attr->config2 = rand64();
-	// only valid with certain event combinations
+	/* wakeup events not relevant */
 
-	//attr->branch_sample_type = rand64();
-	//attr->sample_regs_user = rand64();
-	//attr->saple_stack_user = rand();
+	/* breakpoint events unioned with config */
+	if (attr->type == PERF_TYPE_BREAKPOINT) {
+		setup_breakpoints(attr);
+	} else {
+		/* config1 set earlier */
+		/* leave config2 alone for now */
+	}
 
 }
 
-static void create_mostly_valid_sampling_event(struct perf_event_attr *attr)
+static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
+						int group_leader)
 {
 
 	attr->type = random_event_type();
-	attr->size = sizeof(struct perf_event_attr);
+	attr->size = random_attr_size();
 	attr->config = random_event_config(&attr->type,&attr->config1);
-	if (attr->type == PERF_TYPE_BREAKPOINT) {
-		setup_breakpoints(attr);
-	}
-	attr->sample_period = rand();	/* low values more likely to have "interesting" results */
+
+	/* low values more likely to have "interesting" results */
+	attr->sample_period = rand64();
 	attr->sample_type = random_sample_type();
 	attr->read_format = random_read_format();
 
-	/* Boolean parameters */
+	/* Bitfield parameters, mostly boolean */
 	attr->disabled = rand_bool();
 	attr->inherit = rand_bool();
-	attr->pinned = rand_bool();
+	/* only group leaders can be pinned */
+	if (group_leader) {
+		attr->pinned = rand_bool();
+	} else {
+		attr->pinned = 0;
+	}
 	attr->exclusive = rand_bool();
 	attr->exclude_user = rand_bool();
 	attr->exclude_kernel = rand_bool();
@@ -842,7 +896,7 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr)
 	attr->exclude_idle = rand_bool();
 	attr->mmap = rand_bool();
 	attr->comm = rand_bool();
-
+	attr->freq = rand_bool();
 	attr->inherit_stat = rand_bool();
 	attr->enable_on_exec = rand_bool();
 	attr->task = rand_bool();
@@ -855,42 +909,71 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr)
 	attr->exclude_callchain_kernel = rand_bool();
 	attr->exclude_callchain_user = rand_bool();
 
-	attr->wakeup_events = rand();	// also wakeup_watermark
+	attr->wakeup_events = rand32();
 
-	//attr->config1 = rand64();
-	//attr->config2 = rand64();
-	// only valid with certain event combinations
-
-	//attr->branch_sample_type = rand64();
-	//attr->sample_regs_user = rand64();
-	//attr->saple_stack_user = rand();
+	if (attr->type == PERF_TYPE_BREAKPOINT) {
+		setup_breakpoints(attr);
+	}
+	else {
+		/* breakpoint fields unioned with config fields */
+		/* config1 set earlier */
+	}
 
 }
 
+/* Creates a completely random event, unlikely to be valid */
 static void create_random_event(struct perf_event_attr *attr)
 {
 
 	attr->type = random_event_type();
-	attr->config = random_event_config(&attr->type,&attr->config1);
-	setup_breakpoints(attr);
 
-	switch (rand_bool()) {
-	case 0:
-		attr->size = sizeof(struct perf_event_attr);
-		break;
-	case 1:
-		attr->size = get_len();
-	default:
-		break;
-	}
+	attr->size = random_attr_size();
+
+	attr->config = random_event_config(&attr->type,&attr->config1);
 
+	attr->sample_period = rand64();
 	attr->sample_type = random_sample_type();
 	attr->read_format = random_read_format();
 
-	/* booleans */
+	/* bitfields */
+	attr->disabled = rand_bool();
+	attr->inherit = rand_bool();
+	attr->pinned = rand_bool();
+	attr->exclusive = rand_bool();
 	attr->exclude_user = rand_bool();
-	attr->exclude_kernel = rand_bool();	/* doesn't require root unless paranoid set to 2 */
+	attr->exclude_kernel = rand_bool();
 	attr->exclude_hv = rand_bool();
+	attr->exclude_idle = rand_bool();
+	attr->mmap = rand_bool();
+	attr->comm = rand_bool();
+	attr->freq = rand_bool();
+	attr->inherit_stat = rand_bool();
+	attr->enable_on_exec = rand_bool();
+	attr->task = rand_bool();
+	attr->watermark = rand_bool();
+	attr->precise_ip = rand() % 4;
+	attr->mmap_data = rand_bool();
+	attr->sample_id_all = rand_bool();
+	attr->exclude_host = rand_bool();
+	attr->exclude_guest = rand_bool();
+	attr->exclude_callchain_kernel = rand_bool();
+	attr->exclude_callchain_user = rand_bool();
+
+	attr->wakeup_events=rand32();
+
+	/* Breakpoints are unioned with the config values */
+	if (rand() % 2) {
+		setup_breakpoints(attr);
+	}
+	else {
+		/* config1 set earlier */
+		attr->config2 = rand64();
+	}
+
+	attr->branch_sample_type = rand64();
+	attr->sample_regs_user = rand64();
+	attr->sample_stack_user = rand32();
+
 }
 
 static void sanitise_perf_event_open(int childno)
@@ -898,7 +981,7 @@ static void sanitise_perf_event_open(int childno)
 	struct perf_event_attr *attr;
 	unsigned long flags;
 	pid_t pid;
-	int group_fd;
+	int group_leader=0;
 
 	shm->a1[childno] = (unsigned long)page_rand;
 	attr = (struct perf_event_attr *)shm->a1[childno];
@@ -916,12 +999,22 @@ static void sanitise_perf_event_open(int childno)
 	/* should usually be -1 or another perf_event fd         */
 	/* Anything but -1 unlikely to work unless the other pid */
 	/* was properly set up to be a group master              */
-	if (rand() % 2) {
-		group_fd = -1;
-	} else {
-		group_fd = get_pid();
+	switch (rand() % 3) {
+	case 0:
+		shm->a4[childno] = -1;
+		group_leader = 1;
+		break;
+	case 1:
+		/* Try to get a previous random perf_event_open() fd  */
+		/* It's unclear whether get_random_fd() would do this */
+		shm->a4[childno] = rand() % 1024;
+		break;
+	case 2:
+		/* Rely on ARG_FD */
+		break;
+	default:
+		break;
 	}
-	shm->a4[childno] = group_fd;
 
 	/* flags */
 	/* You almost never set these unless you're playing with cgroups */
@@ -957,14 +1050,16 @@ static void sanitise_perf_event_open(int childno)
 	/* set up attr structure */
 	switch (rand() % 3) {
 	case 0:
-		create_mostly_valid_counting_event(attr);
+		create_mostly_valid_counting_event(attr,group_leader);
 		break;
 	case 1:
-		create_mostly_valid_sampling_event(attr);
+		create_mostly_valid_sampling_event(attr,group_leader);
 		break;
-	default:
+	case 2:
 		create_random_event(attr);
 		break;
+	default:
+		break;
 	}
 }
 
