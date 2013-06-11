From: Dave Jones <davej@redhat.com>
Subject: Re: syscall.c:272:2: error: comparison is always false due
Date: Tue, 11 Jun 2013 11:48:42 -0400
Message-ID: <20130611154842.GA5051@redhat.com>
References: <51B74199.8030501@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51B74199.8030501@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Tue, Jun 11, 2013 at 05:26:17PM +0200, Toralf F=C3=B6rster wrote:
 > Latest git gives at a 32 bit Gentoo Linux:
 >=20
 >   CC    sockets.o
 > syscall.c: In function =E2=80=98mkcall=E2=80=99:
 > syscall.c:272:2: error: comparison is always false due to limited ra=
nge of data type [-Werror=3Dtype-limits]
 > cc1: all warnings being treated as errors

dumb typo. fixed.

	Dave
