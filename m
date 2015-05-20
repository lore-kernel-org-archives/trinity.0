From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] compat.h: Add CLOCK_BOOTTIME.
Date: Wed, 20 May 2015 14:15:04 -0700
Message-ID: <1432156504-9095-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

CLOCK_BOOTTIME is not available with glibc < 2.14.

=46ix build on CentOS 6.

  CC	syscalls/perf_event_open.o
syscalls/perf_event_open.c: In function =E2=80=98create_mostly_valid_sa=
mpling_event=E2=80=99:
syscalls/perf_event_open.c:1118: error: =E2=80=98CLOCK_BOOTTIME=E2=80=99=
 undeclared (first use in this function)
syscalls/perf_event_open.c:1118: error: (Each undeclared identifier is =
reported only once
syscalls/perf_event_open.c:1118: error: for each function it appears in=
=2E)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index c0c7f0a..0e3d011 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -997,3 +997,8 @@ struct kvm_get_htab_fd {
 #ifndef EPOLLWAKEUP
 #define EPOLLWAKEUP (1u << 29)
 #endif
+
+/* time.h */
+#ifndef CLOCK_BOOTTIME
+#define CLOCK_BOOTTIME 7
+#endif
--=20
1.7.1
