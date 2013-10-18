From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 04/12] configure.sh: show error output when something is
 not found
Date: Fri, 18 Oct 2013 14:07:17 -0400
Message-ID: <20131018180717.GA29546@redhat.com>
References: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
 <1381920210-23329-4-git-send-email-mikko.rapeli@iki.fi>
 <20131018180019.GA26183@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131018180019.GA26183@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: trinity@vger.kernel.org

On Fri, Oct 18, 2013 at 02:00:19PM -0400, Dave Jones wrote:
 > On Wed, Oct 16, 2013 at 01:43:22PM +0300, Mikko Rapeli wrote:
 >  > It can be a configuration or ortherwise important warning/error.
 >  >=20
 >  > Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
 > =20
 > I don't like this one, because in most cases, these aren't important=
=2E
 > On some machines, we even expect some of them to fail. Example, on a=
 Fedora 19
 > system we run this test, which we expect to fail..
 >=20
 >=20
 > [*] Checking if glibc headers provide termios2..  [NO]=20
 > /home/davej/tmp/tmp.U0xuPLOakW.c: In function =E2=80=98main=E2=80=99=
:
 > /home/davej/tmp/tmp.U0xuPLOakW.c:7:18: error: storage size of =E2=80=
=98test=E2=80=99 isn=E2=80=99t known
 >   struct termios2 test;
 >                   ^
 >=20
 > Printing out an 'error' when there's nothing actually wrong seems al=
armist.
 > Especially when we do the right thing, and include the right header =
afterwards.

[PATCH 05/12] configure.sh: support cross compilation with sysroot=20
will need rebasing without this. I applied and pushed out everything el=
se.

	Dave
