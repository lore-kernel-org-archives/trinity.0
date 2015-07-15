From: Tom Clark <tclark@redhat.com>
Subject: [PATCH] Add "-F" option for reproducing parts of previous runs
Date: Wed, 15 Jul 2015 13:46:43 -0400
Message-ID: <55A69C83.60304@redhat.com>
Reply-To: tclark@redhat.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org
Cc: lwang <lwang@redhat.com>, Eric Sandeen <sandeen@redhat.com>

If only one child process is being used and a random seed is specified,
-F can be used to reproduce the same syscalls generated at any point
in a previous run.

	$ ./trinity -s 12345 -F 99995 -N 5
	...
	[watchdog] Watchdog is alive. (pid:7878)
	[child0:7849] [99995] ...
	[child0:7849] [99996] ...
	[child0:7849] [99997] ...
	[child0:7849] [99998] ...
	[child0:7849] [99999] ...
	[main] Bailing main loop because Completed maximum number of operations..

This can be useful, for instance, when reporting a bug that occurred
after many unrelated syscalls.  A maintainer reviewing the bug report
may wish to re-run only the relevant calls that caused the bug.
Additionally, it can help in studying the last calls that were made
before some behavior.

This option is not allowed  when multiple child processes are in use
because there is no way to know, for example, which operation child1
will be on by the time child0 should be on operation #99995.
---
 README                     |  5 +++++
 children/random-syscalls.c | 24 +++++++++++++++++++-----
 include/tables.h           |  2 +-
 params.c                   | 24 +++++++++++++++++++++++-
 tables.c                   |  1 +
 5 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/README b/README
index ab37af4..dd0b4fd 100644
--- a/README
+++ b/README
@@ -77,6 +77,11 @@ tmp directory. (Handy for cleaning up any garbage named files; just rm -rf tmp a
      This is useful for catching core dumps if trinity is segfaulting, as by default
      the child processes ignore those signals.
 
+ -F#: start at operation number #
+      This is useful for reproducing the last operations of a run that ended
+      with an error.  To use this flag, a seed must be specified, and only one
+      child process can be used.
+
  -sN: use N as random seed.  (Omitting this uses time of day as a seed).
   Note: There are currently a few bugs that mean no two runs are necessary 100%
   identical with the same seed. See the TODO for details.
diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 807b2ec..c43f755 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -77,6 +77,7 @@ bool child_random_syscalls(void)
 	unsigned long a1, a2, a3;
 	time_t old;
 	pid_t oldpid;
+	bool dryrun;
 
 retry:
 	if (no_syscalls_enabled() == TRUE) {
@@ -113,6 +114,12 @@ retry:
 			shm->exit_reason = EXIT_REACHED_COUNT;
 	}
 
+	/* When reproducing a range of operations from a previous run, we need
+	 * to skip the operations leading up to them, while still picking the
+	 * same random numbers.  So, the first "n" operations are generated
+	 * but not run. */
+	dryrun = rec->op_nr < first_op_nr;
+
 	/* Generate arguments, print them out */
 
 	generate_syscall_args(rec);
@@ -122,7 +129,8 @@ retry:
 	a3 = rec->a3;
 	oldpid = this_child->pid;
 
-	output_syscall_prefix(rec);
+	if (!dryrun)
+		output_syscall_prefix(rec);
 
 	/* Sanity check: Make sure the length of the buffer remains
 	 * constant across the syscall.
@@ -134,7 +142,11 @@ retry:
 		synclogs();
 
 	old = rec->tv.tv_sec;
-	do_syscall(rec);
+
+	if (dryrun)
+		rec->op_nr++;
+	else
+		do_syscall(rec);
 
 	if (this_child->pid == 0) {
 		output(0, "Sanity check failed. my pid became zero after syscall:%s(%lx, %lx, %lx)  was:%d\n",
@@ -168,10 +180,12 @@ retry:
 	}
 
 	/* Output the syscall result, and clean up */
-	output_syscall_postfix(rec);
+	if (!dryrun) {
+		output_syscall_postfix(rec);
 
-	if (dopause == TRUE)
-		sleep(1);
+		if (dopause == TRUE)
+			sleep(1);
+	}
 
 	handle_syscall_ret(rec);
 
diff --git a/include/tables.h b/include/tables.h
index e33c253..33f3b1e 100644
--- a/include/tables.h
+++ b/include/tables.h
@@ -7,6 +7,7 @@ extern const struct syscalltable *syscalls;
 extern const struct syscalltable *syscalls_32bit;
 extern const struct syscalltable *syscalls_64bit;
 
+extern unsigned long first_op_nr;
 extern unsigned long syscalls_todo;
 extern unsigned int max_nr_syscalls;
 extern unsigned int max_nr_32bit_syscalls;
@@ -87,4 +88,3 @@ bool this_syscallname(const char *thisname);
 	for (i = 0; i < max_nr_64bit_syscalls; i++)
 #define for_each_syscall(i) \
 	for (i = 0; i < max_nr_syscalls; i++)
-
diff --git a/params.c b/params.c
index 01b4df5..c03e3a7 100644
--- a/params.c
+++ b/params.c
@@ -91,13 +91,14 @@ static void usage(void)
 	outputerr(" --victims,-V: path to victim files.\n");
 	outputerr("\n");
 	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
+	outputerr(" -F#: start at operation number # (used to reproduce parts of previous runs)\n");
 	outputerr(" -N#: do # syscalls then exit.\n");
 	outputerr(" -p:  pause after syscall.\n");
 	outputerr(" -s#: use # as random seed.\n");
 	exit(EXIT_SUCCESS);
 }
 
-static const char paramstr[] = "a:b:c:C:dDg:hIl:LN:mP:E:pqr:s:T:SV:vx:X";
+static const char paramstr[] = "a:b:c:C:dDF:g:hIl:LN:mP:E:pqr:s:T:SV:vx:X";
 
 static const struct option longopts[] = {
 	{ "arch", required_argument, NULL, 'a' },
@@ -192,6 +193,10 @@ void parse_args(int argc, char *argv[])
 			parse_exclude_domains(optarg);
 			break;
 
+		case 'F':
+			first_op_nr = strtoll(optarg, NULL, 10);
+			break;
+
 		case 'g':
 			if (!strcmp(optarg, "vm"))
 				desired_group = GROUP_VM;
@@ -331,5 +336,22 @@ void parse_args(int argc, char *argv[])
 
 	quiet_level = MAX_LOGLEVEL - quiet_level;
 
+	/* When starting at a certain operation number, a seed must be
+	 * specified and and there can be only one child, since this option is
+	 * used to deterministicly reproduce parts of previous runs. */
+	if (first_op_nr != 0) {
+		if (user_specified_children > 1) {
+			outputerr("-F can only be used with a single child process.");
+			exit(EXIT_FAILURE);
+		} else {
+			max_children = 1;
+		}
+
+		if (!user_set_seed) {
+			outputerr("-F can only be used if a seed is specified with -s\n");
+			exit(EXIT_FAILURE);
+		}
+	}
+
 	output(1, "Done parsing arguments.\n");
 }
diff --git a/tables.c b/tables.c
index b2d7361..c9bf0cf 100644
--- a/tables.c
+++ b/tables.c
@@ -16,6 +16,7 @@
 #include "tables.h"
 #include "utils.h"	// ARRAY_SIZE
 
+unsigned long first_op_nr = 0;
 unsigned long syscalls_todo = 0;
 
 bool biarch = FALSE;
-- 
1.8.3.1

