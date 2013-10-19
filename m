From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] compat.h: Add if_ether.h symbols for older kernels.
Date: Fri, 18 Oct 2013 19:35:34 -0700
Message-ID: <1382150134-29099-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors on CentOS 6.

  CC	net/ether.o
net/ether.c:12: error: =E2=80=98ETH_P_BATMAN=E2=80=99 undeclared here (=
not in a function)
net/ether.c:19: error: =E2=80=98ETH_P_LINK_CTL=E2=80=99 undeclared here=
 (not in a function)
net/ether.c:21: error: =E2=80=98ETH_P_8021AD=E2=80=99 undeclared here (=
not in a function)
net/ether.c:21: error: =E2=80=98ETH_P_802_EX1=E2=80=99 undeclared here =
(not in a function)
net/ether.c:22: error: =E2=80=98ETH_P_8021AH=E2=80=99 undeclared here (=
not in a function)
net/ether.c:22: error: =E2=80=98ETH_P_MVRP=E2=80=99 undeclared here (no=
t in a function)
net/ether.c:23: error: =E2=80=98ETH_P_QINQ1=E2=80=99 undeclared here (n=
ot in a function)
net/ether.c:24: error: =E2=80=98ETH_P_QINQ2=E2=80=99 undeclared here (n=
ot in a function)
net/ether.c:24: error: =E2=80=98ETH_P_QINQ3=E2=80=99 undeclared here (n=
ot in a function)
net/ether.c:31: error: =E2=80=98ETH_P_CANFD=E2=80=99 undeclared here (n=
ot in a function)
net/ether.c:34: error: =E2=80=98ETH_P_CAIF=E2=80=99 undeclared here (no=
t in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 05b0686..2b8c285 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -790,8 +790,41 @@ struct kvm_get_htab_fd {
 #endif
=20
 /* if_ether.h */
+#ifndef ETH_P_BATMAN
+#define ETH_P_BATMAN	0x4305
+#endif
+#ifndef ETH_P_LINK_CTL
+#define ETH_P_LINK_CTL	0x886c
+#endif
+#ifndef ETH_P_8021AD
+#define ETH_P_8021AD	0x88A8
+#endif
+#ifndef ETH_P_802_EX1
+#define ETH_P_802_EX1	0x88B5
+#endif
+#ifndef ETH_P_8021AH
+#define ETH_P_8021AH	0x88E7
+#endif
+#ifndef ETH_P_MVRP
+#define ETH_P_MVRP	0x88F5
+#endif
+#ifndef ETH_P_QINQ1
+#define ETH_P_QINQ1	0x9100
+#endif
+#ifndef ETH_P_QINQ2
+#define ETH_P_QINQ2	0x9200
+#endif
+#ifndef ETH_P_QINQ3
+#define ETH_P_QINQ3	0x9300
+#endif
 #ifndef ETH_P_802_3_MIN
 #define ETH_P_802_3_MIN	0x0600
 #endif
+#ifndef ETH_P_CANFD
+#define ETH_P_CANFD	0x000D
+#endif
+#ifndef ETH_P_CAIF
+#define ETH_P_CAIF	0x00F7
+#endif
=20
 #endif	/* _TRINITY_COMPAT_H */
--=20
1.7.1
