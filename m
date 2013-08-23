From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] timerfd_create: Include time.h instead of sys/timerfd.h.
Date: Thu, 22 Aug 2013 18:07:27 -0700
Message-ID: <1377220047-23751-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors with glibc before 2.8.

syscalls/timerfd_create.c:4:25: error: sys/timerfd.h: No such file or d=
irectory
syscalls/timerfd_create.c:15: error: =E2=80=98CLOCK_REALTIME=E2=80=99 u=
ndeclared here (not in a function)
syscalls/timerfd_create.c:15: error: =E2=80=98CLOCK_MONOTONIC=E2=80=99 =
undeclared here (not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 syscalls/timerfd_create.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/syscalls/timerfd_create.c b/syscalls/timerfd_create.c
index d6b291a..92caaa4 100644
--- a/syscalls/timerfd_create.c
+++ b/syscalls/timerfd_create.c
@@ -1,7 +1,7 @@
 /*
  * SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
  */
-#include <sys/timerfd.h>
+#include <time.h>
 #include "sanitise.h"
 #include "compat.h"
=20
--=20
1.7.4.1
