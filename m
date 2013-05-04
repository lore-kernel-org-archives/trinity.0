From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: [watchdog] Triggering periodic reseed. : will trinity come back
Date: Sat, 04 May 2013 18:32:39 +0200
Message-ID: <51853827.4020505@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

I often run into a situation, where trinity makes no progress, the outp=
ut is just :

=2E..
[913] Regenerating random pages, fd's etc.
[watchdog] 94001 iterations. [F:78315 S:15673]
[watchdog] Triggering periodic reseed.


Currently I do just kill trinity in such a situation after 5 minutes.
But I'm wondering if it would makes sense to wait longer ?


Here are the appropriate process list (within a user mode linux guest)

$> ps axf | grep trinity
  906 ?        SNs    0:00  |       \_ bash -c pkill -9 trinity; M=3D/m=
nt/n22; logger M=3D$M; sudo mount $M; cd $M/w; trinity --children 2 --v=
ictims $M/v/victims ; sudo umount $M
  911 ?        SN     0:00  |           \_ trinity --children 2 --victi=
ms /mnt/n22/v/victims
  912 ?        SN     0:00  |               \_ trinity --children 2 --v=
ictims /mnt/n22/v/victims
  913 ?        RN     8:57  |               \_ trinity --children 2 --v=
ictims /mnt/n22/v/victims
 1047 ?        SNL    0:02  |                   \_ trinity --children 2=
 --victims /mnt/n22/v/victims
 1074 ?        SN     0:00  |                   \_ trinity --children 2=
 --victims /mnt/n22/v/victims
 1084 pts/0    S+     0:00              \_ grep --colour=3Dauto trinity

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
