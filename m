From: Dave Jones <davej@redhat.com>
Subject: Re: compile error on 32 bit Gentoo Linux
Date: Fri, 18 Oct 2013 13:50:03 -0400
Message-ID: <20131018175003.GA24271@redhat.com>
References: <52610500.1050108@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52610500.1050108@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Oct 18, 2013 at 11:53:04AM +0200, Toralf F=C3=B6rster wrote:
 > I do get since today (yesterday it was ok):
 >=20
 >=20
 >   CC    net/ether.o
 > <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by=
 default]
 > net/ether.c:1:0: note: this is the location of the previous definiti=
on
 >   CC    net/icmp6_setsockopt.o
 > net/ether.c:25:2: error: =E2=80=98ETH_P_802_3_MIN=E2=80=99 undeclare=
d here (not in a function)
 > make: *** [net/ether.o] Error 1
 > make: *** Waiting for unfinished jobs....
 > <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by=
 default]
 > net/icmp6_setsockopt.c:1:0: note: this is the location of the previo=
us definition
 >  * ERROR: dev-util/trinity-9999::toralf failed (compile phase):

Should be fixed now. Thanks.

	Dave
