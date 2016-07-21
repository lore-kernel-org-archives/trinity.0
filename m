From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: cleanup_net()/net_mutex hung tasks + kobject release debugging
Date: Thu, 21 Jul 2016 09:13:46 -0400
Message-ID: <20160721131346.GA1705@codemonkey.org.uk>
References: <5790C376.2010206@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5790C376.2010206@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Russell King <rmk+kernel@arm.linux.org.uk>

On Thu, Jul 21, 2016 at 02:43:34PM +0200, Vegard Nossum wrote:

 > The rules for net_mutex are very simple, it's used in very few places so
 > I don't see how the locking could get messed up there. I'll buy your
 > theory that the lock is held for a long time if there are a lot of
 > namespaces to iterate over. I decided to time it myself and it seems
 > that cleanup_net() can hold the mutex for 30-40 seconds at a time, which
 > is surely wrong.

 > so on a hunch I disabled DEBUG_KOBJECT_RELEASE, and that does indeed
 > solve the problem -- cleanup_net() still holds the mutex for fairly
 > long, but only up to max ~5 seconds at a time as opposed to 30-40.

Yeah, I never ran with that option enabled (it used to cause my testbox
to not boot, and I never got around to debugging why). I thought five seconds
was painful enough. I guess we have different thresholds for acceptable
behaviour here :-)

Could be one of the other debug options I had enabled exacerbates the
cleanup_net problem in a similar way though.

 > There's maybe a case for cleanup_net() to release the mutex every now
 > and again during cleanup, but I was also seeing a few other hung tasks
 > unrelated to net_mutex when I disabled the unshare() system call in
 > trinity, which makes me wonder if we need a more general solution.

Not sure. We may have to just look at these on a case by case basis.

	Dave
