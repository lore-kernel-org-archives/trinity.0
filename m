From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] socket: Fix missing-field-initializers build error.
Date: Mon, 31 Aug 2015 16:40:51 -0700
Message-ID: <1441064451-16193-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes this build error.

  CC	syscalls/socket.o
syscalls/socket.c:48:2: error: missing initializer for field =E2=80=98f=
unc=E2=80=99 of =E2=80=98const struct socket_ptr=E2=80=99 [-Werror=3Dmi=
ssing-field-initializers]
  [AF_ECONET] =3D {  }, // DEAD
  ^
syscalls/socket.c:22:9: note: =E2=80=98func=E2=80=99 declared here
  void (*func)(struct socket_triplet *st);
         ^

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 syscalls/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/syscalls/socket.c b/syscalls/socket.c
index 8beaf8d..94feb66 100644
--- a/syscalls/socket.c
+++ b/syscalls/socket.c
@@ -45,7 +45,7 @@ static const struct socket_ptr socketptrs[] =3D {
 	[AF_NETLINK] =3D { .func =3D &netlink_rand_socket },
 	[AF_PACKET] =3D { .func =3D &packet_rand_socket },
 	[AF_ASH] =3D { .func =3D NULL },
-	[AF_ECONET] =3D {  },	// DEAD
+	[AF_ECONET] =3D { .func =3D NULL },	// DEAD
 	[AF_ATMSVC] =3D { .func =3D NULL },
 	[AF_RDS] =3D { .func =3D &rds_rand_socket },
 	[AF_SNA] =3D { .func =3D NULL },
--=20
2.1.4
