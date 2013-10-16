From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 01/12] configure.sh: use colors only with terminal
Date: Wed, 16 Oct 2013 13:43:19 +0300
Message-ID: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org
Cc: mikko.rapeli@iki.fi

The color codes mess up less and log files.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 configure.sh |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/configure.sh b/configure.sh
index 3b3823f..d7f16cb 100755
--- a/configure.sh
+++ b/configure.sh
@@ -2,9 +2,11 @@
 
 DEVEL=0
 
-RED="[1;31m"
-GREEN="[1;32m"
-COL_RESET="[0;m"
+if [ -t 1 ]; then
+	RED="[1;31m"
+	GREEN="[1;32m"
+	COL_RESET="[0;m"
+fi
 
 MISSING_DEFS=0
 
-- 
1.7.9.5
