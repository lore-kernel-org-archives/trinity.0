From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: why is parameter N increased by 1 ?
Date: Sat, 20 Apr 2013 11:03:38 +0200
Message-ID: <517259EA.5040809@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

I'm just curious about this increment in params.c :

                /* Set number of syscalls to do */
                case 'N':
                        syscalls_todo =3D strtoll(optarg, NULL, 10) + 1=
;
                        break;

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
