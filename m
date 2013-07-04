From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 4/6] perf_event_open.c: close dir's on exit paths
Date: Thu,  4 Jul 2013 22:55:42 +0300
Message-ID: <1372967744-29353-5-git-send-email-mikko.rapeli@iki.fi>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Don't leaky fd's so much. Fixes Coverity CID's 1042345, 1042346 and 1042347.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 syscalls/perf_event_open.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index ba5c872..edc64eb 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -304,6 +304,8 @@ static int init_pmus(void) {
 							sizeof(struct format_type));
 			if (pmus[pmu_num].formats==NULL) {
 				pmus[pmu_num].num_formats=0;
+				closedir(dir);
+				closedir(format_dir);
 				return -1;
 			}
 
@@ -368,6 +370,8 @@ static int init_pmus(void) {
 				sizeof(struct generic_event_type));
 			if (pmus[pmu_num].generic_events==NULL) {
 				pmus[pmu_num].num_generic_events=0;
+				closedir(dir);
+				closedir(event_dir);
 				return -1;
 			}
 
-- 
1.8.3.1
