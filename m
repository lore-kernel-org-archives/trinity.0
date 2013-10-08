From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH 1/6] added outputerr/outputstd log functions
Date: Tue,  8 Oct 2013 14:26:50 -0700
Message-ID: <1381267615-9826-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=Oe3RLpjiV/Tb6MxYJ0SpsXoy2PiI7rVflM8USCdv58s=;
        b=SthrbCc6fLjoy9c7kUp7BT6QI2iuG4wBYVfjCyobgeitG2wJ9IvVBcJ/nsiFiVvfjY
         ChOR3fbtsxQaP3ofc8zeZFW4PCTODZy7cdTEe1l5AtFW2iwvI64BPVY2/Dpv9ISY5232
         hocsuPPXjKxbUqTa5txSK1ANpqUT/EIfI5wElrA+7gT/0409CNHpX3BNZiqL8oqwdkot
         gMbBZqiej/9LEKaldfObMnmUK0gHP4nshjyq2WTQOXh4tmoO4zhS9P4ExSsOnYIgQiCx
         GgygJQ9JwYXTYjtGHeZUt41JOEtLIqEYx8IMlCjGEBuqAeuE81JCt/CO5LUyGrvspt0z
         /wDQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Ildar Muslukhov <ildarm@google.com>

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/log.h |  2 ++
 log.c         | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/log.h b/include/log.h
index 2497988..7041eda 100644
--- a/include/log.h
+++ b/include/log.h
@@ -25,6 +25,8 @@
 unsigned int highest_logfile(void);
 void synclogs(void);
 void output(unsigned char level, const char *fmt, ...);
+void outputerr(const char *fmt, ...);
+void outputstd(const char *fmt, ...);
 void open_logfiles(void);
 void close_logfiles(void);
 
diff --git a/log.c b/log.c
index 850a3e2..144567a 100644
--- a/log.c
+++ b/log.c
@@ -221,3 +221,25 @@ void output(unsigned char level, const char *fmt, ...)
 	fprintf(handle, "%s %s", prefix, monobuf);
 	(void)fflush(handle);
 }
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
-- 
1.8.4
