From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] converted COLOR_ARG macro to a function
Date: Tue, 1 Oct 2013 10:54:39 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310011052210.7238@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=ZQbT7fXaVqM5VEkgIdMHopJvq+HCmSbc0m7pFSfFVdU=;
        b=LjXhdDYC4Lvtl7wJn/EOFy9IrXAywVTo0kfjGTAKaZi3El/YONygs/lTMqHj5Yuknv
         cppME5+MI9bbY3JBK9MqvOGEksBigtLeN2/tdVj/cJIb84JX4L7wByJ/QwXwX2VNNGES
         GoCSFHgybx0PY5flLQEVe3lps6b0RvQdArPzPFjcEyUdKGpSdZEZ6IGrNYrVFB4i2C+L
         Qf2uAaxB4eCtaHCx7qSPoxm1S1P+dMVNPpUvqyVT63j25zjP4H0ofJzujiRiVVQAFPkj
         +roRaK7pu1GlMHNCJfl+hE4amjEZ8EkQDtY5rthYawd5ASRJNcLDEe2VsMPnoTadbVwK
         TbIQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


Revised the previous patch that refactors COLOR_ARG macro into a function.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/log.h |   2 +
 syscall.c     | 156 ++++++++++++++++++++++++++++++----------------------------
 2 files changed, 82 insertions(+), 76 deletions(-)

diff --git a/include/log.h b/include/log.h
index f3fc7c4..2497988 100644
--- a/include/log.h
+++ b/include/log.h
@@ -19,6 +19,8 @@
 #define WHITE if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_WHITE);
 #define CRESET if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_RESET);
 
+#define CRESETPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_RESET);
+
 #define MAX_LOGLEVEL 3
 unsigned int highest_logfile(void);
 void synclogs(void);
diff --git a/syscall.c b/syscall.c
index 824102a..71f0a16 100644
--- a/syscall.c
+++ b/syscall.c
@@ -131,6 +131,71 @@ static unsigned long do_syscall(int childno, int *errno_saved)
 	return ret;
 }
 
+static void color_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, char **sptr)
+{
+	if (syscalls[call].entry->num_args >= argnum) {
+		if (!name)
+			return;
+
+		if (argnum != 1) {
+			CRESETPTR
+			*sptr += sprintf(*sptr, ", ");
+		}
+		if (name)
+			*sptr += sprintf(*sptr, "%s=", name);
+
+		if (oldreg == reg) {
+			CRESETPTR
+		} else {
+			*sptr += sprintf(*sptr, "%s", ANSI_CYAN);
+		}
+
+		switch (type) {
+		case ARG_PATHNAME:
+			*sptr += sprintf(*sptr, "\"%s\"", (char *) reg);
+			break;
+		case ARG_PID:
+		case ARG_FD:
+			CRESETPTR
+			*sptr += sprintf(*sptr, "%ld", reg);
+			break;
+		case ARG_MODE_T:
+			CRESETPTR
+			*sptr += sprintf(*sptr, "%o", (mode_t) reg);
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
+				*sptr += sprintf(*sptr, "0x%lx", reg);
+			else
+				*sptr += sprintf(*sptr, "%ld", reg);
+				CRESETPTR
+			break;
+		}
+		if (reg == (((unsigned long)page_zeros) & PAGE_MASK))
+			*sptr += sprintf(*sptr, "[page_zeros]");
+		if (reg == (((unsigned long)page_rand) & PAGE_MASK))
+			*sptr += sprintf(*sptr, "[page_rand]");
+		if (reg == (((unsigned long)page_0xff) & PAGE_MASK))
+			*sptr += sprintf(*sptr, "[page_0xff]");
+		if (reg == (((unsigned long)page_allocs) & PAGE_MASK))
+			*sptr += sprintf(*sptr, "[page_allocs]");
+	}
+}
+
 /*
  * Generate arguments, print them out, then call the syscall.
  */
@@ -168,85 +233,24 @@ long mkcall(int childno)
 	if (syscalls[call].entry->sanitise)
 		syscalls[call].entry->sanitise(childno);
 
