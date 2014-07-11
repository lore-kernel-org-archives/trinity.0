From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: compile error wrt VERSION
Date: Fri, 11 Jul 2014 16:25:47 +0200
Message-ID: <53BFF3EB.7030204@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

At a 32 bit stable Gentoo Linux I do get (using make -j4):

gical-op -Wstrict-aliasing=3D3  -o devices.o -c devices.c
In file included from debug.c:13:0:
include/version.h:3:9: error: macro names must be identifiers
debug.c: In function =E2=80=98__BUG=E2=80=99:
debug.c:44:23: error: =E2=80=98VERSION=E2=80=99 undeclared (first use i=
n this function)
debug.c:44:23: note: each undeclared identifier is reported only once f=
or each function it appears in
make: *** [debug.o] Error 1
make: *** Waiting for unfinished jobs....


--=20
Toralf
