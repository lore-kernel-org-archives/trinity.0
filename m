From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/3] use config.h in USE_* users
Date: Sat, 8 Jun 2013 22:38:55 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306082236440.10999@vincent-weaver-1.um.maine.edu>
References: <1370339304-26492-1-git-send-email-jslaby@suse.cz> <51ADB877.9050705@suse.cz> <alpine.DEB.2.10.1306051509060.7184@vincent-weaver-1.um.maine.edu> <20130605191857.GB24567@redhat.com> <alpine.DEB.2.10.1306061210120.23627@vincent-weaver-1.um.maine.edu>
 <20130606161742.GA13108@redhat.com> <alpine.DEB.2.10.1306081147550.9249@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1306081147550.9249@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Jiri Slaby <jslaby@suse.cz>, trinity@vger.kernel.org


and after all that, I forgot the part of the patch that removes the now 
unnecessary parts of compat.h 

This is on top of the previous patch.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/compat.h b/include/compat.h
index bb2fae4..75af388 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -42,39 +42,6 @@
 #define F_GETOWN_EX 16
 #endif
 
-
-/* linux/perf_event.h */
-#ifndef PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
-#define PERF_COUNT_HW_STALLED_CYCLES_FRONTEND 7
-#endif
-#ifndef PERF_COUNT_HW_STALLED_CYCLES_BACKEND
-#define PERF_COUNT_HW_STALLED_CYCLES_BACKEND 8
-#endif
-#ifndef PERF_COUNT_HW_REF_CPU_CYCLES
-#define PERF_COUNT_HW_REF_CPU_CYCLES 9
-#endif
-
-#ifndef PERF_COUNT_SW_ALIGNMENT_FAULTS
-#define PERF_COUNT_SW_ALIGNMENT_FAULTS 7
-#endif
-#ifndef PERF_COUNT_SW_EMULATION_FAULTS
-#define PERF_COUNT_SW_EMULATION_FAULTS 8
-#endif
-
-#ifndef PERF_TYPE_BREAKPOINT
-#define PERF_TYPE_BREAKPOINT 5
-#endif
-
-#ifndef PERF_FLAG_FD_NO_GROUP
-#define PERF_FLAG_FD_NO_GROUP   (1U << 0)
-#endif
-#ifndef PERF_FLAG_FD_OUTPUT
-#define PERF_FLAG_FD_OUTPUT     (1U << 1)
-#endif
-#ifndef PERF_FLAG_PID_CGROUP
-#define PERF_FLAG_PID_CGROUP    (1U << 2) /* pid=cgroup id, per-cpu mode only */
-#endif
-
 /* linux/hw_breakpoint.h */
 enum {
         HW_BREAKPOINT_LEN_1 = 1,
