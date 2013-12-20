From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: current trinity gives glibc errors
Date: Fri, 20 Dec 2013 21:23:32 +0100
Message-ID: <52B4A744.1010602@gmx.de>
References: <52B45985.6060806@gmx.de> <20131220192739.GA13124@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131220192739.GA13124@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/20/2013 08:27 PM, Dave Jones wrote:
> If you could narrow down which syscalls are causing this it would
> help a lot. scripts/find.sh might give you some ideas.
>=20
> Dave
will do - where's the variable $i (line 32 and 33) defined in find.sh ?

- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlK0p0QACgkQxOrN3gB26U5b6wD/bedr1F1Dk3Kzvtdjb2gZsV+Q
iU7ulQyaINKX3+ZHt5kA/jTFU1HmnJhQ2fO/s4HZTOCML1FDzp7BQsMRHxlpEOvW
=3DL3GK
-----END PGP SIGNATURE-----
