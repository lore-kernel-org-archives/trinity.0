From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Thu, 01 May 2014 17:15:38 +0200
Message-ID: <5362651A.1020504@gmx.de>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com> <536221F4.6000405@gmx.de> <53623EFE.3040603@nod.at>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <53623EFE.3040603@nod.at>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Richard Weinberger <richard@nod.at>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On 05/01/2014 02:33 PM, Richard Weinberger wrote:
> Am 01.05.2014 12:29, schrieb Toralf F=C3=B6rster:
>> On 05/01/2014 11:22 AM, Richard Weinberger wrote:
>>> On Wed, Apr 30, 2014 at 8:19 PM, Toralf F=C3=B6rster <toralf.foerst=
er@gmx.de> wrote:
>>>> -or- it uncovers a bug in kernel v3.15-rc3 for UML:
>>>
>>> UML most not panic. :)
>>>
>>> Do you have the trinity logs?
>>> I'd like to know the syscalls parameters.
>> I run trinity with "-C 2 -c mremap" within the guest, the logs are a=
ttached
>=20
> Can you please try the attached pre-patch?
> It looks like the panic() in that code is an overreaction.
> I'm currently looking deeper in the issue.
>=20
> BTW: If you hit "BUG: failure at mm/filemap.c:202/__delete_from_page_=
cache()!",
> this is a known issue https://lkml.org/lkml/2014/4/15/577
>=20
> Thanks,
> //richard
>=20

That patch helps a lot, in the syslog I do now get :

May  1 17:13:48 trinity kernel: Stub registers -
May  1 17:13:48 trinity kernel:         0 - 100000
May  1 17:13:48 trinity kernel:         1 - 2000
May  1 17:13:48 trinity kernel:         2 - 0
May  1 17:13:48 trinity kernel:         3 - 0
May  1 17:13:48 trinity kernel:         4 - 0
May  1 17:13:48 trinity kernel:         5 - 0
May  1 17:13:48 trinity kernel:         6 - 0
May  1 17:13:48 trinity kernel:         7 - 7b
May  1 17:13:48 trinity kernel:         8 - 7b
May  1 17:13:48 trinity kernel:         9 - 0
May  1 17:13:48 trinity kernel:         10 - 33
May  1 17:13:48 trinity kernel:         11 - ffffffff
May  1 17:13:48 trinity kernel:         12 - 1000c3
May  1 17:13:48 trinity kernel:         13 - 73
May  1 17:13:48 trinity kernel:         14 - 10206
May  1 17:13:48 trinity kernel:         15 - 101028
May  1 17:13:48 trinity kernel:         16 - 7b
May  1 17:13:48 trinity kernel: wait_stub_done : failed to wait for SIG=
TRAP, pid =3D 14757, n =3D 14757, errno =3D 0, status =3D 0xb7f
May  1 17:13:48 trinity kernel: do_syscall_stub : ret =3D 0, offset =3D=
 1052680, data =3D 47788008
May  1 17:13:48 trinity kernel: do_syscall_stub: syscall 91 failed, ret=
urn value =3D 0x0, expected return value =3D 0x0
May  1 17:13:48 trinity kernel: syscall parameters: 0x100000 0x2000 0x0=
 0x0 0x0 0x0
May  1 17:13:48 trinity kernel: Registers -=20
May  1 17:13:48 trinity kernel:         0       0x2c92
May  1 17:13:48 trinity kernel:         1       0x13
May  1 17:13:48 trinity kernel:         2       0x2c92
May  1 17:13:48 trinity kernel:         3       0x2c8e
May  1 17:13:48 trinity kernel:         4       0xbfa39508
May  1 17:13:48 trinity kernel:         5       0xbfa394ec
May  1 17:13:48 trinity kernel:         6       0x0
May  1 17:13:48 trinity kernel:         7       0x7b
May  1 17:13:48 trinity kernel:         8       0x7b
May  1 17:13:48 trinity kernel:         9       0x0
May  1 17:13:48 trinity kernel:         10      0x33
May  1 17:13:48 trinity kernel:         11      0x25
May  1 17:13:48 trinity kernel:         12      0x1000a0
May  1 17:13:48 trinity kernel:         13      0x73
May  1 17:13:48 trinity kernel:         14      0x246
May  1 17:13:48 trinity kernel:         15      0xbfa394b8
May  1 17:13:48 trinity kernel:         16      0x7b
May  1 17:13:48 trinity kernel: do_syscall_stub : PTRACE_SETREGS failed=
, pid =3D 14757, errno =3D 3
May  1 17:13:48 trinity kernel: fix_range_common: failed, killing curre=
nt process
May  1 17:13:48 trinity kernel: BUG: Bad rss-counter state mm:475aab40 =
idx:0 val:1
May  1 17:13:48 trinity kernel: Stub registers -
May  1 17:13:48 trinity kernel:         0 - 100000
May  1 17:13:48 trinity kernel:         1 - 2000
May  1 17:13:48 trinity kernel:         2 - 0
May  1 17:13:48 trinity kernel:         3 - 0
May  1 17:13:48 trinity kernel:         4 - 0
May  1 17:13:48 trinity kernel:         5 - 0
May  1 17:13:48 trinity kernel:         6 - 0
May  1 17:13:48 trinity kernel:         7 - 7b
May  1 17:13:48 trinity kernel:         8 - 7b
May  1 17:13:48 trinity kernel:         9 - 0
May  1 17:13:48 trinity kernel:         10 - 33
May  1 17:13:48 trinity kernel:         11 - ffffffff
May  1 17:13:48 trinity kernel:         12 - 1000c3
May  1 17:13:48 trinity kernel:         13 - 73
May  1 17:13:48 trinity kernel:         14 - 10206
May  1 17:13:48 trinity kernel:         15 - 101028
May  1 17:13:48 trinity kernel:         16 - 7b
May  1 17:13:48 trinity kernel: wait_stub_done : failed to wait for SIG=
TRAP, pid =3D 14758, n =3D 14758, errno =3D 0, status =3D 0xb7f
May  1 17:13:48 trinity kernel: do_syscall_stub : ret =3D 0, offset =3D=
 1052680, data =3D 477a9008
May  1 17:13:48 trinity kernel: do_syscall_stub: syscall 91 failed, ret=
urn value =3D 0x0, expected return value =3D 0x0
May  1 17:13:48 trinity kernel: syscall parameters: 0x100000 0x2000 0x0=
 0x0 0x0 0x0



--=20
Toralf
