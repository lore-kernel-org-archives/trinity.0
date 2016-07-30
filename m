From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: cleanup_net()/net_mutex hung tasks + kobject release debugging
Date: Sat, 30 Jul 2016 07:58:55 -0500
Message-ID: <87fuqrcmeo.fsf@x220.int.ebiederm.org>
References: <5790C376.2010206@oracle.com>
	<20160721131346.GA1705@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160721131346.GA1705@codemonkey.org.uk> (Dave Jones's message
	of "Thu, 21 Jul 2016 09:13:46 -0400")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Vegard Nossum <vegard.nossum@oracle.com>, trinity@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Russell King <rmk+kernel@arm.linux.org.uk>

Dave Jones <davej@codemonkey.org.uk> writes:

> On Thu, Jul 21, 2016 at 02:43:34PM +0200, Vegard Nossum wrote:
>
>  > The rules for net_mutex are very simple, it's used in very few places so
>  > I don't see how the locking could get messed up there. I'll buy your
>  > theory that the lock is held for a long time if there are a lot of
>  > namespaces to iterate over. I decided to time it myself and it seems
>  > that cleanup_net() can hold the mutex for 30-40 seconds at a time, which
>  > is surely wrong.
>
>  > so on a hunch I disabled DEBUG_KOBJECT_RELEASE, and that does indeed
>  > solve the problem -- cleanup_net() still holds the mutex for fairly
>  > long, but only up to max ~5 seconds at a time as opposed to 30-40.
>
> Yeah, I never ran with that option enabled (it used to cause my testbox
> to not boot, and I never got around to debugging why). I thought five seconds
> was painful enough. I guess we have different thresholds for acceptable
> behaviour here :-)
>
> Could be one of the other debug options I had enabled exacerbates the
> cleanup_net problem in a similar way though.
>
>  > There's maybe a case for cleanup_net() to release the mutex every now
>  > and again during cleanup, but I was also seeing a few other hung tasks
>  > unrelated to net_mutex when I disabled the unshare() system call in
>  > trinity, which makes me wonder if we need a more general solution.
>
> Not sure. We may have to just look at these on a case by case basis.

The best you can easily do in cleanup_net with net_mutex is to reduce
the number of net namespaces you free at once.  Which sounds attractive
except that last I looked most of the time was spent in syncrhonize_rcu.

Because the namespaces can share those synchronize_rcu calls cleaning up
a bunch of network namespaces all at once is actually a pretty big
optimization in terms of system performance.

Though if someone wants to dig in and point out non-shared
synchronize_rcu calls or other obvious sillies happening in cleanup_net
I will be happy to see what we can do.

Eric
