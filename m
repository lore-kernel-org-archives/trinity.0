From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 06/12] Makefile: use gcc as compiler
Date: Wed, 16 Oct 2013 13:43:24 +0300
Message-ID: <1381920210-23329-6-git-send-email-mikko.rapeli@iki.fi>
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

Cross compilers might not have cc symlink to gcc.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 298065c..eb7ac9a 100644
--- a/Makefile
+++ b/Makefile
@@ -3,6 +3,7 @@ VERSION=1.3pre
 INSTALL_PREFIX ?= $(DESTDIR)
 INSTALL_PREFIX ?= $(HOME)
 
+CC := gcc
 CC := $(CROSS_COMPILE)$(CC)
 LD := $(CROSS_COMPILE)$(LD)
 
-- 
1.7.9.5
