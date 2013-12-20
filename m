From: Dave Jones <davej@redhat.com>
Subject: Re: current trinity gives glibc errors
Date: Fri, 20 Dec 2013 15:50:03 -0500
Message-ID: <20131220205003.GA14629@redhat.com>
References: <52B45985.6060806@gmx.de>
 <20131220192739.GA13124@redhat.com>
 <52B4A95F.9040407@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B4A95F.9040407@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Dec 20, 2013 at 09:32:31PM +0100, Toralf F=F6rster wrote:
 > -----BEGIN PGP SIGNED MESSAGE-----
 > Hash: SHA256
 >=20
 > On 12/20/2013 08:27 PM, Dave Jones wrote:
 > > On Fri, Dec 20, 2013 at 03:51:49PM +0100, Toralf F=F6rster wrote:
 > >> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA256
 > >>=20
 > >> When I run latest trinity at a stable 32 Bit Gentoo Linux user
 > >> mode linux image I do now get :
 > >>=20
 > >> trinity -q -N 10000 -C 2 -x mremap
 > >>=20
 > It is this :
 >=20
 > trinity -q -l off -N 1 -c move_pages

Are you running as root ?  Probably best to just -x it for now.

sanitise_move_pages could use rewriting tbh, to use the new maps struct=
s.
I'll look at doing that in the new year.

	Dave
