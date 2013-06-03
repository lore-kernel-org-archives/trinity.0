From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Read pid_max from /proc
Date: Mon,  3 Jun 2013 11:07:13 +1000
Message-ID: <1370221633-7143-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

I was hitting this on my system, where it's 65536. So fix the todo and
read it from /proc.

I left a fallback to the hardcoded values in case /proc is not mounted
or something else goes wrong.
---
 include/pids.h |    1 +
 pids.c         |   41 ++++++++++++++++++++++++++++++++++++-----
 trinity.c      |    2 ++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/pids.h b/include/pids.h
index 6a19630..b93ec4c 100644
--- a/include/pids.h
+++ b/include/pids.h
@@ -14,6 +14,7 @@ int find_pid_slot(pid_t mypid);
 bool pidmap_empty(void);
 void dump_pid_slots(void);
 int pid_is_valid(pid_t);
+void pids_init(void);
 
 #define pid_alive(_pid) kill(_pid, 0)
 
diff --git a/pids.c b/pids.c
index 7b8a73b..cfdd5d8 100644
--- a/pids.c
+++ b/pids.c
@@ -36,17 +36,48 @@ void dump_pid_slots(void)
 		printf("## slot%d: %d\n", i, shm->pids[i]);
 }
 
-int pid_is_valid(pid_t pid)
+static pid_t pidmax;
+
+int read_pid_max(void)
 {
-	pid_t pidmax;
+	unsigned long result;
+	char *end, buf[32];
+	FILE *fp;
+
+	fp = fopen("/proc/sys/kernel/pid_max", "r");
+	if (!fp) {
+		perror("fopen");
+		return -1;
+	}
+
+	if (!fgets(buf, sizeof(buf), fp))
+		return -1;
+
+	result = strtoul(buf, &end, 10);
+	if (end == buf)
+		return -1;
+
+	pidmax = result;
+
+	return 0;
+}
 
-// FIXME: Read this from /proc/sys/kernel/pid_max on startup
+void pids_init(void)
+{
+	if (read_pid_max()) {
 #ifdef __x86_64__
-	pidmax = 4194304;
+		pidmax = 4194304;
 #else
-	pidmax = 32768;
+		pidmax = 32768;
 #endif
+		printf("Couldn't read pid_max from proc\n");
+	}
 
+	printf("Using pid_max = %d\n", pidmax);
+}
+
+int pid_is_valid(pid_t pid)
+{
 	if ((pid > pidmax) || (pid < 1)) {
 		output(0, "Sanity check failed! Found pid %d!\n", pid);
 		return FALSE;
diff --git a/trinity.c b/trinity.c
index b95d287..0b88150 100644
--- a/trinity.c
+++ b/trinity.c
@@ -212,6 +212,8 @@ int main(int argc, char* argv[])
 
 	parse_devices();
 
+	pids_init();
+
 	setup_main_signals();
 
 	if (check_tainted() != 0) {
-- 
1.7.10.4
