From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: generic-sanitise.c:fill_arg:294 unreachable!
Date: Tue, 28 May 2013 17:11:45 +0200
Message-ID: <51A4C931.90908@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

run into this today while fuzzying a stable Gentoo Linux image (chroote=
d) and kernel 3.10-rc3:


[29118] [36] statfs64(pathname=3D"/mnt/hostfs/v1/v2/f19735", sz=3D0x3fb=
a7c8f) =3D -1 (Invalid argument)
generic-sanitise.c:fill_arg:294 unreachable!
[watchdog] pid 29096 hasn't made progress in 30 seconds! (last:13697536=
04 now:1369753634 diff:30). Stuck in syscall 279:mq_timedsend. Sending =
SIGKILL.
[28242] Random reseed: 504311294


and later :


[29123] [128] setdomainname(name=3D0, len=3D0) =3D -1 (Operation not pe=
rmitted)
[29123] [129] pread64(fd=3D12, buf=3D0x895a000[page_rand], count=3D4096=
, pos=3D16) =3D -1 (Is a directory)
generic-sanitise.c:fill_arg:294 unreachable!
[watchdog] pid 29118 hasn't made progress in 30 seconds! (last:13697536=
33 now:1369753663 diff:30). Stuck in syscall 279:mq_timedsend. Sending =
SIGKILL.
[28242] Random reseed: 1774374230
[29133] [0] setresuid(ruid=3D0x8fffffff, euid=3D0x45009081, suid=3D0x67=
a8cbc6) =3D -1 (Operation not permitted)



[29133] [31] acct(name=3D0) =3D -1 (Operation not permitted)
[29133] [32] pipe2(fildes=3D4, flags=3D0x4000) =3D -1 (Bad address)
generic-sanitise.c:fill_arg:294 unreachable!
[watchdog] pid 29121 hasn't made progress in 30 seconds! (last:13697536=
35 now:1369753665 diff:30). Stuck in syscall 279:mq_timedsend. Sending =
SIGKILL.
[28242] Random reseed: 641723094
[29143] [0] unlinkat(dfd=3D12, pathname=3D"/mnt/hostfs/v1/v2/f19735", f=
lag=3D0x74fe39d0) =3D -1 (Invalid argument)


expected or rather a ToDo ?

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
