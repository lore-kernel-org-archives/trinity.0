From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] configure: fix cross compile detection of broken ipv6 headers
Date: Fri, 14 Apr 2017 08:18:10 +0300
Message-ID: <ac38a49a18e337fb3bc7ac8e06097e28e1e3b3f7.1492147090.git.baruch@tkos.co.il>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>

Checking the content of the host ipv6.h headers is incompatible with cross
compilation. Target headers may not be the same as the host. Do direct build
test instead using the ${CC} (cross) compiler to detect headers issues.

Define _GNU_SOURCE to make sure glibc ipv6 definitions are exposed.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 configure | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index aa3f7f334971..8639a38eba96 100755
--- a/configure
+++ b/configure
@@ -51,8 +51,21 @@ echo "[*] Checking system headers."
 [ -z "$IPV6" ] && IPV6=yes
 if [[ "$IPV6" == "yes" ]]; then
 	echo -n "[*] Checking ipv6 headers ... "
-	RET=$(grep __UAPI_DEF_IN6_PKTINFO /usr/include/linux/ipv6.h)
-	if [ -z "$RET" ]; then
+	rm -f "$TMP" || exit 1
+
+	cat >"$TMP.c" << EOF
+#include <netinet/in.h>
+#include <netinet/ip6.h>
+#include <linux/in6.h>
+#include <linux/ipv6.h>
+
+int main()
+{
+	struct in6_addr test;
+}
+EOF
+	${CC} ${CFLAGS} -D_GNU_SOURCE "$TMP.c" -o "$TMP" &>"$TMP.log"
+	if [ ! -x "$TMP" ]; then
 		echo $RED "[BROKEN]" $COL_RESET "See https://patchwork.ozlabs.org/patch/425881/"
 	else
 		echo $GREEN "[OK]" $COL_RESET
-- 
2.11.0
