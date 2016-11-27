From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Fix -Wunused error
Date: Sat, 26 Nov 2016 21:56:15 -0500
Message-ID: <20161127025615.fgewhrif2xr576md@codemonkey.org.uk>
References: <1480037868-28007-1-git-send-email-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480037868-28007-1-git-send-email-ynorov@caviumnetworks.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: trinity@vger.kernel.org, Andrew Pinski <Andrew.Pinski@cavium.com>, Steve Ellcey <Steve.Ellcey@cavium.com>

On Fri, Nov 25, 2016 at 07:07:48AM +0530, Yury Norov wrote:
 > I try to build trinity for aarch64. In my configuration USE_PPPOL2TPIN6
 > is not defined, and it makes some functions have unused variables. GCC
 > treats it as error. This patch fixes it.
 > 
 > Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
 > ---
 >  net/proto-pppox.c | 9 +++++++++
 >  rand/seed.c       | 2 ++
 >  2 files changed, 11 insertions(+)
 > 
 > diff --git a/net/proto-pppox.c b/net/proto-pppox.c
 > index 9deb045..bdec306 100644
 > --- a/net/proto-pppox.c
 > +++ b/net/proto-pppox.c
 > @@ -83,6 +83,9 @@ static void pppox_PX_PROTO_OL2TP_PPPoL2TPin6(struct sockaddr **addr, socklen_t *
 >  	pppol2tpin6->pppol2tp.addr.sin6_scope_id = rnd();
 >  	*addr = (struct sockaddr *) pppol2tpin6;
 >  	*addrlen = sizeof(struct sockaddr_pppol2tpin6);
 > +#else
 > +	(void) addr;
 > +	(void) addrlen;

Instead of doing it this way, just add __unused__ tags to the variable
declarations. (In the case where they're actually used, it doesn't
matter)

thanks,

	Dave
