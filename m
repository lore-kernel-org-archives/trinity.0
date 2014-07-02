From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] Add SEEK_HOLE and SEEK_DATA symbols for older distros.
Date: Wed,  2 Jul 2014 10:28:56 -0700
Message-ID: <1404322136-23539-1-git-send-email-vlee@twopensource.com>
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

  CC	syscalls/lseek.o
syscalls/lseek.c:18: error: =E2=80=98SEEK_DATA=E2=80=99 undeclared here=
 (not in a function)
syscalls/lseek.c:18: error: =E2=80=98SEEK_HOLE=E2=80=99 undeclared here=
 (not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    8 ++++++++
 syscalls/lseek.c |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 30edc81..64af817 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -910,3 +910,11 @@ struct kvm_get_htab_fd {
 #ifndef SWAP_FLAG_DISCARD
 #define SWAP_FLAG_DISCARD 0x10000
 #endif
+
+/* unistd.h */
+#ifndef SEEK_DATA
+#define SEEK_DATA 3
+#endif
+#ifndef SEEK_HOLE
+#define SEEK_HOLE 4
+#endif
diff --git a/syscalls/lseek.c b/syscalls/lseek.c
index d832e99..a8ca77b 100644
--- a/syscalls/lseek.c
+++ b/syscalls/lseek.c
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include "sanitise.h"
+#include "compat.h"
=20
 struct syscallentry syscall_lseek =3D {
 	.name =3D "lseek",
--=20
1.7.1
