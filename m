From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] fds/drm.c: Add forward declaration of struct.
Date: Thu, 26 May 2016 00:05:24 +0000
Message-ID: <1464221124-14378-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

=46ix build error.

  CC	fds/drm.o
fds/drm.c: In function =E2=80=98open_drm_fds=E2=80=99:
fds/drm.c:120:3: error: =E2=80=98drm_fd_provider=E2=80=99 undeclared (f=
irst use in this function)
   drm_fd_provider.enabled =3D FALSE;
   ^

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 fds/drm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fds/drm.c b/fds/drm.c
index d33b00e4be51..54cc0faa8d1a 100644
--- a/fds/drm.c
+++ b/fds/drm.c
@@ -71,6 +71,8 @@ static void add_drm_obj(int fd)
 	output(2, "fd[%d] =3D drm\n", fd);
 }
=20
+static struct fd_provider drm_fd_provider;
+
 static int open_drm_fds(void)
 {
 	struct objhead *head;
--=20
2.7.4
