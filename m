From: Brian Haley <brian.haley@hp.com>
Subject: [PATCH] Add missing EPOLLWAKEUP define to compat.h for older distros
Date: Thu, 11 Sep 2014 21:35:37 -0400
Message-ID: <1410485737-27811-1-git-send-email-brian.haley@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

  CC    syscalls/epoll_ctl.o
syscalls/epoll_ctl.c:14:2: error: =E2=80=98EPOLLWAKEUP=E2=80=99 undecla=
red here (not in a function)

Signed-off-by: Brian Haley <brian.haley@hp.com>
---
 include/compat.h     |    5 +++++
 syscalls/epoll_ctl.c |    1 +
 2 files changed, 6 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 64af817..7c8fda0 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -918,3 +918,8 @@ struct kvm_get_htab_fd {
 #ifndef SEEK_HOLE
 #define SEEK_HOLE 4
 #endif
+
+/* sys/epoll.h */
+#ifndef EPOLLWAKEUP
+#define EPOLLWAKEUP (1u << 29)
+#endif
diff --git a/syscalls/epoll_ctl.c b/syscalls/epoll_ctl.c
index 31df7ca..7274422 100644
--- a/syscalls/epoll_ctl.c
+++ b/syscalls/epoll_ctl.c
@@ -7,6 +7,7 @@
 #include <sys/epoll.h>
 #include "sanitise.h"
 #include "utils.h"
+#include "compat.h"
=20
 static const unsigned long epoll_flags[] =3D {
 	EPOLLIN, EPOLLOUT, EPOLLRDHUP, EPOLLPRI,
--=20
1.7.9.5
