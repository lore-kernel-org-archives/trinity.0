From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] syscalls/prctl.c: Fix build with USE_SECCOMP disabled.
Date: Mon,  9 Dec 2013 11:18:11 -0800
Message-ID: <1386616691-29899-1-git-send-email-vlee@freedesktop.org>
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

  CC	syscalls/prctl.o
syscalls/prctl.c:48: error: expected =E2=80=98)=E2=80=99 before =E2=80=98=
int=E2=80=99
cc1: warnings being treated as errors
syscalls/prctl.c: In function =E2=80=98sanitise_prctl=E2=80=99:
syscalls/prctl.c:63: error: implicit declaration of function =E2=80=98d=
o_set_seccomp=E2=80=99
syscalls/prctl.c:63: error: nested extern declaration of =E2=80=98do_se=
t_seccomp=E2=80=99

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 syscalls/prctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/syscalls/prctl.c b/syscalls/prctl.c
index 5c35036..182c458 100644
--- a/syscalls/prctl.c
+++ b/syscalls/prctl.c
@@ -18,6 +18,7 @@
 #include "shm.h"
 #include "compat.h"
 #include "utils.h"
+#include "trinity.h"
=20
 #define NR_PRCTL_OPTS 28
 static int prctl_opts[NR_PRCTL_OPTS] =3D {
--=20
1.7.1
