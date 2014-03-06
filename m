From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: build error with latest gir tree at a 32 bit Linux
Date: Thu, 06 Mar 2014 18:18:43 +0100
Message-ID: <5318ADF3.5030905@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

i686-pc-linux-gnu-gcc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -I. =
-Iinclude/ -Wimplicit  -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-st=
atement -Wformat=3D2 -Winit-self -Wlogical-op -Wnested-externs -Wpacked=
 -Wshadow -Wstrict-aliasing=3D3 -Wswitch-enum -Wundef -Wwrite-strings -=
Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Werror =
-Wl,-O1 -Wl,--as-needed -o interesting-numbers.o -c interesting-numbers=
=2Ec
i686-pc-linux-gnu-gcc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -I. =
-Iinclude/ -Wimplicit  -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-st=
atement -Wformat=3D2 -Winit-self -Wlogical-op -Wnested-externs -Wpacked=
 -Wshadow -Wstrict-aliasing=3D3 -Wswitch-enum -Wundef -Wwrite-strings -=
Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Werror =
-Wl,-O1 -Wl,--as-needed -o locks.o -c locks.c
i686-pc-linux-gnu-gcc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -I. =
-Iinclude/ -Wimplicit  -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-st=
atement -Wformat=3D2 -Winit-self -Wlogical-op -Wnested-externs -Wpacked=
 -Wshadow -Wstrict-aliasing=3D3 -Wswitch-enum -Wundef -Wwrite-strings -=
Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Werror =
-Wl,-O1 -Wl,--as-needed -o log.o -c log.c
locks.c: In function =E2=80=98lock=E2=80=99:
locks.c:4:19: error: declaration of =E2=80=98lock=E2=80=99 shadows a gl=
obal declaration [-Werror=3Dshadow]
locks.c:4:6: error: shadowed declaration is here [-Werror=3Dshadow]
locks.c: In function =E2=80=98unlock=E2=80=99:
locks.c:12:21: error: declaration of =E2=80=98lock=E2=80=99 shadows a g=
lobal declaration [-Werror=3Dshadow]
locks.c:4:6: error: shadowed declaration is here [-Werror=3Dshadow]
cc1: all warnings being treated as errors
make: *** [locks.o] Error 1
make: *** Waiting for unfinished jobs....
 * ERROR: dev-util/trinity-9999::toralf failed (compile phase):
 *   emake failed
 *
 * If you need support, post the output of `emerge --info '=3Ddev-util/=
trinity-9999::toralf'`,

- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMYrfIACgkQxOrN3gB26U4W2AD9EjBYwm07R8MgTHt0x8HwwNtD
h89c9Ebx7VZAkGW7e8cA+gKUgk+wfe69o2r55Sz2drcj4gKb3yTWxj3ON08I59QF
=3Dw/Mb
-----END PGP SIGNATURE-----
