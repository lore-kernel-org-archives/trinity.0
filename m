From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] be more quiet in [main] Setsockopt(...
Date: Tue,  7 Jan 2014 17:27:51 +0100
Message-ID: <1389112071-14394-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org
Cc: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>

Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
---
 syscalls/setsockopt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index e306d5f..9d5b127 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -110,7 +110,7 @@ retry:
=20
 	ret =3D setsockopt(fd, so->level, so->optname, (void *)so->optval, so=
->optlen);
 	if (ret =3D=3D 0) {
-		output(1, "Setsockopt(%lx %lx %lx %lx) on fd %d [%d:%d:%d]\n",
+		output(2, "Setsockopt(%lx %lx %lx %lx) on fd %d [%d:%d:%d]\n",
 			so->level, so->optname, so->optval, so->optlen, fd,
 			triplet->family, triplet->type, triplet->protocol);
 	} else {
--=20
1.8.3.2
