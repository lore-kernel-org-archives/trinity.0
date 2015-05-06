From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] net/domains.c: Include compat.h.
Date: Wed,  6 May 2015 12:27:11 -0700
Message-ID: <1430940431-17203-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

=46ix build errors on CentOS 6.

  CC	net/domains.o
net/domains.c:59: error: =E2=80=98PF_CAIF=E2=80=99 undeclared here (not=
 in a function)
net/domains.c:59: warning: missing initializer
net/domains.c:59: warning: (near initialization for =E2=80=98domains[40=
].domain=E2=80=99)
net/domains.c:60: error: =E2=80=98PF_ALG=E2=80=99 undeclared here (not =
in a function)
net/domains.c:60: warning: missing initializer
net/domains.c:60: warning: (near initialization for =E2=80=98domains[41=
].domain=E2=80=99)
net/domains.c:61: error: =E2=80=98PF_NFC=E2=80=99 undeclared here (not =
in a function)
net/domains.c:61: warning: missing initializer
net/domains.c:61: warning: (near initialization for =E2=80=98domains[42=
].domain=E2=80=99)
net/domains.c:62: error: =E2=80=98PF_VSOCK=E2=80=99 undeclared here (no=
t in a function)
net/domains.c:62: warning: missing initializer
net/domains.c:62: warning: (near initialization for =E2=80=98domains[43=
].domain=E2=80=99)

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/domains.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/domains.c b/net/domains.c
index 6ecd455..0930995 100644
--- a/net/domains.c
+++ b/net/domains.c
@@ -9,6 +9,7 @@
 #include "domains.h"
 #include "params.h"
 #include "utils.h"
+#include "compat.h"
=20
 struct domain {
 	const char *name;
--=20
1.7.1
