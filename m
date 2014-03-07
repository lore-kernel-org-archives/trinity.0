From: Dave Jones <davej@redhat.com>
Subject: Re: build error with latest gir tree at a 32 bit Linux
Date: Fri, 7 Mar 2014 13:16:47 -0500
Message-ID: <20140307181647.GA10060@redhat.com>
References: <5318ADF3.5030905@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5318ADF3.5030905@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Mar 06, 2014 at 06:18:43PM +0100, Toralf F=C3=B6rster wrote:
 > -----BEGIN PGP SIGNED MESSAGE-----
 > Hash: SHA256
 >=20
 > i686-pc-linux-gnu-gcc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -=
I. -Iinclude/ -Wimplicit  -D_GNU_SOURCE -D__linux__ -Wdeclaration-after=
-statement -Wformat=3D2 -Winit-self -Wlogical-op -Wnested-externs -Wpac=
ked -Wshadow -Wstrict-aliasing=3D3 -Wswitch-enum -Wundef -Wwrite-string=
s -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Werr=
or -Wl,-O1 -Wl,--as-needed -o interesting-numbers.o -c interesting-numb=
ers.c
 > i686-pc-linux-gnu-gcc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -=
I. -Iinclude/ -Wimplicit  -D_GNU_SOURCE -D__linux__ -Wdeclaration-after=
-statement -Wformat=3D2 -Winit-self -Wlogical-op -Wnested-externs -Wpac=
ked -Wshadow -Wstrict-aliasing=3D3 -Wswitch-enum -Wundef -Wwrite-string=
s -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Werr=
or -Wl,-O1 -Wl,--as-needed -o locks.o -c locks.c
 > i686-pc-linux-gnu-gcc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -=
I. -Iinclude/ -Wimplicit  -D_GNU_SOURCE -D__linux__ -Wdeclaration-after=
-statement -Wformat=3D2 -Winit-self -Wlogical-op -Wnested-externs -Wpac=
ked -Wshadow -Wstrict-aliasing=3D3 -Wswitch-enum -Wundef -Wwrite-string=
s -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Werr=
or -Wl,-O1 -Wl,--as-needed -o log.o -c log.c
 > locks.c: In function =E2=80=98lock=E2=80=99:
 > locks.c:4:19: error: declaration of =E2=80=98lock=E2=80=99 shadows a=
 global declaration [-Werror=3Dshadow]
 > locks.c:4:6: error: shadowed declaration is here [-Werror=3Dshadow]
 > locks.c: In function =E2=80=98unlock=E2=80=99:
 > locks.c:12:21: error: declaration of =E2=80=98lock=E2=80=99 shadows =
a global declaration [-Werror=3Dshadow]
 > locks.c:4:6: error: shadowed declaration is here [-Werror=3Dshadow]
 > cc1: all warnings being treated as errors
 > make: *** [locks.o] Error 1
 > make: *** Waiting for unfinished jobs....
 >  * ERROR: dev-util/trinity-9999::toralf failed (compile phase):
 >  *   emake failed
 >  *

should be fixed as of 4cbfe382138d930209043ab57a648a3df5cfb46a

	Dave
=20
