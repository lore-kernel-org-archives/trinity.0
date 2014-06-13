From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: *** Error in `trinity': double free or corruption (!prev): 0x08208e78
 ***
Date: Fri, 13 Jun 2014 18:21:14 +0200
Message-ID: <539B24FA.8070800@gmx.de>
References: <539A15DE.7020101@gmx.de> <20140612220605.GA5771@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140612220605.GA5771@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 06/13/2014 12:06 AM, Dave Jones wrote:
> On Thu, Jun 12, 2014 at 11:04:30PM +0200, Toralf F=C3=B6rster wrote:
>=20
>  > Trinity v1.5pre  Dave Jones <davej@redhat.com>                    =
           <------- and I'm wondering if here something like "git descr=
ibe --tags" should be add too to the version string ?
>=20
> Just pushed something out that does this. (And went back and regenera=
ted
> all the release tags to be 'real' tags instead of lightweight ones, s=
o
> that git describe actually works). Pull down the latest tags to make =
it work.
>=20
cool.
> caveat: it needs you to rerun configure.sh each time you pull, which
> kinda sucks.  I suppose it'd be better if it somehow did all this stu=
ff
> from the Makefile.  I'll look into fixing it sometime unless someone =
else beats
> me to it, but it's not on my urgent list.
>=20
ok (althought now the version string is completely empty if git is not =
installed, eg. on virtual test machines)

>  > Done parsing arguments.     =20
>  > Marking all syscalls as enabled.
>  > *** Error in `trinity': double free or corruption (!prev): 0x08208=
e78 ***
>=20
> I've been chasing a bunch of corruption bugs this last week or so, an=
d
> I think I've killed the worst of the bunch.
>=20
> Does -x mremap make this stop happening for you ?
neither "-x mremap" nor "-x madvise" helped hhm

If it would help a lot I could try to bisect trinity to that.

> Asides from damage caused by that syscall the only other bug that I'v=
e
> got outstanding is that occasionally something stomps on the pid
> element of the child structures. Oddly enough, it shows up only when
> run with MALLOC_PERTURB_ set. That's the value that gets scribbled
> there.  The weird part is that that struct never gets freed, and
> the struct is a COW'd mmap from the main process, so it's always
> initialized.  Mysterious.
>=20
> That all said, I've not seen it since I turned a bunch of the
> child handling upside down over the last day or so, so I may have
> inadvertantly "fixed" it by rewriting it away.
> I'm all ears if you see any of the BUG statements where it
> dumps the pids however.

WIll look onto it

--
Toralf
