From: Dave Jones <davej@redhat.com>
Subject: Re: compile error wrt VERSION
Date: Fri, 11 Jul 2014 10:35:05 -0400
Message-ID: <20140711143505.GA27662@redhat.com>
References: <53BFF3EB.7030204@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53BFF3EB.7030204@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Jul 11, 2014 at 04:25:47PM +0200, Toralf F=C3=B6rster wrote:
 > At a 32 bit stable Gentoo Linux I do get (using make -j4):
 >=20
 > gical-op -Wstrict-aliasing=3D3  -o devices.o -c devices.c
 > In file included from debug.c:13:0:
 > include/version.h:3:9: error: macro names must be identifiers
 > debug.c: In function =E2=80=98__BUG=E2=80=99:
 > debug.c:44:23: error: =E2=80=98VERSION=E2=80=99 undeclared (first us=
e in this function)
 > debug.c:44:23: note: each undeclared identifier is reported only onc=
e for each function it appears in
 > make: *** [debug.o] Error 1
 > make: *** Waiting for unfinished jobs....

interesting. Can you paste the contents of include/version.h ?

Does this system have git installed ? (Trying to figure out which
part of scripts/gen-versionh.sh is getting run)

	Dave
=20
