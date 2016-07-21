From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: cleanup_net()/net_mutex hung tasks + kobject release debugging
Date: Thu, 21 Jul 2016 14:43:34 +0200
Message-ID: <5790C376.2010206@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Jones <davej@codemonkey.org.uk>, trinity@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Russell King <rmk+kernel@arm.linux.org.uk>

Hi Dave + list,

I've started doing some trinity fuzzing and I'm seeing quite a few hung
tasks ("blocked for more than 120 seconds").

It started with unshare()/net_mutex which I found a few others running
into as well:

http://www.spinics.net/lists/trinity/msg00724.html
http://www.spinics.net/lists/netdev/msg192073.html
https://lkml.org/lkml/2014/10/20/538

The rules for net_mutex are very simple, it's used in very few places so
I don't see how the locking could get messed up there. I'll buy your
theory that the lock is held for a long time if there are a lot of
namespaces to iterate over. I decided to time it myself and it seems
that cleanup_net() can hold the mutex for 30-40 seconds at a time, which
is surely wrong.

However, I also noticed that cleanup_net() was always preceded by a lot
of kobject_release messages, like this:

kobject: 'rx-0' (ffff881ac6277460): kobject_release, parent 
ffff881ac6272e08 (delayed 3000)
kobject: 'tx-0' (ffff881ba9951ff8): kobject_release, parent 
ffff881ac6272e08 (delayed 2000)
kobject: 'rx-0' (ffff881baed9b650): kobject_release, parent 
ffff881ba91429a8 (delayed 1000)
kobject: 'tx-0' (ffff881ba88262e8): kobject_release, parent 
ffff881ba91429a8 (delayed 4000)
kobject: 'rx-0' (ffff8819361c28c0): kobject_release, parent 
ffff881b124376c8 (delayed 4000)
kobject: 'tx-0' (ffff881a5fcc8018): kobject_release, parent 
ffff881b124376c8 (delayed 1000)
kobject: 'queues' (ffff881ac6272e08): kobject_release, parent 
(null) (delayed 3000)
kobject: 'lo' (ffff881b12762960): kobject_release, parent 
(null) (delayed 1000)
kobject: 'queues' (ffff881ba91429a8): kobject_release, parent 
(null) (delayed 1000)
kobject: 'queues' (ffff881b124376c8): kobject_release, parent 
(null) (delayed 4000)
kobject: 'lo' (ffff881baeec32a0): kobject_release, parent 
(null) (delayed 3000)
kobject: 'lo' (ffff881a8749e080): kobject_release, parent 
(null) (delayed 1000)
kobject: 'cgroup' (ffff881ac6270b08): kobject_release, parent 
(null) (delayed 3000)
kobject: 'topology_server' (ffff881baf5ac540): kobject_release, parent 
          (null) (delayed 200
0)
kobject: 'cgroup' (ffff881ba91420e8): kobject_release, parent 
(null) (delayed 1000)
kobject: 'topology_server' (ffff881baf5ac800): kobject_release, parent 
          (null) (delayed 400
0)
kobject: 'cgroup' (ffff881ac61429a8): kobject_release, parent 
(null) (delayed 3000)
kobject: 'topology_server' (ffff881baf5abfc0): kobject_release, parent 
          (null) (delayed 200
0)
@@@ cleanup_net took 32574 jiffes

so on a hunch I disabled DEBUG_KOBJECT_RELEASE, and that does indeed
solve the problem -- cleanup_net() still holds the mutex for fairly
long, but only up to max ~5 seconds at a time as opposed to 30-40.

It looks to me like the kobject release debugging is causing
cleanup_net() to have a lot more work to do whenever it gets called
and that's why it's taking longer.

There's maybe a case for cleanup_net() to release the mutex every now
and again during cleanup, but I was also seeing a few other hung tasks
unrelated to net_mutex when I disabled the unshare() system call in
trinity, which makes me wonder if we need a more general solution.

Maybe we can limit the number of workqueue items that kobject_release()
can delay, i.e. if there are more than, say, 100 pending delayed works
then we start processing the first ones queued immediately?

Or maybe trinity should just check whether DEBUG_KOBJECT_RELEASE is set
in /proc/config and throw a warning if that's the case?

(Added some more Ccs for good measure.)


Vegard
