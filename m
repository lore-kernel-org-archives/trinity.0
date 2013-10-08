From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH 3/6] refactored output function
Date: Tue,  8 Oct 2013 14:26:52 -0700
Message-ID: <1381267615-9826-3-git-send-email-ildarm@google.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A3SSsu7xXlNf/o2trobm7xinpT5pzzaB+F1AeTMvbls=;
        b=DYsx3gPUhkepiNdxQla612mfcstrEsB+fOy1+aGDX3qzLCI8qvrhcWPjtZcDhD2zKP
         Uq40yFbyEvQIBCaY1knrzZUM7nvmK5pvLU+aA1X1mrdTKx54KeelDKHUocIGATpW6Vm/
         WHp6n8EyJOtlR20N8C6Trb13ZS8Yv3h/pHU6DeiBWW/3XwLHc60LqQhPGDf2oTtyQZb/
         oQeimFE/AI1GjgjdeqSlbNdGxcvqNPcyUfnd/TYifzx8OTfmJ+FZBcKFN6LnfHDcQcq6
         pnz4qGI33rtPOX8fQ7nzyRnES9KzNkofp1Pu2nnZxZVEISutkvnUF+KHTuMhubrEz1Xa
         UrjA==
In-Reply-To: <1381267615-9826-1-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Ildar Muslukhov <ildarm@google.com>

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 log.c | 77 ++++++++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 29 deletions(-)

diff --git a/log.c b/log.c
index 1298038..518dd81 100644
--- a/log.c
+++ b/log.c
@@ -10,7 +10,10 @@
 #include "pids.h"
 #include "log.h"
 
+#define BUFSIZE 1024
+
 FILE *mainlogfile;
+bool logfiles_opened = FALSE;
 
 void open_logfiles(void)
 {
@@ -36,6 +39,7 @@ void open_logfiles(void)
 		}
 	}
 	free(logfilename);
+	logfiles_opened = TRUE;
 }
 
 void close_logfiles(void)
@@ -124,6 +128,25 @@ void synclogs(void)
 	fsync(fileno(mainlogfile));
 }
 
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
 /*
  * level defines whether it gets displayed to the screen with printf.
  * (it always logs).
@@ -139,8 +162,8 @@ void output(unsigned char level, const char *fmt, ...)
 	FILE *handle;
 	unsigned int len, i, j;
 	pid_t pid;
-	char outputbuf[1024];
-	char monobuf[1024];
+	char outputbuf[BUFSIZE];
+	char monobuf[BUFSIZE];
 	char *prefix = NULL;
 	char watchdog_prefix[]="[watchdog]";
 	char init_prefix[]="[init]";
@@ -151,6 +174,7 @@ void output(unsigned char level, const char *fmt, ...)
 	if (logging == FALSE && level >= quiet_level)
 		return;
 
+	/* prefix preparation */
 	pid = getpid();
 	if (pid == watchdog_pid)
 		prefix = watchdog_prefix;
@@ -167,6 +191,7 @@ void output(unsigned char level, const char *fmt, ...)
 		prefix = child_prefix;
 	}
 
+	/* formatting output */
 	va_start(args, fmt);
 	n = vsnprintf(outputbuf, sizeof(outputbuf), fmt, args);
 	va_end(args);
@@ -176,49 +201,43 @@ void output(unsigned char level, const char *fmt, ...)
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
-		fprintf(handle, "%s %s", prefix, outputbuf);
-		(void)fflush(handle);
-		return;
-	}
-
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
+	if (monochrome == FALSE) {
+		/* copy buffer, sans ANSI codes */
+		len = strlen(outputbuf);
+		for (i = 0, j = 0; (i < len) && (i + 2 < BUFSIZE) && (j < BUFSIZE); i++) {
+			if (outputbuf[i] == '') {
+				if (outputbuf[i + 2] == '1')
+					i += 6;	// ANSI_COLOUR
+				else
+					i += 3;	// ANSI_RESET
+			} else {
+				monobuf[j] = outputbuf[i];
+				j++;
+			}
 		}
+		monobuf[j] = '\0';
+		fprintf(handle, "%s %s", prefix, monobuf);
+	} else {
+		fprintf(handle, "%s %s", prefix, outputbuf);
 	}
-	monobuf[j] = '\0';
 
-	fprintf(handle, "%s %s", prefix, monobuf);
 	(void)fflush(handle);
 }
 
-- 
1.8.4
