From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH] ioctls: videodev2: check if defines are obsolete
Date: Wed, 24 Jul 2013 09:44:57 +0300
Message-ID: <CA+ydwtrqHHNXMvrz+tHewGcXT=kujJ8h4TrVJ=CX=rdOsOqqjA@mail.gmail.com>
References: <1374619327-13259-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=cGj9juFuySNq5Ox/bUDwn+0sxMR4eSrDUCOwXdC0KW8=;
        b=MeqqveHns/Xebq/aM9YZ5xRCb4NdI4OVGlERbZJzoxCrJwo3LESqp0abHVOfBXQjAt
         Cqnci1E/F5a9x3HXjDL6ACg8eNfcTCyhsGtIMSmgWvSF9kqiBhWujOfDzYm11J9edXbo
         wXlhvD+YU225EeWikihtb2FSKkFxuWe9VE6NeIjj/LOgc3J6ZsnMmt5VVi3KwY2HdwIL
         Yu5AQJvrelSZAtPVF90F5TgKK7t8iNHZg1+DMmfDkKK75XpNu+KQZtA1nAz+q0AXZDRh
         Gv9LnWiZCSItDhnJNCLwzTOd8ibJg7eHbNhPr4/D+3SLWle1e4+qHEBvet8/zvL6lr2I
         q+Lw==
In-Reply-To: <1374619327-13259-1-git-send-email-andi@etezian.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andi Shyti <andi@etezian.org>
Cc: trinity@vger.kernel.org, mikko.rapeli@iki.fi

2013/7/24 Andi Shyti <andi@etezian.org>:
> In kernel headers 3.11 the VIDIOC_DBG_G_CHIP_IDENT define is
> considered obsolete, therefore removed, generating the following
> compiling error:
>
> ioctls/videodev2.c:72:15: error: =91VIDIOC_DBG_G_CHIP_IDENT=92 undecl=
ared here (not in a function)
>   IOCTL(VIDIOC_DBG_G_CHIP_IDENT),
>                ^
>
> Check the definition of it before using it
>
> Signed-off-by: Andi Shyti <andi@etezian.org>

Thanks, looks good!

> ---
>  ioctls/videodev2.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/ioctls/videodev2.c b/ioctls/videodev2.c
> index 0d1473e..03a5ae5 100644
> --- a/ioctls/videodev2.c
> +++ b/ioctls/videodev2.c
> @@ -69,7 +69,9 @@ static const struct ioctl videodev2_ioctls[] =3D {
>         IOCTL(VIDIOC_TRY_ENCODER_CMD),
>         IOCTL(VIDIOC_DBG_S_REGISTER),
>         IOCTL(VIDIOC_DBG_G_REGISTER),
> +#ifdef VIDIOC_DBG_G_CHIP_IDENT
>         IOCTL(VIDIOC_DBG_G_CHIP_IDENT),
> +#endif
>         IOCTL(VIDIOC_S_HW_FREQ_SEEK),
>  #ifdef VIDIOC_ENUM_DV_PRESETS
>         IOCTL(VIDIOC_ENUM_DV_PRESETS),
> --
> 1.8.3.2
>
