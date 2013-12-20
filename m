From: Dave Jones <davej@redhat.com>
Subject: Re: current trinity gives glibc errors
Date: Fri, 20 Dec 2013 14:27:39 -0500
Message-ID: <20131220192739.GA13124@redhat.com>
References: <52B45985.6060806@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B45985.6060806@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Dec 20, 2013 at 03:51:49PM +0100, Toralf F=F6rster wrote:
 > -----BEGIN PGP SIGNED MESSAGE-----
 > Hash: SHA256
 >=20
 > When I run latest trinity at a stable 32 Bit Gentoo Linux user mode =
linux image I do now get :
 >=20
 > trinity -q -N 10000 -C 2 -x mremap
 >=20
 > ...
 >=20
 > [child0:1763] init_module (128) returned ENOSYS, marking as inactive=
=2E
 > [child0:1763] ipc (117) returned ENOSYS, marking as inactive.
 > [main] Random reseed: 3211420801
 > [child0:1765] ioperm (101) returned ENOSYS, marking as inactive.
 > [child0:1765] set_robust_list (311) returned ENOSYS, marking as inac=
tive.
 > [child0:1765] move_pages (317) returned ENOSYS, marking as inactive.
 > *** glibc detected *** trinity: double free or corruption (out): 0x0=
85bc000 ***
 > =3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
 > /lib/libc.so.6(+0x76552)[0x400a0552]
 > trinity[0x805930e]
 > trinity[0x8052085]
 > trinity[0x805508c]
 > trinity[0x804af91]
 > trinity[0x804ead5]
 > trinity[0x804a605]
 > /lib/libc.so.6(__libc_start_main+0xf5)[0x40046ad5]
 > trinity[0x804ab15]

If you could narrow down which syscalls are causing this it would help =
a lot.
scripts/find.sh might give you some ideas.

	Dave
