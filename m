From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fixes weired looping in child_random_syscalls function.
Date: Thu, 3 Oct 2013 14:33:49 -0400
Message-ID: <20131003183349.GA13162@redhat.com>
References: <alpine.DEB.2.02.1310021641240.24433@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310021641240.24433@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 02, 2013 at 04:46:41PM -0700, Ildar Muslukhov wrote:
 > 
 > This patch removes makes the loop in child_random_syscalls aware of which 
 > system calls are enabled, thus, avoiding unnecessary looping.
 > 
 > Signed-off-by: Ildar Muslukhov <ildarm@google.com>

I knew I should have tested this before merging it..

This seems all kinds of broken:

$ ./trinity -l off -q
Trinity v1.3pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
Marking all syscalls as enabled.
[init] 32-bit syscalls: 351 enabled, 0 disabled.  64-bit syscalls: 314 enabled, 0 disabled.
[init] Using pid_max = 32768
[init] Started watchdog process, PID is 29722
[watchdog] Watchdog is alive. (pid:29722)
[main] Main thread is alive.
[main] 375 sockets created based on info from socket cachefile.
[main] Generating file descriptors
[main] Added 48 filenames from /dev
[main] Added 28849 filenames from /proc
[main] Added 14258 filenames from /sys
[child3:29727] uselib (134) returned ENOSYS, marking as inactive.
[child3:29729] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
[child3:29729] nfsservctl (180) returned ENOSYS, marking as inactive.
[child3:29729] nfsservctl (180) returned ENOSYS, marking as inactive.
[child3:29729] ni_syscall (generic) (182) returned ENOSYS, marking as inactive.
[child-1:29729] ni_syscall (generic) (177) returned ENOSYS, marking as inactive.
[child0:29724] ni_syscall (generic) (215) returned ENOSYS, marking as inactive.
[child1:29725] ni_syscall (generic) (182) returned ENOSYS, marking as inactive.
[child2:29726] ni_syscall (generic) (177) returned ENOSYS, marking as inactive.
[child3:29732] ni_syscall (generic) (214) returned ENOSYS, marking as inactive.
[child1:29739] ni_syscall (generic) (211) returned ENOSYS, marking as inactive.
[child1:29739] ni_syscall (generic) (181) returned ENOSYS, marking as inactive.
[child1:29739] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
[child2:29742] ni_syscall (generic) (205) returned ENOSYS, marking as inactive.
[child1:29750] ni_syscall (generic) (181) returned ENOSYS, marking as inactive.
[child1:29752] ni_syscall (generic) (236) returned ENOSYS, marking as inactive.
[child1:29754] ni_syscall (generic) (181) returned ENOSYS, marking as inactive.
[child2:29755] ni_syscall (generic) (211) returned ENOSYS, marking as inactive.
[child2:29755] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
[child1:29756] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
[child3:29757] ni_syscall (generic) (215) returned ENOSYS, marking as inactive.
[child1:29758] BUG!: CHILD (pid:29758) GOT REPARENTED! parent pid:29723. Watchdog pid:29722
[child1:29758] BUG!: Last syscalls:
[child1:29758] [0]  pid:29733 call:fcntl callno:5
[child1:29758] [1]  pid:29758 call:timer_create callno:9
[child1:29758] [2]  pid:29755 call:fchownat callno:24
[child1:29758] [3]  pid:29757 call:fchdir callno:10
[child-1:29757] child exiting.


1. "child-1" looks suspect
2. There's a lot more ni_syscall's there than there should be.
3. The reparent thing.
   Running with -D shows lots of segv's.


	Dave

`
