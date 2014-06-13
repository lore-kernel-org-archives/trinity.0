From: Dave Jones <davej@redhat.com>
Subject: Re: *** Error in `trinity': double free or corruption (!prev):
  0x08208e78 ***
Date: Fri, 13 Jun 2014 12:38:12 -0400
Message-ID: <20140613163812.GA17879@redhat.com>
References: <539A15DE.7020101@gmx.de>
 <20140612220605.GA5771@redhat.com>
 <539B24FA.8070800@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <539B24FA.8070800@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Jun 13, 2014 at 06:21:14PM +0200, Toralf F=F6rster wrote:

 > > caveat: it needs you to rerun configure.sh each time you pull, whi=
ch
 > > kinda sucks.  I suppose it'd be better if it somehow did all this =
stuff
 > > from the Makefile.  I'll look into fixing it sometime unless someo=
ne else beats
 > > me to it, but it's not on my urgent list.
 > >=20
 > ok (althought now the version string is completely empty if git is n=
ot installed, eg. on virtual test machines)

Ok, Just pushed something out so it falls back to grepping the Makefile
if git isn't installed. Guess that case is useful if someone was
building from one of the snapshot tarballs.

 > >  > Done parsing arguments.     =20
 > >  > Marking all syscalls as enabled.
 > >  > *** Error in `trinity': double free or corruption (!prev): 0x08=
208e78 ***
 > >=20
 > > I've been chasing a bunch of corruption bugs this last week or so,=
 and
 > > I think I've killed the worst of the bunch.
 > >=20
 > > Does -x mremap make this stop happening for you ?
 > neither "-x mremap" nor "-x madvise" helped hhm
 >=20
 > If it would help a lot I could try to bisect trinity to that.

I have a feeling it'll land on one of the bigger changesets, but it
might be useful to narrow down.

	Dave
