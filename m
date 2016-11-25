From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH] Fix -Wunused error
Date: Fri, 25 Nov 2016 07:07:48 +0530
Message-ID: <1480037868-28007-1-git-send-email-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CAVIUMNETWORKS.onmicrosoft.com; s=selector1-caviumnetworks-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HRe/BxTK1ymaPGyTP4Q1HyL1jQKus/ArLqbbl+sqTFs=;
 b=0EOF2YkB/K8tuP45aL29bAX6XQxXxaM40XWfklYNmkTcgdV3mJJise+v1KTtIIzBffcdU1Opm254WRALszvmKMG7OG04ebNIMD+8I7D7Un+gl35RgmQJNTL0VicJDpJ6zg3A00l/NAo0GeVKP1z1MXY6DkyY4/gkJR1iFyB8cB8=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Andrew Pinski <Andrew.Pinski@cavium.com>, Steve Ellcey <Steve.Ellcey@cavium.com>

I try to build trinity for aarch64. In my configuration USE_PPPOL2TPIN6
is not defined, and it makes some functions have unused variables. GCC
treats it as error. This patch fixes it.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 net/proto-pppox.c | 9 +++++++++
 rand/seed.c       | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/net/proto-pppox.c b/net/proto-pppox.c
index 9deb045..bdec306 100644
--- a/net/proto-pppox.c
+++ b/net/proto-pppox.c
@@ -83,6 +83,9 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPin6(struct sockaddr **addr, socklen_t *
 	pppol2tpin6->pppol2tp.addr.sin6_scope_id = rnd();
 	*addr = (struct sockaddr *) pppol2tpin6;
 	*addrlen = sizeof(struct sockaddr_pppol2tpin6);
+#else
+	(void) addr;
+	(void) addrlen;
 #endif
 }
 
@@ -104,6 +107,9 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3(struct sockaddr **addr, socklen_t *a
 	pppol2tpv3->pppol2tp.d_session = rnd();
 	*addr = (struct sockaddr *) pppol2tpv3;
 	*addrlen = sizeof(struct sockaddr_pppol2tpv3);
+#else
+	(void) addr;
+	(void) addrlen;
 #endif
 }
 
@@ -132,6 +138,9 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3in6(struct sockaddr **addr, socklen_t
 	pppol2tpv3in6->pppol2tp.addr.sin6_scope_id = rnd();
 	*addr = (struct sockaddr *) pppol2tpv3in6;
 	*addrlen = sizeof(struct sockaddr_pppol2tpv3in6);
+#else
+	(void) addr;
+	(void) addrlen;
 #endif
 }
 
diff --git a/rand/seed.c b/rand/seed.c
index 2e4f84f..1490f79 100644
--- a/rand/seed.c
+++ b/rand/seed.c
@@ -48,6 +48,8 @@ static int do_getrandom(unsigned int *buf)
 	ret = syscall(SYS_getrandom, buf, 4, 0);
 	if (ret > 0)
 		return TRUE;
+#else
+	(void) buf;
 #endif
 	return FALSE;
 }
-- 
2.7.4
