From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] load correct syscall table for s390 and s390x
Date: Sat, 1 Feb 2014 10:29:47 -0500
Message-ID: <20140201152947.GA6667@redhat.com>
References: <1391249524-5384-1-git-send-email-dan@danny.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1391249524-5384-1-git-send-email-dan@danny.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Dan =?iso-8859-1?Q?Hor=E1k?= <dan@danny.cz>
Cc: trinity@vger.kernel.org

On Sat, Feb 01, 2014 at 11:12:04AM +0100, Dan Hor=E1k wrote:
 > The actual syscall table for s390/s390x must be loaded depending on
 > the __s390x__ symbol.
 >=20

thanks, applied and pushed out.

	Dave
