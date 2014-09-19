From: Markos Chandras <markos.chandras@imgtec.com>
Subject: [PATCH 1/2] configure.sh: Respect CFLAGS from the environment
Date: Fri, 19 Sep 2014 15:11:54 +0100
Message-ID: <1411135915-26522-2-git-send-email-markos.chandras@imgtec.com>
References: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Markos Chandras <markos.chandras@imgtec.com>

Currently, configure.sh does not inherit any cflags from the
environment. However, for MIPS, it's necessary to pass additional
cflags to decide, for example, if we want a big endian (-BE) or
little endian (-EL) build. As a result of which, we modify the
configure.sh script to respect additional cflags passed by the
user.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 configure.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.sh b/configure.sh
index d2a31c266519..98905fb8e7fd 100755
--- a/configure.sh
+++ b/configure.sh
@@ -16,9 +16,9 @@ MISSING_DEFS=0
 # expand tilde
 CC="$(eval echo ${CROSS_COMPILE}${CC})"
 
-CFLAGS=""
+CFLAGS="${CFLAGS}"
 if [ "${SYSROOT}xx" != "xx" ]; then
-	CFLAGS="$(eval echo --sysroot=${SYSROOT} )"
+	CFLAGS="${CFLAGS} $(eval echo --sysroot=${SYSROOT} )"
 fi
 
 echo "#pragma once" > $CONFIGH
-- 
2.1.0
