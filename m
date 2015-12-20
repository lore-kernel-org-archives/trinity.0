From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: 32bit compile error w/ v1.6-115-g4a302e2
Date: Sun, 20 Dec 2015 17:05:10 +0100
Message-ID: <5676D1B6.3060703@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

Happened within a 32 bit KVM of a stable gentoo:


i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W  -I. -I=
include/ -Wimplicit  -D_GNU_SOURCE -D__linux__  -Wdeclaration-after-sta=
tement -Wformat=3D2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wsw=
itch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-proto=
types -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3D3 -Wno-mayb=
e-uninitialized -o ioctls/nvme.o -c ioctls/nvme.c
In file included from ioctls/nvme.c:5:0:
ioctls/nvme.c:11:8: error: =E2=80=98NVME_IOCTL_IO_CMD=E2=80=99 undeclar=
ed here (not in a function)
  IOCTL(NVME_IOCTL_IO_CMD),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W  -I. -I=
include/ -Wimplicit  -D_GNU_SOURCE -D__linux__  -Wdeclaration-after-sta=
tement -Wformat=3D2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wsw=
itch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-proto=
types -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3D3 -Wno-mayb=
e-uninitialized -o ioctls/ozwpan.o -c ioctls/ozwpan.c
ioctls/nvme.c:12:8: error: =E2=80=98NVME_IOCTL_RESET=E2=80=99 undeclare=
d here (not in a function)
  IOCTL(NVME_IOCTL_RESET),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
Makefile:105: recipe for target 'ioctls/nvme.o' failed
make: *** [ioctls/nvme.o] Error 1
 * ERROR: dev-util/trinity-9::local failed (compile phase):
 *   emake failed

--=20
Toralf, pgp: C4EACDDE 0076E94E
