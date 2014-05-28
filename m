From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/2] Add an IGNORE_ENOSYS flag and use it
Date: Wed, 28 May 2014 11:38:36 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1405281134320.6109@vincent-weaver-1.umelst.maine.edu>
References: <1401107522-21239-1-git-send-email-mpe@ellerman.id.au> <20140527004138.GA7911@redhat.com> <1401152719.9871.1.camel@concordia> <alpine.DEB.2.10.1405270057180.1362@vincent-weaver-1.umelst.maine.edu> <1401247674.5468.2.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=lcKmQq/6H4yIeCA4T+Qk/oQyhzlFfMuvlUTyEGfcBFE=;
        b=DiK9IAVUGXoi7WAKqcuR6RZgrlKyfrYAwDf29cOZquONol4dEH1w498cyXcGa3mZ/S
         k2AG7XZsikkQP2nw1/Ek5JeDwU+sGRIjGPXGpLPPUVoSMjD4LCS45TM3V/+HAjiQH9lA
         0L9rJMiyqPIR0+B6OMuQWhSIiobBYasMMNtQo=
In-Reply-To: <1401247674.5468.2.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Wed, 28 May 2014, Michael Ellerman wrote:

> On Tue, 2014-05-27 at 01:02 -0400, Vince Weaver wrote:
> > On Tue, 27 May 2014, Michael Ellerman wrote:
> > 
> > > On Mon, 2014-05-26 at 20:41 -0400, Dave Jones wrote:
> > > > On Mon, May 26, 2014 at 10:32:01PM +1000, Michael Ellerman wrote:
> > > >  > Some syscalls return ENOSYS depending on their arguments. We don't want
> > > >  > to stop calling them just because we hit one of those cases. Add a flag
> > > >  > to specify this behaviour so we don't have to keep special-casing those
> > > >  > calls in mkcall().
> > > > 
> > > > I was hopeful this list wouldn't grow, but that doesn't seem to be
> > > > the case.  Begrudgingly, I applied this.  It's going to be a lot
> > > > cleaner to maintain if people keep doing this.
> > > 
> > > Yeah it's annoying for sure, maybe perf will be the last one, but at least
> > > there's a clean way to handle it if not.
> > 
> > As the author of the man page that you probably got the perf ENOSYS info 
> > from, I have to put out there that perf_event_open() has really 
> > inconsistent and confusing error return values, and they vary among the 
> > various architectures.
> 
> Actually I didn't read the man page, but thanks for reminding me that it
> exists. And yes I am aware of your dislike of the perf interface.

I had just recently contributed an improved "ERRORS" section to the 
perf_event_open manpage that tries to be complete, but I'm sure I missed 
some corner cases.  It does document the odd choice of returning ENOSYS in 
the PERF_SAMPLE_STACK_USER case.

It's a shame there isn't some sort of automated tool that could spit out 
all possible system call return values, it would make it a lot easier to 
keep things consistent.

Vince
