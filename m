From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] Fix build with kernel 3.4 headers.
Date: Fri, 17 Jul 2015 11:15:41 -0700
Message-ID: <1437156941-5862-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

PR_SET_CHILD_SUBREAPER was added in kernel 3.4 but PR_SET_NO_NEW_PRIVS,
PR_GET_NO_NEW_PRIVS, and PR_GET_TID_ADDRESS were added in kernel 3.5.

  CC	syscalls/prctl.o
syscalls/prctl.c:33: error: =E2=80=98PR_SET_NO_NEW_PRIVS=E2=80=99 undec=
lared here (not in a function)
syscalls/prctl.c:34: error: =E2=80=98PR_GET_NO_NEW_PRIVS=E2=80=99 undec=
lared here (not in a function)
syscalls/prctl.c:34: error: =E2=80=98PR_GET_TID_ADDRESS=E2=80=99 undecl=
ared here (not in a function)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 5451870..0e0f30e 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -275,6 +275,9 @@ enum {
 #ifndef PR_SET_CHILD_SUBREAPER
 #define PR_SET_CHILD_SUBREAPER  36
 #define PR_GET_CHILD_SUBREAPER  37
+#endif
+
+#ifndef PR_SET_NO_NEW_PRIVS
 #define PR_SET_NO_NEW_PRIVS     38
 #define PR_GET_NO_NEW_PRIVS     39
 #define PR_GET_TID_ADDRESS      40
--=20
1.9.1
