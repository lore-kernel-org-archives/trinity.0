From: Dave Jones <davej@redhat.com>
Subject: Re: net/ip_setsockopt.c:29:20: =?utf-8?Q?e?=
 =?utf-8?B?cnJvcjog4oCYSVBfVU5JQ0FTVF9JRg==?= =?utf-8?B?4oCZ?= undeclared
 here (not in a function)
Date: Fri, 5 Jul 2013 10:51:19 -0400
Message-ID: <20130705145119.GC325@redhat.com>
References: <51D5A7F7.9030102@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51D5A7F7.9030102@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Jul 04, 2013 at 06:51:03PM +0200, Toralf F=C3=B6rster wrote:
 > Latest git gives :
 >=20
 >   CC    net/llc.o
 > net/ip_setsockopt.c:29:20: error: =E2=80=98IP_UNICAST_IF=E2=80=99 un=
declared here (not
 > in a function)
 > make: *** [net/ip_setsockopt.o] Error 1
 > make: *** Waiting for unfinished jobs....
 >  * ERROR: dev-util/trinity-9999 failed (compile phase):
 >=20

Should be fixed now.

	Dave
