From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: compile error within a 32 bit KVM
Date: Fri, 22 Jan 2016 19:58:29 +0100
Message-ID: <56A27BD5.30106@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

Hi

latest HEAD gives :


i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W  -I. -I=
include/ -Wimplicit  -D_GNU_SOURCE -D__linux__  -Wdeclaration-after-sta=
tement -Wformat=3D2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wsw=
itch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-proto=
types -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3D3 -Wno-mayb=
e-uninitialized -o rand/random.o -c rand/random.c
rand/random-page.c: In function =E2=80=98fabricate_struct=E2=80=99:
rand/random-page.c:67:5: error: =E2=80=98for=E2=80=99 loop initial decl=
arations are only allowed in C99 or C11 mode
     for (int j =3D 0; j < 2; j++) {
     ^
rand/random-page.c:67:5: note: use option -std=3Dc99, -std=3Dgnu99, -st=
d=3Dc11 or -std=3Dgnu11 to compile your code
Makefile:108: recipe for target 'rand/random-page.o' failed
make: *** [rand/random-page.o] Error 1
make: *** Waiting for unfinished jobs....
 * ERROR: dev-util/trinity-9::local failed (compile phase):
 *   emake failed
 *
 * If you need support, post the output of `emerge --info '=3Ddev-util/=
trinity-9::local'`,
 * the complete build log and the output of `emerge -pqv '=3Ddev-util/t=
rinity-9::local'`.
 * The complete build log is located at '/var/log/portage/dev-util:trin=
ity-9:20160122-185702.log.gz'.
 * For convenience, a symlink to the build log is located at '/var/tmp/=
portage/dev-util/trinity-9/temp/build.log.gz'.
 * The ebuild environment file is located at '/var/tmp/portage/dev-util=
/trinity-9/temp/environment'.
 * Working directory: '/var/tmp/portage/dev-util/trinity-9/work/trinity=
-9'
 * S: '/var/tmp/portage/dev-util/trinity-9/work/trinity-9'
 *
 * The following package has failed to build, install, or execute posti=
nst:
 *
 *  (dev-util/trinity-9:0/0::local, ebuild scheduled for merge), Log fi=
le:
 *   '/var/log/portage/dev-util:trinity-9:20160122-185702.log.gz'




--=20
Toralf, pgp: C4EACDDE 0076E94E
