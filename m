From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Wed, 14 May 2014 17:26:29 +1000
Message-ID: <1400052389.8826.1.camel@concordia>
References: <20140512174332.GA3345@redhat.com>
	 <1399963428.2395.2.camel@concordia> <20140513140006.GA32674@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140513140006.GA32674@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Tue, 2014-05-13 at 10:00 -0400, Dave Jones wrote:
> On Tue, May 13, 2014 at 04:43:48PM +1000, Michael Ellerman wrote:
> 
>  > I'm consistently ending up with a watchdog that is spinning using 100% cpu.
>  > 
>  > We are bailing out of __check_main() before clearing shm->mainpid because we
>  > see that we are already exiting.
>  > 
>  >         if (ret == -1) {
>  >                 /* Are we already exiting ? */
>  >                 if (shm->exit_reason != STILL_RUNNING)
>  >                         return FALSE;
>  > 
>  >                 /* No. Check what happened. */
>  >                 if (errno == ESRCH) {
>  > 
>  > 
>  > 161			if (shm->exit_reason != STILL_RUNNING)
>  > (gdb) print shm->exit_reason
>  > $6 = EXIT_FORK_FAILURE
>  > 
>  > It looks like the only other place shm->mainpid is written is in
>  > trinity.c:main(), which is dead. So we are stuck forever as far as I can tell.
>  
> Argh. I hit this exactly once a few weeks back, and thought I had fixed it.
> 
>  > The last thing in trinity.log is:
>  > 
>  > [main] couldn't create child! (Cannot allocate memory)
>  > 
>  > >From main.c:69:
>  > 
>  > 	output(0, "couldn't create child! (%s)\n", strerror(errn    o));
>  > 	shm->exit_reason = EXIT_FORK_FAILURE;
>  > 	exit(EXIT_FAILURE);
>  > 
>  > 
>  > So we exited directly and didn't let the code in main() clear shm->mainpid.
>  > 
>  > Not sure what the correct fix is.
> 
> I think just clearing mainpid before we call exit is the right thing to
> do here.  I'll audit all the other exit() calls too, as this might be a
> problem in other paths.

Thanks. That fix is working for me.

It still exits after a minute or so, because it fails to fork a child in
fork_children().

I have 64 cpus and 16GB of RAM, so that's only 250MB per child.

If I reduce to 32 children then it runs much longer.

I wonder though, should failing to fork a child be a fatal error? Or could it
just skip that child and continue.

cheers

