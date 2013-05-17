From: "Richard RW. Weinberger" <richard@sigma-star.at>
Subject: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x161/0x170()
Date: Fri, 17 May 2013 16:50:55 +0200 (CEST)
Message-ID: <191613158.65052.1368802255386.JavaMail.root@sigma-star.at>
References: <51963E98.2030108@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51963E98.2030108@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: user-mode-linux-devel@lists.sourceforge.net, trinity@vger.kernel.org, richard -rw- weinberger <richard.weinberger@gmail.com>

----- Urspr=C3=BCngliche Mail -----
> On 05/17/2013 02:22 PM, richard -rw- weinberger wrote:
> > Toralf, can you please append the attached patch too?
> > It makes processes killable which corrupted their stub pages.
> yes - now I can run an trinity infinite with the syscall mremap().
>=20
> I still get for every x-th the syslog seen below, but processes are
> now killable (and trinity itself can kill its childs too so far)

That's perfectly fine.

Thanks,
//richard
