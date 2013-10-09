From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] add report on child iteration count after reseed
Date: Tue,  8 Oct 2013 17:24:17 -0700
Message-ID: <1381278257-20668-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=apTzAXD4vuzrsKjvnCyHHg+LDj6MxJCbVN5A9FVy3bw=;
        b=GwaoKrKmCA8ZYFVNY2ZGo603p6Enuda7bhIeQjGD/Ct+BvXluZihdD/2W26bS5lRBJ
         lXQeepGNj25XlISA8/XWeExXoF8DxeHfqlK/ysPbsRRcvKj+bAhEUjPk1jlJK9TySlzC
         sKCsSFHNHx0fcH+cze/EEGsMCDaMqkqwr9fJh5hXyOGktBhOIHGWoDqdT8NiJ7xgakRG
         blO/eQsEcXRsHhn3Bt0KbaUipp7Z3uDl+qwvPRxfeSQIkvrZF7M0DBUTgL/QZDFDUnoG
         mwaQGIuSv3dDX6DC2ErsP+BphWBjDaqYa26eARIdclYCCvQuf7CwpMpIKvsRathLDrI9
         BJ4w==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Ildar Muslukhov <ildarm@google.com>

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/shm.h |  1 +
 log.c         | 16 +++++++++++++---
 seed.c        |  4 +++-
 syscall.c     |  1 +
 watchdog.c    | 12 +++++++++++-
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/shm.h b/include/shm.h
index 0493eb0..5e7f2e8 100644
--- a/include/shm.h
+++ b/include/shm.h
@@ -16,6 +16,7 @@ struct shm_s {
 	unsigned long failures;
 	unsigned long previous_count;
 	unsigned long child_syscall_count[MAX_NR_CHILDREN];
+	unsigned long child_syscall_count_after_reseed[MAX_NR_CHILDREN];
 
 	unsigned long regenerate;
 	unsigned int seed;
diff --git a/log.c b/log.c
index 705153c..84743c5 100644
--- a/log.c
+++ b/log.c
@@ -17,6 +17,7 @@
 
 FILE *mainlogfile;
 bool logfiles_opened = FALSE;
+bool log_no_prefix = FALSE; /* Controls prefix output in output function per process */
 
 void open_logfiles(void)
 {
@@ -271,7 +272,10 @@ void output(unsigned char level, const char *fmt, ...)
 
 	/* stdout output if needed */
 	if (quiet_level > level) {
-		printf("%s %s", prefix, outputbuf);
+		if (!log_no_prefix)
+			printf("%s %s", prefix, outputbuf);
+		else
+			printf("%s", outputbuf);
 		(void)fflush(stdout);
 	}
 
@@ -301,9 +305,15 @@ void output(unsigned char level, const char *fmt, ...)
 			}
 		}
 		monobuf[j] = '\0';
-		fprintf(handle, "%s %s", prefix, monobuf);
+		if (!log_no_prefix)
+			fprintf(handle, "%s %s", prefix, monobuf);
+		else
+			fprintf(handle, "%s", monobuf);
 	} else {
-		fprintf(handle, "%s %s", prefix, outputbuf);
+		if (!log_no_prefix)
+			fprintf(handle, "%s %s", prefix, outputbuf);
+		else
+			fprintf(handle, "%s", outputbuf);
 	}
 
 	(void)fflush(handle);
diff --git a/seed.c b/seed.c
index a9c6f6a..fd8e939 100644
--- a/seed.c
+++ b/seed.c
@@ -70,8 +70,10 @@ unsigned int init_seed(unsigned int seedparam)
 void set_seed(unsigned int pidslot)
 {
 	pid_t pid = getpid();
-	if ((pid != watchdog_pid) && (pid != initpid) && (pid != mainpid))
+	if ((pid != watchdog_pid) && (pid != initpid) && (pid != mainpid)) {
 		output(0, "Setting seed: %u\n", shm->seed + (pidslot + 1));
+		shm->child_syscall_count_after_reseed[pidslot] = 0;
+	}
 	srand(shm->seed + (pidslot + 1));
 	shm->seeds[pidslot] = shm->seed;
 }
diff --git a/syscall.c b/syscall.c
index cb2defd..6d0dc35 100644
--- a/syscall.c
+++ b/syscall.c
@@ -142,6 +142,7 @@ static unsigned long do_syscall(int childno, int *errno_saved)
 	if (pidslot != PIDSLOT_NOT_FOUND) {
 		shm->total_syscalls_done++;
 		shm->child_syscall_count[pidslot]++;
+		shm->child_syscall_count_after_reseed[pidslot]++;
 		(void)gettimeofday(&shm->tv[pidslot], NULL);
 	}
 
diff --git a/watchdog.c b/watchdog.c
index 268c401..4c2bb3b 100644
--- a/watchdog.c
+++ b/watchdog.c
@@ -21,6 +21,7 @@
 #include "child.h"
 
 pid_t watchdog_pid;
+extern bool log_no_prefix;
 
 static int check_shm_sanity(void)
 {
@@ -274,6 +275,7 @@ static void watchdog(void)
 	static unsigned long lastcount = 0;
 	bool watchdog_exit = FALSE;
 	int ret = 0;
+	unsigned int j;
 
 	output(0, "Watchdog is alive. (pid:%d)\n", watchdog_pid);
 
@@ -305,9 +307,17 @@ static void watchdog(void)
 
 			if (shm->total_syscalls_done > 1) {
 				if (shm->total_syscalls_done - lastcount > 10000) {
-					output(0, "%ld iterations. [F:%ld S:%ld]\n",
+					output(0, "%ld iterations. [F:%ld S:%ld] ",
 						shm->total_syscalls_done, shm->failures, shm->successes);
 					lastcount = shm->total_syscalls_done;
+					/* output syscall per child after reseed */
+					log_no_prefix = TRUE;
+					output(0, "{");
+					for_each_pidslot(j) {
+						output(0, "C%d:%d;", j, shm->child_syscall_count_after_reseed[j]);
+					}
+					output(0, "}\n");
+					log_no_prefix = FALSE;
 				}
 			}
 		}
-- 
1.8.4
