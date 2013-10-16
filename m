From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 07/12] Makefile: support sysroot for libs and includes
Date: Wed, 16 Oct 2013 13:43:25 +0300
Message-ID: <1381920210-23329-7-git-send-email-mikko.rapeli@iki.fi>
References: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: mikko.rapeli@iki.fi

Helps with cross compilation when correct lib and include files
are used.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index eb7ac9a..037a04e 100644
--- a/Makefile
+++ b/Makefile
@@ -7,7 +7,10 @@ CC := gcc
 CC := $(CROSS_COMPILE)$(CC)
 LD := $(CROSS_COMPILE)$(LD)
 
-CFLAGS = -Wall -W -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE
+CFLAGS := -Wall -W -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE
+ifneq ($(SYSROOT),)
+CFLAGS += --sysroot=$(SYSROOT)
+endif
 #CFLAGS += $(shell if $(CC) -m32 -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-m32"; fi)
 CFLAGS += -Wdeclaration-after-statement
 CFLAGS += -Wformat=2
-- 
1.7.9.5
