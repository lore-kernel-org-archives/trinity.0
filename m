From: Vince Weaver <vincent.weaver@maine.edu>
Subject: bring perf_event_open() syscall support up to Linux 3.10
Date: Mon, 8 Jul 2013 14:01:53 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307081357350.10386@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org


The following patch implements the new features from Linux 3.10 as well
as properly sets up the new features from 3.7 that were only 
half-implemented before.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 5127231..d1d59ec 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -785,6 +785,10 @@ static long long random_sample_type(void)
 		sample_type |= PERF_SAMPLE_REGS_USER;
 	if (rand_bool())
 		sample_type |= PERF_SAMPLE_STACK_USER;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_WEIGHT;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_DATA_SRC;
 
 	return sample_type;
 }
@@ -837,6 +841,34 @@ static int random_attr_size(void) {
 	return size;
 }
 
+static long long random_branch_sample_type(void)
+{
+
+	long long branch_sample = 0;
+
+	if (rand() % 2)
+		return rand64();
+
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_USER;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_KERNEL;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_HV;
+
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_ANY;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_ANY_CALL;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_ANY_RETURN;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_IND_CALL;
+
+	return branch_sample;
+}
+
+
 static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 						int group_leader)
 {
@@ -886,6 +918,11 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 		/* leave config2 alone for now */
 	}
 
+	/* branch_sample_type not relevant if not sampling */
+
+	/* sample_regs_user not relevant if not sampling */
+
+	/* sample_stack_user not relevant if not sampling */
 }
 
 static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
@@ -940,6 +977,26 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 		/* config1 set earlier */
 	}
 
+	attr->branch_sample_type = random_branch_sample_type();
+
+	/* sample_regs_user is a bitmask of CPU registers to record.     */
+	/* The values come from arch/ARCH/include/uapi/asm/perf_regs.h   */
+	/* Most architectures have fewer than 64 registers...            */
+	switch(rand()%3) {
+		case 0:		attr->sample_regs_user = rand()%16;
+				break;
+		case 1:		attr->sample_regs_user = rand()%64;
+				break;
+		case 2:		attr->sample_regs_user = rand64();
+				break;
+		default:
+				break;
+	}
+
+	/* sample_stack_user is the size of user stack backtrace we want  */
+	/* if we pick too large of a value the kernel in theory truncates */
+	attr->sample_stack_user = rand32();
+
 }
 
 /* Creates a completely random event, unlikely to be valid */
