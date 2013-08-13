From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] net: include compat.h first incase some
 specifier-qualifier-list error
Date: Tue, 13 Aug 2013 11:48:33 -0400
Message-ID: <20130813154833.GA12920@redhat.com>
References: <1376406809-12604-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376406809-12604-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Trinity list <trinity@vger.kernel.org>

On Tue, Aug 13, 2013 at 11:13:29PM +0800, Hangbin Liu wrote:
 > On some old distros, we use sa_family_t in linux/irda.h and linux/ne=
tlink.h
 > first, but include the header file bits/sockaddr.h later in compat.h=
=2E Then it
 > will compile failed with error: expected specifier-qualifier-list be=
fore
 > =E2=80=98sa_family_t=E2=80=99. So let's move compat.h before irda.h =
and netlink.h
 >=20
 >
 > diff --git a/net/irda_setsockopt.c b/net/irda_setsockopt.c
 > index a5d96ec..21ff649 100644
 > --- a/net/irda_setsockopt.c
 > +++ b/net/irda_setsockopt.c
 > @@ -1,9 +1,9 @@
 >  #include <stdlib.h>
 > -#include <linux/irda.h>
 >  #include "net.h"
 >  #include "maps.h"	// page_rand
 >  #include "compat.h"
 >  #include "trinity.h"	// ARRAY_SIZE
 > +#include <linux/irda.h>
 > =20
 >  #define NR_SOL_IRDA_OPTS ARRAY_SIZE(irda_opts)
 >  static const unsigned int irda_opts[] =3D {
 > diff --git a/net/netlink_setsockopt.c b/net/netlink_setsockopt.c
 > index c6e9297..c401047 100644
 > --- a/net/netlink_setsockopt.c
 > +++ b/net/netlink_setsockopt.c
 > @@ -1,9 +1,9 @@
 >  #include <stdlib.h>
 > -#include <linux/netlink.h>
 >  #include "net.h"
 >  #include "maps.h"	// page_rand
 >  #include "compat.h"
 >  #include "trinity.h"	// ARRAY_SIZE
 > +#include <linux/netlink.h>

This seems fragile to me.  The idea here is that compat.h is to overrid=
e
all the system includes, so reordering like this may mean that we won't
get the desired affect on some other distro.

I don't have a better answer for this though, need to think about it so=
me more.
Perhaps changing compat.h to include something other than the bits/sock=
addr
(Or adding additional includes there)..

What distribution was this ?

	Dave
