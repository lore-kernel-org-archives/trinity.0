From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Add MRT_ADD_MFC_PROXY and MRT_DEL_MFC_PROXY for older kernels.
Date: Wed,  3 Jul 2013 16:03:50 -0700
Message-ID: <1372892630-23617-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors on kernels 3.8 and older.

  CC	net/ip_setsockopt.o
net/ip_setsockopt.c:32:22: error: =E2=80=98MRT_ADD_MFC_PROXY=E2=80=99 u=
ndeclared here (not in a function)
net/ip_setsockopt.c:32:41: error: =E2=80=98MRT_DEL_MFC_PROXY=E2=80=99 u=
ndeclared here (not in a function)
make: *** [net/ip_setsockopt.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index e1b9296..0ed2020 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -684,4 +684,12 @@ struct kvm_get_htab_fd {
 #define EM_ARM                    40
 #endif
=20
+/* linux/mroute.h */
+#ifndef MRT_ADD_MFC_PROXY
+#define MRT_ADD_MFC_PROXY	(MRT_BASE+10)
+#endif
+#ifndef MRT_DEL_MFC_PROXY
+#define MRT_DEL_MFC_PROXY	(MRT_BASE+11)
+#endif
+
 #endif	/* _TRINITY_COMPAT_H */
--=20
1.8.1.2
