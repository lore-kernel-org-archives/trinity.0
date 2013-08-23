From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open() branch sample support
Date: Fri, 23 Aug 2013 13:56:51 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1308231351500.1889@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


I'm resending this; I sent it before on July 8th but it probably got lost 
in the shuffle.

The following patch exercises some of the recent additions to the 
perf_event_open() syscall.

The PERF_SAMPLE_WEIGHT and PERF_SAMPLE_DATA_SRC sample types were 
added in Linux 3.10.

It also adds more complete support for PERF_SAMPLE_REGS_USER which was 
added in Linux 3.7

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 1f1bdbb..7499a3c 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -841,6 +841,10 @@ static long long random_sample_type(void)
 		sample_type |= PERF_SAMPLE_REGS_USER;
 	if (rand_bool())
 		sample_type |= PERF_SAMPLE_STACK_USER;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_WEIGHT;
+	if (rand_bool())
+		sample_type |= PERF_SAMPLE_DATA_SRC;
 
 	return sample_type;
 }
@@ -893,6 +897,34 @@ static int random_attr_size(void) {
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
@@ -944,6 +976,11 @@ static void create_mostly_valid_counting_event(struct perf_event_attr *attr,
 		/* leave config2 alone for now */
 	}
 
+	/* branch_sample_type not relevant if not sampling */
+
+	/* sample_regs_user not relevant if not sampling */
+
+	/* sample_stack_user not relevant if not sampling */
 }
 
 static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
@@ -1000,6 +1037,26 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
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
