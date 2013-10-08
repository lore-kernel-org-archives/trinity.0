From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Logs cleanup
Date: Mon, 7 Oct 2013 18:26:18 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310071817130.27197@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=aJ8To+j3abxVmmYvw1zMG1g641gDBWb8CVyFaOLCMKY=;
        b=l45OdU4hlCSyeXkTRHqaz0PclZqurlGubbOmn5uH9SZNzrCx0gxFLhd+2ECZM62yrK
         LtuNFd4aAY8xN0OhMZH8AhCtbniNt6U/C1E//SywAC95MSx6ZGKNlRw7e0xAw7U8X9bi
         L3corwBPJ8YAn6f4YIW/zJR5qsxkc2Gd2tXJCLQZTwK0esNKnws0qY4B9a7XzRAS+ogM
         hHhLQQ9l+99jDTVudAHtOz4+qOtb4S/5e9p0cec2fOOuN1IX0yUF7gnv9yVw7LW7RYLG
         bHc8TyOFJyI6QuykOC8/RhW8wNnZiaOEqF295tvCBfMeI8sdCvl7aa7e/wFFRauCHb/D
         L4Og==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
content-type: TEXT/PLAIN
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch removes almost all printf and wires them into output functions, 
defined in log.c. As a result this patch also fixes bugs with "stack smash 
detected" and emission of ANSI control symbols even if -m (monochrome 
mode) is specified.

I gave it a run for couple of hours with differnt parameters, seems to be 
working, but worth additional testing, since it touches many files.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 child.c                    |   4 +-
 children/random-syscalls.c |  11 +-
 files.c                    |   6 +-
 generic-sanitise.c         |   2 +-
 include/log.h              |  17 ++-
 ioctls/ioctls.c            |  19 +--
 log.c                      | 287 +++++++++++++++++++++++++++++++++++++++------
 main.c                     |  10 +-
 maps.c                     |   8 +-
 net/protocols.c            |  11 +-
 params.c                   |  50 ++++----
 pids.c                     |   6 +-
 seed.c                     |  11 +-
 sockets.c                  |  24 ++--
 syscall.c                  | 139 ++--------------------
 syscalls/perf_event_open.c |   7 +-
 tables.c                   | 100 ++++++++--------
 trinity.c                  |  26 ++--
 watchdog.c                 |   8 +-
 19 files changed, 426 insertions(+), 320 deletions(-)

diff --git a/child.c b/child.c
index e52fbab..e203aeb 100644
--- a/child.c
+++ b/child.c
@@ -50,7 +50,7 @@ static void reenable_coredumps(void)
 	prctl(PR_SET_DUMPABLE, TRUE);
 
 	if (setrlimit(RLIMIT_CORE, &oldrlimit) != 0) {
-		printf("[%d] Error restoring rlimits to cur:%d max:%d (%s)\n",
+		outputerr("[%d] Error restoring rlimits to cur:%d max:%d (%s)\n",
 			getpid(),
 			(unsigned int) oldrlimit.rlim_cur,
 			(unsigned int) oldrlimit.rlim_max,
@@ -72,7 +72,7 @@ static void set_make_it_fail(void)
 
 	if (write(fd, buf, 1) == -1) {
 		if (errno != EPERM)
-			printf("writing to /proc/self/make-it-fail failed! (%s)\n", strerror(errno));
+			outputerr("writing to /proc/self/make-it-fail failed! (%s)\n", strerror(errno));
 		else
 			shm->do_make_it_fail = TRUE;
 	}
diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 08d2f76..553586d 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -76,7 +76,6 @@ extern int sigwas;
 
 int child_random_syscalls(int childno)
 {
-	pid_t pid = getpid();
 	int ret;
 	unsigned int syscallnr;
 
@@ -112,7 +111,7 @@ int child_random_syscalls(int childno)
 		}
 
 		if (shm->exit_reason != STILL_RUNNING) {
-			printf("Main is not running, exiting");
+			outputerr("Main is not running, exiting");
 			goto out;
 		}
 
@@ -139,14 +138,10 @@ int child_random_syscalls(int childno)
 
 		if (syscalls_todo) {
 			if (shm->total_syscalls_done >= syscalls_todo) {
-				output(0, "[%d] shm->total_syscalls_done (%d) >= syscalls_todo (%d)\n",
-					pid, shm->total_syscalls_done,syscalls_todo);
+				output(0, "Reached maximum syscall count (todo = %d, done = %d), exiting...\n",
+					syscalls_todo, shm->total_syscalls_done);
 				shm->exit_reason = EXIT_REACHED_COUNT;
 			}
-
-			if (shm->total_syscalls_done == syscalls_todo)
-				printf("[%d] Reached maximum syscall count %ld\n",
-					pid, shm->total_syscalls_done);
 		}
 
 		ret = mkcall(childno);
diff --git a/files.c b/files.c
index a5296da..7fcfb77 100644
--- a/files.c
+++ b/files.c
@@ -68,7 +68,7 @@ static int ignore_files(const char *path)
 		}
 
 		if (!strcmp(path, ignored_paths[i])) {
-//			printf("Skipping %s\n", path);
+			debugf("Skipping %s\n", path);
 			return 1;
 		}
 	}
@@ -85,14 +85,14 @@ static int ignore_files(const char *path)
 
 	for (i = 0; ignored_patterns[i]; i++) {
 		if (!strcmp(path + offset, ignored_patterns[i])) {
-//			printf("Skipping pattern %s\n", path);
+			debugf("Skipping pattern %s\n", path);
 			return 1;
 		}
 	}
 
 	/* special case to match tty* until I do globbing */
 	if (!strncmp(path + offset, "tty", 3)) {
-//		printf("Skipping %s\n", path);
+		debugf("Skipping %s\n", path);
 		return 1;
 	}
 	return 0;
diff --git a/generic-sanitise.c b/generic-sanitise.c
index a2fe9ad..e64f3dd 100644
--- a/generic-sanitise.c
+++ b/generic-sanitise.c
@@ -91,7 +91,7 @@ static unsigned long handle_arg_range(unsigned int call, unsigned int argnum)
 	}
 
 	if (high == 0) {
-		printf("%s forgets to set hirange!\n", syscalls[call].entry->name);
+		outputerr("%s forgets to set hirange!\n", syscalls[call].entry->name);
 		BUG("Fix syscall definition!\n");
 		return 0;
 	}
diff --git a/include/log.h b/include/log.h
index 2497988..ae73a5d 100644
--- a/include/log.h
+++ b/include/log.h
@@ -1,6 +1,8 @@
 #ifndef _LOG_H
 #define _LOG_H 1
 
+#include "types.h"
+
 #define ANSI_RED	"[1;31m"
 #define ANSI_GREEN	"[1;32m"
 #define ANSI_YELLOW	"[1;33m"
@@ -10,7 +12,7 @@
 #define ANSI_WHITE	"[1;37m"
 #define ANSI_RESET	"[0m"
 
-#define RED if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_RED);
+#define RED if (monochrome == FALSE)   sptr += sprintf(sptr, "%s", ANSI_RED);
 #define GREEN if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_GREEN);
 #define YELLOW if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_YELLOW);
 #define BLUE if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_BLUE);
@@ -19,14 +21,24 @@
 #define WHITE if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_WHITE);
 #define CRESET if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_RESET);
 
-#define CRESETPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_RESET);
+#define REDFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_RED);
+#define GREENFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_GREEN);
+#define CRESETFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_RESET);
 
 #define MAX_LOGLEVEL 3
 unsigned int highest_logfile(void);
 void synclogs(void);
 void output(unsigned char level, const char *fmt, ...);
+void outputerr(const char *fmt, ...);
+void outputstd(const char *fmt, ...);
+
+void output_syscall_prefix(const unsigned int childno, const unsigned int syscallno);
+
+void output_syscall_postfix(unsigned long ret, int errno_saved, bool err);
+
 void open_logfiles(void);
 void close_logfiles(void);
+void debugf(const char *fmt, ...);
 
 #define __stringify_1(x...)     #x
 #define __stringify(x...)       __stringify_1(x)
@@ -37,7 +49,6 @@ void close_logfiles(void);
 #define BUGTXT ANSI_RED "BUG!: " ANSI_RESET GIT_VERSION
 #endif
 
-
 #define BUG(bugtxt)	{ printf("%s:%s:%d %s", __FILE__, __func__, __LINE__, bugtxt); while(1); }
 
 #endif	/* _LOG_H */
diff --git a/ioctls/ioctls.c b/ioctls/ioctls.c
index 76cf550..e43bc3c 100644
--- a/ioctls/ioctls.c
+++ b/ioctls/ioctls.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 
 #include "trinity.h"	// ARRAY_SIZE
