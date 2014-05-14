From: Dave Jones <davej@redhat.com>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Wed, 14 May 2014 09:35:22 -0400
Message-ID: <20140514133522.GA10167@redhat.com>
References: <20140512174332.GA3345@redhat.com>
 <1399963428.2395.2.camel@concordia>
 <20140513140006.GA32674@redhat.com>
 <1400052389.8826.1.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400052389.8826.1.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Wed, May 14, 2014 at 05:26:29PM +1000, Michael Ellerman wrote:

 > >  > Not sure what the correct fix is.
 > > 
 > > I think just clearing mainpid before we call exit is the right thing to
 > > do here.  I'll audit all the other exit() calls too, as this might be a
 > > problem in other paths.
 > 
 > Thanks. That fix is working for me.
 > 
 > It still exits after a minute or so, because it fails to fork a child in
 > fork_children().
 > 
 > I have 64 cpus and 16GB of RAM, so that's only 250MB per child.
 > 
 > If I reduce to 32 children then it runs much longer.
 > 
 > I wonder though, should failing to fork a child be a fatal error? Or could it
 > just skip that child and continue.

Maybe.  It could wait until another child exits before retrying.
Something like the patch below maybe.  I think I tried something like
this before though, and it resulted in a flood of failed forks.

Let me know how this work out.

	Dave

diff --git a/main.c b/main.c
index f393f81ae0ba..be7108287dc9 100644
--- a/main.c
+++ b/main.c
@@ -79,6 +79,10 @@ static void fork_children(void)
 			_exit(EXIT_SUCCESS);
 		} else {
 			if (pid == -1) {
+				/* We failed, wait for a child to exit before retrying. */
+				if (shm->running_childs > 0)
+					return;
+
 				output(0, "couldn't create child! (%s)\n", strerror(errno));
 				shm->exit_reason = EXIT_FORK_FAILURE;
 				exit_main_fail();
