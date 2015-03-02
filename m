From: Dave Jones <davej@codemonkey.org.uk>
Subject: Trinity v1.5 released.
Date: Mon, 2 Mar 2015 11:15:28 -0500
Message-ID: <20150302161528.GA27824@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

It's been almost a year, and development has slowed down enough that I felt
the need to draw a line under the last batch of work that went into trinity.

v1.5 is tagged in git, and tarballs available as usual at
http://www.codemonkey.org.uk/projects/trinity/

Going forward, I don't expect to have as much time & energy to put into
trinity as I did in the past, so a lot of the stuff in the TODO isn't
going to happen any time soon.  I'll still be merging patches and trying
to commit at least basic fuzzing for any new syscalls, but feature development
on my part is pretty much stopped for the foreseeable future while I work
on other stuff.

The good news is that judging by the amount of stuff Sasha finds with
it on linux-next, it's more than capable already of finding a lot
of bugs without needing any new ways to break things. I expect that
to remain true for a while.

Bigger changes since v1.4:
- Fix for premature exiting on fork() failure.
- Tile architecture support
- Fix syscall offset for MIPS & IA64
- New syscall support up to 3.19 kernel.
- perf_event_open() can now create system-wide events
- Correctly ignore ENOSYS from perf_event_open, msgrcv and sys_ipc
- When trinity detects the kernel got tainted, it now syslogs the last seed.
- Trinity no longer spews 'reseeding' messages constantly.
- Locking/scalability improvements.
- Reworked logging code to separate rendering & output.
- Logfiles now only fsync'd when a child process has dirtied them.
- Post-mortem dump when tainting detected. Useful when logging disabled.
- Handle SIGBUS in children correctly.
- Many simplifications and fixes to page dirtying code.
- Various tuned-randomness improvements.
- File descriptor generators for more fd types added.
  Now supports: epoll, eventfd, sysfs/procfs files, memfd, perf, pipes, sockets, regular files, timerfd.
- Assorted code cleanups that should have no user-visible effect.
