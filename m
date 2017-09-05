From: Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH] net/proto-rds.c: rds_setsockopt() stub not needed
Date: Tue,  5 Sep 2017 14:57:56 +0300
Message-ID: <20170905115756.3145-1-tommi.t.rantala@nokia.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tv19hSNAiUQIcwC3mbikBaOyItwQVj5ZzRSG2IgTjfo=;
 b=f/iaC7xNiY+nAeGVPZ6/nzkU7rKi04+j4TVzf//+a4ThP2hsj5vdzd0VBDpsJCaAaJF6D4qlTwfA3NcfBKCK1bUIQ3hAs8LwemtBn8LqLiymEzZeLYX8KcPDL1UmrJw789ZBEIAzmI0au4hkzbTyMGw0McMNWQ23f8mjc7kWMFI=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>

The stub function is not needed, and we can #ifdef the whole file.

Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
---
 net/proto-rds.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/proto-rds.c b/net/proto-rds.c
index fd7746f8..7033ae65 100644
--- a/net/proto-rds.c
+++ b/net/proto-rds.c
@@ -1,10 +1,7 @@
-#include <stdlib.h>
-#include "net.h"
-
 #ifdef USE_RDS
 #include <linux/rds.h>
-#endif
-
+#include <stdlib.h>
+#include "net.h"
 #include "compat.h"
 #include "random.h"
 #include "utils.h"	// RAND_ARRAY
@@ -23,7 +20,6 @@ static void rds_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 	*addrlen = sizeof(struct sockaddr_in);
 }
 
-#ifdef USE_RDS
 static const unsigned int rds_opts[] = {
 	RDS_CANCEL_SENT_TO, RDS_GET_MR, RDS_FREE_MR,
 	4, /* deprecated RDS_BARRIER 4 */
@@ -49,9 +45,4 @@ const struct netproto proto_rds = {
 	.valid_triplets = rds_triplet,
 	.nr_triplets = ARRAY_SIZE(rds_triplet),
 };
-#else
-/* stub if we are built on something without RDS headers */
-void rds_setsockopt(struct sockopt *so)
-{
-}
 #endif	/* USE_RDS */
-- 
2.13.5
