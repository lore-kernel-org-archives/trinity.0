From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] compat.h: Add SO_IP_SET for older distros.
Date: Fri, 11 Mar 2016 16:30:03 -0800
Message-ID: <1457742603-10978-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

  CC	net/proto-ipv4.o
net/proto-ipv4.c:223:12: error: =E2=80=98SO_IP_SET=E2=80=99 undeclared =
here (not in a function)

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 include/compat.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 367fed6..559d90e 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -1102,3 +1102,8 @@ struct kvm_get_htab_fd {
 #ifndef SHM_NORESERVE
 # define SHM_NORESERVE 010000
 #endif
+
+/* netfilter/ipset/ipset.h */
+#ifndef SO_IP_SET
+#define SO_IP_SET 83
+#endif
--=20
1.7.9.5