+#include "log.h"
 #include "files.h"
 #include "shm.h"
 #include "ioctls.h"
@@ -20,7 +21,7 @@ void register_ioctl_group(const struct ioctl_group *grp)
 		return;
 
 	if (grps_cnt == ARRAY_SIZE(grps)) {
-		fprintf(stderr, "WARNING: please grow IOCTL_GROUPS_MAX.\n");
+		outputerr("WARNING: please grow IOCTL_GROUPS_MAX.\n");
 		return;
 	}
 
@@ -100,24 +101,24 @@ void dump_ioctls(void)
 
 	for (i=0; i < grps_cnt; ++i) {
 		if (grps[i]->name)
-			printf("- %s:\n", grps[i]->name);
+			outputerr("- %s:\n", grps[i]->name);
 		else if (grps[i]->devtype) {
 			if (grps[i]->devtype == DEV_MISC)
-				printf("- misc devices");
+				outputerr("- misc devices");
 			else if (grps[i]->devtype == DEV_CHAR)
-				printf("- char devices");
+				outputerr("- char devices");
 			else if (grps[i]->devtype == DEV_BLOCK)
-				printf("- block devices");
+				outputerr("- block devices");
 			for (j=0; j < grps[i]->devs_cnt; ++j)
-				printf("%s '%s'",
+				outputerr("%s '%s'",
 					j == 0 ? "" : ",",
 					grps[i]->devs[j]);
-			printf(":\n");
+			outputerr(":\n");
 		} else
-			printf("- <unknown>:\n");
+			outputerr("- <unknown>:\n");
 
 		for (j=0; j < grps[i]->ioctls_cnt; ++j) {
-			printf("  - 0x%08x : %s\n",
+			outputerr("  - 0x%08x : %s\n",
 					grps[i]->ioctls[j].request,
 					grps[i]->ioctls[j].name ? : "");
 		}
diff --git a/log.c b/log.c
index 850a3e2..b186d26 100644
--- a/log.c
+++ b/log.c
@@ -9,8 +9,12 @@
 #include "shm.h"
 #include "pids.h"
 #include "log.h"
+#include "arch.h" //PAGE_MASK
+#include "maps.h" //pages
+#include "syscall.h" //syscalls
 
 FILE *mainlogfile;
+bool logfiles_opened = FALSE;
 
 void open_logfiles(void)
 {
@@ -22,7 +26,7 @@ void open_logfiles(void)
 	unlink(logfilename);
 	mainlogfile = fopen(logfilename, "a");
 	if (!mainlogfile) {
-		printf("## couldn't open logfile %s\n", logfilename);
+		outputerr("## couldn't open logfile %s\n", logfilename);
 		exit(EXIT_FAILURE);
 	}
 
@@ -31,11 +35,12 @@ void open_logfiles(void)
 		unlink(logfilename);
 		shm->logfiles[i] = fopen(logfilename, "a");
 		if (!shm->logfiles[i]) {
-			printf("## couldn't open logfile %s\n", logfilename);
+			outputerr("## couldn't open logfile %s\n", logfilename);
 			exit(EXIT_FAILURE);
 		}
 	}
 	free(logfilename);
+	logfiles_opened = TRUE;
 }
 
 void close_logfiles(void)
@@ -73,12 +78,12 @@ static FILE * find_logfile_handle(void)
 		if (i != PIDSLOT_NOT_FOUND)
 			return shm->logfiles[i];
 
-		printf("[%d] ## Couldn't find logfile for pid %d\n", getpid(), pid);
+		outputerr("## Couldn't find logfile for pid %d\n", pid);
 		dump_pid_slots();
-		printf("## Logfiles for pids: ");
+		outputerr("## Logfiles for pids: ");
 		for_each_pidslot(j)
-			printf("%p ", shm->logfiles[j]);
-		printf("\n");
+			outputerr("%p ", shm->logfiles[j]);
+		outputerr("\n");
 	}
 	return NULL;
 }
@@ -108,7 +113,7 @@ void synclogs(void)
 	for_each_pidslot(i) {
 		ret = fflush(shm->logfiles[i]);
 		if (ret == EOF) {
-			printf("## logfile flushing failed! %s\n", strerror(errno));
+			outputerr("## logfile flushing failed! %s\n", strerror(errno));
 			continue;
 		}
 
@@ -116,7 +121,7 @@ void synclogs(void)
 		if (fd != -1) {
 			ret = fsync(fd);
 			if (ret != 0)
-				printf("## fsyncing logfile %d failed. %s\n", i, strerror(errno));
+				outputerr("## fsyncing logfile %d failed. %s\n", i, strerror(errno));
 		}
 	}
 
@@ -124,6 +129,92 @@ void synclogs(void)
 	fsync(fileno(mainlogfile));
 }
 
+static void output_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, FILE *fd, bool mono)
+{
+	if (syscalls[call].entry->num_args >= argnum) {
+		if (!name)
+			return;
+
+		if (argnum != 1) {
+			CRESETFD
+			fprintf(fd, ", ");
+		}
+		if (name)
+			fprintf(fd, "%s=", name);
+
+		if (oldreg == reg) {
+			CRESETFD
+		} else {
+			if (mono == FALSE)
+				fprintf(fd, "%s", ANSI_CYAN);
+		}
+
+		switch (type) {
+		case ARG_PATHNAME:
+			fprintf(fd, "\"%s\"", (char *) reg);
+			break;
+		case ARG_PID:
+		case ARG_FD:
+			CRESETFD
+			fprintf(fd, "%ld", reg);
+			break;
+		case ARG_MODE_T:
+			CRESETFD
+			fprintf(fd, "%o", (mode_t) reg);
+			break;
+		case ARG_UNDEFINED:
+		case ARG_LEN:
+		case ARG_ADDRESS:
+		case ARG_NON_NULL_ADDRESS:
+		case ARG_RANGE:
+		case ARG_OP:
+		case ARG_LIST:
+		case ARG_RANDPAGE:
+		case ARG_CPU:
+		case ARG_RANDOM_LONG:
+		case ARG_IOVEC:
+		case ARG_IOVECLEN:
+		case ARG_SOCKADDR:
+		case ARG_SOCKADDRLEN:
+		default:
+			if (reg > 8 * 1024)
+				fprintf(fd, "0x%lx", reg);
+			else
+				fprintf(fd, "%ld", reg);
+			CRESETFD
+			break;
+		}
+		if (reg == (((unsigned long)page_zeros) & PAGE_MASK))
+			fprintf(fd, "[page_zeros]");
+		if (reg == (((unsigned long)page_rand) & PAGE_MASK))
+			fprintf(fd, "[page_rand]");
+		if (reg == (((unsigned long)page_0xff) & PAGE_MASK))
+			fprintf(fd, "[page_0xff]");
+		if (reg == (((unsigned long)page_allocs) & PAGE_MASK))
+			fprintf(fd, "[page_allocs]");
+	}
+}
+
+static FILE *robust_find_logfile_handle(void)
+{
+	unsigned int j;
+	FILE *handle = NULL;
+
+	if ((logging == TRUE) && (logfiles_opened)) {
+		handle = find_logfile_handle();
+		if (!handle) {
+			outputerr("## child logfile handle was null logging to main!\n");
+			(void)fflush(stdout);
+			for_each_pidslot(j)
+				shm->logfiles[j] = mainlogfile;
+			sleep(5);
+			handle = find_logfile_handle();
+		}
+	}
+	return handle;
+}
+
+
 /*
  * level defines whether it gets displayed to the screen with printf.
  * (it always logs).
@@ -151,6 +242,7 @@ void output(unsigned char level, const char *fmt, ...)
 	if (logging == FALSE && level >= quiet_level)
 		return;
 
+	/* prefix preparation */
 	pid = getpid();
 	if (pid == watchdog_pid)
 		prefix = watchdog_prefix;
@@ -167,57 +259,180 @@ void output(unsigned char level, const char *fmt, ...)
 		prefix = child_prefix;
 	}
 
+	/* formatting output */
 	va_start(args, fmt);
 	n = vsnprintf(outputbuf, sizeof(outputbuf), fmt, args);
 	va_end(args);
-
 	if (n < 0) {
-		printf("## Something went wrong in output() [%d]\n", n);
+		outputerr("## Something went wrong in output() [%d]\n", n);
 		exit(EXIT_FAILURE);
 	}
 
+	/* stdout output if needed */
 	if (quiet_level > level) {
 		printf("%s %s", prefix, outputbuf);
 		(void)fflush(stdout);
 	}
 
+	/* go on with file logs only if enabled */
 	if (logging == FALSE)
 		return;
 
