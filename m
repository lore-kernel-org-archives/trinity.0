From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: endless 'Triggering periodic reseed.'
Date: Sun, 04 Aug 2013 12:33:48 +0200
Message-ID: <51FE2E0C.6000308@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

If I see this msg in my trinity log file then I do know that I've to ki=
ll the appropriate process, eg.:

$> kill `grep -B 1  'Triggering periodic reseed.' /mnt/ramdisk/NfsLoopU=
mount.log | grep "Chose rand_syscalls for process" | cut -f5 -d' '`

Anybody else has the same experience or an solution ?

I'm using the latest git tree of trinity.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
