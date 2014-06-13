From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: *** Error in `trinity': double free or corruption (!prev): 0x08208e78
 ***
Date: Fri, 13 Jun 2014 19:14:16 +0200
Message-ID: <539B3168.6050300@gmx.de>
References: <539A15DE.7020101@gmx.de> <20140612220605.GA5771@redhat.com> <539B24FA.8070800@gmx.de> <20140613163812.GA17879@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140613163812.GA17879@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 06/13/2014 06:38 PM, Dave Jones wrote:
> On Fri, Jun 13, 2014 at 06:21:14PM +0200, Toralf F=C3=B6rster wrote:
>=20
>  > > caveat: it needs you to rerun configure.sh each time you pull, w=
hich
>  > > kinda sucks.  I suppose it'd be better if it somehow did all thi=
s stuff
>  > > from the Makefile.  I'll look into fixing it sometime unless som=
eone else beats
>  > > me to it, but it's not on my urgent list.
>  > >=20
>  > ok (althought now the version string is completely empty if git is=
 not installed, eg. on virtual test machines)
>=20
> Ok, Just pushed something out so it falls back to grepping the Makefi=
le
> if git isn't installed. Guess that case is useful if someone was
> building from one of the snapshot tarballs.
>=20
>  > >  > Done parsing arguments.     =20
>  > >  > Marking all syscalls as enabled.
>  > >  > *** Error in `trinity': double free or corruption (!prev): 0x=
08208e78 ***
>  > >=20
>  > > I've been chasing a bunch of corruption bugs this last week or s=
o, and
>  > > I think I've killed the worst of the bunch.
>  > >=20
>  > > Does -x mremap make this stop happening for you ?
>  > neither "-x mremap" nor "-x madvise" helped hhm
>  >=20
>  > If it would help a lot I could try to bisect trinity to that.
>=20
> I have a feeling it'll land on one of the bigger changesets, but it
> might be useful to narrow down.
>=20
> 	Dave
>=20
>=20
I just run this one-liner

$ trinity --list | grep Enabled$ | grep -v AVOID | cut -f3 -d' ' | whil=
e read s; do echo; echo $s; trinity -q -q -q -c $s -N 20 -C 1; done   =20

with latest trinity git tee and latest kernel tree which exposed the sy=
scall "modify_ldt":


