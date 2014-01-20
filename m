From: Dave Jones <davej@redhat.com>
Subject: Re: cppcheck mentions format string error
Date: Mon, 20 Jan 2014 17:00:49 -0500
Message-ID: <20140120220049.GA2792@redhat.com>
References: <52CD9E52.6080301@gmx.de>
 <20140108190438.GA7714@redhat.com>
 <52CDA849.2080203@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52CDA849.2080203@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Wed, Jan 08, 2014 at 08:34:33PM +0100, Toralf F=F6rster wrote:
=20
 > On 01/08/2014 08:04 PM, Dave Jones wrote:
 > > On Wed, Jan 08, 2014 at 07:52:02PM +0100, Toralf F=F6rster wrote:
 > >> heise.de reported about a security flaw in xorg-server found by
 > >> cppcheck - so I just gave it a try.
 > >>=20
 > >> It reports :
 > >>=20
 > >> ~/devel/trinity $ cppcheck ./ --force --quiet [devices.c:90]:
 > >> (warning) %a in format string (no. 2) requires 'float *' but the
 > >> argument type is 'char * *'.
 > >>=20
 > >>=20
 > >> Is it correct ?
 > >=20
 > > no. Looks like it doesn't understand the gnu %as extension, and
 > > thinks it's %a followed by 's'.
 > >=20
 > > That extension isn't C99, but given portability isn't really a goa=
l
 > > for trinity, I'm not overly bothered by it.
 > >=20
 > > Dave
 > >=20
 > >=20
 > ok
 >=20
 > FWIW I created an enhancement request for cppcheck :
 >=20
 > Ticket URL: <http://sourceforge.net/apps/trac/cppcheck/ticket/5329>

I'm not sure why I never noticed before, but after upgrading some packa=
ges
this last week, suddenly gcc and llvm are both warning about it.
After filing a bug on what I thought was a gcc bug, Jakub suggested
switching to %ms, which should make things happier, including cppcheck.

strange.

	Dave
