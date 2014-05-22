From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Thu, 22 May 2014 13:41:13 +1000
Message-ID: <1400730073.14864.5.camel@concordia>
References: <20140512174332.GA3345@redhat.com>
	 <1399963428.2395.2.camel@concordia> <20140513140006.GA32674@redhat.com>
	 <1400052389.8826.1.camel@concordia> <20140514133522.GA10167@redhat.com>
	 <1400726436.14864.4.camel@concordia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1400726436.14864.4.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Thu, 2014-05-22 at 12:40 +1000, Michael Ellerman wrote:
> On Wed, 2014-05-14 at 09:35 -0400, Dave Jones wrote:
> > On Wed, May 14, 2014 at 05:26:29PM +1000, Michael Ellerman wrote:
> > 
> >  > >  > Not sure what the correct fix is.
> >  > > 
> >  > > I think just clearing mainpid before we call exit is the right thing to
> >  > > do here.  I'll audit all the other exit() calls too, as this might be a
> >  > > problem in other paths.
> >  > 
> >  > Thanks. That fix is working for me.
> >  > 
> >  > It still exits after a minute or so, because it fails to fork a child in
> >  > fork_children().
> >  > 
> >  > I have 64 cpus and 16GB of RAM, so that's only 250MB per child.
> >  > 
> >  > If I reduce to 32 children then it runs much longer.
> >  > 
> >  > I wonder though, should failing to fork a child be a fatal error? Or could it
> >  > just skip that child and continue.
> > 
> > Maybe.  It could wait until another child exits before retrying.
> > Something like the patch below maybe.  I think I tried something like
> > this before though, and it resulted in a flood of failed forks.
> > 
> > Let me know how this work out.
> 
> Sorry I didn't get back to you on this. I've been chasing a bug that trinity
> found for us.
> 
> Running aae6d6a I've seen this once, but only once:

And this one, which looks more fun :)

$ trinity -q
Trinity v1.5pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 323 syscalls. Disabled 0 syscalls.
[init] Using pid_max = 65536
[init] Started watchdog process, PID is 47158
[main] Main thread is alive.
[main] Registered 6 fd providers.
[main] Couldn't find socket cachefile. Regenerating.
[main] created 375 sockets
[main] Generating file descriptors
[main] Added 276 filenames from /dev
[main] Something went wrong during nftw(/proc). (-1:Value too large for defined data type)
[main] Added 10283 filenames from /sys
[child30:56679] nfsservctl (168) returned ENOSYS, marking as inactive.
[child30:56679] stat (18) returned ENOSYS, marking as inactive.
[child1:56650] acct (51) returned ENOSYS, marking as inactive.
[child10:56659] quotactl (131) returned ENOSYS, marking as inactive.
[child28:56677] lstat (84) returned ENOSYS, marking as inactive.
[child15:56664] sysctl (149) returned ENOSYS, marking as inactive.
[watchdog] Watchdog is alive. (pid:47158)
[child6:56655] ipc (117) returned ENOSYS, marking as inactive.
[child11:56660] BUG!: CHILD (pid:56660) GOT REPARENTED! parent pid:47159. Watchdog pid:47158
[child11:56660] BUG!: Last syscalls:
[child11:56660] [0]  pid:56649 call:io_getevents callno:23
[child11:56660] [1]  pid:56650 call:syslog callno:23
[child11:56660] [2]  pid:56651 call:getxattr callno:78
[child11:56660] [3]  pid:56652 call:set_mempolicy callno:3
[child11:56660] [4]  pid:56653 call:getdents64 callno:12
[child11:56660] [5]  pid:56654 call:setgroups callno:8
[child11:56660] [6]  pid:56655 call:rt_sigpending callno:31
[child11:56660] [7]  pid:56656 call:mmap callno:15
[child11:56660] [8]  pid:56657 call:setxattr callno:16
[child11:56660] [9]  pid:56658 call:delete_module callno:6
[child11:56660] [10]  pid:56659 call:timer_delete callno:122
[child11:56660] [11]  pid:56660 call:clock_getres callno:279
[child11:56660] [12]  pid:56661 call:open callno:20
[child11:56660] [13]  pid:56662 call:setregid callno:176
[child11:56660] [14]  pid:56663 call:mount callno:24
[child11:56660] [15]  pid:56664 call:mkdir callno:106
[child11:56660] [16]  pid:56665 call:unshare callno:72
[child11:56660] [17]  pid:56666 call:sched_get_priority_max callno:47
[child11:56660] [18]  pid:56667 call:sched_getparam callno:158
[child11:56660] [19]  pid:56668 call:linkat callno:38
[child11:56660] [20]  pid:56669 call:utime callno:13
[child11:56660] [21]  pid:56670 call:epoll_ctl callno:12
[child11:56660] [22]  pid:56671 call:fremovexattr callno:33
[child11:56660] [23]  pid:56672 call:mincore callno:117
[child11:56660] [24]  pid:56673 call:init_module callno:136
[child11:56660] [25]  pid:56674 call:inotify_init1 callno:20
[child11:56660] [26]  pid:56675 call:ssetmask callno:45
[child11:56660] [27]  pid:56676 call:mmap callno:46
[child11:56660] [28]  pid:56677 call:access callno:115
[child11:56660] [29]  pid:56678 call:ioprio_set callno:63
[child11:56660] [30]  pid:56679 call:old_readdir callno:132
[child11:56660] [31]  pid:56680 call:gettimeofday callno:89
I/O possible
$

cheers