modify_ldt
Trinity 1.5pre  Dave Jones <davej@redhat.com>
[init] Marking syscall modify_ldt (123) as to be enabled.
Done parsing arguments.
*** Error in `trinity': double free or corruption (top): 0x0815d870 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/libc.so.6(+0x7a202)[0x400a3202]
/lib/libc.so.6(+0x7af80)[0x400a3f80]
trinity(mkcall+0x17a)[0x805b0ca]
trinity(child_process+0x95)[0x8054965]
trinity(main_loop+0x1e3)[0x80583f3]
trinity(main+0x252)[0x8053752]
/lib/libc.so.6(__libc_start_main+0xf5)[0x40045cc5]
trinity[0x8053cd5]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00100000-00102000 r-xp 00000000 00:00 0=20
08048000-08079000 r-xp 00000000 62:00 12788      /usr/bin/trinity
08079000-0807a000 r--p 00030000 62:00 12788      /usr/bin/trinity
0807a000-080d7000 rw-p 00031000 62:00 12788      /usr/bin/trinity
080d7000-080f8000 rw-p 00000000 00:00 0          [heap]
080f8000-0817e000 rw-p 00000000 00:00 0          [heap]
40000000-40020000 r-xp 00000000 62:00 31279      /lib/ld-2.17.so
40020000-40021000 r--p 0001f000 62:00 31279      /lib/ld-2.17.so
40021000-40022000 rw-p 00020000 62:00 31279      /lib/ld-2.17.so
40022000-40023000 rw-p 00000000 00:00 0=20
40023000-40024000 rw-s 00000000 00:04 292788     /dev/zero (deleted)
40024000-40026000 rw-p 00000000 00:00 0=20
40026000-40028000 rw-s 00000000 00:04 292790     /dev/zero (deleted)
40028000-40029000 rw-p 00000000 00:00 0=20
40029000-401d1000 r-xp 00000000 62:00 31281      /lib/libc-2.17.so
401d1000-401d3000 r--p 001a8000 62:00 31281      /lib/libc-2.17.so
401d3000-401d4000 rw-p 001aa000 62:00 31281      /lib/libc-2.17.so
401d4000-401d8000 rw-p 00000000 00:00 0=20
401d8000-40230000 rw-s 00000000 00:04 292786     /dev/zero (deleted)
40230000-4024e000 ---s 00000000 00:04 292787     /dev/zero (deleted)
4024e000-40253000 rw-s 0001e000 00:04 292787     /dev/zero (deleted)
40253000-40271000 ---s 00023000 00:04 292787     /dev/zero (deleted)
40271000-4027e000 rw-s 00000000 00:04 292789     /dev/zero (deleted)
4027e000-40280000 r--s 00000000 00:04 292791     /dev/zero (deleted)
40280000-40282000 -w-s 00000000 00:04 292792     /dev/zero (deleted)
40282000-40382000 rw-s 00000000 00:04 292793     /dev/zero (deleted)
40382000-40482000 r--s 00000000 00:04 292794     /dev/zero (deleted)
40482000-40582000 -w-s 00000000 00:04 292795     /dev/zero (deleted)
40582000-40782000 rw-s 00000000 00:04 292796     /dev/zero (deleted)
40782000-40982000 r--s 00000000 00:04 292797     /dev/zero (deleted)
40982000-40b82000 -w-s 00000000 00:04 292798     /dev/zero (deleted)
40b82000-40f82000 rw-s 00000000 00:04 292799     /dev/zero (deleted)
40f82000-41382000 r--s 00000000 00:04 292800     /dev/zero (deleted)
41382000-41782000 -w-s 00000000 00:04 292801     /dev/zero (deleted)
41782000-42182000 rw-s 00000000 00:04 292802     /dev/zero (deleted)
42182000-42b82000 r--s 00000000 00:04 292803     /dev/zero (deleted)
42b82000-43582000 -w-s 00000000 00:04 292804     /dev/zero (deleted)
43582000-43583000 rw-p 00000000 00:00 0=20
43589000-435a3000 r-xp 00000000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a3000-435a4000 r--p 00019000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a4000-435a5000 rw-p 0001a000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
bfce1000-bfd02000 rw-p 00000000 00:00 0=20
*** Error in `trinity': double free or corruption (top): 0x0815d870 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/libc.so.6(+0x7a202)[0x400a3202]
/lib/libc.so.6(+0x7af80)[0x400a3f80]
trinity(mkcall+0x17a)[0x805b0ca]
trinity(child_process+0x95)[0x8054965]
trinity(main_loop+0x1e3)[0x80583f3]
trinity(main+0x252)[0x8053752]
/lib/libc.so.6(__libc_start_main+0xf5)[0x40045cc5]
trinity[0x8053cd5]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00100000-00102000 r-xp 00000000 00:00 0=20
08048000-08079000 r-xp 00000000 62:00 12788      /usr/bin/trinity
08079000-0807a000 r--p 00030000 62:00 12788      /usr/bin/trinity
0807a000-080d7000 rw-p 00031000 62:00 12788      /usr/bin/trinity
080d7000-080f8000 rw-p 00000000 00:00 0          [heap]
080f8000-0817e000 rw-p 00000000 00:00 0          [heap]
40000000-40020000 r-xp 00000000 62:00 31279      /lib/ld-2.17.so
40020000-40021000 r--p 0001f000 62:00 31279      /lib/ld-2.17.so
40021000-40022000 rw-p 00020000 62:00 31279      /lib/ld-2.17.so
40022000-40023000 rw-p 00000000 00:00 0=20
40023000-40024000 rw-s 00000000 00:04 292788     /dev/zero (deleted)
40024000-40026000 rw-p 00000000 00:00 0=20
40026000-40028000 rw-s 00000000 00:04 292790     /dev/zero (deleted)
40028000-40029000 rw-p 00000000 00:00 0=20
40029000-401d1000 r-xp 00000000 62:00 31281      /lib/libc-2.17.so
401d1000-401d3000 r--p 001a8000 62:00 31281      /lib/libc-2.17.so
401d3000-401d4000 rw-p 001aa000 62:00 31281      /lib/libc-2.17.so
401d4000-401d8000 rw-p 00000000 00:00 0=20
401d8000-40230000 rw-s 00000000 00:04 292786     /dev/zero (deleted)
40230000-4024e000 ---s 00000000 00:04 292787     /dev/zero (deleted)
4024e000-40253000 rw-s 0001e000 00:04 292787     /dev/zero (deleted)
40253000-40271000 ---s 00023000 00:04 292787     /dev/zero (deleted)
40271000-4027e000 rw-s 00000000 00:04 292789     /dev/zero (deleted)
4027e000-40280000 r--s 00000000 00:04 292791     /dev/zero (deleted)
40280000-40282000 -w-s 00000000 00:04 292792     /dev/zero (deleted)
40282000-40382000 rw-s 00000000 00:04 292793     /dev/zero (deleted)
40382000-40482000 r--s 00000000 00:04 292794     /dev/zero (deleted)
40482000-40582000 -w-s 00000000 00:04 292795     /dev/zero (deleted)
40582000-40782000 rw-s 00000000 00:04 292796     /dev/zero (deleted)
40782000-40982000 r--s 00000000 00:04 292797     /dev/zero (deleted)
40982000-40b82000 -w-s 00000000 00:04 292798     /dev/zero (deleted)
40b82000-40f82000 rw-s 00000000 00:04 292799     /dev/zero (deleted)
40f82000-41382000 r--s 00000000 00:04 292800     /dev/zero (deleted)
41382000-41782000 -w-s 00000000 00:04 292801     /dev/zero (deleted)
41782000-42182000 rw-s 00000000 00:04 292802     /dev/zero (deleted)
42182000-42b82000 r--s 00000000 00:04 292803     /dev/zero (deleted)
42b82000-43582000 -w-s 00000000 00:04 292804     /dev/zero (deleted)
43582000-43583000 rw-p 00000000 00:00 0=20
43589000-435a3000 r-xp 00000000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a3000-435a4000 r--p 00019000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a4000-435a5000 rw-p 0001a000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
bfce1000-bfd02000 rw-p 00000000 00:00 0=20
*** Error in `trinity': double free or corruption (top): 0x0815d870 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/libc.so.6(+0x7a202)[0x400a3202]
/lib/libc.so.6(+0x7af80)[0x400a3f80]
trinity(mkcall+0x17a)[0x805b0ca]
trinity(child_process+0x95)[0x8054965]
trinity(main_loop+0x1e3)[0x80583f3]
trinity(main+0x252)[0x8053752]
/lib/libc.so.6(__libc_start_main+0xf5)[0x40045cc5]
trinity[0x8053cd5]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00100000-00102000 r-xp 00000000 00:00 0=20
08048000-08079000 r-xp 00000000 62:00 12788      /usr/bin/trinity
08079000-0807a000 r--p 00030000 62:00 12788      /usr/bin/trinity
0807a000-080d7000 rw-p 00031000 62:00 12788      /usr/bin/trinity
080d7000-080f8000 rw-p 00000000 00:00 0          [heap]
080f8000-0817e000 rw-p 00000000 00:00 0          [heap]
40000000-40020000 r-xp 00000000 62:00 31279      /lib/ld-2.17.so
40020000-40021000 r--p 0001f000 62:00 31279      /lib/ld-2.17.so
40021000-40022000 rw-p 00020000 62:00 31279      /lib/ld-2.17.so
40022000-40023000 rw-p 00000000 00:00 0=20
40023000-40024000 rw-s 00000000 00:04 292788     /dev/zero (deleted)
40024000-40026000 rw-p 00000000 00:00 0=20
40026000-40028000 rw-s 00000000 00:04 292790     /dev/zero (deleted)
40028000-40029000 rw-p 00000000 00:00 0=20
40029000-401d1000 r-xp 00000000 62:00 31281      /lib/libc-2.17.so
401d1000-401d3000 r--p 001a8000 62:00 31281      /lib/libc-2.17.so
401d3000-401d4000 rw-p 001aa000 62:00 31281      /lib/libc-2.17.so
401d4000-401d8000 rw-p 00000000 00:00 0=20
401d8000-40230000 rw-s 00000000 00:04 292786     /dev/zero (deleted)
40230000-4024e000 ---s 00000000 00:04 292787     /dev/zero (deleted)
4024e000-40253000 rw-s 0001e000 00:04 292787     /dev/zero (deleted)
40253000-40271000 ---s 00023000 00:04 292787     /dev/zero (deleted)
40271000-4027e000 rw-s 00000000 00:04 292789     /dev/zero (deleted)
4027e000-40280000 r--s 00000000 00:04 292791     /dev/zero (deleted)
40280000-40282000 -w-s 00000000 00:04 292792     /dev/zero (deleted)
40282000-40382000 rw-s 00000000 00:04 292793     /dev/zero (deleted)
40382000-40482000 r--s 00000000 00:04 292794     /dev/zero (deleted)
40482000-40582000 -w-s 00000000 00:04 292795     /dev/zero (deleted)
40582000-40782000 rw-s 00000000 00:04 292796     /dev/zero (deleted)
40782000-40982000 r--s 00000000 00:04 292797     /dev/zero (deleted)
40982000-40b82000 -w-s 00000000 00:04 292798     /dev/zero (deleted)
40b82000-40f82000 rw-s 00000000 00:04 292799     /dev/zero (deleted)
40f82000-41382000 r--s 00000000 00:04 292800     /dev/zero (deleted)
41382000-41782000 -w-s 00000000 00:04 292801     /dev/zero (deleted)
41782000-42182000 rw-s 00000000 00:04 292802     /dev/zero (deleted)
42182000-42b82000 r--s 00000000 00:04 292803     /dev/zero (deleted)
42b82000-43582000 -w-s 00000000 00:04 292804     /dev/zero (deleted)
43582000-43583000 rw-p 00000000 00:00 0=20
43589000-435a3000 r-xp 00000000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a3000-435a4000 r--p 00019000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a4000-435a5000 rw-p 0001a000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
bfce1000-bfd02000 rw-p 00000000 00:00 0=20
*** Error in `trinity': double free or corruption (top): 0x0815d870 ***
=3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
/lib/libc.so.6(+0x7a202)[0x400a3202]
/lib/libc.so.6(+0x7af80)[0x400a3f80]
trinity(mkcall+0x17a)[0x805b0ca]
trinity(child_process+0x95)[0x8054965]
trinity(main_loop+0x1e3)[0x80583f3]
trinity(main+0x252)[0x8053752]
/lib/libc.so.6(__libc_start_main+0xf5)[0x40045cc5]
trinity[0x8053cd5]
=3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
00100000-00102000 r-xp 00000000 00:00 0=20
08048000-08079000 r-xp 00000000 62:00 12788      /usr/bin/trinity
08079000-0807a000 r--p 00030000 62:00 12788      /usr/bin/trinity
0807a000-080d7000 rw-p 00031000 62:00 12788      /usr/bin/trinity
080d7000-080f8000 rw-p 00000000 00:00 0          [heap]
080f8000-0817e000 rw-p 00000000 00:00 0          [heap]
40000000-40020000 r-xp 00000000 62:00 31279      /lib/ld-2.17.so
40020000-40021000 r--p 0001f000 62:00 31279      /lib/ld-2.17.so
40021000-40022000 rw-p 00020000 62:00 31279      /lib/ld-2.17.so
40022000-40023000 rw-p 00000000 00:00 0=20
40023000-40024000 rw-s 00000000 00:04 292788     /dev/zero (deleted)
40024000-40026000 rw-p 00000000 00:00 0=20
40026000-40028000 rw-s 00000000 00:04 292790     /dev/zero (deleted)
40028000-40029000 rw-p 00000000 00:00 0=20
40029000-401d1000 r-xp 00000000 62:00 31281      /lib/libc-2.17.so
401d1000-401d3000 r--p 001a8000 62:00 31281      /lib/libc-2.17.so
401d3000-401d4000 rw-p 001aa000 62:00 31281      /lib/libc-2.17.so
401d4000-401d8000 rw-p 00000000 00:00 0=20
401d8000-40230000 rw-s 00000000 00:04 292786     /dev/zero (deleted)
40230000-4024e000 ---s 00000000 00:04 292787     /dev/zero (deleted)
4024e000-40253000 rw-s 0001e000 00:04 292787     /dev/zero (deleted)
40253000-40271000 ---s 00023000 00:04 292787     /dev/zero (deleted)
40271000-4027e000 rw-s 00000000 00:04 292789     /dev/zero (deleted)
4027e000-40280000 r--s 00000000 00:04 292791     /dev/zero (deleted)
40280000-40282000 -w-s 00000000 00:04 292792     /dev/zero (deleted)
40282000-40382000 rw-s 00000000 00:04 292793     /dev/zero (deleted)
40382000-40482000 r--s 00000000 00:04 292794     /dev/zero (deleted)
40482000-40582000 -w-s 00000000 00:04 292795     /dev/zero (deleted)
40582000-40782000 rw-s 00000000 00:04 292796     /dev/zero (deleted)
40782000-40982000 r--s 00000000 00:04 292797     /dev/zero (deleted)
40982000-40b82000 -w-s 00000000 00:04 292798     /dev/zero (deleted)
40b82000-40f82000 rw-s 00000000 00:04 292799     /dev/zero (deleted)
40f82000-41382000 r--s 00000000 00:04 292800     /dev/zero (deleted)
41382000-41782000 -w-s 00000000 00:04 292801     /dev/zero (deleted)
41782000-42182000 rw-s 00000000 00:04 292802     /dev/zero (deleted)
42182000-42b82000 r--s 00000000 00:04 292803     /dev/zero (deleted)
42b82000-43582000 -w-s 00000000 00:04 292804     /dev/zero (deleted)
43582000-43583000 rw-p 00000000 00:00 0=20
43589000-435a3000 r-xp 00000000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a3000-435a4000 r--p 00019000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
435a4000-435a5000 rw-p 0001a000 62:00 28288      /usr/lib/gcc/i686-pc-l=
inux-gnu/4.7.3/libgcc_s.so.1
bfce1000-bfd02000 rw-p 00000000 00:00 0=20



--=20
Toralf
