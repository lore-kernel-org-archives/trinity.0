From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] Fix build errors on Ubuntu 12.04.
Date: Thu, 22 May 2014 21:16:10 -0700
Message-ID: <1400818570-13710-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

  CC    syscalls/prctl.o
syscalls/prctl.c:33:13: error: =E2=80=98PR_SET_CHILD_SUBREAPER=E2=80=99=
 undeclared here (not in a function)
syscalls/prctl.c:33:37: error: =E2=80=98PR_GET_CHILD_SUBREAPER=E2=80=99=
 undeclared here (not in a function)
syscalls/prctl.c:34:23: error: =E2=80=98PR_GET_TID_ADDRESS=E2=80=99 und=
eclared here (not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 51f0936..30edc81 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -257,6 +257,9 @@ enum {
=20
 #ifndef PR_SET_MM
 #define PR_SET_MM               35
+#endif
+
+#ifndef PR_SET_CHILD_SUBREAPER
 #define PR_SET_CHILD_SUBREAPER  36
 #define PR_GET_CHILD_SUBREAPER  37
 #define PR_SET_NO_NEW_PRIVS     38
--=20
1.7.9.5
