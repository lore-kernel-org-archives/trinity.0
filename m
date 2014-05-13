From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] make perf_event_open() create system-wide events
Date: Tue, 13 May 2014 14:45:28 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1405131444280.24957@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405131434170.24957@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=DsRk1wrdM0kKgT+CJUIW8Fg3YemaFj31iFnozmq6RGQ=;
        b=iSg9ndFHZmdCbLLY5S2eGoUhn88D7rS+pyXripiJfnZFWJC6MOUYTOVxEak21Plm8n
         O9y3u4tb15acuNv7z/BSQ0uLLVEevd3PxuMTkdil35bCVSF6btpTXAlhxd+H2ywjqnlN
         wDmjU4TEReU6M1UykjkdFT7bWGyoyCMePYkZc=
In-Reply-To: <alpine.DEB.2.10.1405131434170.24957@vincent-weaver-1.umelst.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org


Sorry, just realized I sent the patch that was against perf_fuzzer and not 
against the trinity tree.  Here's an updated patch.

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

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index c4ccafd..7c20350 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -1089,6 +1089,36 @@ static void create_mostly_valid_sampling_event(struct perf_event_attr *attr,
 
 }
 
+
+/* Creates a global event: one that is not per-process, but system-wide	*/
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
