From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] net/caif.c: Include compat.h.
Date: Wed,  7 Aug 2013 17:26:14 -0700
Message-ID: <1375921574-8237-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes this build error with glibc before 2.13.

  CC    net/caif.o
net/caif.c: In function =E2=80=98caif_gen_sockaddr=E2=80=99:
net/caif.c:22: error: =E2=80=98PF_CAIF=E2=80=99 undeclared (first use i=
n this function)
net/caif.c:22: error: (Each undeclared identifier is reported only once
net/caif.c:22: error: for each function it appears in.)
make: *** [net/caif.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/caif.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/caif.c b/net/caif.c
index 5359f25..9385727 100644
--- a/net/caif.c
+++ b/net/caif.c
@@ -6,6 +6,7 @@
 #include "config.h"
 #include "net.h"
 #include "random.h"
+#include "compat.h"
=20
 #ifdef USE_CAIF
 #include <linux/caif/caif_socket.h>
--=20
1.7.1
