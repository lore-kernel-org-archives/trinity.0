From: Dave Jones <davej@redhat.com>
Subject: Re: maps.c:45:2: error: =?utf-8?B?4oCYc3Ry?=
 =?utf-8?B?dWN0IG1hcOKAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmGxpc3TigJk=?=
Date: Thu, 5 Dec 2013 17:10:28 -0500
Message-ID: <20131205221028.GA18984@redhat.com>
References: <52A0ACFA.9040607@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52A0ACFA.9040607@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Dec 05, 2013 at 05:42:34PM +0100, Toralf F=C3=B6rster wrote:
 > latest git at a stable Gentoo Linux 32 bit :
 >=20
 > s -Wmissing-prototypes -Werror -o maps.o -c maps.c
 > maps.c: In function =E2=80=98dump_maps=E2=80=99:
 > maps.c:45:2: error: =E2=80=98struct map=E2=80=99 has no member named=
 =E2=80=98list=E2=80=99
 > maps.c:45:2: error: =E2=80=98struct map=E2=80=99 has no member named=
 =E2=80=98list=E2=80=99
 > maps.c: In function =E2=80=98alloc_zero_map=E2=80=99:
 > maps.c:96:14: error: =E2=80=98struct map=E2=80=99 has no member name=
d =E2=80=98list=E2=80=99
 > maps.c:97:24: error: =E2=80=98struct map=E2=80=99 has no member name=
d =E2=80=98list=E2=80=99
 > maps.c: In function =E2=80=98setup_maps=E2=80=99:i686-pc-linux-gnu-g=
cc -O2 -march=3Dnative -pipe -g -ggdb -Wall -W  -I. -Iinclude/ -Wimplic=
it  -D_GNU_SOURCE -Wdeclaration-after-statement -Wformat=3D2 -Winit-sel=
f -Wlogical-op -Wnested-externs -Wpacked -Wshadow -Wstrict-aliasing=3D3=
 -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wstrict-protot=
ypes -Wmissing-prototypes -Werror -o params.o -c params.c
 >=20
 > maps.c:106:22: error: =E2=80=98struct map=E2=80=99 has no member nam=
ed =E2=80=98list=E2=80=99
 > maps.c: In function =E2=80=98get_map=E2=80=99:
 > maps.c:124:2: error: =E2=80=98struct map=E2=80=99 has no member name=
d =E2=80=98list=E2=80=99
 > maps.c:124:2: error: =E2=80=98struct map=E2=80=99 has no member name=
d =E2=80=98list=E2=80=99
 > maps.c: In function =E2=80=98destroy_maps=E2=80=99:
 > maps.c:138:26: error: =E2=80=98struct map=E2=80=99 has no member nam=
ed =E2=80=98list=E2=80=99
 > maps.c:144:26: error: =E2=80=98struct map=E2=80=99 has no member nam=
ed =E2=80=98list=E2=80=99
 > maps.c:146:14: error: =E2=80=98struct map=E2=80=99 has no member nam=
ed =E2=80=98list=E2=80=99
 > make: *** [maps.o] Error 1
 > make: *** Waiting for unfinished jobs....
 >  * ERROR: dev-util/trinity-9999::toralf failed (compile phase):

somehow missed a git add. Fixed now.

The work I'm doing on the mmap syscalls might mean you see more oom kil=
ls
for a while btw, especially on 32bit if you run a lot of child processe=
s/instances.

	Dave

=20
