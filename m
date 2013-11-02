From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: kernel: sock: sock_set_timeout: `trinity-main' (pid 1349) tries to
 set negative timeout
Date: Sat, 02 Nov 2013 20:39:28 +0100
Message-ID: <527554F0.4070706@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

I'm observing such syslog messages in a user mode linux image and do wo=
nder why trinity-main
does such unusal things (and not the child which I'd expect of course) =
:


Nov  2 19:14:25 trinity kernel: sock: sock_set_timeout: `trinity-main' =
(pid 1349) tries to set negative timeout
Nov  2 19:14:25 trinity kernel: sock: sock_set_timeout: `trinity-main' =
(pid 1349) tries to set negative timeout

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
