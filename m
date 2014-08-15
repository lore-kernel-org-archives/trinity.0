From: Dave Jones <davej@redhat.com>
Subject: Re: [child0:1694] <timed out>
Date: Fri, 15 Aug 2014 14:15:26 -0400
Message-ID: <20140815181526.GA28839@redhat.com>
References: <53ECEF3C.3080604@gmx.de>
 <20140814222722.GA19056@redhat.com>
 <53EE4B19.4000305@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53EE4B19.4000305@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Aug 15, 2014 at 08:02:01PM +0200, Toralf F=F6rster wrote:

 > >  > With latest git tree I do get now a lot of lines like :
 > >  >=20
 > >  > [child0:1694] <timed out>
 > >=20
 > /me wonders if dfdb9560d brought this message to my eyes ?

ah, yes, quite likely.  I need to go over a lot of that loglevel code
again at some point, there are a few problems with it. Kinda low down
on my list right now,  but I'll get to it before the next tarball
release.

 > Well for the stack trace feature I've to wait till it is implemented=
 - Richard Weinberger told me that there#S a guy just doing it.

Bah, I thought this was ubiquitous by now..

	Dave
