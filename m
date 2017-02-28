From: Vinson Lee <vlee@freedesktop.org>
Subject: Re: [PATCH] fds/drm.c: Increase buffer size.
Date: Tue, 28 Feb 2017 17:59:24 -0500
Message-ID: <CACKvgLGaKWEu_vGmqEOqeauZ7053TOh4iddndGEbJyiUk-VAnQ@mail.gmail.com>
References: <1488311356-12461-1-git-send-email-vlee@freedesktop.org> <20170228210855.sj2zpdw3fusqh4hv@codemonkey.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Ob72d9QU/+26LMP4eJBIL9Je6Ki/QTrzT0ev3B3nHBc=;
        b=XU4GV2IPBEegGL4T7mtIlOaw69Rx7RNF1R4eb4KJz2mQG/INOSUWmrxffcYB0+kk7U
         fA8qT6DmMxuKdgwnImKxVbDqxp5oiMwcTLOSYRcTu4LKNkSclBVl72m7keZFat+0UWkB
         y8ul6/YCXgYIR0lRecyxW4R9kcKqfMOqJJXfDE2ZUIEf30lDO3NSJCcyBgdrmafiSJE8
         2m/rcm0FqIBGtnCS8g710Z89OYySKWBjBiVanRune3MlR7PAkE6/84KqaiqyHT8fSw0z
         plz3Pds75GZ0eHNLgxj3xvIoR3nAURF2hvM8DpX5e8NRVdkOgAHqvITiUoKgsSsfDYYd
         PjUg==
In-Reply-To: <20170228210855.sj2zpdw3fusqh4hv@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

On Tue, Feb 28, 2017 at 4:08 PM, Dave Jones <davej@codemonkey.org.uk> wrote=
:
> On Tue, Feb 28, 2017 at 07:49:16PM +0000, Vinson Lee wrote:
>  > Fix GCC format-truncation error.
>  >
>  >   CC fds/drm.o
>  > fds/drm.c: In function =E2=80=98open_drm_fds=E2=80=99:
>  > fds/drm.c:106:40: error: =E2=80=98%s=E2=80=99 directive output may be =
truncated writing up to 255 bytes into a region of size 119 [-Werror=3Dform=
at-truncation=3D]
>  >    snprintf(buf, sizeof(buf), "/dev/dri/%s", entry->d_name);
>  >                                         ^~
>  > In file included from /usr/include/stdio.h:939:0,
>  >                  from include/list.h:3,
>  >                  from include/fd.h:3,
>  >                  from fds/drm.c:4:
>  > /usr/include/bits/stdio2.h:64:10: note: =E2=80=98__builtin___snprintf_=
chk=E2=80=99 output between 10 and 265 bytes into a destination of size 128
>  >    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>  >           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  >         __bos (__s), __fmt, __va_arg_pack ());
>  >         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  >
>  > Signed-off-by: Vinson Lee <vlee@freedesktop.org>
>  > ---
>  >  fds/drm.c | 2 +-
>  >  1 file changed, 1 insertion(+), 1 deletion(-)
>  >
>  > diff --git a/fds/drm.c b/fds/drm.c
>  > index 1f7b95f1eb34..b094183d8d0d 100644
>  > --- a/fds/drm.c
>  > +++ b/fds/drm.c
>  > @@ -83,7 +83,7 @@ static int open_drm_fds(void)
>  >      int fd, dfd;
>  >      DIR *dir;
>  >      struct dirent *entry;
>  > -    char buf[128];
>  > +    char buf[512];
>
> d_name is only 256. Does 256+10 make the error go away ?
>
> I don't think this is ever a problem in real life, because no-one is
> insane enough to name a device node in that dir that long, but we should
> shut the warning up.
>
> Is this a gcc7 thing ?
>
>         Dave
>

Yes, buf[256+10] also fixes the build error.

Yes, this build error occurs with 7.0.

Vinson
