From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: maps.c:45:2: error: =?UTF-8?B?4oCYc3RydWN0IG1hcOKAmSBoYXMgbm8=?=
 =?UTF-8?B?IG1lbWJlciBuYW1lZCDigJhsaXN04oCZ?=
Date: Sat, 07 Dec 2013 17:18:16 +0100
Message-ID: <52A34A48.30804@gmx.de>
References: <52A0ACFA.9040607@gmx.de> <20131205221028.GA18984@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131205221028.GA18984@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 12/05/2013 11:10 PM, Dave Jones wrote:
> The work I'm doing on the mmap syscalls might mean you see more oom k=
ills
> for a while btw, especially on 32bit if you run a lot of child proces=
ses/instances.
>=20
> 	Dave
Ah - thx for the info - so I excluded that particular call for now - b/=
c
I'm rather interested in a fs / radix_tree issue under x86.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