-	handle = find_logfile_handle();
-	if (!handle) {
-		printf("## child logfile handle was null logging to main!\n");
-		(void)fflush(stdout);
-		for_each_pidslot(j)
-			shm->logfiles[j] = mainlogfile;
-		sleep(5);
+	handle = robust_find_logfile_handle();
+	if (!handle)
 		return;
-	}
 
 	/* If we've specified monochrome, we can just dump the buffer into
 	 * the logfile as is, because there shouldn't be any ANSI codes
 	 * in the buffer to be stripped out. */
-	if (monochrome == TRUE) {
+	if (monochrome == FALSE) {
+		/* copy buffer, sans ANSI codes */
+		len = strlen(outputbuf);
+		for (i = 0, j = 0; i < len; i++) {
+			if (outputbuf[i] == '') {
+				if (outputbuf[i + 2] == '1')
+					i += 6;	// ANSI_COLOUR
+				else
+					i += 3;	// ANSI_RESET
+			} else {
+				monobuf[j] = outputbuf[i];
+				j++;
+			}
+		}
+		monobuf[j] = '\0';
+		fprintf(handle, "%s %s", prefix, monobuf);
+	} else {
 		fprintf(handle, "%s %s", prefix, outputbuf);
-		(void)fflush(handle);
-		return;
 	}
 
-	/* copy buffer, sans ANSI codes */
-	len = strlen(outputbuf);
-	for (i = 0, j = 0; i < len; i++) {
-		if (outputbuf[i] == '') {
-			if (outputbuf[i + 2] == '1')
-				i += 6;	// ANSI_COLOUR
-			else
-				i += 3;	// ANSI_RESET
-		} else {
-			monobuf[j] = outputbuf[i];
-			j++;
-		}
+	(void)fflush(handle);
+	return;
+}
+
+/*
+* Used as a way to consolidated all printf calls if someones one to redirect it to somewhere else.
+* note: this function ignores quiet_level since it main purpose is error output.
+*/
+void outputerr(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+}
+
+void outputstd(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vfprintf(stdout, fmt, args);
+	va_end(args);
+}
+
+static void output_syscall_prefix_to_fd(const unsigned int childno, const pid_t pid, const unsigned int syscallno, FILE *fd, bool mono)
+{
+	fprintf(fd, "[child%d:%d] [%ld] %s", childno, pid, shm->child_syscall_count[childno],
+			(shm->do32bit[childno] == TRUE) ? "[32BIT] " : "");
+
+	if (syscallno > max_nr_syscalls)
+		fprintf(fd, "%u", syscallno);
+	else
+	fprintf(fd, "%s", syscalls[syscallno].entry->name);
+
+	CRESETFD
+	fprintf(fd, "(");
+	output_arg(syscallno, 1, syscalls[syscallno].entry->arg1name, shm->previous_a1[childno], shm->a1[childno],
+			syscalls[syscallno].entry->arg1type, fd, mono);
+	output_arg(syscallno, 2, syscalls[syscallno].entry->arg2name, shm->previous_a2[childno], shm->a2[childno],
+			syscalls[syscallno].entry->arg2type, fd, mono);
+	output_arg(syscallno, 3, syscalls[syscallno].entry->arg3name, shm->previous_a3[childno], shm->a3[childno],
+			syscalls[syscallno].entry->arg3type, fd, mono);
+	output_arg(syscallno, 4, syscalls[syscallno].entry->arg4name, shm->previous_a4[childno], shm->a4[childno],
+			syscalls[syscallno].entry->arg4type, fd, mono);
+	output_arg(syscallno, 5, syscalls[syscallno].entry->arg5name, shm->previous_a5[childno], shm->a5[childno],
+			syscalls[syscallno].entry->arg5type, fd, mono);
+	output_arg(syscallno, 6, syscalls[syscallno].entry->arg6name, shm->previous_a6[childno], shm->a6[childno],
+			syscalls[syscallno].entry->arg6type, fd, mono);
+	CRESETFD
+	fprintf(fd, ") ");
+}
+
+/* This function is always called from a fuzzing child. */
+void output_syscall_prefix(const unsigned int childno, const unsigned int syscallno)
+{
+	FILE *log_handle;
+	pid_t pid;
+
+	/* Exit if should not continue at all. */
+	if (logging == FALSE && quiet_level < MAX_LOGLEVEL)
+		return;
+	pid = getpid();
+
+	/* Find the log file handle */
+	log_handle = robust_find_logfile_handle();
+
+	/* do not output any ascii control symbols to files */
+	if ((logging == TRUE) && (log_handle != NULL))
+		output_syscall_prefix_to_fd(childno, pid, syscallno, log_handle, TRUE);
+
+	/* Output to stdout only if -q param is not specified */
+	if (quiet_level == MAX_LOGLEVEL)
+		output_syscall_prefix_to_fd(childno, pid, syscallno, stdout, monochrome);
+}
+
+static void output_syscall_postfix_err(unsigned long ret, int errno_saved, FILE *fd, bool mono)
+{
+	REDFD
+	fprintf(fd, "= %ld (%s)", ret, strerror(errno_saved));
+	CRESETFD
+	fprintf(fd, "\n");
+}
+
+static void output_syscall_postfix_success(unsigned long ret, FILE *fd, bool mono)
+{
+	GREENFD
+	if ((unsigned long)ret > 10000)
+		fprintf(fd, "= 0x%lx", ret);
+	else
+		fprintf(fd, "= %ld", ret);
+	CRESETFD
+	fprintf(fd, "\n");
+}
+
+
+void output_syscall_postfix(unsigned long ret, int errno_saved, bool err)
+{
+	FILE *log_handle;
+
+	/* Exit if should not continue at all. */
+	if (logging == FALSE && quiet_level < MAX_LOGLEVEL)
+		return;
+
+	/* Find the log file handle */
+	log_handle = robust_find_logfile_handle();
+
+	if (err) {
+		if ((logging == TRUE) && (log_handle != NULL))
+			output_syscall_postfix_err(ret, errno_saved, log_handle, TRUE);
+		if (quiet_level == MAX_LOGLEVEL)
+			output_syscall_postfix_err(ret, errno_saved, stdout, monochrome);
+	} else {
+		if ((logging == TRUE) && (log_handle != NULL))
+			output_syscall_postfix_success(ret, log_handle, TRUE);
+		if (quiet_level == MAX_LOGLEVEL)
+			output_syscall_postfix_success(ret, stdout, monochrome);
 	}
-	monobuf[j] = '\0';
+}
 
-	fprintf(handle, "%s %s", prefix, monobuf);
-	(void)fflush(handle);
+void debugf(const char *fmt, ...)
+{
+	va_list args;
+
+	if (debug == TRUE) {
+		va_start(args, fmt);
+		vprintf(fmt, args);
+		va_end(args);
+	}
 }
diff --git a/main.c b/main.c
index 69f8960..058b87a 100644
--- a/main.c
+++ b/main.c
@@ -84,8 +84,6 @@ static void oom_score_adj(int adj)
 	fclose(fp);
 }
 
-#define debugf if (debug == TRUE) printf
-
 static void fork_children(void)
 {
 	int pidslot;
@@ -109,7 +107,7 @@ static void fork_children(void)
 		/* Find a space for it in the pid map */
 		pidslot = find_pid_slot(EMPTY_PIDSLOT);
 		if (pidslot == PIDSLOT_NOT_FOUND) {
-			printf("## Pid map was full!\n");
+			outputerr("## Pid map was full!\n");
 			dump_pid_slots();
 			exit(EXIT_FAILURE);
 		}
@@ -137,7 +135,7 @@ static void fork_children(void)
 				ret = pid_alive(mainpid);
 				if (ret != 0) {
 					shm->exit_reason = EXIT_SHM_CORRUPTION;
-					printf(BUGTXT "parent (%d) went away!\n", mainpid);
+					outputerr(BUGTXT "parent (%d) went away!\n", mainpid);
 					sleep(20000);
 				}
 			}
@@ -236,7 +234,7 @@ static void handle_child(pid_t childpid, int childstatus)
 			if (slot == PIDSLOT_NOT_FOUND) {
 				/* If we reaped it, it wouldn't show up, so check that. */
 				if (shm->last_reaped != childpid) {
-					printf("## Couldn't find pid slot for %d\n", childpid);
+					outputerr("## Couldn't find pid slot for %d\n", childpid);
 					shm->exit_reason = EXIT_LOST_PID_SLOT;
 					dump_pid_slots();
 				}
@@ -406,7 +404,7 @@ void do_main_loop(void)
 		while (pidmap_empty() == FALSE)
 			handle_children();
 
-		printf("Bailing main loop. Exit reason: %s\n", decode_exit(shm->exit_reason));
+		outputerr("Bailing main loop. Exit reason: %s\n", decode_exit(shm->exit_reason));
 		_exit(EXIT_SUCCESS);
 	}
 
