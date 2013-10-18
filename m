From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 04/12] configure.sh: show error output when something is
 not found
Date: Fri, 18 Oct 2013 14:00:19 -0400
Message-ID: <20131018180019.GA26183@redhat.com>
References: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
 <1381920210-23329-4-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381920210-23329-4-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: trinity@vger.kernel.org

On Wed, Oct 16, 2013 at 01:43:22PM +0300, Mikko Rapeli wrote:
 > It can be a configuration or ortherwise important warning/error.
 >=20
 > Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
=20
I don't like this one, because in most cases, these aren't important.
On some machines, we even expect some of them to fail. Example, on a Fe=
dora 19
system we run this test, which we expect to fail..


[*] Checking if glibc headers provide termios2..  [NO]=20
/home/davej/tmp/tmp.U0xuPLOakW.c: In function =E2=80=98main=E2=80=99:
/home/davej/tmp/tmp.U0xuPLOakW.c:7:18: error: storage size of =E2=80=98=
test=E2=80=99 isn=E2=80=99t known
  struct termios2 test;
                  ^

Printing out an 'error' when there's nothing actually wrong seems alarm=
ist.
Especially when we do the right thing, and include the right header aft=
erwards.

	Dave
