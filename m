From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Thu, 22 May 2014 12:40:36 +1000
Message-ID: <1400726436.14864.4.camel@concordia>
References: <20140512174332.GA3345@redhat.com>
	 <1399963428.2395.2.camel@concordia> <20140513140006.GA32674@redhat.com>
	 <1400052389.8826.1.camel@concordia> <20140514133522.GA10167@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140514133522.GA10167@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, 2014-05-14 at 09:35 -0400, Dave Jones wrote:
> On Wed, May 14, 2014 at 05:26:29PM +1000, Michael Ellerman wrote:
> 
>  > >  > Not sure what the correct fix is.
>  > > 
>  > > I think just clearing mainpid before we call exit is the right thing to
>  > > do here.  I'll audit all the other exit() calls too, as this might be a
>  > > problem in other paths.
>  > 
>  > Thanks. That fix is working for me.
>  > 
>  > It still exits after a minute or so, because it fails to fork a child in
>  > fork_children().
>  > 
>  > I have 64 cpus and 16GB of RAM, so that's only 250MB per child.
>  > 
>  > If I reduce to 32 children then it runs much longer.
>  > 
>  > I wonder though, should failing to fork a child be a fatal error? Or could it
>  > just skip that child and continue.
> 
> Maybe.  It could wait until another child exits before retrying.
> Something like the patch below maybe.  I think I tried something like
> this before though, and it resulted in a flood of failed forks.
> 
> Let me know how this work out.

Sorry I didn't get back to you on this. I've been chasing a bug that trinity
found for us.

Running aae6d6a I've seen this once, but only once:

[watchdog] Sanity check failed! Found pid 1885550132!
[watchdog] problem checking on pid 112 (1:Operation not permitted)
[watchdog] pid 1885550132 has disappeared (oom-killed maybe?). Reaping.
[watchdog] pid 678326126 has disappeared (oom-killed maybe?). Reaping.
[watchdog] pid 1697185792 has disappeared (oom-killed maybe?). Reaping.
[watchdog] Reaped 3 dead children
Killed

cheers

