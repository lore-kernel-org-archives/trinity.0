From: Dave Jones <davej@redhat.com>
Subject: Re: -r not mentioned in --help
Date: Mon, 15 Apr 2013 14:06:25 -0400
Message-ID: <20130415180625.GA1339@redhat.com>
References: <516C3431.2000102@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <516C3431.2000102@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Mon, Apr 15, 2013 at 07:09:05PM +0200, Toralf F=F6rster wrote:
 > And it seems that a command line like
 >=20
 > $> trinity --children 4 --victims \$W/victims -x mremap -N 40000 -r =
-q
 >=20
 > now no longer works, trinity complains about "-r":
 >=20
 > trinity: invalid option -- 'r'

Strange failure mode, but I think this may have been due to -x being be=
fore -r.
I just pushed out a change that enforces the right ordering.

Does that fix it for you if you move the -r earlier ?

	Dave
