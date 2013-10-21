From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: is -1 really too "large" ?
Date: Mon, 21 Oct 2013 20:40:20 +0200
Message-ID: <52657514.3020707@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

got today :

 run trinity at Mon Oct 21 20:38:27 CEST 2013 28#-1 M=3D/mnt/nfsv4

rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000004924000000c=
b': Device or resource busy
rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000003fdd000000a=
9': Device or resource busy
rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs00000000000034230000007=
a': Device or resource busy
rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000002d320000006=
b': Device or resource busy
rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000001a7c0000003=
5': Device or resource busy
rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs00000000000017600000002=
a': Device or resource busy
Trinity v1.3pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
[init] Using pid_max =3D 32768
[init] Started watchdog process, PID is 15311
[main] Main thread is alive.
[main] Generating file descriptors
[main] Something went wrong during nftw(/mnt/nfsv4/victims/v1/v2). (-1:=
Value too large for defined data type)
[child2:15315] iopl (110) returned ENOSYS, marking as inactive.
[child2:15315] acct (51) returned ENOSYS, marking as inactive.
[child2:15315] perf_event_open (336) returned ENOSYS, marking as inacti=
ve.
=2E..

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
