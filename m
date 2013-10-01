From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] converted COLOR_ARG macro to a function
Date: Mon, 30 Sep 2013 17:43:01 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309301739430.17550@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=7RkEHz2Qighdqp28ZV+RNB3kHXUbrObGQDPth3cH7/A=;
        b=M/CpPh/7QHi9cAt/QFYdtlkHuL0ZLqvJ4lshPz4qaU+baXjupzH+MMTS+n+O3MPqwX
         UWawkH3vykfb0UFpPdnmC/nioVb50vOi3d3uG1PNH2RobliL9J1Om2IwC+N4lANi/wqQ
         k8eVisvgt5/+4X3u+J7fThGrqdcNrWc5u1I9iLQHl6gfFlIegwxrB91s61dxKdXCRauy
         LhhC97hUzsez2JT0udakZghWKnsFt5Cqj6wdeGeyMy/SyW0+9VaTJw0czCfHA8p5MfHT
         Qz1fX1q7FPj4dhyFJPuxD7iVGZSVkli6hHg92cb/MnaIpe0NqgGBmgZfjft29TdZCI0j
         PfQQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch converts COLOR_ARG macro to a function. The sole purpose is to 
make the code a bit more readable.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/log.h |   3 ++
 syscall.c     | 164 ++++++++++++++++++++++++++++++----------------------------
 2 files changed, 87 insertions(+), 80 deletions(-)

diff --git a/include/log.h b/include/log.h
index f3fc7c4..627985c 100644
--- a/include/log.h
+++ b/include/log.h
@@ -19,6 +19,9 @@
 #define WHITE if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_WHITE);
 #define CRESET if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_RESET);
 
+#define CYANPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_CYAN);
+#define CRESETPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_RESET);
+
 #define MAX_LOGLEVEL 3
 unsigned int highest_logfile(void);
 void synclogs(void);
diff --git a/syscall.c b/syscall.c
index 824102a..b0611f5 100644
--- a/syscall.c
+++ b/syscall.c
@@ -41,14 +41,14 @@ long syscall32(int num_args, unsigned int call,
 
 	if (num_args <= 6) {
 		long __res;
-#if defined( __i386__)
+#if defined(__i386__)
 		__asm__ volatile (
 			"pushl %%ebp\n\t"
 			"movl %7, %%ebp\n\t"
 			"int $0x80\n\t"
 			"popl %%ebp\n\t"
 			: "=a" (__res)
-			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),"d" ((long)(a3)), "S" ((long)(a4)),"D" ((long)(a5)), "g" ((long)(a6))
+			: "0" (call), "b" ((long)(a1)), "c" ((long)(a2)), "d" ((long)(a3)), "S" ((long)(a4)), "D" ((long)(a5)), "g" ((long)(a6))
 			: "%ebp" /* mark EBP reg as dirty */
 			);
 #elif defined(__x86_64__)
@@ -58,7 +58,7 @@ long syscall32(int num_args, unsigned int call,
 			"int $0x80\n\t"
 			"popq %%rbp\n\t"
 			: "=a" (__res)
-			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),"d" ((long)(a3)), "S" ((long)(a4)),"D" ((long)(a5)), "g" ((long)(a6))
+			: "0" (call), "b" ((long)(a1)), "c" ((long)(a2)), "d" ((long)(a3)), "S" ((long)(a4)), "D" ((long)(a5)), "g" ((long)(a6))
 			: "%rbp" /* mark EBP reg as dirty */
 			);
 #else
@@ -73,7 +73,7 @@ long syscall32(int num_args, unsigned int call,
 	UNUSED(a5);
 	UNUSED(a6);
 #endif
-		__syscall_return(long,__res);
+		__syscall_return(long, __res);
 	}
 #else
 
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
+			CYANPTR
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
