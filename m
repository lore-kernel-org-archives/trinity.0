From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] compat.h: Add SOCK_CLOEXEC and SOCK_NONBLOCK for older glibc.
Date: Wed, 21 Aug 2013 21:22:57 -0700
Message-ID: <1377145378-22426-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors with glibc before 2.9.

syscalls/socket.c: In function =E2=80=98gen_socket_args=E2=80=99:
syscalls/socket.c:82: error: =E2=80=98SOCK_CLOEXEC=E2=80=99 undeclared =
(first use in this function)
syscalls/socket.c:82: error: (Each undeclared identifier is reported on=
ly once
syscalls/socket.c:82: error: for each function it appears in.)
syscalls/socket.c:84: error: =E2=80=98SOCK_NONBLOCK=E2=80=99 undeclared=
 (first use in this function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index fe5d0c7..ae57fcb 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -93,6 +93,14 @@ enum {
=20
=20
 /* bits/socket.h */
+#ifndef SOCK_CLOEXEC
+#define SOCK_CLOEXEC	02000000
+#endif
+
+#ifndef SOCK_NONBLOCK
+#define SOCK_NONBLOCK	04000
+#endif
+
 #ifndef PF_RDS
 #define PF_RDS		21
 #endif
--=20
1.7.4.1
