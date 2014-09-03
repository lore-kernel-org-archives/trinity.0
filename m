From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: hang in creating the trinity-testfileX
Date: Wed, 03 Sep 2014 19:44:43 +0200
Message-ID: <5407538B.7030900@gmx.de>
References: <5404B2AB.8080500@gmx.de> <20140902173732.GA19354@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140902173732.GA19354@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 09/02/2014 07:37 PM, Dave Jones wrote:
> On Mon, Sep 01, 2014 at 07:53:47PM +0200, Toralf F=C3=B6rster wrote:
>  > Trinity sometimes hangs infinitely in a KVM while trying to create=
 the testfiles, eg .:
>  >=20
>  > ...
>  > [main] fd[668] =3D timerfd
>  > [main] fd[669] =3D fopen("trinity-testfile1", O_RDWR)
>  > [main] fd[670] =3D fopen("trinity-testfile2", O_RDWR)
>=20
> so creating the 3rd file is where it hangs ? weird.
> =20
>  > Ctrl-C works fortunately
>=20
> Can you gdb it and find out where it's looping ?
>=20
> 	Dave
>=20
>=20

this is from one ssh terminal of the KVM :

=2E..
[main] fd[654] =3D fopen /proc/376/task/376/net/snmp6 (read-only) flags=
:0
[main] fd[655] =3D fopen /sys/devices/virtual/net/lo/statistics/collisi=
ons (read-only) flags:0
[main] fd[656] =3D open /proc/376/net/fib_triestat (read-only) flags:30=
b380
[main] fd[657] =3D open /proc/365/fdinfo/1 (read-only) flags:281800
[main] fd[658] =3D fopen /proc/21162/task/21162/wchan (read-only) flags=
:0
[main] fd[659] =3D fopen /proc/1971/attr/keycreate (read-write) flags:2
[main] fd[660] =3D fopen /proc/786/net/snmp (read-only) flags:0
[main] fd[661] =3D timerfd
[main] fd[662] =3D timerfd
[main] fd[663] =3D timerfd
[main] fd[664] =3D timerfd
[main] fd[665] =3D timerfd
[main] fd[666] =3D timerfd
[main] fd[667] =3D timerfd
[main] fd[668] =3D timerfd
[main] fd[669] =3D open("trinity-testfile1", flags:1000)          <----=
---------- here it hangs



and this info I derived within another ssh session to the KVM :

tfoerste@n22kvm ~ $ ps fx -eo pid,start_time,command | grep -e trinity =
-e sleep | grep -v grep
  375 19:40  |           \_ trinity -C 3 -q
  376 19:40  |               \_ trinity -C 3 -q
tfoerste@n22kvm ~ $ gdb trinity 375 -n -batch -ex 'thread apply all bt'

warning: Could not load shared library symbols for linux-gate.so.1.
Do you need "set solib-search-path" or "set sysroot"?

warning: no loadable sections found in added symbol-file system-supplie=
d DSO at 0xb772a000
0xb772acec in ?? ()

Thread 1 (process 375):
#0  0xb772acec in ?? ()
#1  0xb7591ee5 in __libc_start_main (main=3D0x8053930 <main>, argc=3D4,=
 argv=3D0xbff5b8d4, init=3D0x80672c0 <__libc_csu_init>, fini=3D0x806733=
0 <__libc_csu_fini>, rtld_fini=3D0xb773b4e0 <_dl_fini>, stack_end=3D0xb=
ff5b8cc) at libc-start.c:285
#2  0x08054125 in _start ()
tfoerste@n22kvm ~ $ gdb trinity 376 -n -batch -ex 'thread apply all bt'

warning: Could not load shared library symbols for linux-gate.so.1.
Do you need "set solib-search-path" or "set sysroot"?

warning: no loadable sections found in added symbol-file system-supplie=
d DSO at 0xb772a000
0xb772acec in ?? ()

Thread 1 (process 376):
#0  0xb772acec in ?? ()
#1  0xb7591ee5 in __libc_start_main (main=3D0x8053930 <main>, argc=3D4,=
 argv=3D0xbff5b8d4, init=3D0x80672c0 <__libc_csu_init>, fini=3D0x806733=
0 <__libc_csu_fini>, rtld_fini=3D0xb773b4e0 <_dl_fini>, stack_end=3D0xb=
ff5b8cc) at libc-start.c:285
#2  0x08054125 in _start ()
tfoerste@n22kvm ~ $ sudo cat /proc/375/stack
[<c5a4a574>] do_wait+0x1b4/0x200
[<c5a4b3a2>] SyS_waitpid+0x72/0xe0
[<c60cc761>] syscall_after_call+0x0/0x4
[<ffffffff>] 0xffffffff
tfoerste@n22kvm ~ $ sudo cat /proc/376/stack
[<c5a97ac8>] hrtimer_nanosleep+0xa8/0x1b0
[<c5a97c26>] SyS_nanosleep+0x56/0x70
[<c60cc66b>] sysenter_after_call+0x0/0x21
[<ffffffff>] 0xffffffff


--=20
Toralf
pgp key: 0076 E94E
