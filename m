From: Dave Jones <davej@redhat.com>
Subject: Re: hang in creating the trinity-testfileX
Date: Wed, 10 Sep 2014 13:59:20 -0400
Message-ID: <20140910175920.GA29738@redhat.com>
References: <5404B2AB.8080500@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5404B2AB.8080500@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Mon, Sep 01, 2014 at 07:53:47PM +0200, Toralf F=F6rster wrote:
 > Trinity sometimes hangs infinitely in a KVM while trying to create t=
he testfiles, eg .:
 >=20
 > ...
 > [main] fd[668] =3D timerfd
 > [main] fd[669] =3D fopen("trinity-testfile1", O_RDWR)
 > [main] fd[670] =3D fopen("trinity-testfile2", O_RDWR)
 >=20
 >=20
 > Ctrl-C works fortunately

I just hit this myself. It happens if the test files already exist.
=46or now just clear out tmp/* before re-running.

I'll push out some changes later to deal with this (and other problems)=
=2E

	Dave
