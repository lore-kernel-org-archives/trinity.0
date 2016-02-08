From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Makefile: Use -std=gnu99 if -std=gnu11 is not supported.
Date: Mon,  8 Feb 2016 21:24:41 +0100
Message-ID: <1454963081-6500-1-git-send-email-vlee@freedesktop.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

-std=gnu11 is not available with gcc < 4.7.

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index a47e248..9fbdb94 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,9 @@ endif
 CC := $(CROSS_COMPILE)$(CC)
 LD := $(CROSS_COMPILE)$(LD)
 
-CFLAGS += -Wall -Wextra -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__ -std=gnu11
+CFLAGS += -Wall -Wextra -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__
+
+CFLAGS += $(shell if $(CC) -std=gnu11 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-std=gnu11"; else echo "-std=gnu99"; fi)
 
 # Only enabled during development, and on gcc 4.9+
 CPP_MAJOR := $(shell $(CPP) -dumpversion 2>&1 | cut -d'.' -f1)
-- 
1.7.9.5
