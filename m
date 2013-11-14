From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open more likely tracepoint values
Date: Thu, 14 Nov 2013 12:35:27 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1311141230450.8746@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org


Tracepoint ids tend to be relatively small (less than 1024 or so).
This change makes it more likely to hit valid ones.

Once the fix to avoid the troublesome 0x18 (irq_work_exit)
tracepoint gets into the kernel maybe we can start stressing
things with trinity again.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>


diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 2ff004e..516172a 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -723,9 +723,20 @@ static long long random_event_config(__u32 *event_type,
 		break;
 	case PERF_TYPE_TRACEPOINT:
 		/* Actual values to use can be found under */
-		/* debugfs tracing/events// *//*/id        */
-		/* usually a small < 1024 number           */
-		config = rand64();
+		/* debugfs tracing/events/?*?/?*?/id       */
+		/* usually a small < 4096 number           */
+		switch(rand()%2) {
+		case 0:
+			/* Try a value < 4096 */
+			config = rand()&0xfff;
+			break;
+		case 1:
+			config = rand64();
+			break;
+		default:
+			config = rand64();
+			break;
+		}
 		break;
 	case PERF_TYPE_HW_CACHE:
 		config = random_cache_config();
