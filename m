From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 12/12] Makefile: install depends on trinity target
Date: Wed, 16 Oct 2013 13:43:30 +0300
Message-ID: <1381920210-23329-12-git-send-email-mikko.rapeli@iki.fi>
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

After this 'make install' just works.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 037a04e..b0bdb36 100644
--- a/Makefile
+++ b/Makefile
@@ -107,7 +107,7 @@ tarball:
 	git prune-packed
 	git archive --format=tar.gz --prefix=trinity-$(VERSION)/ HEAD > trinity-$(VERSION).tgz
 
-install:
+install: trinity
 	install -d -m 755 $(INSTALL_PREFIX)/bin
 	install trinity $(INSTALL_PREFIX)/bin
 
-- 
1.7.9.5
