From: Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH] net: include compat.h first incase some
 specifier-qualifier-list error
Date: Wed, 14 Aug 2013 08:27:21 +0800
Message-ID: <20130814002721.GB14331@localhost.localdomain>
References: <1376406809-12604-1-git-send-email-liuhangbin@gmail.com>
 <20130813154833.GA12920@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9+bxFJexRzTswW80Pewplp7xkqWxl7MvS57XlE2DbTU=;
        b=pp6akmQEtkLDh9NWa//l4F2rqXaLPJVSopXD1gLQe5wDJnbMRytzi925tqfyPU1ZE0
         cqVekX5tkMCXFTabKqfsQ+dtUHpKmdgWh8ObuTTFZNs2as2B90ryLAiIdZeGWdI7oG79
         povzjO45Ht2chHIajz8191zCg2W/hTO5+ppLu5wJYZX1QisMfXub6OXWdkY4kTSXtmuV
         gbO1m4xGQcDbxv/0YTXck2Ws2YNCAA0jF1EToCb1s6GZa2hJblOoM3CPIew/H5imF8Es
         SqmCyyLVZFI28Q3Np+Sd+tgwhcSEcI4zKlOwlons2ssV7DAiT99U0oz2Dy3ROadEJnIn
         tXNA==
Content-Disposition: inline
In-Reply-To: <20130813154833.GA12920@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: Trinity list <trinity@vger.kernel.org>

On Tue, Aug 13, 2013 at 11:48:33AM -0400, Dave Jones wrote:
> On Tue, Aug 13, 2013 at 11:13:29PM +0800, Hangbin Liu wrote:
>  > On some old distros, we use sa_family_t in linux/irda.h and linux/=
netlink.h
>  > first, but include the header file bits/sockaddr.h later in compat=
=2Eh. Then it
>  > will compile failed with error: expected specifier-qualifier-list =
before
>  > =E2=80=98sa_family_t=E2=80=99. So let's move compat.h before irda.=
h and netlink.h
>  >=20
>  >
>  > diff --git a/net/irda_setsockopt.c b/net/irda_setsockopt.c
>  > index a5d96ec..21ff649 100644
>  > --- a/net/irda_setsockopt.c
>  > +++ b/net/irda_setsockopt.c
>  > @@ -1,9 +1,9 @@
>  >  #include <stdlib.h>
>  > -#include <linux/irda.h>
>  >  #include "net.h"
>  >  #include "maps.h"	// page_rand
>  >  #include "compat.h"
>  >  #include "trinity.h"	// ARRAY_SIZE
>  > +#include <linux/irda.h>
>  > =20
>  >  #define NR_SOL_IRDA_OPTS ARRAY_SIZE(irda_opts)
>  >  static const unsigned int irda_opts[] =3D {
>  > diff --git a/net/netlink_setsockopt.c b/net/netlink_setsockopt.c
>  > index c6e9297..c401047 100644
>  > --- a/net/netlink_setsockopt.c
>  > +++ b/net/netlink_setsockopt.c
>  > @@ -1,9 +1,9 @@
>  >  #include <stdlib.h>
>  > -#include <linux/netlink.h>
>  >  #include "net.h"
>  >  #include "maps.h"	// page_rand
>  >  #include "compat.h"
>  >  #include "trinity.h"	// ARRAY_SIZE
>  > +#include <linux/netlink.h>
>=20
> This seems fragile to me.  The idea here is that compat.h is to overr=
ide
> all the system includes, so reordering like this may mean that we won=
't
> get the desired affect on some other distro.
>=20
> I don't have a better answer for this though, need to think about it =
some more.
> Perhaps changing compat.h to include something other than the bits/so=
ckaddr
> (Or adding additional includes there)..
>=20
> What distribution was this ?
>=20
RHEL6.4

# make
<snip>
  CC    net/irda_setsockopt.o
In file included from net/irda_setsockopt.c:2:
/usr/include/linux/irda.h:128: error: expected specifier-qualifier-list=
 before =E2=80=98sa_family_t=E2=80=99
make: *** [net/irda_setsockopt.o] Error 1

# uname -r
2.6.32-358.el6.x86_64

# rpm -qf /usr/include/linux/irda.h
kernel-headers-2.6.32-358.el6.x86_64

# rpm -qa | grep gcc
libgcc-4.4.7-3.el6.x86_64
gcc-4.4.7-3.el6.x86_64
gcc-gfortran-4.4.7-3.el6.x86_64
gcc-c++-4.4.7-3.el6.x86_64

# rpm -qa | grep glibc
glibc-common-2.12-1.107.el6.x86_64
glibc-headers-2.12-1.107.el6.x86_64
glibc-2.12-1.107.el6.x86_64
glibc-devel-2.12-1.107.el6.x86_64

--=20

Thanks & Best Regards
Hangbin Liu <liuhangbin@gmail.com>
