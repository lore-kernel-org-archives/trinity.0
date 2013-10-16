From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 04/12] configure.sh: show error output when something is not found
Date: Wed, 16 Oct 2013 13:43:22 +0300
Message-ID: <1381920210-23329-4-git-send-email-mikko.rapeli@iki.fi>
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

It can be a configuration or ortherwise important warning/error.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 configure.sh |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure.sh b/configure.sh
index 824abea..3bececc 100755
--- a/configure.sh
+++ b/configure.sh
@@ -32,6 +32,7 @@ check_header()
 		echo "#define $2 1" >> config.h
 	else
 		echo $RED "[NO]" $COL_RESET
+		cat "$TMP.log"
 		MISSING_DEFS=1
 	fi
 }
@@ -68,6 +69,7 @@ ${CC} "$TMP.c" -o "$TMP" &>"$TMP.log"
 
 if [ ! -x "$TMP" ]; then
 	echo $RED "[NO]" $COL_RESET
+	cat "$TMP.log"
 	MISSING_DEFS=1
 else
 	echo $GREEN "[YES]" $COL_RESET
@@ -97,6 +99,7 @@ ${CC} "$TMP.c" -o "$TMP" &>"$TMP.log"
 
 if [ ! -x "$TMP" ]; then
 	echo $RED "[NO]" $COL_RESET
+	cat "$TMP.log"
 	MISSING_DEFS=1
 else
 	echo $GREEN "[YES]" $COL_RESET
@@ -126,6 +129,7 @@ ${CC} "$TMP.c" -o "$TMP" &>"$TMP.log"
 
 if [ ! -x "$TMP" ]; then
 	echo $RED "[NO]" $COL_RESET
+	cat "$TMP.log"
 	MISSING_DEFS=1
 else
 	echo $GREEN "[YES]" $COL_RESET
@@ -153,6 +157,7 @@ ${CC} "$TMP.c" -o "$TMP" &>"$TMP.log"
 
 if [ ! -x "$TMP" ]; then
 	echo $RED "[NO]" $COL_RESET
+	cat "$TMP.log"
 	MISSING_DEFS=1
 else
 	echo $GREEN "[YES]" $COL_RESET
@@ -180,6 +185,7 @@ ${CC} "$TMP.c" -o "$TMP" &>"$TMP.log"
 
 if [ ! -x "$TMP" ]; then
 	echo $RED "[NO]" $COL_RESET
+	cat "$TMP.log"
 	MISSING_DEFS=1
 else
 	echo $GREEN "[YES]" $COL_RESET
-- 
1.7.9.5
