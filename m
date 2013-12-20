From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: current trinity gives glibc errors
Date: Fri, 20 Dec 2013 15:51:49 +0100
Message-ID: <52B45985.6060806@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

When I run latest trinity at a stable 32 Bit Gentoo Linux user mode lin=
ux image I do now get :

trinity -q -N 10000 -C 2 -x mremap

=2E..

[child0:1763] init_module (128) returned ENOSYS, marking as inactive.
[child0:1763] ipc (117) returned ENOSYS, marking as inactive.
[main] Random reseed: 3211420801
[child0:1765] ioperm (101) returned ENOSYS, marking as inactive.
[child0:1765] set_robust_list (311) returned ENOSYS, marking as inactiv=
e.
[child0:1765] move_pages (317) returned ENOSYS, marking as inactive.
*** glibc detected *** trinity: double free or corruption (out): 0x085b=
c000 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/libc.so.6(+0x76552)[0x400a0552]
trinity[0x805930e]
trinity[0x8052085]
trinity[0x805508c]
trinity[0x804af91]
trinity[0x804ead5]
trinity[0x804a605]
/lib/libc.so.6(__libc_start_main+0xf5)[0x40046ad5]
trinity[0x804ab15]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00100000-00102000 r-xp 00000000 00:00 0=20
08048000-0806d000 r-xp 00000000 62:00 88380      /usr/bin/trinity
0806d000-0806e000 r--p 00024000 62:00 88380      /usr/bin/trinity
0806e000-080cb000 rw-p 00025000 62:00 88380      /usr/bin/trinity
080cb000-084eb000 rw-p 00000000 00:00 0          [heap]
084eb000-085b5000 rw-p 00000000 00:00 0          [heap]
085b5000-08783000 rw-p 00000000 00:00 0          [heap]
40000000-40020000 r-xp 00000000 62:00 88339      /lib/ld-2.16.so
40020000-40021000 r--p 0001f000 62:00 88339      /lib/ld-2.16.so
40021000-40022000 rw-p 00020000 62:00 88339      /lib/ld-2.16.so
40022000-40026000 rw-p 00000000 00:00 0=20
40026000-40028000 rw-s 00000000 00:04 83577      /dev/zero (deleted)
40028000-40029000 rw-p 00000000 00:00 0=20
40029000-4002a000 rw-p 00000000 00:00 0=20
4002a000-401cb000 r-xp 00000000 62:00 88343      /lib/libc-2.16.so
401cb000-401cc000 ---p 001a1000 62:00 88343      /lib/libc-2.16.so
401cc000-401ce000 r--p 001a1000 62:00 88343      /lib/libc-2.16.so
401ce000-401cf000 rw-p 001a3000 62:00 88343      /lib/libc-2.16.so
401cf000-401d3000 rw-p 00000000 00:00 0=20
401d3000-4022a000 rw-s 00000000 00:04 83575      /dev/zero (deleted)
4022a000-40248000 ---s 00000000 00:04 83576      /dev/zero (deleted)
40248000-40254000 rw-s 0001e000 00:04 83576      /dev/zero (deleted)
40254000-40272000 ---s 0002a000 00:04 83576      /dev/zero (deleted)
40272000-40274000 r--s 00000000 00:04 83578      /dev/zero (deleted)
40274000-40276000 -w-s 00000000 00:04 83579      /dev/zero (deleted)
40276000-40376000 rw-s 00000000 00:04 83580      /dev/zero (deleted)
40376000-40476000 r--s 00000000 00:04 83581      /dev/zero (deleted)
40476000-40576000 -w-s 00000000 00:04 83582      /dev/zero (deleted)
40576000-40776000 rw-s 00000000 00:04 83583      /dev/zero (deleted)
40776000-40976000 r--s 00000000 00:04 83584      /dev/zero (deleted)
40976000-40b76000 -w-s 00000000 00:04 83585      /dev/zero (deleted)
40b76000-40f76000 rw-s 00000000 00:04 83586      /dev/zero (deleted)
40f76000-41376000 r--s 00000000 00:04 83587      /dev/zero (deleted)
41376000-41776000 -w-s 00000000 00:04 83588      /dev/zero (deleted)
41776000-42176000 rw-s 00000000 00:04 83589      /dev/zero (deleted)
42176000-42b76000 r--s 00000000 00:04 83590      /dev/zero (deleted)
42b76000-43576000 -w-s 00000000 00:04 83591      /dev/zero (deleted)
4357d000-43597000 r-xp 00000000 62:00 85032      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
43597000-43598000 r--p 00019000 62:00 85032      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
43598000-43599000 rw-p 0001a000 62:00 85032      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
bf7e3000-bf804000 rw-p 00000000 00:00 0
[main] Random reseed: 3271769164

- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlK0WYUACgkQxOrN3gB26U4+IwD+IqBcRpU9nQud5F1omd0EPWki
Hqvx4eBlZcKgJg19zwQA/1ypItkbJ/qTw6aQtrb/6U832kd7BF4mUfBiWwELD0O2
=3D0UZq
-----END PGP SIGNATURE-----
