From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: cppcheck mentions format string error
Date: Wed, 08 Jan 2014 19:52:02 +0100
Message-ID: <52CD9E52.6080301@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

heise.de reported about a security flaw in xorg-server found by cppchec=
k - so I just gave it a try.

It reports :

~/devel/trinity $ cppcheck ./ --force --quiet
[devices.c:90]: (warning) %a in format string (no. 2) requires 'float *=
' but the argument type is 'char * *'.


Is it correct ?

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
