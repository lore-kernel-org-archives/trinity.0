From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] syscall/prctl.c: Fix unused variable build error with USE_SECCOMP=0.
Date: Wed,  4 Dec 2013 10:33:00 -0800
Message-ID: <1386181980-3294-1-git-send-email-vlee@freedesktop.org>
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
cc1: warnings being treated as errors
syscalls/prctl.c: In function =E2=80=98sanitise_prctl=E2=80=99:
syscalls/prctl.c:36: error: unused variable =E2=80=98saddr=E2=80=99

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 syscalls/prctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/syscalls/prctl.c b/syscalls/prctl.c
index acca027..bde76aa 100644
--- a/syscalls/prctl.c
+++ b/syscalls/prctl.c
@@ -33,7 +33,9 @@ static int prctl_opts[NR_PRCTL_OPTS] =3D {
 void sanitise_prctl(int childno)
 {
 	int option =3D prctl_opts[rand() % NR_PRCTL_OPTS];
+#ifdef USE_SECCOMP
 	struct sockaddr *saddr =3D NULL;
+#endif
=20
 // For now, just do SECCOMP, the other options need some attention.
 option =3D PR_SET_SECCOMP;
--=20
1.7.1
