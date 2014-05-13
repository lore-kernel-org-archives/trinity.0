From: Vince Weaver <vincent.weaver@maine.edu>
Subject: exporting pmu data from perf_event_open.c
Date: Tue, 13 May 2014 14:51:35 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1405131441100.24957@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-type;
        bh=+YEGQqTv6PSanI3muwj/z4ucNa8LLmbA46on53FP8VQ=;
        b=Hc4hMyIz5FA4emdrgzUI1d5X208dAXx1ZZy1tuAYxGbLmHY25piUzIx35W3M5qTVxk
         5DaFwZqntKiLX63sM7zaRJgsl9U7qJRonfFMxTglmPYzoCwsN/mxQ/rLitmqzlQ2bMEl
         Ojd24+ciJRx5tFf+yxFm8uwdcf1aR0GoJN2EA=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


I just finished syncing perf_fuzzer against the Trinity 1.4 codebase.

It was a bit of a pain, but I guess still worth doing in order to
keep perf_event_open.c shared.

I was wondering if you'd consider a patch like the following.
It exports the perf_event_open() pmus structure, that way perf_fuzzer can 
pretty-print the pmu names.  It would save a lot of code duplication.

I could always just make this change in my local tree, but it's nice
having perf_event_open.c the same in both projects.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index c4ccafd..3783382 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -44,9 +44,9 @@ struct pmu_type {
 	struct generic_event_type *generic_events;
 };
 
-static int num_pmus=0;
-
-static struct pmu_type *pmus=NULL;
+/* Not static so other tools can access the PMU data */
+int num_pmus=0;
+struct pmu_type *pmus=NULL;
 
 
 #define FIELD_UNKNOWN	0
