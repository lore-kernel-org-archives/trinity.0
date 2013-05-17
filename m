From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] a perf_event_open() update
Date: Fri, 17 May 2013 17:20:15 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1305171715320.15706@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1305171115180.8633@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1305171115180.8633@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


And below is an even more complex perf_event_open() update.
This applies on top of the patch from my previous e-mail.

This attempts to create mostly valid perf_event_open calls at least 2/3
of the time.

One problem: it quickly opens all available fds and then fails out with no 
more filedescriptors.  I notice that "trinity -copen" does not have this 
issue... but I can't find out how it gets around it.

I already managed to generate this warning on a debian-unstable 3.8 kernel 
sometime during my testing, but didn't notice until too late to replicate.
I should be running a more recent kernel I guess.


[11982.189962] ------------[ cut here ]------------
[11982.189970] WARNING: at /build/buildd-linux_3.8.12-1-amd64-RaG_7r/linux-3.8.12/arch/x86/kernel/hw_breakpoint.c:121 arch_install_hw_breakpoint+0xad/0xcb()
[11982.189972] Hardware name:  DE7000
[11982.189973] Can't find any breakpoint slot
[11982.190046] Pid: 6495, comm: trinity-child1 Not tainted 3.8-1-amd64 #1 Debian 3.8.12-1
[11982.190047] Call Trace:
[11982.190052]  [<ffffffff8103ce54>] ? warn_slowpath_common+0x76/0x8a
[11982.190055]  [<ffffffff8103cf00>] ? warn_slowpath_fmt+0x45/0x4a
[11982.190059]  [<ffffffff81065bc2>] ? local_clock+0x2c/0x37
[11982.190062]  [<ffffffff810133a0>] ? arch_install_hw_breakpoint+0xad/0xcb
[11982.190066]  [<ffffffff810bc22c>] ? event_sched_in+0x6a/0x11f
[11982.190069]  [<ffffffff810bc327>] ? group_sched_in+0x46/0x124
[11982.190071]  [<ffffffff810136a1>] ? paravirt_read_tsc+0x5/0x8
[11982.190074]  [<ffffffff81013b37>] ? native_sched_clock+0x27/0x2f
[11982.190076]  [<ffffffff810136a9>] ? paravirt_sched_clock+0x5/0x8
[11982.190079]  [<ffffffff81065a0d>] ? sched_clock_local+0xd/0x6f
[11982.190082]  [<ffffffff810bc52a>] ? ctx_sched_in+0x125/0x145
[11982.190085]  [<ffffffff810bcaa2>] ? __perf_install_in_context+0xcb/0xea
[11982.190087]  [<ffffffff810b93bb>] ? perf_exclude_event+0x42/0x42
[11982.190090]  [<ffffffff810b93ce>] ? remote_function+0x13/0x3b
[11982.190093]  [<ffffffff8107f391>] ? smp_call_function_single+0x8a/0x106
[11982.190096]  [<ffffffff810b8bd4>] ? task_function_call+0x42/0x4c
[11982.190098]  [<ffffffff810bc9d7>] ? perf_event_sched_in+0x69/0x69
[11982.190101]  [<ffffffff810baf1d>] ? perf_install_in_context+0x5e/0x9e
[11982.190104]  [<ffffffff810bf98e>] ? sys_perf_event_open+0x66e/0x7e6
[11982.190109]  [<ffffffff81388929>] ? system_call_fastpath+0x16/0x1b
[11982.190111] ---[ end trace 3e45a276025d4240 ]---



Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 769e137..0f6eda3 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -60,125 +60,228 @@ static long long random_cache_config(void) {
                (hw_cache_op_result_id << 16);
 }
 
