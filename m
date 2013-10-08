From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH 5/6] added bufferless logging functions for syscall pamaters
Date: Tue,  8 Oct 2013 14:26:54 -0700
Message-ID: <1381267615-9826-5-git-send-email-ildarm@google.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=duJlUa0GVlaMQ7MwAK21tCF3mBx3HO7VrriiEcd/QC8=;
        b=G0U8+ACY1uYjlDoo9ZdAiIm6XvQ3SqHzjBlO13SfzOp8DiIgt2j1yT6ZxsJLN7AaaA
         NP94HVaHsyFCjlJx4KZrWBIJ9MDRK4YY0phyaJ5yGiCWH5FBlMqgVlEbzeUTFPmMLzHy
         JOxP7ke/PmWYMYEHMc8CJkb8zP8291wNYmvGbxa4R+N27lANF5QuNve/G+yrKqlMgA8s
         rClYikah1gVsQn+uam9xrMpjonVtRb48Y1nvq+Zh3kDGfMCIkE6qqaZYXYCZXFpXtXCD
         wN8do4LHKfFY1Es94dklOnFZ8CnDk+8Q8VzAfZ1oJDP6y+/V1jI9YL2cZuqdu/DB1d3m
         GIiA==
In-Reply-To: <1381267615-9826-1-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Ildar Muslukhov <ildarm@google.com>

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/log.h |   9 ++++++
 log.c         | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/include/log.h b/include/log.h
index 7041eda..76b825e 100644
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
@@ -21,12 +23,19 @@
 
 #define CRESETPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_RESET);
 
+#define REDFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_RED);
+#define GREENFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_GREEN);
+#define CRESETFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_RESET);
+
 #define MAX_LOGLEVEL 3
 unsigned int highest_logfile(void);
 void synclogs(void);
 void output(unsigned char level, const char *fmt, ...);
 void outputerr(const char *fmt, ...);
 void outputstd(const char *fmt, ...);
+void output_syscall_prefix(const unsigned int childno, const unsigned int syscallno);
+void output_syscall_postfix(unsigned long ret, int errno_saved, bool err);
+
 void open_logfiles(void);
 void close_logfiles(void);
 
diff --git a/log.c b/log.c
index 518dd81..2a9c140 100644
--- a/log.c
+++ b/log.c
@@ -9,6 +9,9 @@
 #include "shm.h"
 #include "pids.h"
 #include "log.h"
+#include "arch.h" //PAGE_MASK
+#include "maps.h" //pages
+#include "syscall.h" //syscalls
 
 #define BUFSIZE 1024
 
@@ -128,6 +131,10 @@ void synclogs(void)
 	fsync(fileno(mainlogfile));
 }
 
+static void output_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, FILE *fd, bool mono)
+{
+}
+
 static FILE *robust_find_logfile_handle(void)
 {
 	unsigned int j;
@@ -262,3 +269,97 @@ void outputstd(const char *fmt, ...)
 	vfprintf(stdout, fmt, args);
 	va_end(args);
 }
+
+static void output_syscall_prefix_to_fd(const unsigned int childno, const pid_t pid, const unsigned int syscallno, FILE *fd, bool mono)
+{
+	fprintf(fd, "[child%d:%d] [%ld] %s", childno, pid, shm->child_syscall_count[childno],
+			(shm->do32bit[childno] == TRUE) ? "[32BIT] " : "");
+
+	if (syscallno > max_nr_syscalls)
+		fprintf(fd, "%u", syscallno);
+	else
+		fprintf(fd, "%s", syscalls[syscallno].entry->name);
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
+	}
+}
\ No newline at end of file
-- 
1.8.4
