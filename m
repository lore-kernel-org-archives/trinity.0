From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH 6/6] wired syscall parameters logging function into syscall (this should fix stack smash bug detected)
Date: Tue,  8 Oct 2013 14:26:55 -0700
Message-ID: <1381267615-9826-6-git-send-email-ildarm@google.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BKI5qpLpTvQxov/to1AzeAzsLzsJaohPE8IqfoUzZKI=;
        b=jEwAdlgNesYrb2u5d8G570CZhJG8VL2Llj3vCVXnF/YO0KEO7kFjgihFMdWLNoF0XM
         6NUErkC+tV8BpyBnxjr6/7aHSlsiRg13Gj0oZfwbdG8ksyHV7j4+vYggUiKZdC6Jkr3A
         fNd/dcPRFufZHE1UFC6e9MjpYn0YbcjnUGR4y6HV+eXnyWejBXsd8D598L1Z0czST2mT
         9Rb0HcijEHxBxCisCYOK8M8mSNF4Y25U1fl2W2eEM/zc2z3nY0wxbFNNwi3XO2gsFeLV
         4E8Nzx17HGYSvuhZ7wU1nPRtjH26874YmOhzCo5EX7YIR5v882WfYh7aWzxIZ6sEXMgc
         zsnw==
In-Reply-To: <1381267615-9826-1-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Ildar Muslukhov <ildarm@google.com>

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/log.h |   3 --
 log.c         |  63 +++++++++++++++++++++++++-
 syscall.c     | 139 +++++-----------------------------------------------------
 3 files changed, 72 insertions(+), 133 deletions(-)

diff --git a/include/log.h b/include/log.h
index 76b825e..bc870ab 100644
--- a/include/log.h
+++ b/include/log.h
@@ -21,8 +21,6 @@
 #define WHITE if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_WHITE);
 #define CRESET if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_RESET);
 
-#define CRESETPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_RESET);
-
 #define REDFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_RED);
 #define GREENFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_GREEN);
 #define CRESETFD if (mono == FALSE)	fprintf(fd, "%s", ANSI_RESET);
@@ -48,7 +46,6 @@ void close_logfiles(void);
 #define BUGTXT ANSI_RED "BUG!: " ANSI_RESET GIT_VERSION
 #endif
 
-
 #define BUG(bugtxt)	{ printf("%s:%s:%d %s", __FILE__, __func__, __LINE__, bugtxt); while(1); }
 
 #endif	/* _LOG_H */
diff --git a/log.c b/log.c
index 2a9c140..6340d59 100644
--- a/log.c
+++ b/log.c
@@ -133,6 +133,68 @@ void synclogs(void)
 
 static void output_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, FILE *fd, bool mono)
 {
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
 }
 
 static FILE *robust_find_logfile_handle(void)
@@ -202,7 +264,6 @@ void output(unsigned char level, const char *fmt, ...)
 	va_start(args, fmt);
 	n = vsnprintf(outputbuf, sizeof(outputbuf), fmt, args);
 	va_end(args);
-
 	if (n < 0) {
 		outputerr("## Something went wrong in output() [%d]\n", n);
 		exit(EXIT_FAILURE);
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
 
-- 
1.8.4
