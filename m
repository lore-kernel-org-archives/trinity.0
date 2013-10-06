From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Sun, 6 Oct 2013 20:38:19 +0200
Message-ID: <CAMuHMdXrU0e_6AxvdboMkDs+N+tSWD+b8ou92j28c0vsq2eQQA@mail.gmail.com>
References: <524C6643.2040209@gmx.de>
	<CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>
	<524DBD5D.1040203@gmx.de>
	<524DBFBB.1050002@nod.at>
	<524DC278.3020106@gmx.de>
	<524DC394.6030406@nod.at>
	<524DC675.4020201@gmx.de>
	<524E57BA.805@nod.at>
	<52517109.90605@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=Wg5GHAKxVW3sKfTLI2wz88vbE1ZIaTrVdItTvQSNBiQ=;
        b=jrc+v9Z/obVrmUM99BgeIeOGtN8k1LPSzyTAsKGjjnfXYxgZ8EyWoroj/RgqaFTrsV
         QzKwnjTwX3pAzMFo5xnZl/o1PwDuSdXkIBS29DR7MIZxv8+nnTfx6bABNiHi5HOwU6kC
         f7mdt5wLlHlqtsroft73f8cnstfwbgvChFwfS027oSjXDB1PzdBskTx4N7eGKdn8HO8w
         YCnSy4rBbWzGVex/QJelJtct8gq/RUSjdqaWvPePDN6tvrCW5p4cGQqsUcVgHffMvA9X
         E8X51ElTSy4w0UC1xbxkp+3OaleAhB/hDPc5dKCTRbpHUtIEK7NmrJYibAFaUnBanp7V
         y9PA==
In-Reply-To: <52517109.90605@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>, UML devel <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

On Sun, Oct 6, 2013 at 4:17 PM, Toralf F=C3=B6rster <toralf.foerster@gm=
x.de> wrote:
> The UML stopped here :
> ...
>                 if (unlikely(task_ratelimit =3D=3D 0)) {
>                         period =3D max_pause;
>                         pause =3D max_pause;
>                         BUG_ON(pause < 0);
>                         goto pause;
>                 }
>                 BUG_ON(pages_dirtied < 0);
>                 BUG_ON(task_ratelimit < 0);
>                 period =3D HZ * pages_dirtied / task_ratelimit;
>                 BUG_ON(period < 0);         <----------------------he=
re

So pages_dirtied becomes that big compared to task_ratelimit (both are
"unsigned long"), that period (which is "long", just like "pause") over=
flows
into a negative number.

This is indeed much more likely to happen on 32-bit.

> The back trace is :

> #9  0x08411c64 in balance_dirty_pages (pages_dirtied=3D9, mapping=3D<=
optimized out>) at mm/page-writeback.c:1471

But here pages_dirtied is only 9??

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
