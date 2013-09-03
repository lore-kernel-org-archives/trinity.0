From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] update perf_event_open() for Linux 3.11 release
Date: Tue, 3 Sep 2013 15:08:00 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1309031504490.31406@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


Update the perf_event_open syscall support for new ABIs added
in the 3.11 release.

Thankfully this is pretty minor.  Lots of big changes to the ABI
seem to be afoot for 3.12 though.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/perf_event.h b/include/perf_event.h
index fb104e5..0b1df41 100644
--- a/include/perf_event.h
+++ b/include/perf_event.h
@@ -157,8 +157,11 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
 	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
 	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_ABORT_TX	= 1U << 7, /* transaction aborts */
+	PERF_SAMPLE_BRANCH_IN_TX	= 1U << 8, /* in transaction */
+	PERF_SAMPLE_BRANCH_NO_TX	= 1U << 9, /* not in transaction */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 7, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 10, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 7e6daef..05046f2 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -921,6 +921,14 @@ static long long random_branch_sample_type(void)
 	if (rand_bool())
 		branch_sample |= PERF_SAMPLE_BRANCH_IND_CALL;
 
+	/* Transactional Memory Types */
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_ABORT_TX;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_IN_TX;
+	if (rand_bool())
+		branch_sample |= PERF_SAMPLE_BRANCH_NO_TX;
+
 	return branch_sample;
 }
 
