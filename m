From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: trinity doesn't exit after its finished
Date: Thu, 20 Nov 2014 19:08:15 +0100
Message-ID: <546E2E0F.1010708@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

With latest git tree of trinity at a user mode linux image it stays here forever:

$>trinity -C 2 -N 25000 -q -V /mnt/hostfs/victims/v1/v2
...
[child1:5186] <timed out>
[child1:5196] <timed out>
[child1:5197] <timed out>
[child0:5198] <timed out>
[child1:5197] <timed out>
[child1:5229] <timed out>
[watchdog] 20062 iterations. [F:15459 S:4602 HI:1777]
[child0:5233] <timed out>
[child1:5242] <timed out>
[child1:5242] <timed out>
[child0:5249] <timed out>
[child1:5242] <timed out>
[child1:5242] <timed out>
[child0:5249] <timed out>
[main] Bailing main loop because Completed maximum number of operations..
[watchdog] [5096] Watchdog exiting because Completed maximum number of operations..



The proces list shows:

$ ps fx -eo pid,start_time,command | grep -e trinity -e sleep | grep -v grep
 4878 18:30  |       \_ bash -c logger "2#-1, M=/mnt/hostfs"; cd ~; sudo su -c 'if [[ -d ./t3 ]]; then sudo chmod -R a+rwx ./t3; sudo rm -rf ./t3; fi'; mkdir ./t3 && cd ./t3 || exit; if [[ -n /mnt/hostfs ]]; then if [[ -d /mnt/hostfs/victims/v1 ]]; then sudo chmod -R a+rwx /mnt/hostfs/victims/v1; sudo rm -rf /mnt/hostfs/victims/v1 || exit; fi; mkdir -p /mnt/hostfs/victims/v1/v2; for i in $(seq -w 0 99); do touch /mnt/hostfs/victims/v1/v2/f$i; mkdir /mnt/hostfs/victims/v1/v2/d$i; done; fi; MALLOC_CHECK_=2 trinity -C 2 -N 25000 -q -V /mnt/hostfs/victims/v1/v2
 5095 18:30  |           \_ trinity -C 2 -N 25000 -q -V /mnt/hostfs/victims/v1/v2
 5096 18:30  |               \_ [trinity-watchdo] <defunct>
 5097 18:30  |               \_ [trinity-main]


Here are the stacks:

$ sudo cat /proc/5097/stack

[<0805f8b4>] __switch_to+0x44/0x70                                                                                                                     
[<0850b194>] __schedule+0x2f4/0x3a0                                                                                                                    
[<08097b8a>] __cond_resched+0x1a/0x30                                                                                                                  
[<0850b371>] _cond_resched+0x31/0x50
[<080dbbb2>] truncate_inode_pages_range+0x192/0x650
[<080dc102>] truncate_inode_pages_final+0x52/0x60
[<08275f18>] hostfs_evict_inode+0x18/0x40
[<08126e8d>] evict+0xdd/0x1b0
[<08127b0d>] iput+0x16d/0x180
[<08123538>] __dentry_kill+0x138/0x200
[<08123f66>] dput+0x156/0x180
[<0810fa15>] __fput+0x175/0x190
[<0810fa6b>] ____fput+0xb/0x10
[<08092956>] task_work_run+0x76/0x90
[<0807e92d>] do_exit+0x32d/0x940
[<0807f022>] do_group_exit+0xa2/0xf0
[<0807f087>] SyS_exit_group+0x17/0x20
[<08062980>] handle_syscall+0x60/0x80
[<080746fc>] userspace+0x46c/0x5e0
[<0805f720>] fork_handler+0x60/0x70
[<ffffffff>] 0xffffffff

$ sudo cat /proc/5096/stack

[<0805f8b4>] __switch_to+0x44/0x70
[<0850b194>] __schedule+0x2f4/0x3a0
[<0850b295>] schedule+0x55/0x60
[<0807ee9e>] do_exit+0x89e/0x940
[<0807f022>] do_group_exit+0xa2/0xf0
[<0807f087>] SyS_exit_group+0x17/0x20
[<08062980>] handle_syscall+0x60/0x80
[<080746fc>] userspace+0x46c/0x5e0
[<0805f720>] fork_handler+0x60/0x70
[<ffffffff>] 0xffffffff

tfoerste@trinity ~ $ sudo cat /proc/5095/stack
[<0805f8b4>] __switch_to+0x44/0x70
[<0850b194>] __schedule+0x2f4/0x3a0
[<0850b295>] schedule+0x55/0x60
[<0807e4c7>] do_wait+0x177/0x200
[<0807f4ed>] SyS_wait4+0xbd/0xe0
[<0807f537>] SyS_waitpid+0x27/0x30
[<08062980>] handle_syscall+0x60/0x80
[<080746fc>] userspace+0x46c/0x5e0
[<0805f720>] fork_handler+0x60/0x70
[<ffffffff>] 0xffffffff


Maybe it helps you to improve trinity, if not, ignore this mail
;-)

-- 
Toralf
pgp key: 0076 E94E
