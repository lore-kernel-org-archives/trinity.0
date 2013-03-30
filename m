From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH] Add tokens for kernels with earlier versions of exynos_drm.h.
Date: Sat, 30 Mar 2013 09:24:36 +0200
Message-ID: <CA+ydwtpTkRyo12PYuNof2CuxPUe8iQs52MNV=+LE4+WDr43wnQ@mail.gmail.com>
References: <1364604428-12490-1-git-send-email-vlee@twitter.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        bh=oc2qz3tNrCVifGnuQiUDIAOTiK9ZGUF8c/QeiCQAItI=;
        b=NFJlm9Ol/mNqxTGCUhc0aWB9PFbegVCLyE46lxl5d2Hj+sdAb7DivXITHLt7vsoidS
         KVokAJq2XshNEbTNoNscJ/zSfwaPd2SqYXtqsW45jd4n04CIVX7fo2H3r2PhjcSIGQr1
         MkHIHm6D6CImKSKE7Ff7hGdIpL7wEb5YwWcGPsT5jV2RjzSLu4M+8Mj7Wx44PuCwRAXR
         WQyFi4XRJteQBR7D0BIk9lzMnhlDmwaNKFWHklxiGBjz5UKPEbIDtQDiqxfKinlvkXhC
         FgU++CsDlJS28yXEjiR1log4cG3SfwHY6chKAm8YCyM1icoPXgfmXBeJ+gK1WkWgx3UB
         qsdg==
In-Reply-To: <1364604428-12490-1-git-send-email-vlee@twitter.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Vinson Lee <vlee@twitter.com>
Cc: trinity@vger.kernel.org

2013/3/30 Vinson Lee <vlee@twitter.com>
>
> This patch fixes these build errors with Linux 3.4 and earlier.
>
>   CC    ioctls/drm.o
> ioctls/drm.c:179: error: =91DRM_IOCTL_EXYNOS_GEM_GET=92 undeclared he=
re (not in a function)
> ioctls/drm.c:181: error: =91DRM_IOCTL_EXYNOS_G2D_GET_VER=92 undeclare=
d here (not in a function)
> ioctls/drm.c:182: error: =91DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST=92 undec=
lared here (not in a function)
> ioctls/drm.c:183: error: =91DRM_IOCTL_EXYNOS_G2D_EXEC=92 undeclared h=
ere (not in a function)
> make: *** [ioctls/drm.o] Error 1
>
> Signed-off-by: Vinson Lee <vlee@twitter.com>
> ---
>  include/compat.h |   14 ++++++++++++++
>  ioctls/drm.c     |    1 +
>  2 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/include/compat.h b/include/compat.h
> index 934ec78..70cf34c 100644
> --- a/include/compat.h
> +++ b/include/compat.h
> @@ -487,4 +487,18 @@ struct sockaddr_nfc {
>  #define IN_EXCL_UNLINK 0x04000000      /* exclude events on unlinked=
 objects */
>  #endif
>
> +/* drm/exynos_drm.h */
> +#ifndef DRM_IOCTL_EXYNOS_GEM_GET
> +#define DRM_IOCTL_EXYNOS_GEM_GET 0x04
> +#endif
> +#ifndef DRM_IOCTL_EXYNOS_G2D_GET_VER
> +#define DRM_IOCTL_EXYNOS_G2D_GET_VER 0x20
> +#endif
> +#ifndef DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST
> +#define DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST 0x21
> +#endif
> +#ifndef DRM_IOCTL_EXYNOS_G2D_EXEC
> +#define DRM_IOCTL_EXYNOS_G2D_EXEC 0x22
> +#endif
> +

Hi, these are not the complete ioctl commands. In the kernel headers
these numbers are passed to DRM_IOWR(), and on my box the results are:

$ ./trinity -I|grep EXYNOS
  - 0xc0106440 : DRM_IOCTL_EXYNOS_GEM_CREATE
  - 0xc0106441 : DRM_IOCTL_EXYNOS_GEM_MAP_OFFSET
  - 0xc0186442 : DRM_IOCTL_EXYNOS_GEM_MMAP
  - 0xc0106444 : DRM_IOCTL_EXYNOS_GEM_GET
  - 0xc0106447 : DRM_IOCTL_EXYNOS_VIDI_CONNECTION
  - 0xc0086460 : DRM_IOCTL_EXYNOS_G2D_GET_VER
  - 0xc0286461 : DRM_IOCTL_EXYNOS_G2D_SET_CMDLIST
  - 0xc0086462 : DRM_IOCTL_EXYNOS_G2D_EXEC

I propose to just #ifdef the missing exynos ioctls one-by-one in
ioctls/drm.c as it is done for other potentially missing ioctls.

Thanks,
Tommi

>
>  #endif /* _TRINITY_COMPAT_H */
> diff --git a/ioctls/drm.c b/ioctls/drm.c
> index afb3147..82b300e 100644
> --- a/ioctls/drm.c
> +++ b/ioctls/drm.c
> @@ -17,6 +17,7 @@
>
>  #include "trinity.h"
>  #include "ioctls.h"
> +#include "compat.h"
>
>  /* Copy-paste relevant stuff from header, as it is buggy. */
>  /* #include <drm/sis_drm.h> */
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe trinity" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
