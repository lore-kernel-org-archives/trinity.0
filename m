From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: latest git tree gives a build error at a 32 bit Gentoo Linux
Date: Tue, 03 Dec 2013 18:13:28 +0100
Message-ID: <529E1138.1050207@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

shadow -Wstrict-aliasing=3D3 -Wswitch-default -Wswitch-enum -Wundef
-Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes -Werror -o
utils.o -c utils.c
utils.c: In function =E2=80=98zmalloc=E2=80=99:
utils.c:12:3: error: format =E2=80=98%ld=E2=80=99 expects argument of t=
ype =E2=80=98long int=E2=80=99,
but argument 2 has type =E2=80=98size_t=E2=80=99 [-Werror=3Dformat]
cc1: all warnings being treated as errors
make: *** [utils.o] Error 1
make: *** Waiting for unfinished jobs....

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
