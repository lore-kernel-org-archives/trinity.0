From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] proto-phonet: Include compat.h.
Date: Thu, 14 Aug 2014 15:13:11 -0700
Message-ID: <1408054391-14583-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

=46ix build error when missing PF_PHONET with glibc < 2.10.

  CC	net/proto-phonet.o
net/proto-phonet.c: In function =E2=80=98phonet_gen_sockaddr=E2=80=99:
net/proto-phonet.c:17:19: error: =E2=80=98PF_PHONET=E2=80=99 undeclared=
 (first use in this function)
  pn->spn_family =3D PF_PHONET;
                   ^

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/proto-phonet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/proto-phonet.c b/net/proto-phonet.c
index 40a74aa..c6efdf7 100644
--- a/net/proto-phonet.c
+++ b/net/proto-phonet.c
@@ -7,6 +7,7 @@
 #include "net.h"
 #include "random.h"
 #include "utils.h"
+#include "compat.h"
=20
 void phonet_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 {
--=20
1.9.1
