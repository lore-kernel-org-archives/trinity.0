From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/2] Add an IGNORE_ENOSYS flag and use it
Date: Tue, 27 May 2014 01:02:44 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1405270057180.1362@vincent-weaver-1.umelst.maine.edu>
References: <1401107522-21239-1-git-send-email-mpe@ellerman.id.au> <20140527004138.GA7911@redhat.com> <1401152719.9871.1.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=WkfDnQWAko6/JEiNLwRvCfHb5kDI6MfxlGYfiBEpj9U=;
        b=RTlnAyBBNtTV9X/+iz8UR+Nbr0pXQQNMBs6fkXmp0vtej81zNGDFwEPs8e7Rdrgyo0
         tbDRUGPEl8Okc++scAJNpe4akGhgWNEu493aGgTD9VpiBqCokNL4OfUUw1dbKKYMnXfW
         T+ASWaygwKewzlcPATt4kU9wteTKBybxZGxDU=
In-Reply-To: <1401152719.9871.1.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Tue, 27 May 2014, Michael Ellerman wrote:

> On Mon, 2014-05-26 at 20:41 -0400, Dave Jones wrote:
> > On Mon, May 26, 2014 at 10:32:01PM +1000, Michael Ellerman wrote:
> >  > Some syscalls return ENOSYS depending on their arguments. We don't want
> >  > to stop calling them just because we hit one of those cases. Add a flag
> >  > to specify this behaviour so we don't have to keep special-casing those
> >  > calls in mkcall().
> > 
> > I was hopeful this list wouldn't grow, but that doesn't seem to be
> > the case.  Begrudgingly, I applied this.  It's going to be a lot
> > cleaner to maintain if people keep doing this.
> 
> Yeah it's annoying for sure, maybe perf will be the last one, but at least
> there's a clean way to handle it if not.

As the author of the man page that you probably got the perf ENOSYS info 
from, I have to put out there that perf_event_open() has really 
inconsistent and confusing error return values, and they vary among the 
various architectures.

I'd hope other syscalls do better, but it's really easy to slip in weird 
return values in unexpected places.  I somewhat try to follow the 
perf_event ABI and watch for stuff like this (if only to keep the manpage 
up to date) but I missed the ENOSYS commit at the time (especially since
it's not possible to trigger on x86 where I do most of my testing).

Vince
