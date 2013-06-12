From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: return string 1;2c1;2c1;2c1;2c1;2c1;2c1;2c1;2c1;2c
Date: Wed, 12 Jun 2013 20:14:21 +0200
Message-ID: <51B8BA7D.7010601@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

/me just wondering about the "return code" when I run trinity at a
chroot image:


$ sudo ~/workspace/bin/chr_uml.sh -r ~/virtual/uml/trinity -t "cd
/mnt/hostfs/; rm -rf t3; mkdir t3; cd t3; trinity -C 4 -m"
=2E..
[7283] [156] vmsplice(fd=3D385, iov=3D0x974daa0, nr_segs=3D183, flags=3D=
2) =3D 5457
child 7283 exiting
=3D -1 (Interrupted system call)
child 7237 exiting
child 7275 exiting
[5638] Bailing main loop. Exit reason: ctrl-c
[5637] Watchdog exiting

Ran 1238429 syscalls. Successes: 275725  Failures: 960137
$ 1;2c1;2c1;2c1;2c1;2c1;2c1;2c1;2c1;2c


Happened all the time, the chr_uml.sh just creates a ramdisk which is
mounted onto a directory known within the chroot (/mnt/hostfs)

Does anybody else experienced this ?

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
