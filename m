From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 1/5] Makefile: use grep -c to avoid wc -l
Date: Tue, 7 Feb 2017 09:14:48 -0500
Message-ID: <20170207141448.qw3sg6udt6rhllv3@codemonkey.org.uk>
References: <20170205155352.13191-1-tt.rantala@gmail.com>
 <877f52b9ja.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f52b9ja.fsf@concordia.ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Tommi Rantala <tt.rantala@gmail.com>, trinity@vger.kernel.org

On Tue, Feb 07, 2017 at 09:05:45PM +1100, Michael Ellerman wrote:
 > Tommi Rantala <tt.rantala@gmail.com> writes:
 > 
 > > ---
 > >  Makefile | 2 +-
 > >  1 file changed, 1 insertion(+), 1 deletion(-)
 > >
 > > diff --git a/Makefile b/Makefile
 > > index b93fc3a..16fafe8 100644
 > > --- a/Makefile
 > > +++ b/Makefile
 > > @@ -2,7 +2,7 @@ VERSION="1.8pre"
 > >  
 > >  INSTALL_PREFIX ?= $(DESTDIR)
 > >  INSTALL_PREFIX ?= $(HOME)
 > > -NR_CPUS := $(shell grep ^processor /proc/cpuinfo | /usr/bin/wc -l)
 > > +NR_CPUS := $(shell grep -c ^processor /proc/cpuinfo)
 > 
 > Or you could just use nproc(1) ?

Is that in ancient coreutils from crusty old enterprise distros ?
Judging by user reports, I think we need to support back as far as
RHEL6 for now.

 > It's in coreutils, but maybe that's not sufficiently portable?

Portability to non-Linux OS's hasn't been a concern so far. 
I had 1-2 people email me about BSD support but the patches they've sent
have been about 1% of the work actually necessary so I've just rejected
them.

It's way easier to just extend iknowthis (or possibly syzkaller)
than to retrofit it into Trinity at this point.

I admit to having a morbid curiousity to know just how well the various
BSD's would hold up under a targetted fuzzing run, but the likelyhood of
me finding time to work on it, or even support it, is practically nil.

	Dave

