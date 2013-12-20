From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: current trinity gives glibc errors
Date: Fri, 20 Dec 2013 21:32:31 +0100
Message-ID: <52B4A95F.9040407@gmx.de>
References: <52B45985.6060806@gmx.de> <20131220192739.GA13124@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131220192739.GA13124@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/20/2013 08:27 PM, Dave Jones wrote:
> On Fri, Dec 20, 2013 at 03:51:49PM +0100, Toralf F=C3=B6rster wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
>>=20
>> When I run latest trinity at a stable 32 Bit Gentoo Linux user
>> mode linux image I do now get :
>>=20
>> trinity -q -N 10000 -C 2 -x mremap
>>=20
>> ...
>>=20
>> [child0:1763] init_module (128) returned ENOSYS, marking as
>> inactive. [child0:1763] ipc (117) returned ENOSYS, marking as
>> inactive. [main] Random reseed: 3211420801 [child0:1765] ioperm
>> (101) returned ENOSYS, marking as inactive. [child0:1765]
>> set_robust_list (311) returned ENOSYS, marking as inactive.=20
>> [child0:1765] move_pages (317) returned ENOSYS, marking as
>> inactive. *** glibc detected *** trinity: double free or
>> corruption (out): 0x085bc000 *** =3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=20
>> /lib/libc.so.6(+0x76552)[0x400a0552] trinity[0x805930e]=20
>> trinity[0x8052085] trinity[0x805508c] trinity[0x804af91]=20
>> trinity[0x804ead5] trinity[0x804a605]=20
>> /lib/libc.so.6(__libc_start_main+0xf5)[0x40046ad5]=20
>> trinity[0x804ab15]
>=20
> If you could narrow down which syscalls are causing this it would
> help a lot. scripts/find.sh might give you some ideas.
>=20
> Dave
>=20
>=20
It is this :

trinity -q -l off -N 1 -c move_pages


- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlK0qV8ACgkQxOrN3gB26U6gUwD/WSN2Cvc/pKt1JmDDv4nPreCs
5saJoP1QSw77PWP5xogBAImklXwHsLqlTA/ASJDQ250kzuwXAC5NzDMl0D5tOfeq
=3DssCC
-----END PGP SIGNATURE-----
