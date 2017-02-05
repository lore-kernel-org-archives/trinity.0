From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/5] Makefile: use findstring to check if we are building in development mode
Date: Sun,  5 Feb 2017 17:53:49 +0200
Message-ID: <20170205155352.13191-2-tt.rantala@gmail.com>
References: <20170205155352.13191-1-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OmW2XxET2ptfzR+aRfdUHfIkEGzCCNAjKNwXf5N3if8=;
        b=JUmexHX6c/OwP3phbDEqj+yyrIy+Ux45D+dA8eLC6U0a+UzI0rc53RRr96U9HEjuzM
         lh3wpIyBJJhmITTOW22tR+gJIkoWyYCz+EEuzJZNE5kvPYR8PWomsLWIn+1uzWTGHYzk
         W7CYR9LhiHhvMODgXNP6CkvO76cjDKmRHWiD2JSpEeAIMowx7MaVXq4J+QSOGuvoOerm
         weC5BoEBkte6ZBvz+YXvMqA6dJN0iTlI2069WTmeYFuwv/HZYKcCuhk4hyQL6eNeAYcM
         74NMVrg7GbBbJsjsmrVApPbMD0qhS0JJxZTHs2ra+BCzLE0odK09VC5Cot2bvfyDQQCD
         e+aA==
In-Reply-To: <20170205155352.13191-1-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 Makefile | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 16fafe8..8088608 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,11 @@
 VERSION="1.8pre"
 
+ifeq (,$(findstring pre,$(VERSION)))
+DEVEL = 0
+else
+DEVEL = 1
+endif
+
 INSTALL_PREFIX ?= $(DESTDIR)
 INSTALL_PREFIX ?= $(HOME)
 NR_CPUS := $(shell grep -c ^processor /proc/cpuinfo)
@@ -15,10 +21,11 @@ CFLAGS += -Wall -Wextra -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_
 CFLAGS += $(shell if $(CC) -std=gnu11 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-std=gnu11"; else echo "-std=gnu99"; fi)
 
 # Only enabled during development, and on gcc 4.9+
+ifeq ($(DEVEL), 1)
 CPP_MAJOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f1)
 CPP_MINOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f2)
-DEVEL	:= $(shell grep VERSION Makefile | head -n1 | grep pre | wc -l)
-CFLAGS	+= $(shell if [ $(CPP_MAJOR) -eq 5 -a $(CPP_MINOR) -ge 1 -a $(DEVEL) -eq 1 ] ; then echo "-Werror"; else echo ""; fi)
+CFLAGS	+= $(shell if [ $(CPP_MAJOR) -eq 5 -a $(CPP_MINOR) -ge 1 ] ; then echo "-Werror"; else echo ""; fi)
+endif
 
 ifneq ($(SYSROOT),)
 CFLAGS += --sysroot=$(SYSROOT)
@@ -46,7 +53,9 @@ LDLIBS += -lrt
 ifneq ($(shell $(CC) -v 2>&1 | grep -c "clang"), 1)
 CFLAGS += -Wlogical-op
 CFLAGS += -Wstrict-aliasing=3
-CFLAGS += $(shell if [ $(DEVEL) -eq 0 ]; then echo "-Wno-maybe-uninitialized"; else echo ""; fi)
+ifeq ($(DEVEL), 0)
+CFLAGS += -Wno-maybe-uninitialized
+endif
 endif
 
 # Sometimes useful for debugging. more useful with clang than gcc.
-- 
2.9.3
