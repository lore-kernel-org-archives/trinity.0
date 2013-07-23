From: Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] ioctls: btrfs-control: fix header inclusion order
Date: Wed, 24 Jul 2013 01:30:14 +0200
Message-ID: <20130723233014.GB4249@jack.whiskey>
References: <1374608128-29846-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374608128-29846-1-git-send-email-andi@etezian.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, mikko.rapeli@iki.fi

> This patch enables older linux/btrfs.h where NULL is not
                      ^^^

This was supposed to be newer, I'll come with patch v2

Andi

> recognized as a define. It gets rid of the following compiling
> error:
>=20
> In file included from ioctls/btrfs-control.c:5:0:
> /usr/include/linux/btrfs.h: In function =E2=80=98btrfs_err_str=E2=80=99=
:
> /usr/include/linux/btrfs.h:486:11: error: =E2=80=98NULL=E2=80=99 unde=
clared (first use in this function)
>     return NULL;
>            ^
>=20
> This is done by postponing the inclusion of btrf.h
>=20
> Signed-off-by: Andi Shyti <andi@etezian.org>
