From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: current trinity gives glibc errors
Date: Fri, 20 Dec 2013 21:59:17 +0100
Message-ID: <52B4AFA5.20002@gmx.de>
References: <52B45985.6060806@gmx.de> <20131220192739.GA13124@redhat.com> <52B4A95F.9040407@gmx.de> <20131220205003.GA14629@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131220205003.GA14629@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/20/2013 09:50 PM, Dave Jones wrote:
> Are you running as root ?  Probably best to just -x it for now.
>=20
no - always as common user w/o special rights - but will do it
> sanitise_move_pages could use rewriting tbh, to use the new maps
> structs. I'll look at doing that in the new year.
thx :-)

- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlK0r6QACgkQxOrN3gB26U73kQD+K3fC7dXjjobKKhqyvlT8sJXJ
QmAZeiOHNfiRneOY65sA/jE8fE/hcvIeX2AkA+IAo1zejb8UTYpgS8qwzKbv7xZw
=3DEwGM
-----END PGP SIGNATURE-----
