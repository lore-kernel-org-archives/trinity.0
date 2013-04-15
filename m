From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: -r not mentioned in --help
Date: Mon, 15 Apr 2013 19:09:05 +0200
Message-ID: <516C3431.2000102@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

And it seems that a command line like

$> trinity --children 4 --victims \$W/victims -x mremap -N 40000 -r -q

now no longer works, trinity complains about "-r":

trinity: invalid option -- 'r'


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
