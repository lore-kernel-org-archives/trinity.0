From: Dave Jones <davej@redhat.com>
Subject: Re: random.c:183:3: error: left shift count >= width of type
 [-Werror]
Date: Wed, 22 May 2013 13:18:52 -0400
Message-ID: <20130522171852.GA636@redhat.com>
References: <519CFCDB.2000509@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519CFCDB.2000509@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Wed, May 22, 2013 at 07:14:03PM +0200, Toralf F=C3=B6rster wrote:
 > At a 32 bit stable Gentoo Linux I get with current git tree :
 >=20
 >   CC    child.o
 > random.c: In function =E2=80=98rand64=E2=80=99:
 > random.c:183:3: error: left shift count >=3D width of type [-Werror]
 > cc1: all warnings being treated as errors
 > make: *** [random.o] Error 1

I knew I forgot to test something. Thanks, fixed.

	Dave
