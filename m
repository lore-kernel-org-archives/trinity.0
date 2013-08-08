From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] compat.h: Add MSG_CMSG_CLOEXEC for older glibc.
Date: Thu,  8 Aug 2013 15:01:14 -0700
Message-ID: <1375999274-6210-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes this build error with glibc before 2.7.

  CC    syscalls/recvfrom.o
syscalls/recvfrom.c:28: error: =E2=80=98MSG_CMSG_CLOEXEC=E2=80=99 undec=
lared here (not in a function)
make: *** [syscalls/recvfrom.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index ad1dcb5..7e73131 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -140,6 +140,10 @@ enum {
 #define MSG_WAITFORONE	0x10000
 #endif
=20
+#ifndef MSG_CMSG_CLOEXEC
+#define MSG_CMSG_CLOEXEC	0x40000000
+#endif
+
 /* linux/socket.h */
 #ifndef MSG_PROBE
 #define MSG_PROBE 0x10
--=20
1.7.4.1
