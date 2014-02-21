From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: current trinity gives glibc errors
Date: Fri, 21 Feb 2014 22:28:32 +0100
Message-ID: <5307C500.8050300@gmx.de>
References: <52B45985.6060806@gmx.de> <20131220192739.GA13124@redhat.com> <52B4A95F.9040407@gmx.de> <20131220205003.GA14629@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131220205003.GA14629@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/20/2013 09:50 PM, Dave Jones wrote:
> On Fri, Dec 20, 2013 at 09:32:31PM +0100, Toralf F=C3=B6rster wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
>>=20
>> On 12/20/2013 08:27 PM, Dave Jones wrote:
>>> On Fri, Dec 20, 2013 at 03:51:49PM +0100, Toralf F=C3=B6rster
>>> wrote:
>>>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
>>>>=20
>>>> When I run latest trinity at a stable 32 Bit Gentoo Linux
>>>> user mode linux image I do now get :
>>>>=20
>>>> trinity -q -N 10000 -C 2 -x mremap
>>>>=20
>> It is this :
>>=20
>> trinity -q -l off -N 1 -c move_pages
>=20
> Are you running as root ?  Probably best to just -x it for now.
>=20
> sanitise_move_pages could use rewriting tbh, to use the new maps
> structs. I'll look at doing that in the new year.
>=20
since today (with 1.1-1102-g4914e9f) it works now again - thx


- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMHxQAACgkQxOrN3gB26U6JmQD+MIlNwsJVfDUHNzVpPp4O3+mg
lk5ZawRphM124rOFsEUA/30dKQr57nJOLmtppRDPHgqWNkfSrJHn0GxISAhifrjG
=3Dl5xU
-----END PGP SIGNATURE-----
