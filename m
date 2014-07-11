From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: compile error wrt VERSION
Date: Fri, 11 Jul 2014 16:48:31 +0200
Message-ID: <53BFF93F.5030208@gmx.de>
References: <53BFF3EB.7030204@gmx.de> <20140711143505.GA27662@redhat.com> <20140711143801.GA3386@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140711143801.GA3386@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 07/11/2014 04:38 PM, Dave Jones wrote:
> On Fri, Jul 11, 2014 at 10:35:05AM -0400, Dave Jones wrote:
>  > On Fri, Jul 11, 2014 at 04:25:47PM +0200, Toralf F=C3=B6rster wrot=
e:
>  >  > At a 32 bit stable Gentoo Linux I do get (using make -j4):
>  >  >=20
>  >  > gical-op -Wstrict-aliasing=3D3  -o devices.o -c devices.c
>  >  > In file included from debug.c:13:0:
>  >  > include/version.h:3:9: error: macro names must be identifiers
>  >  > debug.c: In function =E2=80=98__BUG=E2=80=99:
>  >  > debug.c:44:23: error: =E2=80=98VERSION=E2=80=99 undeclared (fir=
st use in this function)
>  >  > debug.c:44:23: note: each undeclared identifier is reported onl=
y once for each function it appears in
>  >  > make: *** [debug.o] Error 1
>  >  > make: *** Waiting for unfinished jobs....
>  >=20
>  > interesting. Can you paste the contents of include/version.h ?
>  >=20
>  > Does this system have git installed ? (Trying to figure out which
>  > part of scripts/gen-versionh.sh is getting run)
>=20
> ah, looks like I screwed up the "no git" case. I just pushed a fix.

exactly - for the UML test scenario I do not have git.

The fix works - thx.


>=20
> 	Dave
>=20
>=20


--=20
Toralf
