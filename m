From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 09/12] net/irda_setsockopt.c: workaround for old irda headers
Date: Wed, 16 Oct 2013 13:43:27 +0300
Message-ID: <1381920210-23329-9-git-send-email-mikko.rapeli@iki.fi>
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

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 net/irda_setsockopt.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/irda_setsockopt.c b/net/irda_setsockopt.c
index e6255b2..692ef52 100644
--- a/net/irda_setsockopt.c
+++ b/net/irda_setsockopt.c
@@ -1,5 +1,9 @@
 #include <stdlib.h>
 #include <sys/socket.h> /* old irda.h is broken */
+
+/* old irda.h does not include something which defines sa_family_t */
+#include <netinet/in.h>
+
 #include <linux/irda.h>
 #include "net.h"
 #include "maps.h"	// page_rand
-- 
1.7.9.5
