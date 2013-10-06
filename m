From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Sun, 06 Oct 2013 23:01:08 +0200
Message-ID: <5251CF94.5040101@gmx.de>
References: <524C6643.2040209@gmx.de>	<CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>	<524DBD5D.1040203@gmx.de>	<524DBFBB.1050002@nod.at>	<524DC278.3020106@gmx.de>	<524DC394.6030406@nod.at>	<524DC675.4020201@gmx.de>	<524E57BA.805@nod.at>	<52517109.90605@gmx.de>	<CAMuHMdXrU0e_6AxvdboMkDs+N+tSWD+b8ou92j28c0vsq2eQQA@mail.gmail.com>	<5251C334.3010604@gmx.de> <CAMuHMdUo8dSd4s3089ZDEc485wL1sFxBKLeaExJuqNiQY+S-Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUo8dSd4s3089ZDEc485wL1sFxBKLeaExJuqNiQY+S-Lw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>, UML devel <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

On 10/06/2013 10:26 PM, Geert Uytterhoeven wrote:
> On Sun, Oct 6, 2013 at 10:08 PM, Toralf F=C3=B6rster <toralf.foerster=
@gmx.de> wrote:
>> On 10/06/2013 08:38 PM, Geert Uytterhoeven wrote:
>>> On Sun, Oct 6, 2013 at 4:17 PM, Toralf F=C3=B6rster <toralf.foerste=
r@gmx.de> wrote:
>>>> The UML stopped here :
>>>> ...
>>>>                 if (unlikely(task_ratelimit =3D=3D 0)) {
>>>>                         period =3D max_pause;
>>>>                         pause =3D max_pause;
>>>>                         BUG_ON(pause < 0);
>>>>                         goto pause;
>>>>                 }
>>>>                 BUG_ON(pages_dirtied < 0);
>>>>                 BUG_ON(task_ratelimit < 0);
>>>>                 period =3D HZ * pages_dirtied / task_ratelimit;
>>>>                 BUG_ON(period < 0);         <---------------------=
-here
>>>
>>> So pages_dirtied becomes that big compared to task_ratelimit (both =
are
>>> "unsigned long"), that period (which is "long", just like "pause") =
overflows
>>> into a negative number.
>>>
>>> This is indeed much more likely to happen on 32-bit.
>>>
>>>> The back trace is :
>>>
>>>> #9  0x08411c64 in balance_dirty_pages (pages_dirtied=3D9, mapping=3D=
<optimized out>) at mm/page-writeback.c:1471
>>>
>>> But here pages_dirtied is only 9??
>=20
>> Well, this points to an overflow or ? :
>=20
> Negative indicates an overflow, but pages_dirtied doesn't.
>=20
>> tfoerste@n22 ~/devel/linux $ nl -ba mm/page-writeback.c | grep -A 5 =
-B 5 1468
>>   1463                          BUG_ON(pause < 0);
>>   1464                          goto pause;
>>   1465                  }
>>   1466                  period =3D HZ * pages_dirtied / task_ratelim=
it;
>>   1467                  pause =3D period;
>>   1468                  BUG_ON(pause < 0 && pages_dirtied > 0 && tas=
k_ratelimit > 0);
>>   1469                  if (current->dirty_paused_when)
>>   1470                          pause -=3D now - current->dirty_paus=
ed_when;
>>   1471                  /*
>>   1472                   * For less than 1s think time (ext3/4 may b=
lock the dirtier
>>   1473                   * for up to 800ms from time to time on 1-HD=
D; so does xfs,
>>
>>
>> and the back trace is :
>>
>> #9  0x08411c6c in balance_dirty_pages (pages_dirtied=3D0, mapping=3D=
<optimized out>) at mm/page-writeback.c:1468
>=20
> Hmm, now pages_dirtied is zero, according to the backtrace, but the B=
UG_ON()
> asserts its strict positive?!?
>=20
> Can you please try the following instead of the BUG_ON():
>=20
> if (pause < 0) {
>         printk("pages_dirtied =3D %lu\n", pages_dirtied);
>         printk("task_ratelimit =3D %lu\n", task_ratelimit);
>         printk("pause =3D %ld\n", pause);
> }
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
I tried it in different ways already - I'm completely unsuccessful in g=
etting any printk output.
As soon as the issue happens I do have a=20

BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:1521]

at stderr of the UML and then no further input is accepted. With uml_mc=
onsole I'm however able
to run very basic commands like a crash dump, sysrq ond so on.



>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linu=
x-m68k.org
>=20
> In personal conversations with technical people, I call myself a hack=
er. But
> when I'm talking to journalists I just say "programmer" or something =
like that.
>                                 -- Linus Torvalds
>=20


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
