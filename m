From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: trinity seems not to reap all childs
Date: Sat, 09 Aug 2014 18:35:45 +0200
Message-ID: <53E64DE1.1020905@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

I do observe in the last few days that under a 32 bit Gentoo UML guest =
sometimes 1 trinity job survives although all of its parents are gone a=
lready.


The console output at th ehost system is :

[main] Bailing main loop because Completed maximum number of operations=
=2E.
[watchdog] [2604] Watchdog exiting because Completed maximum number of =
operations..
[init] Ran 100001 syscalls. Successes: 21199  Failures: 78802


A ps shows that there's still 1 job running in the guest :

$ ssh tfoerste@trinity "ps fx -eo pid,start_time,command | grep -e trin=
ity -e sleep | grep -v grep"
 2723 17:55 trinity -C 2 -N 100000 -x mremap -q -V /mnt/ramdisk/victims=
/v1/v2



Logging into the UML guest and looking at the trinity files gives :


tfoerste@trinity ~/t3 $ ls -l
total 480
-rw-r--r-- 1 tfoerste users 253943 Aug  9 18:15 trinity-child0.log
-rw-r--r-- 1 tfoerste users 206229 Aug  9 18:15 trinity-child1.log
-rw-r--r-- 1 tfoerste users  19077 Aug  9 18:15 trinity.log
-rw-r-S-wt 1 tfoerste users     11 Aug  9 18:15 trinity-testfile1
-rwSr--rwT 1 tfoerste users      0 Aug  9 17:49 trinity-testfile2
-rwx--Srwx 1 tfoerste users   1110 Aug  9 18:15 trinity-testfile3
------xrwt 1 tfoerste users  16384 Aug  9 18:15 trinity-testfile4

tfoerste@trinity ~/t3 $ tail -vf *log
=3D=3D> trinity-child0.log <=3D=3D
[child0:3003] [2727] unlinkat(dfd=3D175, pathname=3D"/mnt/ramdisk/victi=
ms/v1/v2/f92", flag=3D0x1f3ff000) =3D -1 (Invalid argument)
[child0:3003] [2728] eventfd2(count=3D19, flags=3D0x1) =3D 336
[child0:3003] [2729] getpid() =3D 3003
[child0:3003] [2730] fcntl(fd=3D175, cmd=3D0xc, arg=3D0xf6abffff) =3D -=
1 (Bad file descriptor)
[child0:3003] [2731] swapon(path=3D"/mnt/ramdisk/victims/v1/v2/d52", sw=
ap_flags=3D0x18000) =3D -1 (Operation not permitted)
[child0:3003] [2732] olduname(name=3D0xc0100220) =3D -1 (Bad address)
[child0:3003] [2733] getpriority(which=3D0x0, who=3D3012) =3D 1
[child0:3003] [2734] mlock(addr=3D0x40499000, len=3D0x100000) =3D -1 (C=
annot allocate memory)
[child0:3003] [2735] time(tloc=3D0x0) =3D 0x53e6493b
[child0:3003] [2736] epoll_pwait(epfd=3D20, events=3D0x85c0340, maxeven=
ts=3D0xffff0000, timeout=3D0xff0067aa) =3D -1 (Invalid argument)

=3D=3D> trinity-child1.log <=3D=3D
[child1:3012] [2225] flock(fd=3D18, cmd=3D0xf41fffff) =3D 0
[child1:3012] [2226] getpgid(pid=3D1) =3D 1
[child1:3012] [2227] mq_notify(mqdes=3D175, u_notification=3D0x4) =3D -=
1 (Bad address)
[child1:3012] [2228] msync(start=3D0x40299000, len=3D0x100000, flags=3D=
0x4) =3D 0
[child1:3012] [2229] mkdirat(dfd=3D175, pathname=3D"/mnt/ramdisk/victim=
s/v1/v2/f58", mode=3D0) =3D -1 (Permission denied)
[child1:3012] [2230] write(fd=3D236, buf=3D0xffffff9b, count=3D1) =3D -=
1 (Bad file descriptor)
[child1:3012] [2231] fsync(fd=3D210) =3D 0
[child1:3012] [2232] rt_sigpending(set=3D0x80e4000[page_rand], sigsetsi=
ze=3D0xff6094ab) =3D -1 (Invalid argument)
[child1:3012] [2233] tee(fdin=3D7, fdout=3D4, len=3D0x6800, flags=3D0x3=
) =3D -1 (Bad file descriptor)
[child1:3012] [2234] utimes(filename=3D"/mnt/ramdisk/victims/v1/v2/f12"=
, utimes=3D0x1) =3D -1 (Bad address)

=3D=3D> trinity.log <=3D=3D
[watchdog] 30087 iterations. [F:23623 S:6463 HI:9706]
[watchdog] 40138 iterations. [F:31443 S:8694 HI:9706]
[watchdog] 50215 iterations. [F:39370 S:10844 HI:9706]
[watchdog] 60221 iterations. [F:47228 S:12992 HI:9706]
[watchdog] 70225 iterations. [F:55100 S:15124 HI:9706]
[watchdog] 80278 iterations. [F:63007 S:17270 HI:9706]
[watchdog] 90287 iterations. [F:71013 S:19273 HI:9706]
[main] Bailing main loop because Completed maximum number of operations=
=2E.
[watchdog] [2604] Watchdog exiting because Completed maximum number of =
operations..
[init] Ran 100001 syscalls. Successes: 21199  Failures: 78802
^C

tfoerste@trinity ~/t3 $ sudo tail -vf *test*
=3D=3D> trinity-testfile1 <=3D=3D

=3D=3D> trinity-testfile2 <=3D=3D

=3D=3D> trinity-testfile3 <=3D=3D
EF =EF=BF=BD=EF=BF=BD=EF=BF=BDP~zeoP =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
2 =E2=96=922.6.56#2 Mon Aug 4 21:47:01 CEST 2014i686(none)
=3D=3D> trinity-testfile4 <=3D=3D
^C



killing the job helped fortunately:


$ ssh tfoerste@trinity kill 2723



--=20
Toralf
