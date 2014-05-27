From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/2] Add an IGNORE_ENOSYS flag and use it
Date: Tue, 27 May 2014 11:05:19 +1000
Message-ID: <1401152719.9871.1.camel@concordia>
References: <1401107522-21239-1-git-send-email-mpe@ellerman.id.au>
	 <20140527004138.GA7911@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140527004138.GA7911@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Mon, 2014-05-26 at 20:41 -0400, Dave Jones wrote:
> On Mon, May 26, 2014 at 10:32:01PM +1000, Michael Ellerman wrote:
>  > Some syscalls return ENOSYS depending on their arguments. We don't want
>  > to stop calling them just because we hit one of those cases. Add a flag
>  > to specify this behaviour so we don't have to keep special-casing those
>  > calls in mkcall().
> 
> I was hopeful this list wouldn't grow, but that doesn't seem to be
> the case.  Begrudgingly, I applied this.  It's going to be a lot
> cleaner to maintain if people keep doing this.

Yeah it's annoying for sure, maybe perf will be the last one, but at least
there's a clean way to handle it if not.

cheers

