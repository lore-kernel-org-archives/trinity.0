From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] scripts/gen-versionh.sh: Explicitly use bash.
Date: Thu, 10 Jul 2014 16:24:54 -0700
Message-ID: <1405034694-13763-1-git-send-email-vlee@twopensource.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

From: Vinson Lee <vlee@twitter.com>

Fix build error on Ubuntu.

scripts/gen-versionh.sh: 34: [: 1: unexpected operator

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 scripts/gen-versionh.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gen-versionh.sh b/scripts/gen-versionh.sh
index c531767..09d4fe5 100755
--- a/scripts/gen-versionh.sh
+++ b/scripts/gen-versionh.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 HEADER="include/version.h"
 
-- 
1.7.9.5
