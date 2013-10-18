From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: compile error on 32 bit Gentoo Linux
Date: Fri, 18 Oct 2013 11:53:04 +0200
Message-ID: <52610500.1050108@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

I do get since today (yesterday it was ok):


  CC    net/ether.o
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by de=
fault]
net/ether.c:1:0: note: this is the location of the previous definition
  CC    net/icmp6_setsockopt.o
net/ether.c:25:2: error: =E2=80=98ETH_P_802_3_MIN=E2=80=99 undeclared h=
ere (not in a function)
make: *** [net/ether.o] Error 1
make: *** Waiting for unfinished jobs....
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by de=
fault]
net/icmp6_setsockopt.c:1:0: note: this is the location of the previous =
definition
 * ERROR: dev-util/trinity-9999::toralf failed (compile phase):

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
