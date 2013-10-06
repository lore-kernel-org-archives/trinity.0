From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Sun, 6 Oct 2013 22:26:45 +0200
Message-ID: <CAMuHMdUo8dSd4s3089ZDEc485wL1sFxBKLeaExJuqNiQY+S-Lw@mail.gmail.com>
References: <524C6643.2040209@gmx.de>
	<CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>
	<524DBD5D.1040203@gmx.de>
	<524DBFBB.1050002@nod.at>
	<524DC278.3020106@gmx.de>
	<524DC394.6030406@nod.at>
	<524DC675.4020201@gmx.de>
	<524E57BA.805@nod.at>
	<52517109.90605@gmx.de>
	<CAMuHMdXrU0e_6AxvdboMkDs+N+tSWD+b8ou92j28c0vsq2eQQA@mail.gmail.com>
	<5251C334.3010604@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=BOeT49rOGhWZMBI61Sus3YixHjdshOf97Xz92epR9cw=;
        b=QfAZhCvLPgsSMpJYk+AYtvUuDaB1MmOC1lrQOPJ4i11A7tGyo2JyPM7O2PEkA4iDpG
         QUS26DQP+s4aNEM+WiiLVyg6YN+kyABcKLL94Ai0Jnptsw/9dUQyoPhiJNfv/NHC3rBA
         KvN05NMv7runVuDN0qgVzNxY2OVVW77XIzhlbmXdjhtxOF6jM8E47Qh2vlD/y2zQOz7I
         TYk6Y5HMLo8QLXqymy+JgOWIoRinbLKTDOWS4cLpPVgVQdlWXGu96JzVWMuf4sh4KtU4
         o3z5ooyPU3fOi4aHjeNvT+0K8BHdxj/BkTQ48Et3fY3hDV5Y62zNbVzDzyS/YdG+oRnX
         9NVg==
In-Reply-To: <5251C334.3010604@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>, UML devel <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

On Sun, Oct 6, 2013 at 10:08 PM, Toralf F=C3=B6rster <toralf.foerster@g=
mx.de> wrote:
> On 10/06/2013 08:38 PM, Geert Uytterhoeven wrote:
>> On Sun, Oct 6, 2013 at 4:17 PM, Toralf F=C3=B6rster <toralf.foerster=
@gmx.de> wrote:
>>> The UML stopped here :
>>> ...
>>>                 if (unlikely(task_ratelimit =3D=3D 0)) {
>>>                         period =3D max_pause;
>>>                         pause =3D max_pause;
>>>                         BUG_ON(pause < 0);
>>>                         goto pause;
>>>                 }
>>>                 BUG_ON(pages_dirtied < 0);
>>>                 BUG_ON(task_ratelimit < 0);
>>>                 period =3D HZ * pages_dirtied / task_ratelimit;
>>>                 BUG_ON(period < 0);         <----------------------=
here
>>
>> So pages_dirtied becomes that big compared to task_ratelimit (both a=
re
>> "unsigned long"), that period (which is "long", just like "pause") o=
verflows
>> into a negative number.
>>
>> This is indeed much more likely to happen on 32-bit.
>>
>>> The back trace is :
>>
>>> #9  0x08411c64 in balance_dirty_pages (pages_dirtied=3D9, mapping=3D=
<optimized out>) at mm/page-writeback.c:1471
>>
>> But here pages_dirtied is only 9??

> Well, this points to an overflow or ? :

Negative indicates an overflow, but pages_dirtied doesn't.

> tfoerste@n22 ~/devel/linux $ nl -ba mm/page-writeback.c | grep -A 5 -=
B 5 1468
>   1463                          BUG_ON(pause < 0);
>   1464                          goto pause;
>   1465                  }
>   1466                  period =3D HZ * pages_dirtied / task_ratelimi=
t;
>   1467                  pause =3D period;
>   1468                  BUG_ON(pause < 0 && pages_dirtied > 0 && task=
_ratelimit > 0);
>   1469                  if (current->dirty_paused_when)
>   1470                          pause -=3D now - current->dirty_pause=
d_when;
>   1471                  /*
>   1472                   * For less than 1s think time (ext3/4 may bl=
ock the dirtier
>   1473                   * for up to 800ms from time to time on 1-HDD=
; so does xfs,
>
>
> and the back trace is :
>
> #9  0x08411c6c in balance_dirty_pages (pages_dirtied=3D0, mapping=3D<=
optimized out>) at mm/page-writeback.c:1468

Hmm, now pages_dirtied is zero, according to the backtrace, but the BUG=
_ON()
asserts its strict positive?!?

Can you please try the following instead of the BUG_ON():

if (pause < 0) {
        printk("pages_dirtied =3D %lu\n", pages_dirtied);
        printk("task_ratelimit =3D %lu\n", task_ratelimit);
        printk("pause =3D %ld\n", pause);
}

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
