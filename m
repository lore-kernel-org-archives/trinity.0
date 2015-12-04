From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH v2] Remove unused variable in fds/drm.c.
Date: Fri,  4 Dec 2015 02:18:52 -0800
Message-ID: <1449224332-29060-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

=46ix build error with GCC 5.2.1.

  CC	fds/drm.o
fds/drm.c: In function =E2=80=98open_drm_fds=E2=80=99:
fds/drm.c:70:15: error: unused variable =E2=80=98i=E2=80=99 [-Werror=3D=
unused-variable]
  unsigned int i;
               ^

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
v2 - Fixed typo in commit message.

 fds/drm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fds/drm.c b/fds/drm.c
index b7fc867..4c9b5c5 100644
--- a/fds/drm.c
+++ b/fds/drm.c
@@ -67,7 +67,6 @@ static void add_drm_obj(int fd)
=20
 static int open_drm_fds(void)
 {
-	unsigned int i;
 	int fd, dfd;
 	DIR *dir;
 	struct dirent *entry;
--=20
2.6.3
