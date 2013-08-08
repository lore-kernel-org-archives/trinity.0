From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] net/alg.c: Include compat.h.
Date: Wed,  7 Aug 2013 17:17:14 -0700
Message-ID: <1375921034-32408-1-git-send-email-vlee@freedesktop.org>
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

  CC	net/alg.o
net/alg.c: In function =E2=80=98alg_gen_sockaddr=E2=80=99:
net/alg.c:21: error: =E2=80=98PF_ALG=E2=80=99 undeclared (first use in =
this function)
net/alg.c:21: error: (Each undeclared identifier is reported only once
net/alg.c:21: error: for each function it appears in.)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/alg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/alg.c b/net/alg.c
index d13909b..86cdb66 100644
--- a/net/alg.c
+++ b/net/alg.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include "config.h"
 #include "net.h"
+#include "compat.h"
=20
 #ifdef USE_IF_ALG
 #include <linux/if_alg.h>
--=20
1.7.1
