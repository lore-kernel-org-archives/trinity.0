From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Check for bpf_attr map_flags.
Date: Sat, 12 Nov 2016 00:55:35 +0000
Message-ID: <1478912135-21812-1-git-send-email-vlee@freedesktop.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

map_flags is not available until Linux 4.6.

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 configure | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index ca37e4efa27b..18d9df73985f 100755
--- a/configure
+++ b/configure
@@ -222,6 +222,33 @@ else
 fi
 
 #############################################################################################
+# is /usr/include/linux/bpf.h new enough to feature bpf
+#
+echo -n "[*] Checking if bpf_attr can use map_flags.. "
+rm -f "$TMP" || exit 1
+
+cat >"$TMP.c" << EOF
+#include <stdio.h>
+#include <linux/bpf.h>
+
+void main()
+{
+	union bpf_attr attr = {
+		.map_flags = 0,
+	};
+}
+EOF
+
+${CC} ${CFLAGS} "$TMP.c" -o "$TMP" &>"$TMP.log"
+if [ ! -x "$TMP" ]; then
+	echo $RED "[NO]" $COL_RESET
+	MISSING_DEFS=1
+else
+	echo $GREEN "[YES]" $COL_RESET
+	echo "#define USE_BPF 1" >> $CONFIGH
+fi
+
+#############################################################################################
 
 check_header linux/caif/caif_socket.h USE_CAIF
 check_header linux/if_alg.h USE_IF_ALG
@@ -239,7 +266,6 @@ check_header execinfo.h USE_BACKTRACE
 check_header netatalk/at.h USE_APPLETALK
 check_header netrom/netrom.h USE_NETROM
 check_header netrose/rose.h USE_ROSE
-check_header linux/bpf.h USE_BPF
 
 rm -f "$TMP" "$TMP.log" "$TMP.c"
 
-- 
2.7.4
