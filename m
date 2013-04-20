From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: called althought it is marked as AVOID.
Date: Sat, 20 Apr 2013 22:01:30 +0200
Message-ID: <5172F41A.7060704@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

Running trinity within a user mode linux image yield into :


2013-04-20T21:48:16.000+02:00 trinity tfoerste: W=3D/mnt/nfs/n22/w
2013-04-20T21:48:21.926+02:00 trinity kernel: ------------[ cut here ]-=
-----------
2013-04-20T21:48:21.926+02:00 trinity kernel: WARNING: at mm/mmap.c:270=
2 exit_mmap+0x161/0x170()
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bd90:  [<0836fe08>] d=
ump_stack+0x22/0x24
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bda8:  [<0807f1da>] w=
arn_slowpath_common+0x5a/0x80
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bdd0:  [<0807f2a3>] w=
arn_slowpath_null+0x23/0x30
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bde0:  [<080e9231>] e=
xit_mmap+0x161/0x170
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844be18:  [<0807cdd9>] m=
mput+0x39/0x90
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844be2c:  [<08083f00>] d=
o_exit+0x2d0/0x820
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844be7c:  [<08084527>] d=
o_group_exit+0x97/0xe0
2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bea0:  [<08084589>] s=
ys_exit_group+0x19/0x20
2013-04-20T21:48:21.930+02:00 trinity kernel: 1844beac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-20T21:48:21.930+02:00 trinity kernel: 1844bef4:  [<08076f2d>] u=
serspace+0x46d/0x590
2013-04-20T21:48:21.930+02:00 trinity kernel: 1844bfec:  [<080617fc>] f=
ork_handler+0x6c/0x70
2013-04-20T21:48:21.930+02:00 trinity kernel: 1844bffc:  [<00000000>] 0=
x0
2013-04-20T21:48:21.930+02:00 trinity kernel:
2013-04-20T21:48:21.930+02:00 trinity kernel: ---[ end trace 9f502214d4=
921e53 ]---


The trinity command line was :

$> trinity.sh -x mremap -x mount -x add_key -x request_key -x keyctl -x=
 clock_nanosleep

I'm wondering what does AVOID took to be ignored ?


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
