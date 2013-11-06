From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open: vary pid and cpu values more
Date: Wed, 6 Nov 2013 15:49:06 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1311061546560.27137@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


While digging through long execution traces working on the ftrace
bug I noticed we weren't really varying the "cpu" or "pid" values
very much.  This attempts to add a bit more variety.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 87a0522..2ff004e 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -6,6 +6,7 @@
 
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <sys/types.h>
 #include <dirent.h>
 #include <errno.h>
@@ -1144,10 +1145,20 @@ void sanitise_perf_event_open(int childno)
 	memset(page_rand, 0, sizeof(struct perf_event_attr));
 
 	/* cpu */
-	/* requires ROOT to select CPU if paranoid level not 0 */
+	/* requires ROOT to select specific CPU if pid==-1 (all processes) */
 	/* -1 means all CPUs */
-	//shm->a3[childno] = cpu;
-	// the default get_cpu() is good enough here
+
+	switch(rand() % 2) {
+	case 0:
+		/* Any CPU */
+		shm->a3[childno] = -1;
+		break;
+	case 1:
+		/* Default to the get_cpu() value */
+		/* set by ARG_CPU                 */
+	default:
+		break;
+	}
 
 	/* group_fd */
 	/* should usually be -1 or another perf_event fd         */
@@ -1187,18 +1198,28 @@ void sanitise_perf_event_open(int childno)
 
 	/* pid */
 	/* requires ROOT to select pid that doesn't belong to us */
-	/* pid of 0 means current process */
-	/* pid of -1 means all processes  */
 
 	if (flags & PERF_FLAG_PID_CGROUP) {
 		/* In theory in this case we should pass in */
 		/* a file descriptor from /dev/cgroup       */
 		pid = get_random_fd();
 	} else {
-		if (rand_bool()) {
+		switch(rand() % 4) {
+		case 0:	/* use current thread */
 			pid = 0;
-		} else {
+			break;
+		case 1: /* get an arbitrary pid */
 			pid = get_pid();
+			break;
+		case 2:	/* measure *all* pids.  Might require root */
+			pid = -1;
+			break;
+		case 3: /* measure our actual pid */
+			pid=getpid();
+			break;
+		default:
+			pid = 0;
+			break;
 		}
 	}
 	shm->a2[childno] = pid;
