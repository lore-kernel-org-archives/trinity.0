From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] compat.h: Add more address family symbols for older glibc.
Date: Fri, 16 Aug 2013 19:26:30 -0700
Message-ID: <1376706390-16617-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors with glibc before 2.10.

syscalls/socket.c:27: error: =E2=80=98AF_CAN=E2=80=99 undeclared here (=
not in a function)
syscalls/socket.c:33: error: =E2=80=98AF_LLC=E2=80=99 undeclared here (=
not in a function)
syscalls/socket.c:38: error: =E2=80=98AF_PHONET=E2=80=99 undeclared her=
e (not in a function)
syscalls/socket.c:39: error: =E2=80=98AF_RDS=E2=80=99 undeclared here (=
not in a function)
syscalls/socket.c:40: error: =E2=80=98AF_TIPC=E2=80=99 undeclared here =
(not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 7e73131..fe5d0c7 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -93,6 +93,19 @@ enum {
=20
=20
 /* bits/socket.h */
+#ifndef PF_RDS
+#define PF_RDS		21
+#endif
+#ifndef AF_RDS
+#define AF_RDS		PF_RDS
+#endif
+
+#ifndef PF_LLC
+#define PF_LLC		26
+#endif
+#ifndef AF_LLC
+#define AF_LLC		PF_LLC
+#endif
=20
 #ifndef AF_IB
 #define AF_IB		27
@@ -101,6 +114,27 @@ enum {
 #define PF_IB          AF_IB
 #endif
=20
+#ifndef PF_CAN
+#define PF_CAN		29
+#endif
+#ifndef AF_CAN
+#define AF_CAN		PF_CAN
+#endif
+
+#ifndef PF_TIPC
+#define PF_TIPC		30
+#endif
+#ifndef AF_TIPC
+#define AF_TIPC		PF_TIPC
+#endif
+
+#ifndef PF_PHONET
+#define PF_PHONET	35
+#endif
+#ifndef AF_PHONET
+#define AF_PHONET	PF_PHONET
+#endif
+
 #ifndef PF_CAIF
 #define PF_CAIF		37
 #endif
--=20
1.7.4.1
