From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: does trinity use the parent directory of the victims directory too
 ?
Date: Wed, 29 May 2013 20:23:46 +0200
Message-ID: <51A647B2.5090903@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

Given a victims directory like /mnt/ramdisk/victims/v1/v2 to trinity
results into a lot of scary file names in the parent directory
/mnt/ramdisk/victims/v1

Is this a side effect of cd'ing into /mnt/ramdisk/victims/v1 before
starting trinity or is trinity intended to create files in the parent o=
f
v2 too ?

=46WIW I meant something like this :

$ ls -1 /mnt/ramdisk/victims/v1/ | sort -u | head

^
<
'
"
=EF=BF=BD
=EF=BF=BD
=EF=BF=BD=EF=BF=BD =EF=BF=BD
=EF=BF=BD=EF=BF=BD =D2=87
=EF=BF=BD=EF=BF=BD=EF=BF=BD

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
