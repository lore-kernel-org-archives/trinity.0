From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: git issue
Date: Wed, 1 Jul 2015 10:21:41 -0400
Message-ID: <20150701142141.GA11460@codemonkey.org.uk>
References: <5593ED2C.50705@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5593ED2C.50705@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Wed, Jul 01, 2015 at 03:37:48PM +0200, Toralf F=F6rster wrote:
 > got today :
 >=20
 > $ cd ~/devel/trinity; git pull                      =20
 > U       blockdevs.c
 > U       debug.c
 > U       rand/random-pathname.c
 > U       rand/random.c
 > U       shm.c
 > U       tools/analyze-sockets.c
 > U       uid.c
 > Pull is not possible because you have unmerged files.
 > Please, fix them up in the work tree, and then use 'git add/rm <file=
>'
 > as appropriate to mark resolution and make a commit.
 >=20
 >=20
 > tfoerste@t44 ~/devel/trinity $ git diff
 >=20
 > tfoerste@t44 ~/devel/trinity $ git status
 > On branch master
 > Your branch and 'origin/master' have diverged,
 > and have 3702 and 3711 different commits each, respectively.
 >   (use "git pull" to merge the remote branch into yours)
 > You have unmerged paths.
 >   (fix conflicts and run "git commit")

I wondered if anyone would notice this.
I edited history to fix up two broken commit dates.

Just reclone. Shouldn't happen again.

	Dave
