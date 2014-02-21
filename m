From: Dave Jones <davej@redhat.com>
Subject: Re: current trinity gives glibc errors
Date: Fri, 21 Feb 2014 16:52:28 -0500
Message-ID: <20140221215228.GA19143@redhat.com>
References: <52B45985.6060806@gmx.de>
 <20131220192739.GA13124@redhat.com>
 <52B4A95F.9040407@gmx.de>
 <20131220205003.GA14629@redhat.com>
 <5307C500.8050300@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5307C500.8050300@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Feb 21, 2014 at 10:28:32PM +0100, Toralf F=F6rster wrote:
=20
 > >>>> When I run latest trinity at a stable 32 Bit Gentoo Linux
 > >>>> user mode linux image I do now get :
 > >>>>=20
 > >>>> trinity -q -N 10000 -C 2 -x mremap
 > >>>>=20
 > >> It is this :
 > >>=20
 > >> trinity -q -l off -N 1 -c move_pages
 > >=20
 > > Are you running as root ?  Probably best to just -x it for now.
 > >=20
 > > sanitise_move_pages could use rewriting tbh, to use the new maps
 > > structs. I'll look at doing that in the new year.
 > >=20
 > since today (with 1.1-1102-g4914e9f) it works now again - thx

good to know. I've still got a bunch of other backtraces to dig through=
,
but that's going to have to wait until next week.

	Dave
