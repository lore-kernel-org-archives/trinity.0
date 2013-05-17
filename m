From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x161/0x170()
Date: Fri, 17 May 2013 16:28:40 +0200
Message-ID: <51963E98.2030108@gmx.de>
References: <518FB97A.5070907@gmx.de> <518FBE6A.50605@gmx.de> <CAFLxGvyvRb+WD-eLBFnH5O-sXjUdtUkXbKzG6HFqgzm+x2LUow@mail.gmail.com> <CAFLxGvwEiE0dfw9Vju_Xg6mXkF_NH_OU_t7puPceYN42dphTLA@mail.gmail.com> <518FE33B.60701@gmx.de> <CAFLxGvyiKbbkPAG0h42y1fb=Z6YuboJPdyb+2Xk9Z2YYt7oryg@mail.gmail.com> <518FF354.7020408@gmx.de> <CAFLxGvxYjpt6X9MQF3Huh-Sqzm3CBMJAfGb_Qjpqu00iUzj=qg@mail.gmail.com> <518FFBA3.6000800@gmx.de> <CAFLxGvx+8wpBeF_TqOk3JKBEoADAS-NeatpJMuSVvaDhZNqE0g@mail.gmail.com> <CAFLxGvzSEY8iciEONkxNGeO6Lt5v4VcB2sF1XPcqLA=n8PUaAQ@mail.gmail.com> <51901400.4060302@gmx.de> <CAFLxGvx-saWcJ+JCubUBAVT70OSMZDYNETqiNijJgXeqCPwwUA@mail.gmail.com> <5193DCA7.1070708@gmx.de> <CAFLxGvxhDu6jVHZ0iOhjSBEfEY5JZRJ9xw0gxcduvuTR6BGOPg@mail.gmail.com> <5193E26E.90003@gmx.de> <CAFLxGvyggXx0grnef3RNPbyDq0scNjDJ
 Q_h0=aRdbe_Aa-p-gQ@mail.gmail.com> <CAFLxGvz4Ru-TKb34_WE-EC7Z8SenR3HcrDfbpNeO1oOROpzk=A@mail.gmail.com> <CAFLxGvxkOH91Ne59vzahDLkphBno2GYntsPf5DBAj7CeCjTivA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvxkOH91Ne59vzahDLkphBno2GYntsPf5DBAj7CeCjTivA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "user-mode-linux-devel@lists.sourceforge.net" <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

On 05/17/2013 02:22 PM, richard -rw- weinberger wrote:
> Toralf, can you please append the attached patch too?
> It makes processes killable which corrupted their stub pages.
yes - now I can run an trinity infinite with the syscall mremap().

I still get for every x-th the syslog seen below, but processes are now=
 killable (and trinity itself can kill its childs too so far)


2013-05-17T16:27:30.234+02:00 trinity kernel: do_syscall_stub: syscall =
91 failed, return value =3D 0x0, expected return value =3D 0x0
2013-05-17T16:27:30.234+02:00 trinity kernel: syscall parameters: 0x100=
000 0x300000 0x0 0x0 0x0 0x0
2013-05-17T16:27:30.441+02:00 trinity kernel: Stub registers -
2013-05-17T16:27:30.441+02:00 trinity kernel:   0 - 100000
2013-05-17T16:27:30.441+02:00 trinity kernel:   1 - 300000
2013-05-17T16:27:30.441+02:00 trinity kernel:   2 - 0
2013-05-17T16:27:30.441+02:00 trinity kernel:   3 - 0
2013-05-17T16:27:30.441+02:00 trinity kernel:   4 - 0
2013-05-17T16:27:30.441+02:00 trinity kernel:   5 - 0
2013-05-17T16:27:30.441+02:00 trinity kernel:   6 - 0
2013-05-17T16:27:30.441+02:00 trinity kernel:   7 - 7b
2013-05-17T16:27:30.441+02:00 trinity kernel:   8 - 7b
2013-05-17T16:27:30.442+02:00 trinity kernel:   9 - 0
2013-05-17T16:27:30.442+02:00 trinity kernel:   10 - 33
2013-05-17T16:27:30.442+02:00 trinity kernel:   11 - ffffffff
2013-05-17T16:27:30.442+02:00 trinity kernel:   12 - 1000c3
2013-05-17T16:27:30.442+02:00 trinity kernel:   13 - 73
2013-05-17T16:27:30.442+02:00 trinity kernel:   14 - 10206
2013-05-17T16:27:30.442+02:00 trinity kernel:   15 - 101028
2013-05-17T16:27:30.442+02:00 trinity kernel:   16 - 7b
2013-05-17T16:27:30.442+02:00 trinity kernel: wait_stub_done : failed t=
o wait for SIGTRAP, pid =3D 31946, n =3D 31946, errno =3D 0, status =3D=
 0xb7f
2013-05-17T16:27:30.442+02:00 trinity kernel: do_syscall_stub : ret =3D=
 0, offset =3D 1052680, data =3D 41c36008
2013-05-17T16:27:30.443+02:00 trinity kernel: do_syscall_stub: syscall =
91 failed, return value =3D 0x0, expected return value =3D 0x0
2013-05-17T16:27:30.443+02:00 trinity kernel: syscall parameters: 0x100=
000 0x300000 0x0 0x0 0x0 0x0

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
