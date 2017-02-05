From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 4/5] Makefile: -Werror also for gcc 6.x
Date: Sun,  5 Feb 2017 17:53:51 +0200
Message-ID: <20170205155352.13191-4-tt.rantala@gmail.com>
References: <20170205155352.13191-1-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c75Ttw6/J0nTzIYQNziEQVDMDHte7qrTgEZ/B3wek9k=;
        b=QnHgkDBz8ubQhuP/K0Sesa6Gpr0Ix9RvOgCx5fU+ngIe757Wqcaa90QThMS1DMdvIk
         I7fVsTccwXQMleOs8cayNpI8VuGj4C59ZYpdKHvRjfE0tpj+moD7ZuXkiJh8Lcm9Xef5
         R6UxEie344NDgrIlPahhdV5Bmscb6Z36NjDi0NdJxpRu+bX6HSH+9X6lNWTMz83ePjqk
         DNXwk9OniFLuKOisbG8tHpR7F3NuzC3fghaeT8R0CVgGFKTy4J4GlWSd3Our4TKQPmBg
         fwcpukL2LrBVK2LE+E1onpBF+tx9oEuE/LKKUlx04M+bJXCtuQuy/FqmKJvtbqwiey2+
         YSdQ==
In-Reply-To: <20170205155352.13191-1-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 8a061b1..1fc8799 100644
--- a/Makefile
+++ b/Makefile
@@ -21,11 +21,11 @@ CFLAGS += -Wall -Wextra -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_
 CCSTD := $(shell if $(CC) -std=gnu11 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-std=gnu11"; else echo "-std=gnu99"; fi)
 CFLAGS += $(CCSTD)
 
-# Only enabled during development, and on gcc 4.9+
+# -Werror only enabled during development, and on gcc 5.1+
 ifeq ($(DEVEL), 1)
 CPP_MAJOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f1)
 CPP_MINOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f2)
-WERROR	:= $(shell if [ $(CPP_MAJOR) -eq 5 -a $(CPP_MINOR) -ge 1 ] ; then echo "-Werror"; else echo ""; fi)
+WERROR	:= $(shell if [ $(CPP_MAJOR) -eq 5 -a $(CPP_MINOR) -ge 1 ] || [ $(CPP_MAJOR) -ge 6 ] ; then echo "-Werror"; else echo ""; fi)
 CFLAGS	+= $(WERROR)
 endif
 
-- 
2.9.3
