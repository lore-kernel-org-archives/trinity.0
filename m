From: Dave Jones <davej@redhat.com>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Tue, 13 May 2014 10:00:06 -0400
Message-ID: <20140513140006.GA32674@redhat.com>
References: <20140512174332.GA3345@redhat.com>
 <1399963428.2395.2.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1399963428.2395.2.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Tue, May 13, 2014 at 04:43:48PM +1000, Michael Ellerman wrote:

 > I'm consistently ending up with a watchdog that is spinning using 100% cpu.
 > 
 > We are bailing out of __check_main() before clearing shm->mainpid because we
 > see that we are already exiting.
 > 
 >         if (ret == -1) {
 >                 /* Are we already exiting ? */
 >                 if (shm->exit_reason != STILL_RUNNING)
 >                         return FALSE;
 > 
 >                 /* No. Check what happened. */
 >                 if (errno == ESRCH) {
 > 
 > 
 > 161			if (shm->exit_reason != STILL_RUNNING)
 > (gdb) print shm->exit_reason
 > $6 = EXIT_FORK_FAILURE
 > 
 > It looks like the only other place shm->mainpid is written is in
 > trinity.c:main(), which is dead. So we are stuck forever as far as I can tell.
 
Argh. I hit this exactly once a few weeks back, and thought I had fixed it.

 > The last thing in trinity.log is:
 > 
 > [main] couldn't create child! (Cannot allocate memory)
 > 
 > >From main.c:69:
 > 
 > 	output(0, "couldn't create child! (%s)\n", strerror(errn    o));
 > 	shm->exit_reason = EXIT_FORK_FAILURE;
 > 	exit(EXIT_FAILURE);
 > 
 > 
 > So we exited directly and didn't let the code in main() clear shm->mainpid.
 > 
 > Not sure what the correct fix is.

I think just clearing mainpid before we call exit is the right thing to
do here.  I'll audit all the other exit() calls too, as this might be a
problem in other paths.

 > We could drop the check of shm->exit_reason
 > in __check_main(), but presumably that is there for a good reason.

It's mostly cosmetic. It would previously end up in that path on a
successful exit, and then complain that main had "disappeared".

	Dave
