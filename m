From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] can.c: Include compat.h.
Date: Fri, 23 Aug 2013 20:04:52 -0700
Message-ID: <1377313492-21875-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors with glibc before 2.10.

net/can.c: In function =E2=80=98can_gen_sockaddr=E2=80=99:
net/can.c:17: error: =E2=80=98AF_CAN=E2=80=99 undeclared (first use in =
this function)
net/can.c:17: error: (Each undeclared identifier is reported only once
net/can.c:17: error: for each function it appears in.)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/can.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/can.c b/net/can.c
index 6b107cb..7322f3e 100644
--- a/net/can.c
+++ b/net/can.c
@@ -6,6 +6,7 @@
 #include <stdlib.h>
 #include "net.h"
 #include "random.h"
+#include "compat.h"
=20
 void can_gen_sockaddr(unsigned long *addr, unsigned long *addrlen)
 {
--=20
1.7.4.1
