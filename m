From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: cppcheck mentions format string error
Date: Wed, 08 Jan 2014 20:34:33 +0100
Message-ID: <52CDA849.2080203@gmx.de>
References: <52CD9E52.6080301@gmx.de> <20140108190438.GA7714@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140108190438.GA7714@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 01/08/2014 08:04 PM, Dave Jones wrote:
> On Wed, Jan 08, 2014 at 07:52:02PM +0100, Toralf F=C3=B6rster wrote:
>> heise.de reported about a security flaw in xorg-server found by
>> cppcheck - so I just gave it a try.
>>=20
>> It reports :
>>=20
>> ~/devel/trinity $ cppcheck ./ --force --quiet [devices.c:90]:
>> (warning) %a in format string (no. 2) requires 'float *' but the
>> argument type is 'char * *'.
>>=20
>>=20
>> Is it correct ?
>=20
> no. Looks like it doesn't understand the gnu %as extension, and
> thinks it's %a followed by 's'.
>=20
> That extension isn't C99, but given portability isn't really a goal
> for trinity, I'm not overly bothered by it.
>=20
> Dave
>=20
>=20
ok

=46WIW I created an enhancement request for cppcheck :

Ticket URL: <http://sourceforge.net/apps/trac/cppcheck/ticket/5329>

- --=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLNqEkACgkQxOrN3gB26U5kggD+IB2GXXByWJhXuQxZ/KBLpNQk
8uKd0/estsOegrJ9G/kA/2e4sCfDRL0OZlvOSqYPgtQFXiikQDf5ne5jo0ZkPtVg
=3DEP9s
-----END PGP SIGNATURE-----
