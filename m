From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: test processes are not all killed
Date: Wed, 2 Aug 2017 11:09:21 +0800
Message-ID: <20170802030921.mwhtygus3oambllj@linux>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux>
 <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

On Tue, Aug 01, 2017 at 11:38:23AM -0400, Dave Jones wrote:
> On Tue, Aug 01, 2017 at 05:38:13PM +0800, Dai Xiang wrote:
>  > Hi!
>  > I use below cmds(with root permission) include trinity to test and find an interesting issue:
>  > 
>  > cmd="trinity -q -q -l off -s $seed -x get_robust_list -x remap_file_pages -N 999999999"
>  > cd /tmp
>  > chroot --userspec nobody:nogroup / $cmd 2>&1 &
>  > pid=$!
>  > sleep 300s
>  > kill -9 $pid
>  > 
>  > Then after run finish, i use pgrep and find test process do not kill
>  > while i think the test logic is right:
>  > 
>  > 5292 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
>  > 5293 trinity-watchdo
>  > 5294 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
>  > 70558 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
>  > 
>  > I do some simple tests and all processes can be killed.
>  > 
>  > Does trinity suppress kill or it run at background can not use this
>  > way to kill?
> 
> It doesn't do anything special to mask signals (unless it happened to
> call some of the signal syscalls with the right random arguments, which
> is unlikely - the sanitize routines for the signal syscalls are pretty
> dumb, or missing entirely)
> 
> More likely is you've found a kernel bug, or the processes are blocked
> on something.
> 
> Looking at /proc/<pid>/stack can sometimes give clues as to where a
> process is stuck.
> 
> Also a script like this is useful for tracing stuck pids
> 
> cd /sys/kernel/debug/tracing/
> echo $1 >> set_ftrace_pid
> echo function_graph >> current_tracer
> echo 1 >> tracing_on
> sleep 5
> echo 0 >> tracing_on
> 
> cat /sys/kernel/debug/tracing/trace
> 
> 
> Actually looking again, I see you have a trinity-watchdog process, which
> current versions don't have, so maybe try updating to 1.7, (or better, the git
> version) and seeing if it's reproducable there.  I don't even remember
> what bugs got fixed that long ago.

I use apt to install 1.7 version and still can reproduce:
root@local ~# pgrep -a trinity
30480 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30504 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30558 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30564 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30565 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30573 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30587 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
30600 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999

root@local ~# cat /proc/30504/stack
[<ffffffff8122b5ac>] wb_wait_for_completion+0x5c/0x90
[<ffffffff8122ed26>] sync_inodes_sb+0x96/0x200
[<ffffffff81235135>] sync_inodes_one_sb+0x15/0x20
[<ffffffff81204913>] iterate_supers+0xc3/0x120
[<ffffffff81235455>] sys_sync+0x35/0x90
[<ffffffff818fd39e>] tracesys_phase2+0x84/0x89
[<ffffffffffffffff>] 0xffffffffffffffff

The test script:
#!/bin/bash

cmd="trinity -q -q -l off -s $seed -x get_robust_list -x remap_file_pages -N 999999999"
chroot --userspec nobody:nogroup / $cmd 2>&1 &
pid=$!
echo $pid
sleep 300
kill -9 $pid

