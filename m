From: Dave Jones <davej@redhat.com>
Subject: Re: cppcheck mentions format string error
Date: Wed, 8 Jan 2014 14:04:38 -0500
Message-ID: <20140108190438.GA7714@redhat.com>
References: <52CD9E52.6080301@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52CD9E52.6080301@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Wed, Jan 08, 2014 at 07:52:02PM +0100, Toralf F=F6rster wrote:
 > heise.de reported about a security flaw in xorg-server found by cppc=
heck - so I just gave it a try.
 >=20
 > It reports :
 >=20
 > ~/devel/trinity $ cppcheck ./ --force --quiet
 > [devices.c:90]: (warning) %a in format string (no. 2) requires 'floa=
t *' but the argument type is 'char * *'.
 >=20
 >=20
 > Is it correct ?
=20
no. Looks like it doesn't understand the gnu %as extension, and thinks =
it's %a followed by 's'.

That extension isn't C99, but given portability isn't really a goal for=
 trinity, I'm
not overly bothered by it.

	Dave
