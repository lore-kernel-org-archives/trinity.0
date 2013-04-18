From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: syscall vmsplice gives a lot of : *** glibc detected *** trinity:
 malloc(): smallbin double linked list corrupted:
Date: Thu, 18 Apr 2013 19:44:35 +0200
Message-ID: <51703103.9020603@gmx.de>
References: <517022C4.90400@gmx.de> <CAANmmGGwyY2Uca9KFahXV+AKk1nJFgNrkpP3DMktcr6Lr396qw@mail.gmail.com> <CAANmmGHzZ-sbNZX2peXKdveyJfmodso2fGjzd3S46V01XuBASA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAANmmGHzZ-sbNZX2peXKdveyJfmodso2fGjzd3S46V01XuBASA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michael Abshoff <mabshoff@gmail.com>
Cc: trinity@vger.kernel.org

On 04/18/2013 07:00 PM, Michael Abshoff wrote:
>=20
> It is a valgrind issue, i.e. AVX instructions in 32 bit mode - see
>=20
>    https://bugs.kde.org/show_bug.cgi?id=3D301967
ah - thx.

Couldn't resist to put my 2ct onto that bug report too.


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
