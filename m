From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 3/5] Makefile: improve build time with immediate variables
Date: Sun,  5 Feb 2017 17:53:50 +0200
Message-ID: <20170205155352.13191-3-tt.rantala@gmail.com>
References: <20170205155352.13191-1-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CMhRKR3qp1sflfQGDNelcynMwHzCMgpyR4JBdMk3zKM=;
        b=Pxz0WMkL8sBiO3Isxyvy0Gb5r0hAYxOo3x6z0EpwXmmkLHGEWfWq6zKwzIDVo7Ozq7
         UG3fhCC4kV1N+HcebsgIwuF7SJb5W8Y/Ry8oQwQfsDvEVSNM2qKNgRhMJZrlxYhkQLwU
         g+SAwmbIa5Utg/bULpkxGJp9IiqzuZGh8SUk+q2OlSSrUMKgBCRplNSexhdx79q7sBbR
         I339dHk8hx688M8lUkhtGHok5995SMaadKcGs33IRH+ZVeT+N+jNMa8LK3ZjsWAO+NJR
         F5phEPnhNP+3wUtfAFPXBLbYIAMRjGQNilc73+IR+CgfCjmSn/gKXqnYx0O+yni6jB02
         WIkA==
In-Reply-To: <20170205155352.13191-1-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

It looks like "CFLAGS += $(shell ..." is a bad idea, as make will repeat the
shell expansion again and again during the build.

Use immediate variables where we can to avoid the issue.

make -j4 before this patch:
real	0m10.774s
user	0m24.541s
sys	0m10.676s

make -j4 with this patch:
real	0m8.173s
user	0m20.817s
sys	0m7.632s
---
 Makefile | 74 +++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/Makefile b/Makefile
index 8088608..8a061b1 100644
--- a/Makefile
+++ b/Makefile
@@ -18,13 +18,15 @@ LD := $(CROSS_COMPILE)$(LD)
 
 CFLAGS += -Wall -Wextra -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__
 
-CFLAGS += $(shell if $(CC) -std=gnu11 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-std=gnu11"; else echo "-std=gnu99"; fi)
+CCSTD := $(shell if $(CC) -std=gnu11 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-std=gnu11"; else echo "-std=gnu99"; fi)
+CFLAGS += $(CCSTD)
 
 # Only enabled during development, and on gcc 4.9+
 ifeq ($(DEVEL), 1)
 CPP_MAJOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f1)
 CPP_MINOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f2)
-CFLAGS	+= $(shell if [ $(CPP_MAJOR) -eq 5 -a $(CPP_MINOR) -ge 1 ] ; then echo "-Werror"; else echo ""; fi)
+WERROR	:= $(shell if [ $(CPP_MAJOR) -eq 5 -a $(CPP_MINOR) -ge 1 ] ; then echo "-Werror"; else echo ""; fi)
+CFLAGS	+= $(WERROR)
 endif
 
 ifneq ($(SYSROOT),)
@@ -75,40 +77,40 @@ test:
 	@if [ ! -f config.h ]; then  echo "[1;31mRun configure.sh first.[0m" ; exit; fi
 
 
-MACHINE		= $(shell $(CC) -dumpmachine)
-SYSCALLS_ARCH	= $(shell case "$(MACHINE)" in \
-		  (sh*) echo syscalls/sh/*.c ;; \
-		  (ia64*) echo syscalls/ia64/*.c ;; \
-		  (ppc*|powerpc*) echo syscalls/ppc/*.c ;; \
-		  (sparc*) echo syscalls/sparc/*.c ;; \
-		  (x86_64*) echo syscalls/x86/*.c \
-				 syscalls/x86/i386/*.c \
-				 syscalls/x86/x86_64/*.c;; \
-		  (i?86*) echo syscalls/x86/*.c \
-			       syscalls/x86/i386/*.c;; \
-		  esac)
-
-HEADERS		= $(patsubst %.h,%.h,$(wildcard *.h)) $(patsubst %.h,%.h,$(wildcard syscalls/*.h)) $(patsubst %.h,%.h,$(wildcard ioctls/*.h))
-
-SRCS		= $(wildcard *.c) \
-		  $(wildcard childops/*.c) \
-		  $(wildcard fds/*.c) \
-		  $(wildcard ioctls/*.c) \
-		  $(wildcard mm/*.c) \
-		  $(wildcard net/*.c) \
-		  $(wildcard rand/*.c) \
-		  $(wildcard syscalls/*.c) \
-		  $(SYSCALLS_ARCH)
-
-OBJS		= $(sort $(patsubst %.c,%.o,$(wildcard *.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard childops/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard fds/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard ioctls/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard mm/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard net/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard rand/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(wildcard syscalls/*.c))) \
-		  $(sort $(patsubst %.c,%.o,$(SYSCALLS_ARCH)))
+MACHINE		:= $(shell $(CC) -dumpmachine)
+SYSCALLS_ARCH	:= $(shell case "$(MACHINE)" in \
+		   (sh*) echo syscalls/sh/*.c ;; \
+		   (ia64*) echo syscalls/ia64/*.c ;; \
+		   (ppc*|powerpc*) echo syscalls/ppc/*.c ;; \
+		   (sparc*) echo syscalls/sparc/*.c ;; \
+		   (x86_64*) echo syscalls/x86/*.c \
+				  syscalls/x86/i386/*.c \
+				  syscalls/x86/x86_64/*.c;; \
+		   (i?86*) echo syscalls/x86/*.c \
+			        syscalls/x86/i386/*.c;; \
+		   esac)
+
+HEADERS		:= $(patsubst %.h,%.h,$(wildcard *.h)) $(patsubst %.h,%.h,$(wildcard syscalls/*.h)) $(patsubst %.h,%.h,$(wildcard ioctls/*.h))
+
+SRCS		:= $(wildcard *.c) \
+		   $(wildcard childops/*.c) \
+		   $(wildcard fds/*.c) \
+		   $(wildcard ioctls/*.c) \
+		   $(wildcard mm/*.c) \
+		   $(wildcard net/*.c) \
+		   $(wildcard rand/*.c) \
+		   $(wildcard syscalls/*.c) \
+		   $(SYSCALLS_ARCH)
+
+OBJS		:= $(sort $(patsubst %.c,%.o,$(wildcard *.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard childops/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard fds/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard ioctls/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard mm/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard net/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard rand/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(wildcard syscalls/*.c))) \
+		   $(sort $(patsubst %.c,%.o,$(SYSCALLS_ARCH)))
 
 DEPDIR= .deps
 
-- 
2.9.3