diff --git a/maps.c b/maps.c
index 18b9bcb..c5d739b 100644
--- a/maps.c
+++ b/maps.c
@@ -39,7 +39,7 @@ static struct map * alloc_map(void)
 
 	newmap = malloc(sizeof(struct map));
 	if (!newmap) {
-		printf("Couldn't allocate maps list!\n");
+		outputerr("Couldn't allocate maps list!\n");
 		exit(EXIT_FAILURE);
 	}
 	memset(newmap, 0, sizeof(struct map));
@@ -70,7 +70,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 
 	fd = open("/dev/zero", O_RDWR);
 	if (fd < 0) {
-		printf("open /dev/zero failure. %s\n", strerror(errno));
+		outputerr("open /dev/zero failure. %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
 
@@ -97,7 +97,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 	tmpmap->ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_SHARED, fd, 0);
 
 	if (tmpmap->ptr == MAP_FAILED) {
-		printf("mmap /dev/zero failure\n");
+		outputerr("mmap /dev/zero failure\n");
 		exit(EXIT_FAILURE);
 	}
 
@@ -105,7 +105,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 
 	tmpmap->name = malloc(80);
 	if (!tmpmap->name) {
-		fprintf(stderr, "malloc() failed in %s().", __func__);
+		outputerr("malloc() failed in %s().", __func__);
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/net/protocols.c b/net/protocols.c
index f42b762..891acfe 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -6,6 +6,7 @@
 #include "trinity.h"
 #include "constants.h"
 #include "net.h"
+#include "log.h"
 
 struct protocol {
 	const char *name;
@@ -76,7 +77,7 @@ void find_specific_proto(const char *protoarg)
 		for (i = 0; i < ARRAY_SIZE(protocols); i++) {
 			if (strcmp(protoarg, protocols[i].name) == 0) {
 				specific_proto = protocols[i].proto;
-				printf("Proto %s = %d\n", protoarg, specific_proto);
+				output(2, "Proto %s = %d\n", protoarg, specific_proto);
 				break;
 			}
 		}
@@ -89,13 +90,13 @@ void find_specific_proto(const char *protoarg)
 	}
 
 	if (i > TRINITY_PF_MAX) {
-		printf("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
+		outputerr("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
 		for (i = 0; i < ARRAY_SIZE(protocols); i++)
-			printf("%s ", protocols[i].name);
-		printf("\n");
+			outputerr("%s ", protocols[i].name);
+		outputerr("\n");
 
 		exit(EXIT_FAILURE);
 	}
 
-	printf("Using protocol %s (%u) for all sockets\n", protocols[i].name, protocols[i].proto);
+	output(2, "Using protocol %s (%u) for all sockets\n", protocols[i].name, protocols[i].proto);
 }
diff --git a/params.c b/params.c
index 552742e..cde8684 100644
--- a/params.c
+++ b/params.c
@@ -54,28 +54,28 @@ bool kernel_taint_param_occured = FALSE;
 
 static void usage(void)
 {
-	fprintf(stderr, "%s\n", progname);
-	fprintf(stderr, " --children,-C: specify number of child processes\n");
-	fprintf(stderr, " --exclude,-x: don't call a specific syscall\n");
-	fprintf(stderr, " --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
-	fprintf(stderr, " --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. \n");
-	fprintf(stderr, " --list,-L: list all syscalls known on this architecture.\n");
-	fprintf(stderr, " --ioctls,-I: list all ioctls.\n");
-	fprintf(stderr, " --logging,-l: (off=disable logging).\n");
-	fprintf(stderr, " --monochrome,-m: don't output ANSI codes\n");
-	fprintf(stderr, " --no_files,-n: Only pass sockets as fd's, not files\n");
-	fprintf(stderr, " --proto,-P: specify specific network protocol for sockets.\n");
-	fprintf(stderr, " --quiet,-q: less output.\n");
-	fprintf(stderr, " --random,-r#: pick N syscalls at random and just fuzz those\n");
-	fprintf(stderr, " --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
-	fprintf(stderr, " --verbose,-v: increase output verbosity.\n");
-	fprintf(stderr, " --victims,-V: path to victim files.\n");
-	fprintf(stderr, " --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.");
-	fprintf(stderr, "\n");
-	fprintf(stderr, " -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
-	fprintf(stderr, " -N#: do # syscalls then exit.\n");
-	fprintf(stderr, " -p:  pause after syscall.\n");
-	fprintf(stderr, " -s#: use # as random seed.\n");
+	outputerr("%s\n", progname);
+	outputerr(" --children,-C: specify number of child processes\n");
+	outputerr(" --exclude,-x: don't call a specific syscall\n");
+	outputerr(" --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
+	outputerr(" --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. \n");
+	outputerr(" --list,-L: list all syscalls known on this architecture.\n");
+	outputerr(" --ioctls,-I: list all ioctls.\n");
+	outputerr(" --logging,-l: (off=disable logging).\n");
+	outputerr(" --monochrome,-m: don't output ANSI codes\n");
+	outputerr(" --no_files,-n: Only pass sockets as fd's, not files\n");
+	outputerr(" --proto,-P: specify specific network protocol for sockets.\n");
+	outputerr(" --quiet,-q: less output.\n");
+	outputerr(" --random,-r#: pick N syscalls at random and just fuzz those\n");
+	outputerr(" --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
+	outputerr(" --verbose,-v: increase output verbosity.\n");
+	outputerr(" --victims,-V: path to victim files.\n");
+	outputerr(" --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.");
+	outputerr("\n");
+	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
+	outputerr(" -N#: do # syscalls then exit.\n");
+	outputerr(" -p:  pause after syscall.\n");
+	outputerr(" -s#: use # as random seed.\n");
 	exit(EXIT_SUCCESS);
 }
 
@@ -148,7 +148,7 @@ static void toggle_taint_flag_by_name(char *beg, char *end) {
 	else if (strcmp(name,"OOT_MODULE") == 0)
 		toggle_taint_flag(TAINT_OOT_MODULE);
 	else {
-		printf("Unrecognizable kernel taint flag \"%s\".\n", name);
+		outputerr("Unrecognizable kernel taint flag \"%s\".\n", name);
 		exit(EXIT_FAILURE);
 	}
 }
@@ -181,7 +181,7 @@ void parse_args(int argc, char *argv[])
 			if (opt == '?')
 				exit(EXIT_FAILURE);
 			else
-				printf("opt:%c\n", opt);
+				outputstd("opt:%c\n", opt);
 			return;
 
 		case '\0':
@@ -273,7 +273,7 @@ void parse_args(int argc, char *argv[])
 
 		case 'r':
 			if (do_exclude_syscall == TRUE) {
-				printf("-r needs to be before any -x options.\n");
+				outputerr("-r needs to be before any -x options.\n");
 				exit(EXIT_FAILURE);
 			}
 			random_selection = 1;
diff --git a/pids.c b/pids.c
index dd33d72..a2005c1 100644
--- a/pids.c
+++ b/pids.c
@@ -54,7 +54,7 @@ void dump_pid_slots(void)
 		sptr += sprintf(sptr, "\n");
 	}
 	*sptr = '\0';
-	printf("%s", string);
+	outputerr("%s", string);
 }
 
 static pid_t pidmax;
@@ -95,10 +95,10 @@ void pids_init(void)
 #else
 		pidmax = 32768;
 #endif
-		printf("Couldn't read pid_max from proc\n");
+		outputerr("Couldn't read pid_max from proc\n");
 	}
 
-	printf("[init] Using pid_max = %d\n", pidmax);
+	output(0, "Using pid_max = %d\n", pidmax);
 }
 
 int pid_is_valid(pid_t pid)
diff --git a/seed.c b/seed.c
index 802d587..a9c6f6a 100644
--- a/seed.c
+++ b/seed.c
@@ -19,7 +19,7 @@ unsigned int seed = 0;
 
 static void syslog_seed(int seedparam)
 {
-	fprintf(stderr, "Randomness reseeded to %u\n", seedparam);
+	outputerr("Randomness reseeded to %u\n", seedparam);
 	openlog("trinity", LOG_CONS|LOG_PERROR, LOG_USER);
 	syslog(LOG_CRIT, "Randomness reseeded to %u\n", seedparam);
 	closelog();
@@ -50,11 +50,11 @@ unsigned int new_seed(void)
 unsigned int init_seed(unsigned int seedparam)
 {
 	if (user_set_seed == TRUE)
-		printf("Using user passed random seed: %u\n", seedparam);
+		output(0, "Using user passed random seed: %u\n", seedparam);
 	else {
 		seedparam = new_seed();
 
-		printf("Initial random seed: %u\n", seedparam);
+		output(0, "Initial random seed: %u\n", seedparam);
 	}
 
 	if (do_syslog == TRUE)
@@ -69,6 +69,9 @@ unsigned int init_seed(unsigned int seedparam)
  */
 void set_seed(unsigned int pidslot)
 {
+	pid_t pid = getpid();
+	if ((pid != watchdog_pid) && (pid != initpid) && (pid != mainpid))
+		output(0, "Setting seed: %u\n", shm->seed + (pidslot + 1));
 	srand(shm->seed + (pidslot + 1));
 	shm->seeds[pidslot] = shm->seed;
 }
@@ -86,7 +89,7 @@ void reseed(void)
 	shm->reseed_counter = 0;
 
 	if (getpid() != mainpid) {
-		output(0, "Reseeding should only happen from parent!\n");
+		outputerr("Reseeding should only happen from parent!\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/sockets.c b/sockets.c
index c2037c9..ee56e49 100644
--- a/sockets.c
+++ b/sockets.c
@@ -49,15 +49,15 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
 
 		ret = bind(fd, &sa, salen);
 /*		if (ret == -1)
-			printf("bind: %s\n", strerror(errno));
+			debugf("bind: %s\n", strerror(errno));
 		else
-			printf("bind: success!\n");
+			debugf("bind: success!\n");
 */
 		ret = listen(fd, (rand() % 2) + 1);
 /*		if (ret == -1)
-			printf("listen: %s\n", strerror(errno));
+			debugf("listen: %s\n", strerror(errno));
 		else
-			printf("listen: success!\n");
+			debugf("listen: success!\n");
 */
 	}
 
@@ -116,7 +116,7 @@ static void generate_sockets(void)
 
 	cachefile = creat(cachefilename, S_IWUSR|S_IRUSR);
 	if (cachefile < 0) {
-		printf("Couldn't open cachefile for writing! (%s)\n",
+		outputerr("Couldn't open cachefile for writing! (%s)\n",
 			strerror(errno));
 		exit(EXIT_FAILURE);
 	}
@@ -152,14 +152,14 @@ static void generate_sockets(void)
 				buffer[2] = st.protocol;
 				n = write(cachefile, &buffer, sizeof(int) * 3);
 				if (n == -1) {
-					printf("something went wrong writing the cachefile!\n");
+					outputerr("something went wrong writing the cachefile!\n");
 					exit(EXIT_FAILURE);
 				}
 
 				if (nr_to_create == 0)
 					goto done;
 			} else {
-				//printf("Couldn't open family:%d (%s)\n", st.family, get_proto_name(st.family));
+				//outputerr("Couldn't open family:%d (%s)\n", st.family, get_proto_name(st.family));
 			}
 skip:
 
@@ -190,7 +190,7 @@ static void close_sockets(void)
 		fd = shm->socket_fds[i];
 		shm->socket_fds[i] = 0;
 		if (close(fd) != 0) {
-			printf("failed to close socket.(%s)\n", strerror(errno));
+			output(1, "failed to close socket.(%s)\n", strerror(errno));
 		}
 	}
 
@@ -211,7 +211,7 @@ void open_sockets(void)
 
 	cachefile = open(cachefilename, O_RDONLY);
 	if (cachefile < 0) {
-		printf("Couldn't find socket cachefile. Regenerating.\n");
+		output(1, "Couldn't find socket cachefile. Regenerating.\n");
 		generate_sockets();
 		return;
 	}
@@ -229,7 +229,7 @@ void open_sockets(void)
 
 		if (do_specific_proto == TRUE) {
 			if (domain != specific_proto) {
-				printf("ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
+				output(1, "ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
 regenerate:
 				unlock_cachefile(cachefile);	/* drop the reader lock. */
 				close(cachefile);
@@ -241,7 +241,7 @@ regenerate:
 
 		fd = open_socket(domain, type, protocol);
 		if (fd < 0) {
-			printf("Cachefile is stale. Need to regenerate.\n");
+			output(1, "Cachefile is stale. Need to regenerate.\n");
 			close_sockets();
 			goto regenerate;
 		}
@@ -254,7 +254,7 @@ regenerate:
 	}
 
 	if (nr_sockets < NR_SOCKET_FDS) {
-		printf("Insufficient sockets in cachefile (%d). Regenerating.\n", nr_sockets);
+		output(1, "Insufficient sockets in cachefile (%d). Regenerating.\n", nr_sockets);
 		goto regenerate;
 	}
 
diff --git a/syscall.c b/syscall.c
index 80f5a34..cb2defd 100644
--- a/syscall.c
+++ b/syscall.c
@@ -148,138 +148,35 @@ static unsigned long do_syscall(int childno, int *errno_saved)
 	return ret;
 }
 
-static void color_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, char **sptr)
-{
-	if (syscalls[call].entry->num_args >= argnum) {
-		if (!name)
-			return;
-
-		if (argnum != 1) {
-			CRESETPTR
-			*sptr += sprintf(*sptr, ", ");
-		}
-		if (name)
-			*sptr += sprintf(*sptr, "%s=", name);
-
-		if (oldreg == reg) {
-			CRESETPTR
-		} else {
-			*sptr += sprintf(*sptr, "%s", ANSI_CYAN);
-		}
-
-		switch (type) {
-		case ARG_PATHNAME:
-			*sptr += sprintf(*sptr, "\"%s\"", (char *) reg);
-			break;
-		case ARG_PID:
-		case ARG_FD:
-			CRESETPTR
-			*sptr += sprintf(*sptr, "%ld", reg);
-			break;
-		case ARG_MODE_T:
-			CRESETPTR
-			*sptr += sprintf(*sptr, "%o", (mode_t) reg);
-			break;
-		case ARG_UNDEFINED:
-		case ARG_LEN:
-		case ARG_ADDRESS:
-		case ARG_NON_NULL_ADDRESS:
-		case ARG_RANGE:
-		case ARG_OP:
-		case ARG_LIST:
-		case ARG_RANDPAGE:
-		case ARG_CPU:
-		case ARG_RANDOM_LONG:
-		case ARG_IOVEC:
-		case ARG_IOVECLEN:
-		case ARG_SOCKADDR:
-		case ARG_SOCKADDRLEN:
-		default:
-			if (reg > 8 * 1024)
-				*sptr += sprintf(*sptr, "0x%lx", reg);
-			else
-				*sptr += sprintf(*sptr, "%ld", reg);
-			CRESETPTR
-			break;
-		}
-		if (reg == (((unsigned long)page_zeros) & PAGE_MASK))
-			*sptr += sprintf(*sptr, "[page_zeros]");
-		if (reg == (((unsigned long)page_rand) & PAGE_MASK))
-			*sptr += sprintf(*sptr, "[page_rand]");
-		if (reg == (((unsigned long)page_0xff) & PAGE_MASK))
-			*sptr += sprintf(*sptr, "[page_0xff]");
-		if (reg == (((unsigned long)page_allocs) & PAGE_MASK))
-			*sptr += sprintf(*sptr, "[page_allocs]");
-	}
-}
-
 /*
  * Generate arguments, print them out, then call the syscall.
  */
 long mkcall(int childno)
 {
-	unsigned long olda1, olda2, olda3, olda4, olda5, olda6;
 	unsigned int call = shm->syscallno[childno];
 	unsigned long ret = 0;
 	int errno_saved;
-	char string[512], *sptr;
 	uid_t olduid = getuid();
 
 	shm->regenerate++;
 
-	sptr = string;
-
-	sptr += sprintf(sptr, "[%ld] ", shm->child_syscall_count[childno]);
-	if (shm->do32bit[childno] == TRUE)
-		sptr += sprintf(sptr, "[32BIT] ");
-
-	olda1 = shm->a1[childno] = (unsigned long)rand64();
-	olda2 = shm->a2[childno] = (unsigned long)rand64();
-	olda3 = shm->a3[childno] = (unsigned long)rand64();
-	olda4 = shm->a4[childno] = (unsigned long)rand64();
-	olda5 = shm->a5[childno] = (unsigned long)rand64();
-	olda6 = shm->a6[childno] = (unsigned long)rand64();
-
-	if (call > max_nr_syscalls)
-		sptr += sprintf(sptr, "%u", call);
-	else
-		sptr += sprintf(sptr, "%s", syscalls[call].entry->name);
+	shm->a1[childno] = (unsigned long)rand64();
+	shm->a2[childno] = (unsigned long)rand64();
+	shm->a3[childno] = (unsigned long)rand64();
+	shm->a4[childno] = (unsigned long)rand64();
+	shm->a5[childno] = (unsigned long)rand64();
+	shm->a6[childno] = (unsigned long)rand64();
 
 	generic_sanitise(childno);
 	if (syscalls[call].entry->sanitise)
 		syscalls[call].entry->sanitise(childno);
 
-	/* micro-optimization. If we're not logging, and we're quiet, then
-	 * we can skip right over all of this. */
-	if ((logging == FALSE) && (quiet_level < MAX_LOGLEVEL))
-		goto skip_args;
-
-	CRESET
-	sptr += sprintf(sptr, "(");
-	color_arg(call, 1, syscalls[call].entry->arg1name, olda1, shm->a1[childno],
-			syscalls[call].entry->arg1type, &sptr);
-	color_arg(call, 2, syscalls[call].entry->arg2name, olda2, shm->a2[childno],
-			syscalls[call].entry->arg2type, &sptr);
-	color_arg(call, 3, syscalls[call].entry->arg3name, olda3, shm->a3[childno],
-			syscalls[call].entry->arg3type, &sptr);
-	color_arg(call, 4, syscalls[call].entry->arg4name, olda4, shm->a4[childno],
-			syscalls[call].entry->arg4type, &sptr);
-	color_arg(call, 5, syscalls[call].entry->arg5name, olda5, shm->a5[childno],
-			syscalls[call].entry->arg5type, &sptr);
-	color_arg(call, 6, syscalls[call].entry->arg6name, olda6, shm->a6[childno],
-			syscalls[call].entry->arg6type, &sptr);
-	CRESET
-	sptr += sprintf(sptr, ") ");
-	*sptr = '\0';
-
-	output(2, "%s", string);
+	output_syscall_prefix(childno, call);
 
 	/* If we're going to pause, might as well sync pre-syscall */
 	if (dopause == TRUE)
 		synclogs();
 
-skip_args:
-
 	if (((unsigned long)shm->a1 == (unsigned long) shm) ||
 	    ((unsigned long)shm->a2 == (unsigned long) shm) ||
 	    ((unsigned long)shm->a3 == (unsigned long) shm) ||
@@ -289,7 +186,6 @@ skip_args:
 		BUG("Address of shm ended up in a register!\n");
 	}
 
-
 	/* Some architectures (IA64/MIPS) start their Linux syscalls
 	 * At non-zero, and have other ABIs below.
 	 */
@@ -297,27 +193,12 @@ skip_args:
 
 	ret = do_syscall(childno, &errno_saved);
 
-	sptr = string;
-
-	if (IS_ERR(ret)) {
-		RED
-		sptr += sprintf(sptr, "= %ld (%s)", ret, strerror(errno_saved));
-		CRESET
+	if (IS_ERR(ret))
 		shm->failures++;
-	} else {
-		GREEN
-		if ((unsigned long)ret > 10000)
-			sptr += sprintf(sptr, "= 0x%lx", ret);
-		else
-			sptr += sprintf(sptr, "= %ld", ret);
-		CRESET
+	else
 		shm->successes++;
-	}
-
-	*sptr = '\0';
-
-	output(2, "%s\n", string);
 
+	output_syscall_postfix(ret, errno_saved, IS_ERR(ret));
 	if (dopause == TRUE)
 		sleep(1);
 
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index dfcec77..468357a 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -15,6 +15,7 @@
 #include "compat.h"
 #include "maps.h"
 #include "shm.h"
+#include "log.h"
 
 #define SYSFS "/sys/bus/event_source/devices/"
 
@@ -97,7 +98,7 @@ static int parse_format(char *string, int *field_type, unsigned long long *mask)
 			if (string[i]=='-') break;
 			if (string[i]==',') break;
 			if ((string[i]<'0') || (string[i]>'9')) {
-				fprintf(stderr,"Unknown format char %c\n",string[i]);
+				outputerr("Unknown format char %c\n", string[i]);
 				return -1;
 			}
 			firstnum*=10;
@@ -119,7 +120,7 @@ static int parse_format(char *string, int *field_type, unsigned long long *mask)
 				if (string[i]=='-') break;
 				if (string[i]==',') break;
 				if ((string[i]<'0') || (string[i]>'9')) {
-					fprintf(stderr,"Unknown format char %c\n",string[i]);
+					outputerr("Unknown format char %c\n", string[i]);
 					return -1;
 				}
 				secondnum*=10;
@@ -238,7 +239,7 @@ static int parse_generic(int pmu, char *value,
 				if (value[ptr]==',') break;
 				if (! ( ((value[ptr]>='0') && (value[ptr]<='9'))
                    			|| ((value[ptr]>='a') && (value[ptr]<='f'))) ) {
-					fprintf(stderr,"Unexpected char %c\n",value[ptr]);
+					outputerr("Unexpected char %c\n", value[ptr]);
 				}
 				temp*=base;
 				if ((value[ptr]>='0') && (value[ptr]<='9')) {
diff --git a/tables.c b/tables.c
index 618d742..f159814 100644
--- a/tables.c
+++ b/tables.c
@@ -38,7 +38,7 @@ int search_syscall_table(const struct syscalltable *table, unsigned int nr_sysca
 	/* search by name */
 	for (i = 0; i < nr_syscalls; i++) {
 		if (strcmp(arg, table[i].entry->name) == 0) {
-			//printf("Found %s at %u\n", table[i].entry->name, i);
+			//debugf("Found %s at %u\n", table[i].entry->name, i);
 			return i;
 		}
 	}
@@ -52,10 +52,10 @@ static void validate_specific_syscall(const struct syscalltable *table, int call
 		return;
 
 	if (table[call].entry->flags & AVOID_SYSCALL)
-		printf("%s is marked as AVOID. Skipping\n", table[call].entry->name);
+		output(0, "%s is marked as AVOID. Skipping\n", table[call].entry->name);
 
 	if (table[call].entry->flags & NI_SYSCALL)
-		printf("%s is NI_SYSCALL. Skipping\n", table[call].entry->name);
+		output(0, "%s is NI_SYSCALL. Skipping\n", table[call].entry->name);
 }
 
 int validate_specific_syscall_silent(const struct syscalltable *table, int call)
@@ -145,12 +145,12 @@ void deactivate_syscall(unsigned int calln)
 void count_syscalls_enabled(void)
 {
 	if (biarch == TRUE) {
-		printf("[init] 32-bit syscalls: %d enabled, %d disabled.  "
+		output(0, "32-bit syscalls: %d enabled, %d disabled.  "
 			"64-bit syscalls: %d enabled, %d disabled.\n",
 			shm->nr_active_32bit_syscalls, max_nr_32bit_syscalls - shm->nr_active_32bit_syscalls,
 			shm->nr_active_64bit_syscalls, max_nr_64bit_syscalls - shm->nr_active_64bit_syscalls);
 	} else {
-		printf("Enabled %d syscalls. Disabled %d syscalls.\n",
+		output(0, "Enabled %d syscalls. Disabled %d syscalls.\n",
 			shm->nr_active_syscalls, max_nr_syscalls - shm->nr_active_syscalls);
 	}
 }
@@ -245,7 +245,7 @@ static void check_syscall(struct syscall *entry)
 	if (entry->num_args > 0) {				\
 		if (entry->num_args > NUMARGS) {		\
 			if (entry->ARGNAME == NULL)  {		\
-				printf("arg %d of %s has no name\n", ARGNUM, entry->name);      \
+				outputerr("arg %d of %s has no name\n", ARGNUM, entry->name);      \
 				exit(EXIT_FAILURE);		\
 			}					\
 		}						\
@@ -265,7 +265,7 @@ static void check_syscall(struct syscall *entry)
 	if (entry->num_args > 0) {				\
 		if (entry->num_args > NUMARGS) {		\
 			if (entry->ARGTYPE == ARG_UNDEFINED) {	\
-				printf("%s has an undefined argument type for arg1 (%s)!\n", entry->name, entry->ARGNAME);	\
+				outputerr("%s has an undefined argument type for arg1 (%s)!\n", entry->name, entry->ARGNAME);	\
 			}					\
 		}						\
 	}							\
@@ -303,7 +303,7 @@ void mark_all_syscalls_active(void)
 {
 	unsigned int i;
 
-	printf("Marking all syscalls as enabled.\n");
+	outputstd("Marking all syscalls as enabled.\n");
 	if (biarch == TRUE) {
 		if (do_32_arch)
 			for_each_32bit_syscall(i) {
@@ -346,7 +346,7 @@ static void check_user_specified_arch(const char *arg, char **arg_name, bool *on
 				*only_64bit = FALSE;
 				*only_32bit = TRUE;
 			} else {
-				printf("Unknown bit width (%s). Choose 32, or 64.\n", arg);
+				outputerr("Unknown bit width (%s). Choose 32, or 64.\n", arg);
 				exit(EXIT_FAILURE);
 			}
 		}
@@ -380,7 +380,7 @@ static void toggle_syscall_biarch_n(int calln, const struct syscalltable *table,
 	}
 
 	if ((arch_bits != 0) && (calln != -1))
-		printf("Marking %d-bit syscall %s (%d) as to be %sabled.\n",
+		output(0, "Marking %d-bit syscall %s (%d) as to be %sabled.\n",
 			arch_bits, arg_name, calln,
 			state ? "en" : "dis");
 }
@@ -405,17 +405,17 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 
 
 	if ((!only_32bit) && (!only_64bit)) {
-		printf("No idea what architecture for syscall (%s) is.\n", arg);
+		outputerr("No idea what architecture for syscall (%s) is.\n", arg);
 		exit(EXIT_FAILURE);
 	}
 
 	if ((specific_syscall64 == -1) && (specific_syscall32 == -1)) {
-		printf("No idea what syscall (%s) is.\n", arg);
+		outputerr("No idea what syscall (%s) is.\n", arg);
 		exit(EXIT_FAILURE);
 	}
 
 	if ((specific_syscall64 != -1) && (specific_syscall32 != -1)) {
-		printf("Marking syscall %s (64bit:%d 32bit:%d) as to be %sabled.\n",
+		output(0, "Marking syscall %s (64bit:%d 32bit:%d) as to be %sabled.\n",
 			arg_name, specific_syscall64, specific_syscall32,
 			state ? "en" : "dis");
 		clear_check_user_specified_arch(arg, &arg_name);
@@ -423,7 +423,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 	}
 
 	if (specific_syscall64 != -1) {
-		printf("Marking 64-bit syscall %s (%d) as to be %sabled.\n",
+		output(0, "Marking 64-bit syscall %s (%d) as to be %sabled.\n",
 			arg, specific_syscall64,
 			state ? "en" : "dis");
 		clear_check_user_specified_arch(arg, &arg_name);
@@ -431,7 +431,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 	}
 
 	if  (specific_syscall32 != -1) {
-		printf("Marking 32-bit syscall %s (%d) as to be %sabled.\n",
+		output(0, "Marking 32-bit syscall %s (%d) as to be %sabled.\n",
 			arg, specific_syscall32,
 			state ? "en" : "dis");
 		clear_check_user_specified_arch(arg, &arg_name);
@@ -443,7 +443,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 static void toggle_syscall_n(int calln, bool state, const char *arg, const char *arg_name)
 {
 	if (calln == -1) {
-		printf("No idea what syscall (%s) is.\n", arg);
+		outputerr("No idea what syscall (%s) is.\n", arg);
 		exit(EXIT_FAILURE);
 	}
 
@@ -456,7 +456,7 @@ static void toggle_syscall_n(int calln, bool state, const char *arg, const char
 		syscalls[calln].entry->flags |= TO_BE_DEACTIVATED;
 	}
 
-	printf("Marking syscall %s (%d) as to be %sabled.\n",
+	output(0, "Marking syscall %s (%d) as to be %sabled.\n",
 		arg_name, calln,
 		state ? "en" : "dis");
 }
@@ -482,14 +482,14 @@ void deactivate_disabled_syscalls(void)
 {
 	unsigned int i;
 
-	printf("Disabling syscalls marked as disabled by command line options\n");
+	output(0, "Disabling syscalls marked as disabled by command line options\n");
 
 	if (biarch == TRUE) {
 		for_each_64bit_syscall(i) {
 			if (syscalls_64bit[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls_64bit[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 				deactivate_syscall64(i);
-				printf("Marked 64-bit syscall %s (%d) as deactivated.\n",
+				output(0, "Marked 64-bit syscall %s (%d) as deactivated.\n",
 					syscalls_64bit[i].entry->name, syscalls_64bit[i].entry->number);
 			}
 		}
@@ -497,7 +497,7 @@ void deactivate_disabled_syscalls(void)
 			if (syscalls_32bit[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls_32bit[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 				deactivate_syscall32(i);
-				printf("Marked 32-bit syscall %s (%d) as deactivated.\n",
+				output(0, "Marked 32-bit syscall %s (%d) as deactivated.\n",
 					syscalls_32bit[i].entry->name, syscalls_32bit[i].entry->number);
 			}
 		}
@@ -507,7 +507,7 @@ void deactivate_disabled_syscalls(void)
 			if (syscalls[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 				deactivate_syscall(i);
-				printf("Marked syscall %s (%d) as deactivated.\n",
+				output(0, "Marked syscall %s (%d) as deactivated.\n",
 					syscalls[i].entry->name, syscalls[i].entry->number);
 			}
 		}
@@ -517,9 +517,9 @@ void deactivate_disabled_syscalls(void)
 static void show_state(unsigned int state)
 {
 	if (state)
-		printf("Enabled");
+		outputstd("Enabled");
 	else
-		printf("Disabled");
+		outputstd("Disabled");
 }
 
 void dump_syscall_tables(void)
@@ -527,31 +527,31 @@ void dump_syscall_tables(void)
 	unsigned int i;
 
 	if (biarch == TRUE) {
-		printf("32-bit syscalls: %d\n", max_nr_32bit_syscalls);
-		printf("64-bit syscalls: %d\n", max_nr_64bit_syscalls);
+		outputstd("32-bit syscalls: %d\n", max_nr_32bit_syscalls);
+		outputstd("64-bit syscalls: %d\n", max_nr_64bit_syscalls);
 
 		for_each_32bit_syscall(i) {
-			printf("32-bit entrypoint %d %s : ", syscalls_32bit[i].entry->number, syscalls_32bit[i].entry->name);
+			outputstd("32-bit entrypoint %d %s : %s", syscalls_32bit[i].entry->number, syscalls_32bit[i].entry->name);
 			show_state(syscalls_32bit[i].entry->flags & ACTIVE);
 			if (syscalls_32bit[i].entry->flags & AVOID_SYSCALL)
-				printf(" AVOID");
-			printf("\n");
+				outputstd(" AVOID");
+			outputstd("\n");
 		}
 		for_each_64bit_syscall(i) {
-			printf("64-bit entrypoint %d %s : ", syscalls_64bit[i].entry->number, syscalls_64bit[i].entry->name);
+			outputstd("64-bit entrypoint %d %s : ", syscalls_64bit[i].entry->number, syscalls_64bit[i].entry->name);
 			show_state(syscalls_64bit[i].entry->flags & ACTIVE);
 			if (syscalls_64bit[i].entry->flags & AVOID_SYSCALL)
-				printf(" AVOID");
-			printf("\n");
+				outputstd(" AVOID");
+			outputstd("\n");
 		}
 	} else {
-		printf("syscalls: %d\n", max_nr_syscalls);
+		outputstd("syscalls: %d\n", max_nr_syscalls);
 		for_each_syscall(i) {
-			printf("%d %s : ", syscalls[i].entry->number, syscalls[i].entry->name);
+			outputstd("%d %s : ", syscalls[i].entry->number, syscalls[i].entry->name);
 			show_state(syscalls[i].entry->flags & ACTIVE);
 			if (syscalls[i].entry->flags & AVOID_SYSCALL)
-				printf(" AVOID");
-			printf("\n");
+				outputstd(" AVOID");
+			outputstd("\n");
 		}
 	}
 }
@@ -635,9 +635,9 @@ int setup_syscall_group(unsigned int group)
 		}
 
 		if (shm->nr_active_32bit_syscalls == 0) {
-			printf("No 32-bit syscalls in group\n");
+			outputstd("No 32-bit syscalls in group\n");
 		} else {
-			printf("Found %d 32-bit syscalls in group\n", shm->nr_active_32bit_syscalls);
+			outputstd("Found %d 32-bit syscalls in group\n", shm->nr_active_32bit_syscalls);
 		}
 
 		/* now the 64 bit table*/
@@ -647,10 +647,10 @@ int setup_syscall_group(unsigned int group)
 		}
 
 		if (shm->nr_active_64bit_syscalls == 0) {
-			printf("No 64-bit syscalls in group\n");
+			outputstd("No 64-bit syscalls in group\n");
 			return FALSE;
 		} else {
-			printf("Found %d 64-bit syscalls in group\n", shm->nr_active_64bit_syscalls);
+			outputstd("Found %d 64-bit syscalls in group\n", shm->nr_active_64bit_syscalls);
 		}
 
 	} else {
@@ -661,10 +661,10 @@ int setup_syscall_group(unsigned int group)
 		}
 
 		if (shm->nr_active_syscalls == 0) {
-			printf("No syscalls found in group\n");
+			outputstd("No syscalls found in group\n");
 			return FALSE;
 		} else {
-			printf("Found %d syscalls in group\n", shm->nr_active_syscalls);
+			outputstd("Found %d syscalls in group\n", shm->nr_active_syscalls);
 		}
 	}
 
@@ -690,7 +690,7 @@ const char * print_syscall_name(unsigned int callno, bool is32bit)
 	}
 
 	if (callno >= max) {
-		printf("Bogus syscall number in %s (%u)\n", __func__, callno);
+		outputstd("Bogus syscall number in %s (%u)\n", __func__, callno);
 		return "invalid-syscall";
 	}
 
@@ -704,19 +704,19 @@ void display_enabled_syscalls(void)
 	if (biarch == TRUE) {
 		for_each_64bit_syscall(i) {
 			if (syscalls_64bit[i].entry->flags & ACTIVE)
-				printf("64-bit syscall %d:%s enabled.\n", i, syscalls_64bit[i].entry->name);
+				output(0, "64-bit syscall %d:%s enabled.\n", i, syscalls_64bit[i].entry->name);
 		}
 
 		for_each_32bit_syscall(i) {
 			if (syscalls_32bit[i].entry->flags & ACTIVE)
-				printf("32-bit syscall %d:%s enabled.\n", i, syscalls_32bit[i].entry->name);
+				output(0, "32-bit syscall %d:%s enabled.\n", i, syscalls_32bit[i].entry->name);
 		}
 
 	} else {
 		/* non-biarch */
 		for_each_syscall(i) {
 			if (syscalls[i].entry->flags & ACTIVE)
-				printf("syscall %d:%s enabled.\n", i, syscalls[i].entry->name);
+				output(0, "syscall %d:%s enabled.\n", i, syscalls[i].entry->name);
 		}
 	}
 }
@@ -766,7 +766,7 @@ void disable_non_net_syscalls(void)
 {
 	unsigned int i;
 
-	printf("Disabling non networking related syscalls\n");
+	output(0, "Disabling non networking related syscalls\n");
 
 	if (biarch == TRUE) {
 		for_each_64bit_syscall(i) {
@@ -818,23 +818,23 @@ void enable_random_syscalls(void)
 	unsigned int call, call32, call64;
 
 	if (random_selection_num == 0) {
-		printf("-r 0 syscalls ? what?\n");
+		outputerr("-r 0 syscalls ? what?\n");
 		exit(EXIT_FAILURE);
 	}
 
 	if (biarch == TRUE) {
 		if ((random_selection_num > max_nr_64bit_syscalls) && do_64_arch) {
-			printf("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_64bit_syscalls);
+			outputerr("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_64bit_syscalls);
 			exit(EXIT_FAILURE);
 		}
 	} else {
 		if (random_selection_num > max_nr_syscalls) {
-			printf("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_syscalls);
+			outputerr("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_syscalls);
 			exit(EXIT_FAILURE);
 		}
 	}
 
-	printf("Enabling %d random syscalls\n", random_selection_num);
+	outputerr("Enabling %d random syscalls\n", random_selection_num);
 
 	for (i = 0; i < random_selection_num; i++) {
 
diff --git a/trinity.c b/trinity.c
index 73627cf..63f205c 100644
--- a/trinity.c
+++ b/trinity.c
@@ -99,7 +99,7 @@ static void setup_shm_postargs(void)
 		shm->max_children = sysconf(_SC_NPROCESSORS_ONLN);
 
 	if (shm->max_children > MAX_NR_CHILDREN) {
-		printf("Increase MAX_NR_CHILDREN!\n");
+		outputerr("Increase MAX_NR_CHILDREN!\n");
 		exit(EXIT_FAILURE);
 	}
 }
@@ -145,8 +145,8 @@ static int munge_tables(void)
 		display_enabled_syscalls();
 
 	if (validate_syscall_tables() == FALSE) {
-		printf("No syscalls were enabled!\n");
-		printf("Use 32bit:%d 64bit:%d\n", use_32bit, use_64bit);
+		outputstd("No syscalls were enabled!\n");
+		outputstd("Use 32bit:%d 64bit:%d\n", use_32bit, use_64bit);
 		return FALSE;
 	}
 
@@ -185,7 +185,7 @@ int main(int argc, char* argv[])
 	int childstatus;
 	unsigned int i;
 
-	printf("Trinity v" __stringify(VERSION) "  Dave Jones <davej@redhat.com>\n");
+	outputstd("Trinity v" __stringify(VERSION) "  Dave Jones <davej@redhat.com>\n");
 
 	progname = argv[0];
 
@@ -200,10 +200,10 @@ int main(int argc, char* argv[])
 		exit(EXIT_FAILURE);
 
 	parse_args(argc, argv);
-	printf("Done parsing arguments.\n");
+	outputstd("Done parsing arguments.\n");
 
 	if (kernel_taint_mask != (int)0xFFFFFFFF) {
-		printf("Custom kernel taint mask has been specified: 0x%08x (%d).\n", kernel_taint_mask, kernel_taint_mask);
+		outputstd("Custom kernel taint mask has been specified: 0x%08x (%d).\n", kernel_taint_mask, kernel_taint_mask);
 	}
 
 	setup_shm_postargs();
@@ -230,17 +230,17 @@ int main(int argc, char* argv[])
 
 	if (getuid() == 0) {
 		if (dangerous == TRUE) {
-			printf("DANGER: RUNNING AS ROOT.\n");
-			printf("Unless you are running in a virtual machine, this could cause serious problems such as overwriting CMOS\n");
-			printf("or similar which could potentially make this machine unbootable without a firmware reset.\n\n");
-			printf("ctrl-c now unless you really know what you are doing.\n");
+			outputstd("DANGER: RUNNING AS ROOT.\n");
+			outputstd("Unless you are running in a virtual machine, this could cause serious problems such as overwriting CMOS\n");
+			outputstd("or similar which could potentially make this machine unbootable without a firmware reset.\n\n");
+			outputstd("ctrl-c now unless you really know what you are doing.\n");
 			for (i = 10; i > 0; i--) {
-				printf("Continuing in %d seconds.\r", i);
+				outputstd("Continuing in %d seconds.\r", i);
 				(void)fflush(stdout);
 				sleep(1);
 			}
 		} else {
-			printf("Don't run as root (or pass --dangerous if you know what you are doing).\n");
+			outputstd("Don't run as root (or pass --dangerous if you know what you are doing).\n");
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -274,7 +274,7 @@ int main(int argc, char* argv[])
 	/* Shutting down. */
 	waitpid(watchdog_pid, &childstatus, 0);
 
-	printf("\nRan %ld syscalls. Successes: %ld  Failures: %ld\n",
+	output(0, "\nRan %ld syscalls. Successes: %ld  Failures: %ld\n",
 		shm->total_syscalls_done - 1, shm->successes, shm->failures);
 
 	ret = EXIT_SUCCESS;
diff --git a/watchdog.c b/watchdog.c
index 7f9999b..268c401 100644
--- a/watchdog.c
+++ b/watchdog.c
@@ -188,7 +188,7 @@ static void check_children(void)
 
 		/* if we wrapped, just reset it, we'll pick it up next time around. */
 		if (old > (now + 3)) {
-			printf("child %d wrapped! old=%ld now=%ld\n", i, old, now);
+			output(1, "child %d wrapped! old=%ld now=%ld\n", i, old, now);
 			shm->tv[i].tv_sec = now;
 			continue;
 		}
@@ -275,7 +275,7 @@ static void watchdog(void)
 	bool watchdog_exit = FALSE;
 	int ret = 0;
 
-	printf("[watchdog] Watchdog is alive. (pid:%d)\n", watchdog_pid);
+	output(0, "Watchdog is alive. (pid:%d)\n", watchdog_pid);
 
 	prctl(PR_SET_NAME, (unsigned long) &watchdogname);
 	(void)signal(SIGSEGV, SIG_DFL);
@@ -303,9 +303,9 @@ static void watchdog(void)
 			if (shm->total_syscalls_done % 1000 == 0)
 				synclogs();
 
-			if ((quiet_level > 1) && (shm->total_syscalls_done > 1)) {
+			if (shm->total_syscalls_done > 1) {
 				if (shm->total_syscalls_done - lastcount > 10000) {
-					printf("[watchdog] %ld iterations. [F:%ld S:%ld]\n",
+					output(0, "%ld iterations. [F:%ld S:%ld]\n",
 						shm->total_syscalls_done, shm->failures, shm->successes);
 					lastcount = shm->total_syscalls_done;
 				}
-- 
1.8.4