-static void sanitise_perf_event_open(int childno)
-{
-	struct perf_event_attr *attr;
+static long long random_event_type(void) {
 
-	shm->a1[childno] = (unsigned long) page_rand;
-	attr = (struct perf_event_attr *) shm->a1[childno];
-
-	/* this makes sure we clear out the reserved fields. */
-	memset(page_rand, 0, sizeof(struct perf_event_attr));
+	long long type;
 
 	switch(rand() % 6) {
-		case 0:	attr->type = PERF_TYPE_HARDWARE;
+		case 0:	type = PERF_TYPE_HARDWARE;
+			break;
+		case 1: type = PERF_TYPE_SOFTWARE;
+			break;
+		case 2: type = PERF_TYPE_TRACEPOINT;
+			break;
+		case 3: type = PERF_TYPE_HW_CACHE;
+			break;
+		case 4: type = PERF_TYPE_RAW;
+			break;
+		case 5: type = PERF_TYPE_BREAKPOINT;
+			break;
+		default: type=rand();
+			break;
+	}
+	return type;
+}
+
+
+static long long random_event_config(long long event_type) {
+
+	unsigned long long config;
+
+	switch(event_type) {
+		case PERF_TYPE_HARDWARE:
 			switch(rand() % 11) {
-				case 0: attr->config=PERF_COUNT_HW_CPU_CYCLES;
+				case 0: config=PERF_COUNT_HW_CPU_CYCLES;
 					break;
-				case 1: attr->config=PERF_COUNT_HW_INSTRUCTIONS;
+				case 1: config=PERF_COUNT_HW_INSTRUCTIONS;
 					break;
-				case 2: attr->config=PERF_COUNT_HW_CACHE_REFERENCES;
+				case 2: config=PERF_COUNT_HW_CACHE_REFERENCES;
 					break;
-				case 3: attr->config=PERF_COUNT_HW_CACHE_MISSES;
+				case 3: config=PERF_COUNT_HW_CACHE_MISSES;
 					break;
-				case 4: attr->config=PERF_COUNT_HW_BRANCH_INSTRUCTIONS;
+				case 4: config=PERF_COUNT_HW_BRANCH_INSTRUCTIONS;
 					break;
-				case 5: attr->config=PERF_COUNT_HW_BRANCH_MISSES;
+				case 5: config=PERF_COUNT_HW_BRANCH_MISSES;
 					break;
-				case 6: attr->config=PERF_COUNT_HW_BUS_CYCLES;
+				case 6: config=PERF_COUNT_HW_BUS_CYCLES;
 					break;
-				case 7: attr->config=PERF_COUNT_HW_STALLED_CYCLES_FRONTEND;
+				case 7: config=PERF_COUNT_HW_STALLED_CYCLES_FRONTEND;
 					break;
-				case 8: attr->config=PERF_COUNT_HW_STALLED_CYCLES_BACKEND;
+				case 8: config=PERF_COUNT_HW_STALLED_CYCLES_BACKEND;
 					break;
-				case 9: attr->config=PERF_COUNT_HW_REF_CPU_CYCLES;
+				case 9: config=PERF_COUNT_HW_REF_CPU_CYCLES;
 					break;
-				case 10: attr->config = rand();
+				default: config = rand();
 					break;
-				default: break;
 			}
 			break;
-		case 1: attr->type = PERF_TYPE_SOFTWARE;
+		case PERF_TYPE_SOFTWARE:
 			switch(rand() % 10) {
-				case 0: attr->config=PERF_COUNT_SW_CPU_CLOCK;
+				case 0: config=PERF_COUNT_SW_CPU_CLOCK;
+					break;
+				case 1: config=PERF_COUNT_SW_TASK_CLOCK;
 					break;
-				case 1: attr->config=PERF_COUNT_SW_TASK_CLOCK;
+				case 2: config=PERF_COUNT_SW_PAGE_FAULTS;
 					break;
-				case 2: attr->config=PERF_COUNT_SW_PAGE_FAULTS;
+				case 3: config=PERF_COUNT_SW_CONTEXT_SWITCHES;
 					break;
-				case 3: attr->config=PERF_COUNT_SW_CONTEXT_SWITCHES;
+				case 4: config=PERF_COUNT_SW_CPU_MIGRATIONS;
 					break;
-				case 4: attr->config=PERF_COUNT_SW_CPU_MIGRATIONS;
+				case 5: config=PERF_COUNT_SW_PAGE_FAULTS_MIN;
 					break;
-				case 5: attr->config=PERF_COUNT_SW_PAGE_FAULTS_MIN;
+				case 6: config=PERF_COUNT_SW_PAGE_FAULTS_MAJ;
 					break;
-				case 6: attr->config=PERF_COUNT_SW_PAGE_FAULTS_MAJ;
+				case 7: config=PERF_COUNT_SW_ALIGNMENT_FAULTS;
 					break;
-				case 7: attr->config=PERF_COUNT_SW_ALIGNMENT_FAULTS;
+				case 8: config=PERF_COUNT_SW_EMULATION_FAULTS;
 					break;
-				case 8: attr->config=PERF_COUNT_SW_EMULATION_FAULTS;
+				default: config=rand();
 					break;
-				case 9: attr->config=rand();
-				default: break;
 			}
 			break;
-		case 2: attr->type = PERF_TYPE_TRACEPOINT;
+		case PERF_TYPE_TRACEPOINT:
 			/* Actual values to use can be found under */
 			/* debugfs tracing/events//*//*/id         */
-			attr->config=rand();
+			config=rand();
 			break;
-		case 3: attr->type = PERF_TYPE_HW_CACHE;
-			attr->config = random_cache_config();
+		case PERF_TYPE_HW_CACHE:
+			config = random_cache_config();
 			break;
-		case 4: attr->type = PERF_TYPE_RAW;
+		case PERF_TYPE_RAW:
 			/* can be arbitrary 64-bit value */
 			/* there are some constraints we can add */
 			/* to make it more likely to be a valid event */
-			attr->config = rand();
-
+			config = rand();
 			break;
-		case 5: attr->type = PERF_TYPE_BREAKPOINT;
+		case PERF_TYPE_BREAKPOINT:
 			/* Breakpoint type only valid if config==0 */
 			/* Set it to something else too anyway     */
-			if (rand()%2) attr->config = rand();
-			else attr->config = 0;
+			if (rand()%2) config = rand();
+			else config = 0;
+			break;
+		default: config=rand();
+			break;
+	}
+	return config;
+}
 
-			switch (rand()%6) {
-				case 0: attr->bp_type=HW_BREAKPOINT_EMPTY;
-					break;
-				case 1: attr->bp_type=HW_BREAKPOINT_R;
-					break;
-				case 2: attr->bp_type=HW_BREAKPOINT_W;
-					break;
-				case 3: attr->bp_type=HW_BREAKPOINT_RW;
-					break;
-				case 4: attr->bp_type=HW_BREAKPOINT_X;
-					break;
-				default: attr->bp_type=rand();
-					break;
-			}
+static void setup_breakpoints(struct perf_event_attr *attr) {
 
-			/* This might be more interesting if this were    */
-			/* a valid executable address for HW_BREAKPOINT_X */
-			/* or a valid mem location for R/W/RW             */
-			attr->bp_addr = rand();
+	switch (rand()%6) {
+		case 0: attr->bp_type=HW_BREAKPOINT_EMPTY;
+			break;
+		case 1: attr->bp_type=HW_BREAKPOINT_R;
+			break;
+		case 2: attr->bp_type=HW_BREAKPOINT_W;
+			break;
+		case 3: attr->bp_type=HW_BREAKPOINT_RW;
+			break;
+		case 4: attr->bp_type=HW_BREAKPOINT_X;
+			break;
+		default: attr->bp_type=rand();
+			break;
+	}
 
-			switch(rand()%5) {
-				case 0: attr->bp_len=HW_BREAKPOINT_LEN_1;
-					break;
-				case 1: attr->bp_len=HW_BREAKPOINT_LEN_2;
-					break;
-				case 2: attr->bp_len=HW_BREAKPOINT_LEN_4;
-					break;
-				case 3: attr->bp_len=HW_BREAKPOINT_LEN_8;
-					break;
-				default: attr->bp_len=rand();
-					break;
-			}
+	/* This might be more interesting if this were    */
+	/* a valid executable address for HW_BREAKPOINT_X */
+	/* or a valid mem location for R/W/RW             */
+	attr->bp_addr = rand();
 
+	switch(rand()%5) {
+		case 0: attr->bp_len=HW_BREAKPOINT_LEN_1;
+			break;
+		case 1: attr->bp_len=HW_BREAKPOINT_LEN_2;
+			break;
+		case 2: attr->bp_len=HW_BREAKPOINT_LEN_4;
+			break;
+		case 3: attr->bp_len=HW_BREAKPOINT_LEN_8;
+			break;
+		default: attr->bp_len=rand();
 			break;
-		default: break;
 	}
+}
+
+static long long random_sample_type(void) {
+
+	long long sample_type=0;
+
+	if (rand()%2) return rand();
+
+	if (rand()%2) sample_type|=PERF_SAMPLE_IP;
+	if (rand()%2) sample_type|=PERF_SAMPLE_TID;
+	if (rand()%2) sample_type|=PERF_SAMPLE_TIME;
+	if (rand()%2) sample_type|=PERF_SAMPLE_ADDR;
+	if (rand()%2) sample_type|=PERF_SAMPLE_READ;
+	if (rand()%2) sample_type|=PERF_SAMPLE_CALLCHAIN;
+	if (rand()%2) sample_type|=PERF_SAMPLE_ID;
+	if (rand()%2) sample_type|=PERF_SAMPLE_CPU;
+	if (rand()%2) sample_type|=PERF_SAMPLE_PERIOD;
+	if (rand()%2) sample_type|=PERF_SAMPLE_STREAM_ID;
+	if (rand()%2) sample_type|=PERF_SAMPLE_RAW;
+
+	return sample_type;
+}
+
+static long long random_read_format(void) {
+
+	long long read_format=0;
+
+	if (rand()%2) return rand();
+
+	if (rand()%2) read_format|=PERF_FORMAT_GROUP;
+	if (rand()%2) read_format|=PERF_FORMAT_ID;
+	if (rand()%2) read_format|=PERF_FORMAT_TOTAL_TIME_ENABLED;
+	if (rand()%2) read_format|=PERF_FORMAT_TOTAL_TIME_RUNNING;
+
+	return read_format;
+}
+
+static void create_mostly_valid_counting_event(struct perf_event_attr *attr) {
+
+	attr->type=random_event_type();
+	attr->size=sizeof(struct perf_event_attr);
+	attr->config=random_event_config(attr->type);
+	if (attr->type==PERF_TYPE_BREAKPOINT) {
+		setup_breakpoints(attr);
+	}
+	attr->read_format=random_read_format();
+
+	/* Boolean parameters */
+	attr->disabled=rand()%2;
+	attr->pinned=rand()%2;
+	attr->exclude_user=rand()%2;
+	attr->exclude_kernel=rand()%2;
+	attr->exclude_hv=rand()%2;
+
+}
+
+static void create_mostly_valid_sampling_event(struct perf_event_attr *attr) {
+
+	attr->type=random_event_type();
+	attr->size=sizeof(struct perf_event_attr);
+	attr->config=random_event_config(attr->type);
+	if (attr->type==PERF_TYPE_BREAKPOINT) {
+		setup_breakpoints(attr);
+	}
+	attr->sample_period=rand(); /* low values more likely to have "interesting" results */
+	attr->sample_type=random_sample_type();
+	attr->read_format=random_read_format();
+
+	/* booleans */
+	attr->disabled=rand()%2;
+	attr->pinned=rand()%2;
+	attr->exclude_user=rand()%2;
+	attr->exclude_kernel=rand()%2;
+	attr->exclude_hv=rand()%2;
+	attr->wakeup_events=rand()%2;
+
+}
+
+static void create_random_event(struct perf_event_attr *attr) {
+
+	attr->type=random_event_type();
+	attr->config=random_event_config(attr->type);
+	setup_breakpoints(attr);
 
 	switch(rand() % 2) {
 		case 0: attr->size = sizeof(struct perf_event_attr);
@@ -187,9 +290,52 @@ static void sanitise_perf_event_open(int childno)
 		default: break;
 	}
 
-	attr->sample_type = rand() % PERF_SAMPLE_MAX;
-	attr->read_format = rand() % PERF_FORMAT_MAX;
-	attr->exclude_kernel = TRUE;	// FIXME: root-mode
+	attr->sample_type = random_sample_type();
+	attr->read_format = random_read_format();
+
+	/* booleans */
+	attr->exclude_user=rand()%2;
+	attr->exclude_kernel = rand()%2;	/* does't require root unless paranoid set to 2 */
+	attr->exclude_hv = rand()%2;
+}
+
+static void sanitise_perf_event_open(int childno)
+{
+	struct perf_event_attr *attr;
+
+	shm->a1[childno] = (unsigned long) page_rand;
+	attr = (struct perf_event_attr *) shm->a1[childno];
+
+	/* this makes sure we clear out the reserved fields. */
+	memset(page_rand, 0, sizeof(struct perf_event_attr));
+
+	/* pid */
+	/* requires ROOT to select pid that doesn't belong to us */
+	/* pid of 0 means current process */
+	shm->a2[childno]=0;
+
+	/* cpu */
+	/* requires ROOT to select CPU if paranoid level not 0 */
+	shm->a3[childno]=-1;
+
+	/* groupfd */
+	/* should usually be -1 or another perf_event fd         */
+	/* Anything but -1 unlikely to work unless the other pid */
+	/* was properly set up to be a group master		 */
+	shm->a4[childno]=-1;
+
+	/* flags */
+	/* You almost never set these unless you're playing with cgroups */
+	shm->a5[childno]=0;
+
+	switch(rand()%3) {
+		case 0:	create_mostly_valid_counting_event(attr);
+			break;
+		case 1: create_mostly_valid_sampling_event(attr);
+			break;
+		default: create_random_event(attr);
+			break;
+	}
 }
 
 struct syscall syscall_perf_event_open = {
@@ -204,11 +350,10 @@ struct syscall syscall_perf_event_open = {
 	.arg4name = "group_fd",
 	.arg4type = ARG_FD,
 	.arg5name = "flags",
-	.arg5type = ARG_LIST,
-	.arg5list = {
-		.num = 3,
-		.values = { PERF_FLAG_FD_NO_GROUP, PERF_FLAG_FD_OUTPUT, PERF_FLAG_PID_CGROUP },
-	},
-	.sanitise = sanitise_perf_event_open,
+        .arg5list = {
+                .num = 3,
+                .values = { PERF_FLAG_FD_NO_GROUP, PERF_FLAG_FD_OUTPUT, PERF_FLAG_PID_CGROUP },
+        },
+        .sanitise = sanitise_perf_event_open,
 	.flags = NEED_ALARM,
 };
