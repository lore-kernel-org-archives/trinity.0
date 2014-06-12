From: Dave Jones <davej@redhat.com>
Subject: Re: *** Error in `trinity': double free or corruption (!prev):
 0x08208e78 ***
Date: Thu, 12 Jun 2014 18:06:05 -0400
Message-ID: <20140612220605.GA5771@redhat.com>
References: <539A15DE.7020101@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <539A15DE.7020101@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Jun 12, 2014 at 11:04:30PM +0200, Toralf F=F6rster wrote:

 > Trinity v1.5pre  Dave Jones <davej@redhat.com>                      =
         <------- and I'm wondering if here something like "git describ=
e --tags" should be add too to the version string ?

Just pushed something out that does this. (And went back and regenerate=
d
all the release tags to be 'real' tags instead of lightweight ones, so
that git describe actually works). Pull down the latest tags to make it=
 work.

caveat: it needs you to rerun configure.sh each time you pull, which
kinda sucks.  I suppose it'd be better if it somehow did all this stuff
from the Makefile.  I'll look into fixing it sometime unless someone el=
se beats
me to it, but it's not on my urgent list.

 > Done parsing arguments.     =20
 > Marking all syscalls as enabled.
 > *** Error in `trinity': double free or corruption (!prev): 0x08208e7=
8 ***

I've been chasing a bunch of corruption bugs this last week or so, and
I think I've killed the worst of the bunch.

Does -x mremap make this stop happening for you ?

Asides from damage caused by that syscall the only other bug that I've
got outstanding is that occasionally something stomps on the pid
element of the child structures. Oddly enough, it shows up only when
run with MALLOC_PERTURB_ set. That's the value that gets scribbled
there.  The weird part is that that struct never gets freed, and
the struct is a COW'd mmap from the main process, so it's always
initialized.  Mysterious.

That all said, I've not seen it since I turned a bunch of the
child handling upside down over the last day or so, so I may have
inadvertantly "fixed" it by rewriting it away.
I'm all ears if you see any of the BUG statements where it
dumps the pids however.


I'll poke at mremap in the coming days, because that's the only
thing I'm having to exclude right now because it does so much
damage to trinity's internals.

	Dave
