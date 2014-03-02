From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: do not mremap the sub page of UML [ was:Re: [uml-devel] [info] syscall
 mremap can't be tested at a UML w/ fuzzy tool trinity]
Date: Sun, 02 Mar 2014 13:03:14 +0100
Message-ID: <53131E02.9010800@gmx.de>
References: <5311A846.4020303@gmx.de> <CAFLxGvw+1NH-t1jbsc44EzTGD+Jp2jGCn=Ds4dEJ+7LtzDq7pw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvw+1NH-t1jbsc44EzTGD+Jp2jGCn=Ds4dEJ+7LtzDq7pw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

How can I tell trinity to not mremap it ?

On 03/01/2014 10:34 AM, Richard Weinberger wrote:
> On Sat, Mar 1, 2014 at 10:28 AM, Toralf F=C3=B6rster
> <toralf.foerster@gmx.de> wrote:
>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
>>>=20
>>> Today I tested if I can activate that syscall again here
>>> (munmap works fine since few days). Testing a 32 bit user mode
>>> linux image with "$>trinity -q -N 100000 -C 8" gave in the
>>> syslog of the UML guest:
>>>=20
>>> Mar  1 10:09:18 trinity kernel: Stub registers - Mar  1
>>> 10:09:18 trinity kernel:         0 - 100000
> Looks like the stub page. You cannot remap it. If you do so the
> calling process will die.
>=20


- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMTHgIACgkQxOrN3gB26U7mJAD+NoKRpLbpLjbQyry7y0Ngkbmx
oH9pVUr0bu1tbbfB+pYBAIQ+scnrW97kngcFAM2bJb/R9fp6osEB4AbPpV5ZEmwC
=3Dhgfr
-----END PGP SIGNATURE-----
