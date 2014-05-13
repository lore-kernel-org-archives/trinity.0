From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] make perf_event_open() create system-wide events
Date: Tue, 13 May 2014 14:40:54 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1405131434170.24957@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-type;
        bh=uIJIMj4+o1EKjKXPo6Mb9OXk+2iJsGJQFyCb2th3LPA=;
        b=X76jGuYpOW83oiUCrSuStP++3KxsYg1Vw+Neu6d5XY303/n5R9m+tSvAiU+c8le8eG
         7AfdSxSE3wQsrbZvtx5FjPdkLLPcwOQk280zbLCFikx0hcbmfz0tVGDbE1jgrTLl0cx3
         oXed7klWbZQKdpA1sZVzGRZXL22ixQBW1H/J4=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


This patch adds a create_mostly_valid_global_event case to the
perf_event_open() code.

Without this patch it is extremely unlikely that a global
(not per-process) event would be randomly created.

Most users will not notice a change, as you can only create global events
as root or else if /proc/sys/kernel/perf_event_paranoid is set to < 1
(the default is 1).

With this change some of the more obscure event types such as uncore,
northbridge, and RAPL power events are occasionally properly created.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/fuzzer/trinity_files/perf_event_open.c b/fuzzer/trinity_files/perf_event_open.c
index c4ccafd..7c20350 100644
--- a/fuzzer/trinity_files/perf_event_open.c
+++ b/fuzzer/trinity_files/perf_event_open.c
@@ -1089,6 +1089,36 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 
 }
 
+
+/* Creates a global event: one that is not per-process, but system-wide */
+/* To be valid must be created with pid=-1 and cpu being a valid CPU.   */
+/* Also usually only root can create these unless                       */
+/*    /proc/sys/kernel/perf_event_paranoid is less than 1.              */
+/* Most custom PMU types (uncore/northbridge/RAPL) are covered here.    */
+
+static void create_mostly_valid_global_event(struct perf_event_attr *attr,
+						int group_leader)
+{
+
+	attr->type = random_event_type();
+	attr->size = random_attr_size();
+	attr->config = random_event_config(&attr->type,
+					&attr->config1,
+					&attr->config2);
+
+	attr->read_format = random_read_format();
+
+	/* Bitfield parameters, mostly boolean */
+	attr->disabled = rand_bool();
+	attr->inherit = rand_bool();
+	if (group_leader) {
+		attr->pinned = rand_bool();
+	}
+
+	/* Not setting most other paramaters */
+	/* As they tend to be not valid in a global event */
+}
+
 /* Creates a completely random event, unlikely to be valid */
 static void create_random_event(struct perf_event_attr *attr)
 {
@@ -1244,7 +1274,7 @@ void sanitise_perf_event_open(int childno)
 	shm->syscall[childno].a2 = pid;
 
 	/* set up attr structure */
-	switch (rand() % 3) {
+	switch (rand() % 4) {
 	case 0:
 		create_mostly_valid_counting_event(attr,group_leader);
 		break;
@@ -1252,6 +1282,9 @@ void sanitise_perf_event_open(int childno)
 		create_mostly_valid_sampling_event(attr,group_leader);
 		break;
 	case 2:
+		create_mostly_valid_global_event(attr,group_leader);
+		break;
+	case 3:
 		create_random_event(attr);
 		break;
 	default:
