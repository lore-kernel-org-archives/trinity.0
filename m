From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: maps.c:45:2: error: =?UTF-8?B?4oCYc3RydWN0IG1hcOKAmSBoYXMgbm8gbWU=?=
 =?UTF-8?B?bWJlciBuYW1lZCDigJhsaXN04oCZ?=
Date: Thu, 05 Dec 2013 17:42:34 +0100
Message-ID: <52A0ACFA.9040607@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

latest git at a stable Gentoo Linux 32 bit :

s -Wmissing-prototypes -Werror -o maps.o -c maps.c
maps.c: In function =E2=80=98dump_maps=E2=80=99:
maps.c:45:2: error: =E2=80=98struct map=E2=80=99 has no member named =E2=
=80=98list=E2=80=99
maps.c:45:2: error: =E2=80=98struct map=E2=80=99 has no member named =E2=
=80=98list=E2=80=99
maps.c: In function =E2=80=98alloc_zero_map=E2=80=99:
maps.c:96:14: error: =E2=80=98struct map=E2=80=99 has no member named =E2=
=80=98list=E2=80=99
maps.c:97:24: error: =E2=80=98struct map=E2=80=99 has no member named =E2=
=80=98list=E2=80=99
maps.c: In function =E2=80=98setup_maps=E2=80=99:i686-pc-linux-gnu-gcc =
-O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -I. -Iinclude/ -Wimplicit =
 -D_GNU_SOURCE -Wdeclaration-after-statement -Wformat=3D2 -Winit-self -=
Wlogical-op -Wnested-externs -Wpacked -Wshadow -Wstrict-aliasing=3D3 -W=
switch-default -Wswitch-enum -Wundef -Wwrite-strings -Wstrict-prototype=
s -Wmissing-prototypes -Werror -o params.o -c params.c

maps.c:106:22: error: =E2=80=98struct map=E2=80=99 has no member named =
=E2=80=98list=E2=80=99
maps.c: In function =E2=80=98get_map=E2=80=99:
maps.c:124:2: error: =E2=80=98struct map=E2=80=99 has no member named =E2=
=80=98list=E2=80=99
maps.c:124:2: error: =E2=80=98struct map=E2=80=99 has no member named =E2=
=80=98list=E2=80=99
maps.c: In function =E2=80=98destroy_maps=E2=80=99:
maps.c:138:26: error: =E2=80=98struct map=E2=80=99 has no member named =
=E2=80=98list=E2=80=99
maps.c:144:26: error: =E2=80=98struct map=E2=80=99 has no member named =
=E2=80=98list=E2=80=99
maps.c:146:14: error: =E2=80=98struct map=E2=80=99 has no member named =
=E2=80=98list=E2=80=99
make: *** [maps.o] Error 1
make: *** Waiting for unfinished jobs....
 * ERROR: dev-util/trinity-9999::toralf failed (compile phase):



--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
