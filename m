From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Add SWAP_FLAG_DISCARD symbol for older distros.
Date: Mon, 24 Mar 2014 14:46:56 -0700
Message-ID: <1395697616-10620-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes this build error on CentOS 6.

  CC	syscalls/swap.o
syscalls/swap.c:16: error: =E2=80=98SWAP_FLAG_DISCARD=E2=80=99 undeclar=
ed here (not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    5 +++++
 syscalls/swap.c  |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 9d3be59..f392258 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -862,3 +862,8 @@ struct kvm_get_htab_fd {
 #ifndef SCHED_DEADLINE
 #define SCHED_DEADLINE 6
 #endif
+
+/* sys/swap.h */
+#ifndef SWAP_FLAG_DISCARD
+#define SWAP_FLAG_DISCARD 0x10000
+#endif
diff --git a/syscalls/swap.c b/syscalls/swap.c
index 7eb9d79..c28a54a 100644
--- a/syscalls/swap.c
+++ b/syscalls/swap.c
@@ -3,6 +3,7 @@
  */
 #include <sys/swap.h>
 #include "sanitise.h"
+#include "compat.h"
=20
 struct syscallentry syscall_swapon =3D {
 	.name =3D "swapon",
--=20
1.7.1
