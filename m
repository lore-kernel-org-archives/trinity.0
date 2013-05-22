From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: random.c:183:3: error: left shift count >= width of type [-Werror]
Date: Wed, 22 May 2013 19:14:03 +0200
Message-ID: <519CFCDB.2000509@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

At a 32 bit stable Gentoo Linux I get with current git tree :

  CC    child.o
random.c: In function =E2=80=98rand64=E2=80=99:
random.c:183:3: error: left shift count >=3D width of type [-Werror]
cc1: all warnings being treated as errors
make: *** [random.o] Error 1

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
