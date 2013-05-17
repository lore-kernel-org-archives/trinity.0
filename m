From: Vince Weaver <vincent.weaver@maine.edu>
Subject: a perf_event_open() update
Date: Fri, 17 May 2013 11:18:39 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1305171115180.8633@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


Here's a patch that improves slightly the coverage in perf_event_open().

It handles cache events and breakpoint events.

perf_event_open() is such a complicated syscall it's fairly unlikely to 
generate a valid event randomly, even with these changes.

Also a question: is there a way to easily generate a 64-bit random number?
From what I can tell rand() only generates a 32-bit one?

I plan to improve this some more, based on the work I've done writing the 
perf_event_open manpage.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 0c87cf1..769e137 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -7,11 +7,59 @@
 #include <stdlib.h>
 #include <string.h>
 #include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
 #include "sanitise.h"
 #include "compat.h"
 #include "maps.h"
 #include "shm.h"
 
+static long long random_cache_config(void) {
+
+	int cache_id,hw_cache_op_id,hw_cache_op_result_id;
+
+	switch(rand()%8) {
+		case 0: cache_id=PERF_COUNT_HW_CACHE_L1D;
+			break;
+		case 1: cache_id=PERF_COUNT_HW_CACHE_L1I;
+			break;
+		case 2: cache_id=PERF_COUNT_HW_CACHE_LL;
+			break;
+		case 3: cache_id=PERF_COUNT_HW_CACHE_DTLB;
+			break;
+		case 4: cache_id=PERF_COUNT_HW_CACHE_ITLB;
+			break;
+		case 5: cache_id=PERF_COUNT_HW_CACHE_BPU;
+			break;
+		case 6: cache_id=PERF_COUNT_HW_CACHE_NODE;
+			break;
+		default: cache_id=rand();
+			break;
+	}
+
+	switch(rand()%4) {
+		case 0: hw_cache_op_id=PERF_COUNT_HW_CACHE_OP_READ;
+			break;
+		case 1: hw_cache_op_id=PERF_COUNT_HW_CACHE_OP_WRITE;
+			break;
+		case 2: hw_cache_op_id=PERF_COUNT_HW_CACHE_OP_PREFETCH;
+			break;
+		default: hw_cache_op_id=rand();
+			break;
+	}
+
+	switch(rand()%3) {
+		case 0:	hw_cache_op_result_id=PERF_COUNT_HW_CACHE_RESULT_ACCESS;
+			break;
+		case 1: hw_cache_op_result_id=PERF_COUNT_HW_CACHE_RESULT_MISS;
+			break;
+		default: hw_cache_op_result_id=rand();
+			break;
+	}
+
+	return (cache_id) | (hw_cache_op_id << 8) |
+               (hw_cache_op_result_id << 16);
+}
+
 static void sanitise_perf_event_open(int childno)
 {
 	struct perf_event_attr *attr;
@@ -24,26 +72,28 @@ static void sanitise_perf_event_open(int childno)
 
 	switch(rand() % 6) {
 		case 0:	attr->type = PERF_TYPE_HARDWARE;
-			switch(rand() % 10) {
+			switch(rand() % 11) {
 				case 0: attr->config=PERF_COUNT_HW_CPU_CYCLES;
 					break;
 				case 1: attr->config=PERF_COUNT_HW_INSTRUCTIONS;
 					break;
 				case 2: attr->config=PERF_COUNT_HW_CACHE_REFERENCES;
 					break;
-				case 3: attr->config=PERF_COUNT_HW_BRANCH_INSTRUCTIONS;
+				case 3: attr->config=PERF_COUNT_HW_CACHE_MISSES;
+					break;
+				case 4: attr->config=PERF_COUNT_HW_BRANCH_INSTRUCTIONS;
 					break;
-				case 4: attr->config=PERF_COUNT_HW_BRANCH_MISSES;
+				case 5: attr->config=PERF_COUNT_HW_BRANCH_MISSES;
 					break;
-				case 5: attr->config=PERF_COUNT_HW_BUS_CYCLES;
+				case 6: attr->config=PERF_COUNT_HW_BUS_CYCLES;
 					break;
-				case 6: attr->config=PERF_COUNT_HW_STALLED_CYCLES_FRONTEND;
+				case 7: attr->config=PERF_COUNT_HW_STALLED_CYCLES_FRONTEND;
 					break;
-				case 7: attr->config=PERF_COUNT_HW_STALLED_CYCLES_BACKEND;
+				case 8: attr->config=PERF_COUNT_HW_STALLED_CYCLES_BACKEND;
 					break;
-				case 8: attr->config=PERF_COUNT_HW_REF_CPU_CYCLES;
+				case 9: attr->config=PERF_COUNT_HW_REF_CPU_CYCLES;
 					break;
-				case 9: attr->config = rand();
+				case 10: attr->config = rand();
 					break;
 				default: break;
 			}
@@ -73,8 +123,12 @@ static void sanitise_perf_event_open(int childno)
 			}
 			break;
 		case 2: attr->type = PERF_TYPE_TRACEPOINT;
+			/* Actual values to use can be found under */
+			/* debugfs tracing/events//*//*/id         */
+			attr->config=rand();
 			break;
 		case 3: attr->type = PERF_TYPE_HW_CACHE;
+			attr->config = random_cache_config();
 			break;
 		case 4: attr->type = PERF_TYPE_RAW;
 			/* can be arbitrary 64-bit value */
@@ -84,6 +138,44 @@ static void sanitise_perf_event_open(int childno)
 
 			break;
 		case 5: attr->type = PERF_TYPE_BREAKPOINT;
+			/* Breakpoint type only valid if config==0 */
+			/* Set it to something else too anyway     */
+			if (rand()%2) attr->config = rand();
+			else attr->config = 0;
+
+			switch (rand()%6) {
+				case 0: attr->bp_type=HW_BREAKPOINT_EMPTY;
+					break;
+				case 1: attr->bp_type=HW_BREAKPOINT_R;
+					break;
+				case 2: attr->bp_type=HW_BREAKPOINT_W;
+					break;
+				case 3: attr->bp_type=HW_BREAKPOINT_RW;
+					break;
+				case 4: attr->bp_type=HW_BREAKPOINT_X;
+					break;
+				default: attr->bp_type=rand();
+					break;
+			}
+
+			/* This might be more interesting if this were    */
+			/* a valid executable address for HW_BREAKPOINT_X */
+			/* or a valid mem location for R/W/RW             */
+			attr->bp_addr = rand();
+
+			switch(rand()%5) {
+				case 0: attr->bp_len=HW_BREAKPOINT_LEN_1;
+					break;
+				case 1: attr->bp_len=HW_BREAKPOINT_LEN_2;
+					break;
+				case 2: attr->bp_len=HW_BREAKPOINT_LEN_4;
+					break;
+				case 3: attr->bp_len=HW_BREAKPOINT_LEN_8;
+					break;
+				default: attr->bp_len=rand();
+					break;
+			}
+
 			break;
 		default: break;
 	}
