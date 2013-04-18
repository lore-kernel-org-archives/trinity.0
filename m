From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: syscall vmsplice gives a lot of : *** glibc detected *** trinity:
 malloc(): smallbin double linked list corrupted:
Date: Thu, 18 Apr 2013 18:43:48 +0200
Message-ID: <517022C4.90400@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

When I tried the syscall vmsplice under a 32 bit (Gentoo Linux) user mo=
de linux I get tons of :


tfoerste@n22 ~ $ trinity.sh -c vmsplice
starting trinity at Thu Apr 18 18:08:06 CEST 2013 using /mnt/n22 ...
Trinity v1.2pre  Dave Jones <davej@redhat.com>
[2036] Marking syscall vmsplice (316) as to be enabled.
Done parsing arguments.
[2036] Enabled 1 syscalls. Disabled 350 syscalls.
[2036] Started watchdog process, PID is 2037
[2038] Main thread is alive.
Generating file descriptors
Added 201 filenames from /mnt/n22/w/victims
*** glibc detected *** trinity: malloc(): smallbin double linked list c=
orrupted: 0x080ca370 ***
trinity: malloc.c:3790: _int_malloc: Assertion `(unsigned long)(size) >=
=3D (unsigned long)(nb)' failed.
trinity: malloc.c:3790: _int_malloc: Assertion `(unsigned long)(size) >=
=3D (unsigned long)(nb)' failed.
*** glibc detected *** trinity: corrupted double-linked list: 0x080cd13=
0 ***
trinity: malloc.c:3790: _int_malloc: Assertion `(unsigned long)(size) >=
=3D (unsigned long)(nb)' failed.
*** glibc detected *** trinity: malloc(): smallbin double linked list c=
orrupted: 0x080c4930 ***
trinity: malloc.c:3790: _int_malloc: Assertion `(unsigned long)(size) >=
=3D (unsigned long)(nb)' failed.
[2037] Watchdog is alive


So I just gave valgrind a try :



$ valgrind --leak-check=3Dyes trinity --children 4 --victims /mnt/n22/w=
/victims -N 50000 --quiet -c vmsplice
=3D=3D1065=3D=3D Memcheck, a memory error detector
=3D=3D1065=3D=3D Copyright (C) 2002-2011, and GNU GPL'd, by Julian Sewa=
rd et al.
=3D=3D1065=3D=3D Using Valgrind-3.7.0 and LibVEX; rerun with -h for cop=
yright info
=3D=3D1065=3D=3D Command: trinity --children 4 --victims /mnt/n22/w/vic=
tims -N 50000 --quiet -c vmsplice
=3D=3D1065=3D=3D
vex x86->IR: unhandled instruction bytes: 0xC5 0xF9 0x6E 0x40
=3D=3D1065=3D=3D valgrind: Unrecognised instruction at address 0x40149a=
0.
=3D=3D1065=3D=3D    at 0x40149A0: _dl_sysdep_start (in /lib/ld-2.15.so)
=3D=3D1065=3D=3D    by 0xFFF: ???
=3D=3D1065=3D=3D Your program just tried to execute an instruction that=
 Valgrind
=3D=3D1065=3D=3D did not recognise.  There are two possible reasons for=
 this.
=3D=3D1065=3D=3D 1. Your program has a bug and erroneously jumped to a =
non-code
=3D=3D1065=3D=3D    location.  If you are running Memcheck and you just=
 saw a
=3D=3D1065=3D=3D    warning about a bad jump, it's probably your progra=
m's fault.
=3D=3D1065=3D=3D 2. The instruction is legitimate but Valgrind doesn't =
handle it,
=3D=3D1065=3D=3D    i.e. it's Valgrind's fault.  If you think this is t=
he case or
=3D=3D1065=3D=3D    you are not sure, please let us know and we'll try =
to fix it.
=3D=3D1065=3D=3D Either way, Valgrind will now raise a SIGILL signal wh=
ich will
=3D=3D1065=3D=3D probably kill your program.
=3D=3D1065=3D=3D
=3D=3D1065=3D=3D Process terminating with default action of signal 4 (S=
IGILL): dumping core
=3D=3D1065=3D=3D  Illegal opcode at address 0x40149A0
=3D=3D1065=3D=3D    at 0x40149A0: _dl_sysdep_start (in /lib/ld-2.15.so)
=3D=3D1065=3D=3D    by 0xFFF: ???
=3D=3D1065=3D=3D
=3D=3D1065=3D=3D HEAP SUMMARY:
=3D=3D1065=3D=3D     in use at exit: 0 bytes in 0 blocks
=3D=3D1065=3D=3D   total heap usage: 0 allocs, 0 frees, 0 bytes allocat=
ed
=3D=3D1065=3D=3D
=3D=3D1065=3D=3D All heap blocks were freed -- no leaks are possible
=3D=3D1065=3D=3D
=3D=3D1065=3D=3D For counts of detected and suppressed errors, rerun wi=
th: -v
=3D=3D1065=3D=3D ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0=
 from 0)
Illegal instruction


which immediately exits complaining about that illegal instructions.


Is this just related to valgrind or is this a trinity thing ?


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
