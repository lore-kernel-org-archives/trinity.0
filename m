From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 1/2] Add an IGNORE_ENOSYS flag and use it
Date: Mon, 26 May 2014 22:32:01 +1000
Message-ID: <1401107522-21239-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Some syscalls return ENOSYS depending on their arguments. We don't want
to stop calling them just because we hit one of those cases. Add a flag
to specify this behaviour so we don't have to keep special-casing those
calls in mkcall().
---
 include/syscall.h   |  1 +
 syscall.c           | 23 ++++++-----------------
 syscalls/futex.c    |  2 +-
 syscalls/ioctl.c    |  2 +-
 syscalls/sendfile.c |  4 ++--
 5 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/include/syscall.h b/include/syscall.h
index e42cd85..bc19273 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -121,4 +121,5 @@ struct syscalltable {
 #define TO_BE_DEACTIVATED	(1<<4)
 #define NEED_ALARM		(1<<5)
 #define EXTRA_FORK		(1<<6)
+#define IGNORE_ENOSYS		(1<<7)
 
diff --git a/syscall.c b/syscall.c
index bca2aea..50e64ac 100644
--- a/syscall.c
+++ b/syscall.c
@@ -176,29 +176,18 @@ bool mkcall(int childno)
 	if (dopause == TRUE)
 		sleep(1);
 
-	/* If the syscall doesn't exist don't bother calling it next time. */
-	if ((ret == -1UL) && (errno_saved == ENOSYS)) {
-
-		/* Futex is awesome, it ENOSYS's depending on arguments. Sigh. */
-		if (call == (unsigned int) search_syscall_table(syscalls, max_nr_syscalls, "futex"))
-			goto skip_enosys;
-
-		/* Unknown ioctls also ENOSYS. */
-		if (call == (unsigned int) search_syscall_table(syscalls, max_nr_syscalls, "ioctl"))
-			goto skip_enosys;
-
-		/* sendfile() may ENOSYS depending on args. */
-		if (call == (unsigned int) search_syscall_table(syscalls, max_nr_syscalls, "sendfile"))
-			goto skip_enosys;
-
+	/*
+	 * If the syscall doesn't exist don't bother calling it next time.
+	 * Some syscalls return ENOSYS depending on their arguments, we mark
+	 * those as IGNORE_ENOSYS and keep calling them.
+	 */
+	if ((ret == -1UL) && (errno_saved == ENOSYS) && !(entry->flags & IGNORE_ENOSYS)) {
 		output(1, "%s (%d) returned ENOSYS, marking as inactive.\n",
 			entry->name, call + SYSCALL_OFFSET);
 
 		deactivate_syscall(call, syscallrec->do32bit);
 	}
 
-skip_enosys:
-
 	if (entry->post)
 	    entry->post(childno, syscallrec);
 
diff --git a/syscalls/futex.c b/syscalls/futex.c
index 5e194ab..4d18f30 100644
--- a/syscalls/futex.c
+++ b/syscalls/futex.c
@@ -33,5 +33,5 @@ struct syscallentry syscall_futex = {
 	.arg5type = ARG_ADDRESS,
 	.arg6name = "val3",
 	.rettype = RET_FD,		// FIXME: Needs to mutate depending on 'op' value
-	.flags = NEED_ALARM,
+	.flags = NEED_ALARM | IGNORE_ENOSYS,
 };
diff --git a/syscalls/ioctl.c b/syscalls/ioctl.c
index 012f055..db3b485 100644
--- a/syscalls/ioctl.c
+++ b/syscalls/ioctl.c
@@ -70,5 +70,5 @@ struct syscallentry syscall_ioctl = {
 	.arg3name = "arg",
 	.arg3type = ARG_RANDPAGE,
 	.sanitise = sanitise_ioctl,
-	.flags = NEED_ALARM,
+	.flags = NEED_ALARM | IGNORE_ENOSYS,
 };
diff --git a/syscalls/sendfile.c b/syscalls/sendfile.c
index 05e49e9..3e74841 100644
--- a/syscalls/sendfile.c
+++ b/syscalls/sendfile.c
@@ -14,7 +14,7 @@ struct syscallentry syscall_sendfile = {
 	.arg3type = ARG_ADDRESS,
 	.arg4name = "count",
 	.arg4type = ARG_LEN,
-	.flags = NEED_ALARM,
+	.flags = NEED_ALARM | IGNORE_ENOSYS,
 };
 
 /*
@@ -32,5 +32,5 @@ struct syscallentry syscall_sendfile64 = {
 	.arg3type = ARG_ADDRESS,
 	.arg4name = "count",
 	.arg4type = ARG_LEN,
-	.flags = NEED_ALARM,
+	.flags = NEED_ALARM | IGNORE_ENOSYS,
 };
-- 
1.9.1
