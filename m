From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] Fixes weired looping in child_random_syscalls function.
Date: Thu, 3 Oct 2013 13:12:19 -0700
Message-ID: <CAEGbLttXGU-G9e9XCoZwoTCfPJTTyGei688Dd51ZG25CxWHx5Q@mail.gmail.com>
References: <alpine.DEB.2.02.1310021641240.24433@ildarm-linux.kir.corp.google.com>
	<20131003183349.GA13162@redhat.com>
	<CAEGbLtvYzMHJvEw+BnPj3449ZuNuyxYe3V=5e3VyMpjDwFW47w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=J+Yjh4JL4a+HtgeeA+x26XrOTPz1vtnvy3NFxVItG+Y=;
        b=YWC++gYI90ADhAlsm4xafOipRNE9etLRKtHQcEwLO1rBlBD7gk/96mw3R0un6xBgk+
         kphtOrw1t7bHY93wSBE2gzj/O3xU2WcnojvwHCGiT/H0toEsmMBINRB4J/lsQXzcfynw
         jqgf3Gb4S3QfCZhXy3K7R0DLtwOyVR2DHOLa64htfdPx0yuPApC37yEHgbotPHttU25c
         0jfNWnvKXHt3sGthLcNJ9V2TnCTHYnwX1FCXx4AI2T63h/EnLi2qejnBqGVocpohgLEm
         9JudLhj3JEnkdcgSwwu38WzBp6svUIuqDnIkYPVwnwEBsfLkDqmleskzPCKFxoqe45hG
         KQBw==
In-Reply-To: <CAEGbLtvYzMHJvEw+BnPj3449ZuNuyxYe3V=5e3VyMpjDwFW47w@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

I think I found the problem, seems to work now. Will keep it running
for 10-20 min to confirm.

On Thu, Oct 3, 2013 at 11:44 AM, Ildar Muslukhov <ildarm@google.com> wrote:
> Will take a look into it.
>
> On Thu, Oct 3, 2013 at 11:33 AM, Dave Jones <davej@redhat.com> wrote:
>> On Wed, Oct 02, 2013 at 04:46:41PM -0700, Ildar Muslukhov wrote:
>>  >
>>  > This patch removes makes the loop in child_random_syscalls aware of which
>>  > system calls are enabled, thus, avoiding unnecessary looping.
>>  >
>>  > Signed-off-by: Ildar Muslukhov <ildarm@google.com>
>>
>> I knew I should have tested this before merging it..
>>
>> This seems all kinds of broken:
>>
>> $ ./trinity -l off -q
>> Trinity v1.3pre  Dave Jones <davej@redhat.com>
>> Done parsing arguments.
>> Marking all syscalls as enabled.
>> [init] 32-bit syscalls: 351 enabled, 0 disabled.  64-bit syscalls: 314 enabled, 0 disabled.
>> [init] Using pid_max = 32768
>> [init] Started watchdog process, PID is 29722
>> [watchdog] Watchdog is alive. (pid:29722)
>> [main] Main thread is alive.
>> [main] 375 sockets created based on info from socket cachefile.
>> [main] Generating file descriptors
>> [main] Added 48 filenames from /dev
>> [main] Added 28849 filenames from /proc
>> [main] Added 14258 filenames from /sys
>> [child3:29727] uselib (134) returned ENOSYS, marking as inactive.
>> [child3:29729] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
>> [child3:29729] nfsservctl (180) returned ENOSYS, marking as inactive.
>> [child3:29729] nfsservctl (180) returned ENOSYS, marking as inactive.
>> [child3:29729] ni_syscall (generic) (182) returned ENOSYS, marking as inactive.
>> [child-1:29729] ni_syscall (generic) (177) returned ENOSYS, marking as inactive.
>> [child0:29724] ni_syscall (generic) (215) returned ENOSYS, marking as inactive.
>> [child1:29725] ni_syscall (generic) (182) returned ENOSYS, marking as inactive.
>> [child2:29726] ni_syscall (generic) (177) returned ENOSYS, marking as inactive.
>> [child3:29732] ni_syscall (generic) (214) returned ENOSYS, marking as inactive.
>> [child1:29739] ni_syscall (generic) (211) returned ENOSYS, marking as inactive.
>> [child1:29739] ni_syscall (generic) (181) returned ENOSYS, marking as inactive.
>> [child1:29739] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
>> [child2:29742] ni_syscall (generic) (205) returned ENOSYS, marking as inactive.
>> [child1:29750] ni_syscall (generic) (181) returned ENOSYS, marking as inactive.
>> [child1:29752] ni_syscall (generic) (236) returned ENOSYS, marking as inactive.
>> [child1:29754] ni_syscall (generic) (181) returned ENOSYS, marking as inactive.
>> [child2:29755] ni_syscall (generic) (211) returned ENOSYS, marking as inactive.
>> [child2:29755] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
>> [child1:29756] ni_syscall (generic) (185) returned ENOSYS, marking as inactive.
>> [child3:29757] ni_syscall (generic) (215) returned ENOSYS, marking as inactive.
>> [child1:29758] BUG!: CHILD (pid:29758) GOT REPARENTED! parent pid:29723. Watchdog pid:29722
>> [child1:29758] BUG!: Last syscalls:
>> [child1:29758] [0]  pid:29733 call:fcntl callno:5
>> [child1:29758] [1]  pid:29758 call:timer_create callno:9
>> [child1:29758] [2]  pid:29755 call:fchownat callno:24
>> [child1:29758] [3]  pid:29757 call:fchdir callno:10
>> [child-1:29757] child exiting.
>>
>>
>> 1. "child-1" looks suspect
>> 2. There's a lot more ni_syscall's there than there should be.
>> 3. The reparent thing.
>>    Running with -D shows lots of segv's.
>>
>>
>>         Dave
>>
>> `
