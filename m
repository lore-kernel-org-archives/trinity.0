From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 02/12] configure.sh: use gcc as default compiler
Date: Wed, 16 Oct 2013 13:43:20 +0300
Message-ID: <1381920210-23329-2-git-send-email-mikko.rapeli@iki.fi>
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

Cross compilers might not have cc symlink but do have gcc.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 configure.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.sh b/configure.sh
index d7f16cb..c1a5ad2 100755
--- a/configure.sh
+++ b/configure.sh
@@ -10,7 +10,7 @@ fi
 
 MISSING_DEFS=0
 
-[ -z "$CC" ] && CC=cc
+[ -z "$CC" ] && CC=gcc
 
 CC=${CROSS_COMPILE}${CC}
 
-- 
1.7.9.5