Run log:
23182   <===
Trinity 1.7  Dave Jones <davej@codemonkey.org.uk> <===
shm:0x7f2beff1c000-0x7f2bfc898da0 (4 pages)
[main] Marking syscall remap_file_pages (64bit:216 32bit:257) as to be disabled.
[main] Couldn't chmod tmp/ to 0777.
[main] Using user passed random seed: 0.
Marking all syscalls as enabled.
[main] Disabling syscalls marked as disabled by command line options
[main] Marked 64-bit syscall remap_file_pages (216) as deactivated.
[main] Marked 32-bit syscall remap_file_pages (257) as deactivated.
[main] 32-bit syscalls: 378 enabled, 2 disabled.  64-bit syscalls: 330 enabled, 2 disabled.
[main] Using pid_max = 32768
[main] There are 12 entries in the 0 list (@0x5586de2afe50).
[main]  start: 0x7f2befee0000 size:4KB  name: anon(PROT_READ | PROT_WRITE)
[main]  start: 0x7f2befedf000 size:4KB  name: anon(PROT_READ)
[main]  start: 0x7f2befede000 size:4KB  name: anon(PROT_WRITE)
[main]  start: 0x7f2befdde000 size:1MB  name: anon(PROT_READ | PROT_WRITE)
[main]  start: 0x7f2bee2ef000 size:1MB  name: anon(PROT_READ)
[main]  start: 0x7f2bee1ef000 size:1MB  name: anon(PROT_WRITE)
[main]  start: 0x7f2bedfef000 size:2MB  name: anon(PROT_READ | PROT_WRITE)
[main]  start: 0x7f2beddef000 size:2MB  name: anon(PROT_READ)
[main]  start: 0x7f2bedbef000 size:2MB  name: anon(PROT_WRITE)
[main]  start: 0x7f2befddd000 size:4KB  name: anon(PROT_READ | PROT_WRITE)
[main]  start: 0x7f2befddc000 size:4KB  name: anon(PROT_READ)
[main]  start: 0x7f2befddb000 size:4KB  name: anon(PROT_WRITE)
[main] Reserved/initialized 10 futexes.
[main] Added 25 filenames from /dev
[main] Added 25305 filenames from /proc
[main] Added 8175 filenames from /sys
[main] There are 8 entries in the 3 list (@0x5586de4987f0).
[main] pipefd:293
[main] pipefd:294
[main] pipefd:295
[main] pipefd:296
[main] pipefd:297
[main] pipefd:298
[main] pipefd:299
[main] pipefd:300
[main] Couldn't open socket 2:5:0. Socket type not supported
[main] Couldn't open socket 3:2:0. Address family not supported by protocol
[main] Couldn't open socket 3:3:0. Address family not supported by protocol
[main] Couldn't open socket 3:5:0. Address family not supported by protocol
[main] Couldn't open socket 3:5:1. Address family not supported by protocol
[main] Couldn't open socket 3:5:207. Address family not supported by protocol
[main] Couldn't open socket 4:2:0. Address family not supported by protocol
[main] Couldn't open socket 5:2:0. Address family not supported by protocol
[main] Couldn't open socket 5:3:0. Address family not supported by protocol
[main] Couldn't open socket 6:5:0. Address family not supported by protocol
[main] Couldn't open socket 9:5:0. Address family not supported by protocol
[main] Couldn't open socket 12:5:2. Address family not supported by protocol
[main] Couldn't open socket 12:1:2. Address family not supported by protocol
[main] Couldn't open socket 26:2:0. Address family not supported by protocol
[main] Couldn't open socket 26:1:0. Address family not supported by protocol
[main] Couldn't open socket 16:2:14. Protocol not supported
[main] Couldn't open socket 16:3:14. Protocol not supported
[main] Couldn't open socket 17:10:768. Operation not permitted
[main] Couldn't open socket 17:3:768. Operation not permitted
[main] Couldn't open socket 19:5:0. Address family not supported by protocol
[main] Couldn't open socket 21:5:0. Address family not supported by protocol
[main] Couldn't open socket 23:2:0. Address family not supported by protocol
[main] Couldn't open socket 23:2:1. Address family not supported by protocol
[main] Couldn't open socket 23:5:0. Address family not supported by protocol
[main] Couldn't open socket 23:1:0. Address family not supported by protocol
[main] Couldn't open socket 26:2:0. Address family not supported by protocol
[main] Couldn't open socket 26:1:0. Address family not supported by protocol
[main] Couldn't open socket 29:3:1. Address family not supported by protocol
[main] Couldn't open socket 29:2:2. Address family not supported by protocol
[main] Couldn't open socket 30:2:0. Address family not supported by protocol
[main] Couldn't open socket 30:5:0. Address family not supported by protocol
[main] Couldn't open socket 30:1:0. Address family not supported by protocol
[main] Couldn't open socket 31:5:0. Address family not supported by protocol
[main] Couldn't open socket 31:5:2. Address family not supported by protocol
[main] Couldn't open socket 31:1:0. Address family not supported by protocol
[main] Couldn't open socket 31:1:3. Address family not supported by protocol
[main] Couldn't open socket 31:3:0. Address family not supported by protocol
[main] Couldn't open socket 31:3:1. Address family not supported by protocol
[main] Couldn't open socket 31:3:3. Address family not supported by protocol
[main] Couldn't open socket 31:3:4. Address family not supported by protocol
[main] Couldn't open socket 31:3:5. Address family not supported by protocol
[main] Couldn't open socket 31:3:6. Address family not supported by protocol
[main] Couldn't open socket 31:3:7. Address family not supported by protocol
[main] Couldn't open socket 31:2:0. Address family not supported by protocol
[main] Couldn't open socket 33:2:2. Address family not supported by protocol
[main] Couldn't open socket 35:2:0. Address family not supported by protocol
[main] Couldn't open socket 35:5:0. Address family not supported by protocol
[main] Couldn't open socket 35:2:1. Address family not supported by protocol
[main] Couldn't open socket 35:5:2. Address family not supported by protocol
[main] Couldn't open socket 37:5:0. Address family not supported by protocol
[main] Couldn't open socket 37:5:1. Address family not supported by protocol
[main] Couldn't open socket 37:5:2. Address family not supported by protocol
[main] Couldn't open socket 37:5:3. Address family not supported by protocol
[main] Couldn't open socket 37:5:4. Address family not supported by protocol
[main] Couldn't open socket 37:5:5. Address family not supported by protocol
[main] Couldn't open socket 37:1:0. Address family not supported by protocol
[main] Couldn't open socket 37:1:1. Address family not supported by protocol
[main] Couldn't open socket 37:1:2. Address family not supported by protocol
[main] Couldn't open socket 37:1:3. Address family not supported by protocol
[main] Couldn't open socket 37:1:4. Address family not supported by protocol
[main] Couldn't open socket 37:1:5. Address family not supported by protocol
[main] Couldn't open socket 39:5:0. Address family not supported by protocol
[main] Couldn't open socket 39:3:0. Address family not supported by protocol
[main] Couldn't open socket 39:2:1. Address family not supported by protocol
[main] Couldn't open socket 39:1:1. Address family not supported by protocol
[main] Couldn't open socket 39:3:1. Address family not supported by protocol
[main] Couldn't open socket 41:10:0. Address family not supported by protocol
[main] Couldn't open socket 41:2:0. Address family not supported by protocol
[main] There are 20 entries in the 2 list (@0x5586de5e9180).
[main]  start: 0x7f2befd7e000 size:4KB  name: trinity-testfile1
[main]  start: 0x7f2befd7d000 size:4KB  name: trinity-testfile2
[main]  start: 0x7f2befd7c000 size:4KB  name: trinity-testfile3
[main]  start: 0x7f2bed400000 size:4KB  name: trinity-testfile4
[main]  start: 0x7f2befd7b000 size:4KB  name: trinity-testfile1
[main]  start: 0x7f2befd7a000 size:4KB  name: trinity-testfile2
[main]  start: 0x7f2befd79000 size:4KB  name: trinity-testfile3
[main]  start: 0x7f2befd78000 size:4KB  name: trinity-testfile4
[main]  start: 0x7f2befd77000 size:4KB  name: trinity-testfile1
[main]  start: 0x7f2befd76000 size:4KB  name: trinity-testfile2
[main]  start: 0x7f2befd75000 size:4KB  name: trinity-testfile3
[main]  start: 0x7f2befd74000 size:4KB  name: trinity-testfile4
[main]  start: 0x7f2befd73000 size:4KB  name: trinity-testfile1
[main]  start: 0x7f2befd72000 size:4KB  name: trinity-testfile2
[main]  start: 0x7f2befd71000 size:4KB  name: trinity-testfile3
[main]  start: 0x7f2befd70000 size:4KB  name: trinity-testfile4
[main]  start: 0x7f2befd6f000 size:4KB  name: trinity-testfile1
[main]  start: 0x7f2befd6e000 size:4KB  name: trinity-testfile2
[main]  start: 0x7f2befd6d000 size:4KB  name: trinity-testfile3
[main]  start: 0x41aba000 size:4KB  name: trinity-testfile4
[main] Enabled 13/14 fd providers. initialized:13.
[main] 11222 iterations. [F:8431 S:2745 HI:1573]
[main] 22548 iterations. [F:16928 S:5535 HI:2212]
[main] 33796 iterations. [F:25466 S:8211 HI:3806]
[main] 44419 iterations. [F:33558 S:10718 HI:3806]
[main] 54513 iterations. [F:41165 S:13178 HI:4445 STALLED:1]
[main] 64799 iterations. [F:48968 S:15625 HI:4445]
[main] 75504 iterations. [F:56938 S:18327 HI:4445]
[main] 85566 iterations. [F:64472 S:20816 HI:4445]
[main] 96687 iterations. [F:72892 S:23475 HI:4445]
[main] 107252 iterations. [F:80984 S:25902 HI:4445]
[main] 117292 iterations. [F:88535 S:28347 HI:4445]
[main] 127929 iterations. [F:96598 S:30879 HI:4445]
[main] 138578 iterations. [F:104592 S:33502 HI:4445]
[main] 148618 iterations. [F:112194 S:35879 HI:4445]

It makes me confused that the pid is different from which i echo.
with `diff /proc/30558/stack /proc/30504/stack` but no difference.

$ ps aux | grep trinity
nobody   30480  0.0  0.4  56612 36160 ?        Ds   10:35   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30504  0.0  0.4  54804 34172 ?        DNs  10:35   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30558  0.0  0.3  56180 29256 ?        DNs  10:35   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30564  0.0  0.2  55160 21320 pts/0    D    10:35   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30565  0.0  0.3  57504 28472 ?        Ds   10:35   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
Their status are all D, so i can not kill them.
And i want to know when those process kill themselves.
Is it a bug?

Thanks
Xiang

> 
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe trinity" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
