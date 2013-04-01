From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 8/9] Fix SYSCALLS_ARCH
Date: Mon,  1 Apr 2013 21:58:38 +0300
Message-ID: <1364842720-24127-8-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=0M4Q3BJKcNDn9nV9a26W4AB1baJx9mDlgkrFmoaCCOk=;
        b=tP6onDfDc+hGMiI2jHA53ExHpgCRzTDeIzQuGyX3ZyQ+fozLnsKMM+M+Lbw3a64h9V
         feOJnExkUyKPPbmcH0UZ6yI7SNwBl5NuSV+YaPtNWmho8TfTW4pxAYy/YSljRv8NzPNZ
         goiD1ZF31yI5MgWrlK1EcjdujaK5RPly1w5QCgAGlD3Yy7MgISCN9zXxBQQIefTezVnW
         Ut7FFbAjB9grpwnabU1ifyCuAsREnTPuEqbIm+hlAgRdyIWrPmoN8T/TkhlZWNFWE5+E
         G6xcrR3aCLRZUzkEEBwHFtW0DIW203fA7f+1cxZxbyOpa1+C/idr/K04RiBokwEGcicM
         e3WA==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

SuperH compilation was broken, since we are adding SYSCALLS_ARCH to
SRCS, and expect SRCS to only contain *.c files.
---
 Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 69c9ab1..1320eb0 100644
--- a/Makefile
+++ b/Makefile
@@ -33,9 +33,9 @@ test:
 
 
 MACHINE		= $(shell $(CC) -dumpmachine)
-SYSCALLS_ARCH	= $(patsubst %.c,%.o,$(shell case "$(MACHINE)" in \
+SYSCALLS_ARCH	= $(shell case "$(MACHINE)" in \
 		  (sh*) echo syscalls/sh/*.c ;; \
-		  esac))
+		  esac)
 
 HEADERS		= $(patsubst %.h,%.h,$(wildcard *.h)) $(patsubst %.h,%.h,$(wildcard syscalls/*.h)) $(patsubst %.h,%.h,$(wildcard ioctls/*.h))
 
@@ -46,7 +46,7 @@ SRCS		= $(wildcard *.c) \
 
 OBJS		= $(patsubst %.c,%.o,$(wildcard *.c)) \
 		  $(patsubst %.c,%.o,$(wildcard syscalls/*.c)) \
-		  $(SYSCALLS_ARCH) \
+		  $(patsubst %.c,%.o,$(SYSCALLS_ARCH)) \
 		  $(patsubst %.c,%.o,$(wildcard ioctls/*.c))
 
 DEPDIR= .deps
-- 
1.7.9.5
