From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Add symbols from sys/mount.h for older glibc.
Date: Fri, 23 Aug 2013 19:10:32 -0700
Message-ID: <1377310232-12663-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

MNT_DETACH and MNT_EXPIRE are not available with glibc before 2.10.

UMOUNT_NOFOLLOW is not available with glibc before 2.12.

This patches fixes these build errors with older glibc.

syscalls/umount.c:16: error: =E2=80=98MNT_DETACH=E2=80=99 undeclared he=
re (not in a function)
syscalls/umount.c:16: error: =E2=80=98MNT_EXPIRE=E2=80=99 undeclared he=
re (not in a function)
syscalls/umount.c:16: error: =E2=80=98UMOUNT_NOFOLLOW=E2=80=99 undeclar=
ed here (not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h  |   13 +++++++++++++
 syscalls/umount.c |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index ae57fcb..bb77e3b 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -761,4 +761,17 @@ struct kvm_get_htab_fd {
 #define MRT_DEL_MFC_PROXY	(MRT_BASE+11)
 #endif
=20
+/* sys/mount.h */
+#ifndef MNT_DETACH
+#define MNT_DETACH		2
+#endif
+
+#ifndef MNT_EXPIRE
+#define MNT_EXPIRE		4
+#endif
+
+#ifndef UMOUNT_NOFOLLOW
+#define UMOUNT_NOFOLLOW		8
+#endif
+
 #endif	/* _TRINITY_COMPAT_H */
diff --git a/syscalls/umount.c b/syscalls/umount.c
index 3523df2..fce22ff 100644
--- a/syscalls/umount.c
+++ b/syscalls/umount.c
@@ -3,6 +3,7 @@
  */
 #include <sys/mount.h>
 #include "sanitise.h"
+#include "compat.h"
=20
 struct syscall syscall_umount =3D {
 	.name =3D "umount",
--=20
1.7.4.1
