From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x161/0x170()
Date: Wed, 15 May 2013 21:30:54 +0200
Message-ID: <5193E26E.90003@gmx.de>
References: <518FB97A.5070907@gmx.de> <CAFLxGvzn+Q=D4vjTNuggSTnQKVp0QYLPoHmUwAVBcRbSmD3HWQ@mail.gmail.com> <518FBE6A.50605@gmx.de> <CAFLxGvyvRb+WD-eLBFnH5O-sXjUdtUkXbKzG6HFqgzm+x2LUow@mail.gmail.com> <CAFLxGvwEiE0dfw9Vju_Xg6mXkF_NH_OU_t7puPceYN42dphTLA@mail.gmail.com> <518FE33B.60701@gmx.de> <CAFLxGvyiKbbkPAG0h42y1fb=Z6YuboJPdyb+2Xk9Z2YYt7oryg@mail.gmail.com> <518FF354.7020408@gmx.de> <CAFLxGvxYjpt6X9MQF3Huh-Sqzm3CBMJAfGb_Qjpqu00iUzj=qg@mail.gmail.com> <518FFBA3.6000800@gmx.de> <CAFLxGvx+8wpBeF_TqOk3JKBEoADAS-NeatpJMuSVvaDhZNqE0g@mail.gmail.com> <CAFLxGvzSEY8iciEONkxNGeO6Lt5v4VcB2sF1XPcqLA=n8PUaAQ@mail.gmail.com> <51901400.4060302@gmx.de> <CAFLxGvx-saWcJ+JCubUBAVT70OSMZDYNETqiNijJgXeqCPwwUA@mail.gmail.com> <5193DCA7.1070708@gmx.de> <CAFLxGvxhDu6jVHZ0iOhjSBEfEY5JZRJ9xw0gxcduvuTR6BGOPg@mail.
 gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvxhDu6jVHZ0iOhjSBEfEY5JZRJ9xw0gxcduvuTR6BGOPg@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "user-mode-linux-devel@lists.sourceforge.net" <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

On 05/15/2013 09:11 PM, richard -rw- weinberger wrote:
> On Wed, May 15, 2013 at 9:06 PM, Toralf F=C3=B6rster <toralf.foerster=
@gmx.de> wrote:
>> On 05/13/2013 09:12 AM, richard -rw- weinberger wrote:
>>> This looks like another issue.
>>> Are you testing process_vm_writev() with trinity?
>>> Looks like it managed to overwrite the stub page of a process, whic=
h
>>> is not good.
>> nope, it is the mremap syscall.
>>
>> A command like
>>
>> $>trinity -c mremap -N 10
>>
>> immediately after starting a 32 bit Gentoo linux guest with current =
kernel 3.10-rc1-... +
>> strnlen + stub4 patch works, but later a
>>
>> $>trinity -c mremap -N 1000
>>
>> yields into
>>
>> 2013-05-15T21:02:04.061+02:00 trinity kernel: Stub registers -
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   0 - 100000
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   1 - 300000
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   2 - 0
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   3 - 0
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   4 - 0
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   5 - 0
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   6 - 0
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   7 - 7b
>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   8 - 7b
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   9 - 0
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   10 - 33
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   11 - ffffffff
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   12 - 1000c3
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   13 - 73
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   14 - 10206
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   15 - 101028
>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   16 - 7b
>> 2013-05-15T21:02:04.065+02:00 trinity kernel: wait_stub_done : faile=
d to wait for SIGTRAP, pid =3D 15692, n =3D 15692, errno =3D 0, status =
=3D 0xb7f
>>
>> and now that process can't be killed - I had to stop the UML guest.
>=20
> Hmm, you've remapped the stub page and therefore the process broke.
> I think it would make sense to kill the process in stead of writing
> the "wait_stub_done ..." message.
> Changing the stub page is as destructive than overwriting the stack.

Unfortunately no trinity process can be killed as soon as that happen.
Neither pgrep, pkill, nor "ps -efla" do return any result.
Killing any of those processes by its pid won't work too.

> Maybe we can teach triniy to no change the stub page.
> I'm sure trinity has also a mechanism to not destroy the stack.

@trinity Mailing list
	What do you think about that ?

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
