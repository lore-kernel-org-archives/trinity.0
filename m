From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: BUG!: CHILD (pid:1350) GOT REPARENTED! parent pid:1161. Watchdog
 pid:1160
Date: Thu, 02 May 2013 18:00:53 +0200
Message-ID: <51828DB5.8040401@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

=46WIW my trinity wrapper script sometimes does kill the trinity main p=
rocess if it assumes
that trinity is hanging. After one of such a kill the following message=
 did appear :

bash: line 1:  1159 Terminated              trinity --children 2 --vict=
ims $M/v/victims -N 500000
=3D 0

BUG!: CHILD (pid:1350) GOT REPARENTED! parent pid:1161. Watchdog pid:11=
60
BUG!: Last syscalls:
[0]  pid:1350 call:read callno:1431
[1]  pid:1352 call:vmsplice callno:0

Happens with current trinity git version : 1.1-298-gfd11595

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