-/*
- * I *really* loathe how this macro has grown. It should be a real function one day.
- */
-#define COLOR_ARG(ARGNUM, NAME, BIT, OLDREG, REG, TYPE)			\
-	if ((logging == FALSE) && (quiet_level < MAX_LOGLEVEL))		\
-		goto args_done;						\
-									\
-	if (syscalls[call].entry->num_args >= ARGNUM) {			\
-		if (!NAME)						\
-			goto args_done;					\
-		if (ARGNUM != 1) {					\
-			CRESET						\
-			sptr += sprintf(sptr, ", ");			\
-		}							\
-		if (NAME)						\
-			sptr += sprintf(sptr, "%s=", NAME);		\
-									\
-		if (OLDREG == REG) {					\
-			CRESET						\
-		} else {						\
-			CYAN						\
-		}							\
-									\
-		switch(TYPE) {						\
-		case ARG_PATHNAME:					\
-			sptr += sprintf(sptr, "\"%s\"", (char *) REG);	\
-			break;						\
-		case ARG_PID:						\
-		case ARG_FD:						\
-			CRESET						\
-			sptr += sprintf(sptr, "%ld", REG);		\
-			break;						\
-		case ARG_MODE_T:					\
-			CRESET						\
-			sptr += sprintf(sptr, "%o", (mode_t) REG);	\
-			break;						\
-		case ARG_UNDEFINED:					\
-		case ARG_LEN:						\
-		case ARG_ADDRESS:					\
-		case ARG_NON_NULL_ADDRESS:				\
-		case ARG_RANGE:						\
-		case ARG_OP:						\
-		case ARG_LIST:						\
-		case ARG_RANDPAGE:					\
-		case ARG_CPU:						\
-		case ARG_RANDOM_LONG:					\
-		case ARG_IOVEC:						\
-		case ARG_IOVECLEN:					\
-		case ARG_SOCKADDR:					\
-		case ARG_SOCKADDRLEN:					\
-		default:						\
-			if (REG > 8 * 1024)				\
-				sptr += sprintf(sptr, "0x%lx", REG);	\
-			else						\
-				sptr += sprintf(sptr, "%ld", REG);	\
-			CRESET						\
-			break;						\
-		}							\
-		if (REG == (((unsigned long)page_zeros) & PAGE_MASK))	\
-			sptr += sprintf(sptr, "[page_zeros]");		\
-		if (REG == (((unsigned long)page_rand) & PAGE_MASK))	\
-			sptr += sprintf(sptr, "[page_rand]");		\
-		if (REG == (((unsigned long)page_0xff) & PAGE_MASK))	\
-			sptr += sprintf(sptr, "[page_0xff]");		\
-		if (REG == (((unsigned long)page_allocs) & PAGE_MASK))	\
-			sptr += sprintf(sptr, "[page_allocs]");		\
+	if ((logging == TRUE) && (quiet_level == MAX_LOGLEVEL)) {
+		CRESET
+		sptr += sprintf(sptr, "(");
+		color_arg(call, 1, syscalls[call].entry->arg1name, olda1, shm->a1[childno],
+				syscalls[call].entry->arg1type, &sptr);
+		color_arg(call, 2, syscalls[call].entry->arg2name, olda2, shm->a2[childno],
+				syscalls[call].entry->arg2type, &sptr);
+		color_arg(call, 3, syscalls[call].entry->arg3name, olda3, shm->a3[childno],
+				syscalls[call].entry->arg3type, &sptr);
+		color_arg(call, 4, syscalls[call].entry->arg4name, olda4, shm->a4[childno],
+				syscalls[call].entry->arg4type, &sptr);
+		color_arg(call, 5, syscalls[call].entry->arg5name, olda5, shm->a5[childno],
+				syscalls[call].entry->arg5type, &sptr);
+		color_arg(call, 6, syscalls[call].entry->arg6name, olda6, shm->a6[childno],
+				syscalls[call].entry->arg6type, &sptr);
 	}
 
 	CRESET
-	sptr += sprintf(sptr, "(");
-
-	COLOR_ARG(1, syscalls[call].entry->arg1name, 1<<5, olda1, shm->a1[childno], syscalls[call].entry->arg1type);
-	COLOR_ARG(2, syscalls[call].entry->arg2name, 1<<4, olda2, shm->a2[childno], syscalls[call].entry->arg2type);
-	COLOR_ARG(3, syscalls[call].entry->arg3name, 1<<3, olda3, shm->a3[childno], syscalls[call].entry->arg3type);
-	COLOR_ARG(4, syscalls[call].entry->arg4name, 1<<2, olda4, shm->a4[childno], syscalls[call].entry->arg4type);
-	COLOR_ARG(5, syscalls[call].entry->arg5name, 1<<1, olda5, shm->a5[childno], syscalls[call].entry->arg5type);
-	COLOR_ARG(6, syscalls[call].entry->arg6name, 1<<0, olda6, shm->a6[childno], syscalls[call].entry->arg6type);
-args_done:
-	CRESET
 	sptr += sprintf(sptr, ") ");
 	*sptr = '\0';
 
-- 
1.8.4
