From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] compat.h: Add NETLINK_SOCK_DIAG.
Date: Sun, 29 Nov 2015 23:13:04 -0800
Message-ID: <1448867584-11008-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

=46ix CentOS 6 build error.

  CC	net/proto-netlink.o
net/proto-netlink.c: In function =E2=80=98netlink_rand_socket=E2=80=99:
net/proto-netlink.c:49: error: =E2=80=98NETLINK_SOCK_DIAG=E2=80=99 unde=
clared (first use in this function)

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 include/compat.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 1e8768a..f98fe32 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -265,6 +265,9 @@ enum {
 #ifndef NETLINK_CAP_ACK
 #define NETLINK_CAP_ACK 10
 #endif
+#ifndef NETLINK_SOCK_DIAG
+#define NETLINK_SOCK_DIAG 4
+#endif
=20
 /* linux/prctl.h */
 #ifndef PR_MCE_KILL_GET
--=20
1.7.1
