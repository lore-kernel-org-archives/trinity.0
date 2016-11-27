From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH] Fix -Wunused error
Date: Sun, 27 Nov 2016 12:50:29 +0530
Message-ID: <20161127072029.GA18679@yury-N73SV>
References: <1480037868-28007-1-git-send-email-ynorov@caviumnetworks.com>
 <20161127025615.fgewhrif2xr576md@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CAVIUMNETWORKS.onmicrosoft.com; s=selector1-caviumnetworks-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bnOAPnac7AtA35bCj0x/hAkl//0x+OdJGKMSvxaWHDE=;
 b=3J7FdTbuYDlLurGyuigfG/RYBGoG34dOhd5c0OOhsMXmyu5NMA71aZ+VlYlWoIqCBXsw2mygq2X9svTzDHL2sRuZYuTv2fQWfrRUnWtOZLSiOZSTMe28431Lqgjut50sTQ/NlQqjjwjCXhs+8h9spGQo9RCtYcuVyIbJawNIQQw=
Content-Disposition: inline
In-Reply-To: <20161127025615.fgewhrif2xr576md@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org, Andrew Pinski <Andrew.Pinski@cavium.com>, Steve Ellcey <Steve.Ellcey@cavium.com>

On Sat, Nov 26, 2016 at 09:56:15PM -0500, Dave Jones wrote:
> On Fri, Nov 25, 2016 at 07:07:48AM +0530, Yury Norov wrote:
>  > I try to build trinity for aarch64. In my configuration USE_PPPOL2TPIN6
>  > is not defined, and it makes some functions have unused variables. GCC
>  > treats it as error. This patch fixes it.
>  > 
>  > Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
>  > ---
>  >  net/proto-pppox.c | 9 +++++++++
>  >  rand/seed.c       | 2 ++
>  >  2 files changed, 11 insertions(+)
>  > 
>  > diff --git a/net/proto-pppox.c b/net/proto-pppox.c
>  > index 9deb045..bdec306 100644
>  > --- a/net/proto-pppox.c
>  > +++ b/net/proto-pppox.c
>  > @@ -83,6 +83,9 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPin6(struct sockaddr **addr, socklen_t *
>  >  	pppol2tpin6->pppol2tp.addr.sin6_scope_id = rnd();
>  >  	*addr = (struct sockaddr *) pppol2tpin6;
>  >  	*addrlen = sizeof(struct sockaddr_pppol2tpin6);
>  > +#else
>  > +	(void) addr;
>  > +	(void) addrlen;
> 
> Instead of doing it this way, just add __unused__ tags to the variable
> declarations. (In the case where they're actually used, it doesn't
> matter)
> 
> thanks,
> 
> 	Dave

OK

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 net/proto-pppox.c | 9 ++++++---
 rand/seed.c       | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/proto-pppox.c b/net/proto-pppox.c
index 9deb045..52288fa 100644
--- a/net/proto-pppox.c
+++ b/net/proto-pppox.c
@@ -58,7 +58,8 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TP(struct sockaddr **addr, socklen_t *add
 	*addrlen = sizeof(struct sockaddr_pppol2tp);
 }
 
-static void pppox_PX_PROTO_OL2TP_PPPoL2TPin6(struct sockaddr **addr, socklen_t *addrlen)
+static void pppox_PX_PROTO_OL2TP_PPPoL2TPin6(__unused__ struct sockaddr **addr,
+						__unused__ socklen_t *addrlen)
 {
 #ifdef USE_PPPOL2TPIN6
 	struct sockaddr_pppol2tpin6 *pppol2tpin6;
@@ -86,7 +87,8 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPin6(struct sockaddr **addr, socklen_t *
 #endif
 }
 
-static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3(struct sockaddr **addr, socklen_t *addrlen)
+static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3(__unused__ struct sockaddr **addr,
+						__unused__ socklen_t *addrlen)
 {
 #ifdef USE_PPPOL2TPV3
 	struct sockaddr_pppol2tpv3 *pppol2tpv3;
@@ -107,7 +109,8 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3(struct sockaddr **addr, socklen_t *a
 #endif
 }
 
-static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3in6(struct sockaddr **addr, socklen_t *addrlen)
+static void pppox_PX_PROTO_OL2TP_PPPoL2TPv3in6(__unused__ struct sockaddr **addr,
+						__unused__ socklen_t *addrlen)
 {
 #ifdef USE_PPPOL2TPIN6
 	struct sockaddr_pppol2tpv3in6 *pppol2tpv3in6;
diff --git a/rand/seed.c b/rand/seed.c
index 2e4f84f..87880a6 100644
--- a/rand/seed.c
+++ b/rand/seed.c
@@ -40,7 +40,7 @@ static int urandomfd;
  * to store what gets passed in from the command line -s argument */
 unsigned int seed = 0;
 
-static int do_getrandom(unsigned int *buf)
+static int do_getrandom(__unused__ unsigned int *buf)
 {
 #ifdef SYS_getrandom
 	int ret;
-- 
2.7.4
