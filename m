From: Dave Jones <davej@redhat.com>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Wed, 21 May 2014 23:50:45 -0400
Message-ID: <20140522035045.GB21777@redhat.com>
References: <20140512174332.GA3345@redhat.com>
 <1399963428.2395.2.camel@concordia>
 <20140513140006.GA32674@redhat.com>
 <1400052389.8826.1.camel@concordia>
 <20140514133522.GA10167@redhat.com>
 <1400726436.14864.4.camel@concordia>
 <1400730073.14864.5.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400730073.14864.5.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <michael@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Thu, May 22, 2014 at 01:41:13PM +1000, Michael Ellerman wrote:
 
 > [main] Registered 6 fd providers.
 > [main] Couldn't find socket cachefile. Regenerating.
 > [main] created 375 sockets
 > [main] Generating file descriptors
 > [main] Added 276 filenames from /dev
 > [main] Something went wrong during nftw(/proc). (-1:Value too large for defined data type)

that's curious, but probably not fatal.

 > [child6:56655] ipc (117) returned ENOSYS, marking as inactive.
 > [child11:56660] BUG!: CHILD (pid:56660) GOT REPARENTED! parent pid:47159. Watchdog pid:47158

This is usually indicative of the main pid segfaulting.
If you run with -D, you'll get coredumps (though also of the child
processes, so there's going to be a lot of them if it runs enough)
You should able to find the one that corresponds to the main pid though,
and get a backtrace.

 > I/O possible

Also weird.

I'll dig into it some more tomorrow if you don't beat me to it.

As a last resort, you might be able to bisect between todays changes
(I'd say start at c19c0ef3973bf816025a2aef5ae5dbd00ca5c9eb).
There's only one bad commit in that range, which is
4401f6d0f0bfdeb92595520dc3be23dee32efc77.  If the bisect lands on that,
do git show 4401f6d0f0bfdeb92595520dc3be23dee32efc77| patch -p1 on top of it.

	Dave
