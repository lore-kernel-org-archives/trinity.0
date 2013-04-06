From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Include compat.h in syscalls/msgsnd.c for MSG_COPY for older kernels.
Date: Fri,  5 Apr 2013 20:03:14 -0700
Message-ID: <1365217394-30404-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes this build error on Linux 3.7 and older.

  CC	syscalls/msgsnd.o
syscalls/msgsnd.c:19:40: error: =E2=80=98MSG_COPY=E2=80=99 undeclared h=
ere (not in a function)
make: *** [syscalls/msgsnd.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 syscalls/msgsnd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/syscalls/msgsnd.c b/syscalls/msgsnd.c
index 13e663f..132336b 100644
--- a/syscalls/msgsnd.c
+++ b/syscalls/msgsnd.c
@@ -2,6 +2,7 @@
  * SYSCALL_DEFINE4(msgsnd, int, msqid, struct msgbuf __user *, msgp, s=
ize_t, msgsz, int, msgflg)
  */
 #include <linux/msg.h>
+#include "compat.h"
 #include "sanitise.h"
=20
 struct syscall syscall_msgsnd =3D {
--=20
1.7.9.5
