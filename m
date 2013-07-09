From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Fallback to the git SHA1 if there are no tags
Date: Tue,  9 Jul 2013 18:44:51 +1000
Message-ID: <1373359491-18091-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

We use 'git describe' to generate the GITVERSION. However if the
repository has no tags for some reason that fails, and generates no
output. We should use 'git describe --always' which will fall back to
just printing the abbreviated SHA1 if there are no tags available.
---
 configure.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.sh b/configure.sh
index 804860b..90694d7 100755
--- a/configure.sh
+++ b/configure.sh
@@ -201,7 +201,7 @@ rm -f "$TMP" "$TMP.log" "$TMP.c"
 
 #############################################################################################
 if [ "$DEVEL" == "1" ]; then
-  VER=$(git describe)
+  VER=$(git describe --always)
   echo "#define GITVERSION \""$VER\" >> config.h
 fi
 
-- 
1.7.10.4
