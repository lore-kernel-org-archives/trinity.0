From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH v2] ioctls: btrfs-control: fix header inclusion order
Date: Wed, 24 Jul 2013 09:56:47 +0300
Message-ID: <CA+ydwtobNJMxn5r+jLQM3Pc8kY_swh1=pNw7dwEDhkGneC9r8g@mail.gmail.com>
References: <20130723233014.GB4249@jack.whiskey>
	<1374622742-11219-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=AsvetkrXO/2HC+GikP4dBhufz6ttV2XDRmcjFEieJzU=;
        b=bis1cRNbqZEj/G4Kl1dNpwcOGG0EOINaYoZBw41Pz8ei2fBW1YDSW0DBDim2K6WjFa
         7Od0mu52ehI/ERZt+Wt+6N5jGssWUe20vsdIu4Vl5wp6zSNvXfRZYQyqEk/0KzjTcjG5
         yTLVBRex5KOHzn7/qFFK6PmoPiholllrXjO6zJugwCwV4cQVDNYSgdt92yRF3k0pLR/b
         nOB7pGg1usjUOaITlU1KPGr6QfHDsa2KcSV+2x3tTX8zM1IdLd/wAHBKE4+oXkKNS6X+
         g/y1kjD7T2wvtN2vSXFg4Chr6x9g+Glm97uF/WRfXuGxVDuuLaUXBvEB7hbXofztmHQs
         UjSQ==
In-Reply-To: <1374622742-11219-1-git-send-email-andi@etezian.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andi Shyti <andi@etezian.org>
Cc: trinity@vger.kernel.org, mikko.rapeli@iki.fi

2013/7/24 Andi Shyti <andi@etezian.org>:
> This patch enables newer linux/btrfs.h in Kernel headers 3.11,
> where NULL is not recognized as a define. It gets rid of the
> following compiling error:
>
> In file included from ioctls/btrfs-control.c:5:0:
> /usr/include/linux/btrfs.h: In function =91btrfs_err_str=92:
> /usr/include/linux/btrfs.h:486:11: error: =91NULL=92 undeclared (firs=
t use in this function)
>     return NULL;
>            ^
>
> This is done by postponing the inclusion of btrf.h
>
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  ioctls/btrfs-control.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ioctls/btrfs-control.c b/ioctls/btrfs-control.c
> index 35e5389..8d1e2d9 100644
> --- a/ioctls/btrfs-control.c
> +++ b/ioctls/btrfs-control.c
> @@ -2,11 +2,11 @@
>
>  #ifdef USE_BTRFS
>
> -#include <linux/btrfs.h>
> -
>  #include "trinity.h"
>  #include "ioctls.h"
>
> +#include <linux/btrfs.h>
> +

Thanks for the patch!

I have one comment: if you look at other files in ioctl/, we're
including the system headers before the trinity headers, so how about
including something like <stdlib.h> before btrfs.h? That should also
fix this, right?

>  static const struct ioctl btrfs_control_ioctls[] =3D {
>         IOCTL(BTRFS_IOC_SCAN_DEV),
>         IOCTL(BTRFS_IOC_DEVICES_READY),
> --
> 1.8.3.2
>
