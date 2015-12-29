From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] convert syscall time tracking to CLOCK_MONOTONIC
Date: Wed, 30 Dec 2015 02:36:12 +0300
Message-ID: <1451432172-70916-1-git-send-email-kirill.shutemov@linux.intel.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Commit e8646038d918 ("add some extra sanity checks inside the child
process") made trinity near unusable for me: the rec->tv sanity check
fails rather quickly after first syscall capable of changing wall time.

The patch reworks trinity to use clock_gettime(CLOCK_MONOTONIC) instead
of gettimeofday(). It makes trinity usable again.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 children/random-syscalls.c | 8 ++++----
 debug.c                    | 2 +-
 include/syscall.h          | 4 ++--
 main.c                     | 2 +-
 post-mortem.c              | 6 +++---
 rand/seed.c                | 1 +
 syscall.c                  | 2 +-
 watchdog.c                 | 8 ++++----
 8 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index c35f649d55a9..7994cb9ba473 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -80,13 +80,13 @@ static void check_sanity(struct syscallrecord *rec, struct syscallrecord *stash)
 {
 	unsigned int len;
 
-	if (stash->tv.tv_sec != 0) {
+	if (stash->tp.tv_sec != 0) {
 		// FIXME: Should factor in loadavg here, as with enough pids, a child can exceed 60s
 		//  without getting scheduled.
-		if (rec->tv.tv_sec - stash->tv.tv_sec > 60) {
-			output(0, "Sanity check failed. Something stomped on rec->tv after syscall:%s(%lx, %lx, %lx)  was:%lx now:%lx.\n",
+		if (rec->tp.tv_sec - stash->tp.tv_sec > 60) {
+			output(0, "Sanity check failed. Something stomped on rec->tp after syscall:%s(%lx, %lx, %lx)  was:%lx now:%lx.\n",
 				print_syscall_name(stash->nr, stash->do32bit),
-				stash->a1, stash->a2, stash->a3, stash->tv.tv_sec, rec->tv.tv_sec);
+				stash->a1, stash->a2, stash->a3, stash->tp.tv_sec, rec->tp.tv_sec);
 			fail_sanity();
 		}
 	}
diff --git a/debug.c b/debug.c
index 8c0bec625b7d..64f6b06502ec 100644
--- a/debug.c
+++ b/debug.c
@@ -68,7 +68,7 @@ void __BUG(const char *bugtxt, const char *filename, const char *funcname, unsig
 
 void dump_syscallrec(struct syscallrecord *rec)
 {
-	output(0, " tv.tvsec=%d tv.usec=%d\n", rec->tv.tv_sec, rec->tv.tv_usec);
+	output(0, " tp.tv_sec=%d tp.tv_nsec=%ld\n", rec->tp.tv_sec, rec->tp.tv_nsec);
 	output(0, " nr:%d a1:%lx a2:%lx a3:%lx a4:%lx a5:%lx a6:%lx retval:%ld errno_post:%d\n",
 		rec->nr, rec->a1, rec->a2, rec->a3, rec->a4, rec->a5, rec->a6, rec->retval, rec->errno_post);
 	output(0, " op_nr:%lx do32bit:%d\n", rec->op_nr, rec->do32bit);
diff --git a/include/syscall.h b/include/syscall.h
index 0511cc942868..bb0f97488f74 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -1,6 +1,6 @@
 #pragma once
 
-#include <sys/time.h>
+#include <time.h>
 #include <sys/types.h>
 #include "locks.h"
 #include "types.h"
@@ -20,7 +20,7 @@ enum syscallstate {
 };
 
 struct syscallrecord {
-	struct timeval tv;
+	struct timespec tp;
 	unsigned int nr;
 	unsigned long a1;
 	unsigned long a2;
diff --git a/main.c b/main.c
index 885f1ceaafda..5358d8c9c95c 100644
--- a/main.c
+++ b/main.c
@@ -127,7 +127,7 @@ void reap_child(pid_t childpid)
 
 	child = shm->children[i];
 	child->pid = EMPTY_PIDSLOT;
-	child->syscall.tv.tv_sec = 0;
+	child->syscall.tp = (struct timespec){};
 	shm->running_childs--;
 	shm->last_reaped = childpid;
 
diff --git a/post-mortem.c b/post-mortem.c
index 046ce5c2f454..2afc2cd333b8 100644
--- a/post-mortem.c
+++ b/post-mortem.c
@@ -53,12 +53,12 @@ static void dump_syscall_records(void)
 
 void tainted_postmortem(int taint)
 {
-	struct timeval taint_tv;
+	struct timespec taint_tp;
 
 	shm->postmortem_in_progress = TRUE;
 
-	//TODO: Sort syscall rec output by timeval, and mark when we detected taint_tv.
-	gettimeofday(&taint_tv, NULL);
+	//TODO: Sort syscall rec output by timespec, and mark when we detected taint_tp.
+	clock_gettime(CLOCK_MONOTONIC, &taint_tp);
 
 	panic(EXIT_KERNEL_TAINTED);
 
diff --git a/rand/seed.c b/rand/seed.c
index c2fd259e6926..5a1b4d280017 100644
--- a/rand/seed.c
+++ b/rand/seed.c
@@ -23,6 +23,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <sys/time.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
diff --git a/syscall.c b/syscall.c
index 611f0d9ce1c5..1124a5b676b6 100644
--- a/syscall.c
+++ b/syscall.c
@@ -118,7 +118,7 @@ static void __do_syscall(struct syscallrecord *rec)
 	shm->stats.total_syscalls_done++;
 
 	lock(&rec->lock);
-	(void)gettimeofday(&rec->tv, NULL);
+	clock_gettime(CLOCK_MONOTONIC, &rec->tp);
 
 	rec->op_nr++;
 	rec->errno_post = errno;
diff --git a/watchdog.c b/watchdog.c
index fce552d9c268..3c94690852a2 100644
--- a/watchdog.c
+++ b/watchdog.c
@@ -297,7 +297,7 @@ static void stuck_syscall_info(struct childdata *child)
 static bool is_child_making_progress(struct childdata *child)
 {
 	struct syscallrecord *rec;
-	struct timeval tv;
+	struct timespec tp;
 	time_t diff, old, now;
 	pid_t pid;
 
@@ -308,14 +308,14 @@ static bool is_child_making_progress(struct childdata *child)
 
 	rec = &child->syscall;
 
-	old = rec->tv.tv_sec;
+	old = rec->tp.tv_sec;
 
 	/* haven't done anything yet. */
 	if (old == 0)
 		return TRUE;
 
-	gettimeofday(&tv, NULL);
-	now = tv.tv_sec;
+	clock_gettime(CLOCK_MONOTONIC, &tp);
+	now = tp.tv_sec;
 
 	if (old > now)
 		diff = old - now;
-- 
2.6.4
