From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: syscall.c:272:2: error: comparison is always false due
Date: Tue, 11 Jun 2013 17:26:17 +0200
Message-ID: <51B74199.8030501@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

Latest git gives at a 32 bit Gentoo Linux:

  CC    sockets.o
syscall.c: In function =E2=80=98mkcall=E2=80=99:
syscall.c:272:2: error: comparison is always false due to limited range=
 of data type [-Werror=3Dtype-limits]
cc1: all warnings being treated as errors
make: *** [syscall.o] Error 1
make: *** Waiting for unfinished jobs....
 * ERROR: dev-util/trinity-9999 failed (compile phase):
 *   emake failed

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
