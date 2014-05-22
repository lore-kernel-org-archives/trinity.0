From: Dave Jones <davej@redhat.com>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Wed, 21 May 2014 23:40:56 -0400
Message-ID: <20140522034056.GA21777@redhat.com>
References: <20140512174332.GA3345@redhat.com>
 <1399963428.2395.2.camel@concordia>
 <20140513140006.GA32674@redhat.com>
 <1400052389.8826.1.camel@concordia>
 <20140514133522.GA10167@redhat.com>
 <1400726436.14864.4.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400726436.14864.4.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Thu, May 22, 2014 at 12:40:36PM +1000, Michael Ellerman wrote:
 
 > Sorry I didn't get back to you on this. I've been chasing a bug that trinity
 > found for us.
 > 
 > Running aae6d6a I've seen this once, but only once:
 > 
 > [watchdog] Sanity check failed! Found pid 1885550132!
 > [watchdog] problem checking on pid 112 (1:Operation not permitted)
 > [watchdog] pid 1885550132 has disappeared (oom-killed maybe?). Reaping.
 > [watchdog] pid 678326126 has disappeared (oom-killed maybe?). Reaping.
 > [watchdog] pid 1697185792 has disappeared (oom-killed maybe?). Reaping.
 > [watchdog] Reaped 3 dead children
 > Killed

If it happens again, check /proc/sys/kernel/pid_max.
I wonder if something scribbled in there.
(We only read it on startup, so if it changes under us, and we start
 getting pids out of our expected range, that could go awry).

I'll add some more robustness to that check tomorrow.

Though looking at the pids in the dump above, I wonder if there's
something more screwed up, like we corrupted the ptrs to the pid map
in the shm.

	Dave
