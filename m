From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 3/6] perf_event_open: initialize chars
Date: Thu,  4 Jul 2013 22:55:41 +0300
Message-ID: <1372967744-29353-4-git-send-email-mikko.rapeli@iki.fi>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Just in case if they get used like in Coverity CID 1042349 and 1042348.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 syscalls/perf_event_open.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 5df6bed..ba5c872 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -219,8 +219,12 @@ static int init_pmus(void) {
 
 	DIR *dir,*event_dir,*format_dir;
 	struct dirent *entry,*event_entry,*format_entry;
-	char dir_name[BUFSIZ],event_name[BUFSIZ],event_value[BUFSIZ],
-		temp_name[BUFSIZ],format_name[BUFSIZ],format_value[BUFSIZ];
+	char dir_name[BUFSIZ] = "";
+	char event_name[BUFSIZ] = "";
+	char event_value[BUFSIZ] = "";
+	char temp_name[BUFSIZ] = "";
+	char format_name[BUFSIZ] = "";
+	char format_value[BUFSIZ] = "";
 	int type,pmu_num=0,format_num=0,generic_num=0;
 	FILE *fff;
 	int result;
-- 
1.8.3.1
