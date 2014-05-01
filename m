From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Thu, 01 May 2014 12:29:08 +0200
Message-ID: <536221F4.6000405@gmx.de>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030104010505060007000306"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------030104010505060007000306
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On 05/01/2014 11:22 AM, Richard Weinberger wrote:
> On Wed, Apr 30, 2014 at 8:19 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> -or- it uncovers a bug in kernel v3.15-rc3 for UML:
> 
> UML most not panic. :)
> 
> Do you have the trinity logs?
> I'd like to know the syscalls parameters.
I run trinity with "-C 2 -c mremap" within the guest, the logs are attached

> 
> It looks like trinity managed it to crash a thread on the host side.
> This is why ptrace() failed with ESRCH.
> 
>>
>>
>> commit 23dc478aba4134db51584d19e4783ec87ce87b88
>> Author: Dave Jones <davej@redhat.com>
>> Date:   Tue Apr 29 16:42:45 2014 -0400
>>
>>     non-biarch arches aren't necessarily 32-bit.
>>
>> diff --git a/children/random-syscalls.c b/children/random-syscalls.c
>> index 82e49f5..1d7e7ce 100644
>> --- a/children/random-syscalls.c
>> +++ b/children/random-syscalls.c
>> @@ -32,7 +32,6 @@ static bool choose_syscall_table(void)
>>
>>         if (biarch == FALSE) {
>>                 active_syscalls = shm->active_syscalls;
>> -               do32 = TRUE;
>>         } else {
>>
>>                 /* First, check that we have syscalls enabled in either table. */
>>
>>
>>
>>
>> I do get :
>>
>>
>> Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed, errno = 3
>>
>> CPU: 0 PID: 1303 Comm: trinity-c0 Not tainted 3.15.0-rc3 #1
>> Stack:
>>  085a4f54 085a4f54 4841fc48 00000004 086c8547 00002b58 00000003 00000011
>>  4841fc58 084eae75 00000000 00000000 4841fc80 084e72e0 085b08e8 08700960
>>  085ad7b4 4841fc90 00000000 00002b58 00000003 00000011 4841fcb4 080734c5
>> Call Trace:
>>  [<080734c5>] ? run_syscall_stub+0x125/0x2c0
>>  [<084eae75>] dump_stack+0x26/0x28
>>  [<084e72e0>] panic+0x7a/0x194
>>  [<080734c5>] run_syscall_stub+0x125/0x2c0
>>  [<08073b15>] unmap+0xf5/0x110
>>  [<08061047>] do_ops+0xb7/0x160
>>  [<080615f8>] fix_range_common+0x448/0x480
>>  [<080e50f4>] ? vma_interval_tree_insert+0x74/0x80
>>  [<0806193e>] flush_tlb_range+0x3e/0x40
>>  [<080f045e>] move_page_tables+0x24e/0x280
>>  [<080f0577>] move_vma+0xe7/0x230
>>  [<080eda20>] ? get_unmapped_area+0xa0/0xc0
>>  [<080f08b8>] SyS_mremap+0x1f8/0x4c0
>>  [<08062ab4>] handle_syscall+0x64/0x80
>>  [<0849d4f1>] ? ptrace+0x31/0x80
>>  [<080797a2>] ? get_fp_registers+0x22/0x40
>>  [<08074815>] userspace+0x475/0x5f0
>>  [<0849d4f1>] ? ptrace+0x31/0x80
>>  [<08079d06>] ? os_set_thread_area+0x26/0x40
>>  [<08078cd0>] ? do_set_thread_area+0x20/0x50
>>  [<08078e48>] ? arch_switch_tls+0xb8/0x100
>>  [<0805f770>] fork_handler+0x60/0x70
>>
>> /home/tfoerste/workspace/bin/start_uml.sh: line 110:  9558 Aborted                 (core dumped) $LINUX earlyprintk ubda=$ROOTFS ubdb=$SWAP eth0=$NET mem=$MEM $TTY umid=uml_$NAME rootfstype=ext4 "$ARGS"
>>
>>
>> --
>> Toralf
>>
>>
>> ------------------------------------------------------------------------------
>> "Accelerate Dev Cycles with Automated Cross-Browser Testing - For FREE
>> Instantly run your Selenium tests across 300+ browser/OS combos.  Get
>> unparalleled scalability from the best Selenium testing platform available.
>> Simple to use. Nothing to install. Get started now for free."
>> http://p.sf.net/sfu/SauceLabs
>> _______________________________________________
>> User-mode-linux-devel mailing list
>> User-mode-linux-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel
> 
> 
> 


-- 
Toralf


--------------030104010505060007000306
Content-Type: text/x-log;
 name="trinity.sh.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="trinity.sh.log"


 prepare trinity job at Thu May  1 12:20:04 CEST 2014 1#-1, M=
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
[init] shm is at 0x4024e000
[init] Enabled 1 syscalls. Disabled 353 syscalls.
[init] page_zeros @ 0x80cf000
[init] page_0xff @ 0x80d2000
[init] page_rand @ 0x80d5000
[init] page_allocs @ 0x80d8000
[init] page_maps @ 0x84dd000
[init] mapping[0]: (zeropage PROT_READ | PROT_WRITE) 0x4027a000 (8192 bytes)
[init] mapping[1]: (zeropage PROT_READ) 0x4027c000 (8192 bytes)
[init] mapping[2]: (zeropage PROT_WRITE) 0x4027e000 (8192 bytes)
[init] mapping[3]: (zeropage PROT_READ | PROT_WRITE) 0x40280000 (1MB)
[init] mapping[4]: (zeropage PROT_READ) 0x40380000 (1MB)
[init] mapping[5]: (zeropage PROT_WRITE) 0x40480000 (1MB)
[init] mapping[6]: (zeropage PROT_READ | PROT_WRITE) 0x40580000 (2MB)
[init] mapping[7]: (zeropage PROT_READ) 0x40780000 (2MB)
[init] mapping[8]: (zeropage PROT_WRITE) 0x40980000 (2MB)
[init] mapping[9]: (zeropage PROT_READ | PROT_WRITE) 0x40b80000 (4MB)
[init] mapping[10]: (zeropage PROT_READ) 0x40f80000 (4MB)
[init] mapping[11]: (zeropage PROT_WRITE) 0x41380000 (4MB)
[init] mapping[12]: (zeropage PROT_READ | PROT_WRITE) 0x41780000 (10MB)
[init] mapping[13]: (zeropage PROT_READ) 0x42180000 (10MB)
[init] mapping[14]: (zeropage PROT_WRITE) 0x42b80000 (10MB)
[init] There are 15 entries in the map table
[init]  start: 0x4027a000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x4027c000  name: anon(PROT_READ)
[init]  start: 0x4027e000  name: anon(PROT_WRITE)
[init]  start: 0x40280000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x40380000  name: anon(PROT_READ)
[init]  start: 0x40480000  name: anon(PROT_WRITE)
[init]  start: 0x40580000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x40780000  name: anon(PROT_READ)
[init]  start: 0x40980000  name: anon(PROT_WRITE)
[init]  start: 0x40b80000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x40f80000  name: anon(PROT_READ)
[init]  start: 0x41380000  name: anon(PROT_WRITE)
[init]  start: 0x41780000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x42180000  name: anon(PROT_READ)
[init]  start: 0x42b80000  name: anon(PROT_WRITE)
[init] Parsed 13 char devices, 4 block devices, 7 misc devices.
[init] Using pid_max = 32768
[init] Started watchdog process, PID is 1349
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] fd[7] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[8] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 2 80d5000 4) on fd 8 [2:1:6]
[main] fd[9] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 f 80d5000 4) on fd 9 [1:1:1]
[main] fd[10] = domain:2 (PF_INET) type:0x1 protocol:6
[main] fd[11] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 27) on fd 11 [10:1:0]
[main] fd[12] = domain:16 (PF_NETLINK) type:0x3 protocol:4
[main] Setsockopt(10e 3 80d5000 4) on fd 12 [16:3:4]
[main] fd[13] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2f 80d5000 4) on fd 13 [1:2:1]
[main] fd[14] = domain:2 (PF_INET) type:0x1 protocol:0
[main] fd[15] = domain:16 (PF_NETLINK) type:0x2 protocol:9
[main] Setsockopt(10e 5 80d5000 fe) on fd 15 [16:2:9]
[main] fd[16] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2c 80d5000 4) on fd 16 [1:2:1]
[main] fd[17] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(1 a 80d5000 4) on fd 17 [2:2:17]
[main] fd[18] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 8 80d5000 4) on fd 18 [10:1:0]
[main] fd[19] = domain:16 (PF_NETLINK) type:0x2 protocol:16
[main] fd[20] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 2b 80d5000 4) on fd 20 [1:5:1]
[main] fd[21] = domain:2 (PF_INET) type:0x2 protocol:17
[main] fd[22] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 b 80d5000 4) on fd 22 [10:1:0]
[main] fd[23] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 28 80d5000 8e) on fd 23 [1:5:1]
[main] fd[24] = domain:2 (PF_INET) type:0x1 protocol:0
[main] fd[25] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 2 80d5000 40) on fd 25 [10:1:0]
[main] fd[26] = domain:16 (PF_NETLINK) type:0x2 protocol:15
[main] Setsockopt(10e 4 80d5000 da) on fd 26 [16:2:15]
[main] fd[27] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[28] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 29 80d5000 aa) on fd 28 [2:1:6]
[main] fd[29] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 2 0 4) on fd 29 [10:1:0]
[main] fd[30] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[31] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 3b) on fd 31 [2:2:17]
[main] fd[32] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(0 b 80d5000 4) on fd 32 [10:2:17]
[main] fd[33] = domain:16 (PF_NETLINK) type:0x2 protocol:16
[main] Setsockopt(10e 5 80d5000 8d) on fd 33 [16:2:16]
[main] fd[34] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2b 80d5000 4) on fd 34 [1:2:1]
[main] fd[35] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 5 80d5000 97) on fd 35 [10:1:0]
[main] fd[36] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[37] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(1 9 80d5000 4) on fd 37 [2:2:17]
[main] fd[38] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 23 80d5000 4) on fd 38 [1:1:1]
[main] fd[39] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 10 80d5000 4) on fd 39 [2:1:6]
[main] fd[40] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(1 23 80d5000 4b) on fd 40 [10:2:17]
[main] fd[41] = domain:16 (PF_NETLINK) type:0x3 protocol:15
[main] Setsockopt(1 23 80d5000 59) on fd 41 [16:3:15]
[main] fd[42] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2b 80d5000 e5) on fd 42 [1:2:1]
[main] fd[43] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[44] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(88 1 80d5000 e5) on fd 44 [2:2:0]
[main] fd[45] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 2 80d5000 18) on fd 45 [10:2:0]
[main] fd[46] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[47] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(1 e 80d5000 4) on fd 47 [2:1:0]
[main] fd[48] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] fd[49] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[50] = domain:2 (PF_INET) type:0x1 protocol:0
[main] fd[51] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 64) on fd 51 [10:2:0]
[main] fd[52] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[53] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(1 2c 80d5000 f2) on fd 53 [2:2:0]
[main] fd[54] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 3 80d5000 4) on fd 54 [10:1:0]
[main] fd[55] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 29 80d5000 ad) on fd 55 [1:1:1]
[main] fd[56] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 4) on fd 56 [10:2:0]
[main] fd[57] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 10 80d5000 ed) on fd 57 [1:1:1]
[main] fd[58] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 b 80d5000 c0) on fd 58 [1:1:1]
[main] fd[59] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[60] = domain:2 (PF_INET) type:0x1 protocol:0
[main] fd[61] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 22 80d5000 4) on fd 61 [1:1:1]
[main] fd[62] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(1 9 80d5000 4) on fd 62 [10:2:0]
[main] fd[63] = domain:16 (PF_NETLINK) type:0x3 protocol:15
[main] fd[64] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[65] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 4) on fd 65 [2:1:0]
[main] fd[66] = domain:16 (PF_NETLINK) type:0x3 protocol:9
[main] Setsockopt(10e 4 80d5000 16) on fd 66 [16:3:9]
[main] fd[67] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 b 80d5000 4) on fd 67 [1:1:1]
[main] fd[68] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 11 0 4) on fd 68 [10:2:17]
[main] fd[69] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[70] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 d 80d5000 8) on fd 70 [2:1:6]
[main] fd[71] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 b 0 97) on fd 71 [10:2:17]
[main] fd[72] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[73] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(0 1 80d5000 4) on fd 73 [10:1:0]
[main] fd[74] = domain:16 (PF_NETLINK) type:0x2 protocol:15
[main] Setsockopt(1 1d 80d5000 4) on fd 74 [16:2:15]
[main] fd[75] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[76] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(1 9 80d5000 4) on fd 76 [2:2:17]
[main] fd[77] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 14 80d5000 8) on fd 77 [1:5:1]
[main] fd[78] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 8 80d5000 4b) on fd 78 [10:1:0]
[main] fd[79] = domain:16 (PF_NETLINK) type:0x3 protocol:15
[main] Setsockopt(1 2 80d5000 4) on fd 79 [16:3:15]
[main] fd[80] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[81] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[82] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 4) on fd 82 [2:2:0]
[main] fd[83] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 b 80d5000 4) on fd 83 [10:2:17]
[main] fd[84] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 b 80d5000 4) on fd 84 [1:1:1]
[main] fd[85] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(6 12 80d5000 f1) on fd 85 [2:1:6]
[main] fd[86] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[87] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 17 0 4) on fd 87 [10:1:0]
[main] fd[88] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 29 80d5000 fe) on fd 88 [1:2:1]
[main] fd[89] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(0 1 80d5000 c2) on fd 89 [2:1:0]
[main] fd[90] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 19 0 4) on fd 90 [10:1:0]
[main] fd[91] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[92] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(0 c 80d5000 1) on fd 92 [10:1:0]
[main] fd[93] = domain:16 (PF_NETLINK) type:0x2 protocol:0
[main] Setsockopt(10e 3 80d5000 4) on fd 93 [16:2:0]
[main] fd[94] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[95] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 c 80d5000 4) on fd 95 [2:1:0]
[main] fd[96] = domain:16 (PF_NETLINK) type:0x2 protocol:10
[main] Setsockopt(10e 4 80d5000 98) on fd 96 [16:2:10]
[main] fd[97] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[98] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 39) on fd 98 [10:2:0]
[main] fd[99] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 a 80d5000 4) on fd 99 [1:1:1]
[main] fd[100] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 b 0 4) on fd 100 [10:2:17]
[main] fd[101] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 12 80d5000 4) on fd 101 [1:2:1]
[main] fd[102] = domain:2 (PF_INET) type:0x1 protocol:6
[main] fd[103] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[104] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] Setsockopt(1 b 80d5000 4) on fd 104 [16:3:16]
[main] fd[105] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[106] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(0 12 80d5000 4) on fd 106 [2:2:0]
[main] fd[107] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(0 12 80d5000 4) on fd 107 [10:1:0]
[main] fd[108] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 7 80d5000 4) on fd 108 [1:1:1]
[main] fd[109] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 18 0 4) on fd 109 [10:1:0]
[main] fd[110] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 22 80d5000 4) on fd 110 [1:5:1]
[main] fd[111] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(88 1 80d5000 55) on fd 111 [2:2:0]
[main] fd[112] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 b 80d5000 f6) on fd 112 [10:2:17]
[main] fd[113] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 8 80d5000 7d) on fd 113 [1:2:1]
[main] fd[114] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 4b) on fd 114 [2:2:17]
[main] fd[115] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(1 2b 80d5000 4) on fd 115 [10:2:0]
[main] fd[116] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[117] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 4) on fd 117 [2:2:0]
[main] fd[118] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 4 80d5000 4) on fd 118 [10:2:0]
[main] fd[119] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 5 80d5000 4) on fd 119 [1:2:1]
[main] fd[120] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 5 80d5000 4) on fd 120 [10:1:0]
[main] fd[121] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 28 80d5000 35) on fd 121 [1:1:1]
[main] fd[122] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 4) on fd 122 [2:2:0]
[main] fd[123] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 10 80d5000 4) on fd 123 [1:2:1]
[main] fd[124] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(0 f 80d5000 4) on fd 124 [2:2:17]
[main] fd[125] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 4) on fd 125 [10:2:0]
[main] fd[126] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 a 80d5000 ff) on fd 126 [1:1:1]
[main] fd[127] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 4) on fd 127 [2:2:17]
[main] fd[128] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(1 2c 80d5000 1b) on fd 128 [10:2:0]
[main] fd[129] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[130] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(88 64 80d5000 4) on fd 130 [2:2:0]
[main] fd[131] = domain:16 (PF_NETLINK) type:0x2 protocol:0
[main] Setsockopt(10e 1 80d5000 b6) on fd 131 [16:2:0]
[main] fd[132] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[133] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(0 d 80d5000 1) on fd 133 [2:2:17]
[main] fd[134] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[135] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 28 80d5000 57) on fd 135 [10:1:0]
[main] fd[136] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2e 80d5000 4) on fd 136 [1:2:1]
[main] fd[137] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 ec) on fd 137 [2:2:17]
[main] fd[138] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(88 64 80d5000 4) on fd 138 [10:2:17]
[main] fd[139] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 2d 80d5000 82) on fd 139 [1:5:1]
[main] fd[140] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(0 12 80d5000 4) on fd 140 [2:1:0]
[main] fd[141] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 18 0 2c) on fd 141 [10:1:0]
[main] fd[142] = domain:16 (PF_NETLINK) type:0x2 protocol:4
[main] Setsockopt(1 2c 80d5000 6d) on fd 142 [16:2:4]
[main] fd[143] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[144] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 fc) on fd 144 [2:2:17]
[main] fd[145] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[146] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 4) on fd 146 [2:2:17]
[main] fd[147] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[148] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(6 1 80d5000 4) on fd 148 [2:1:6]
[main] fd[149] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 14 80d5000 8) on fd 149 [10:1:0]
[main] fd[150] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] fd[151] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 8 80d5000 4) on fd 151 [1:1:1]
[main] fd[152] = domain:16 (PF_NETLINK) type:0x2 protocol:10
[main] Setsockopt(10e 5 80d5000 4) on fd 152 [16:2:10]
[main] fd[153] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[154] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 4) on fd 154 [2:1:0]
[main] fd[155] = domain:16 (PF_NETLINK) type:0x2 protocol:2
[main] Setsockopt(1 8 80d5000 4) on fd 155 [16:2:2]
[main] fd[156] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 7 80d5000 e0) on fd 156 [1:2:1]
[main] fd[157] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 1a) on fd 157 [2:2:17]
[main] fd[158] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[159] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 5a) on fd 159 [2:1:0]
[main] fd[160] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 4) on fd 160 [10:2:17]
[main] fd[161] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 2f 80d5000 a8) on fd 161 [1:5:1]
[main] fd[162] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(1 b 80d5000 4) on fd 162 [10:2:17]
[main] fd[163] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[164] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 7 80d5000 e6) on fd 164 [2:1:0]
[main] fd[165] = domain:16 (PF_NETLINK) type:0x3 protocol:4
[main] Setsockopt(1 10 80d5000 52) on fd 165 [16:3:4]
[main] fd[166] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 a 80d5000 4e) on fd 166 [1:5:1]
[main] fd[167] = domain:2 (PF_INET) type:0x2 protocol:17
[main] fd[168] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] Setsockopt(10e 2 80d5000 4) on fd 168 [16:3:16]
[main] fd[169] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[170] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 11 80d5000 f1) on fd 170 [10:1:0]
[main] fd[171] = domain:16 (PF_NETLINK) type:0x3 protocol:9
[main] Setsockopt(1 2d 80d5000 4e) on fd 171 [16:3:9]
[main] fd[172] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 28 80d5000 d3) on fd 172 [1:5:1]
[main] fd[173] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(0 2 80d5000 d8) on fd 173 [2:2:0]
[main] fd[174] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 15 80d5000 8) on fd 174 [1:2:1]
[main] fd[175] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 64 80d5000 4) on fd 175 [2:2:0]
[main] fd[176] = domain:16 (PF_NETLINK) type:0x2 protocol:0
[main] Setsockopt(1 a 80d5000 83) on fd 176 [16:2:0]
[main] fd[177] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2b 80d5000 4) on fd 177 [1:2:1]
[main] fd[178] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 62) on fd 178 [2:2:0]
[main] fd[179] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(0 7 80d5000 1) on fd 179 [10:2:17]
[main] fd[180] = domain:16 (PF_NETLINK) type:0x2 protocol:16
[main] Setsockopt(1 2b 80d5000 8a) on fd 180 [16:2:16]
[main] fd[181] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[182] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 64 80d5000 c) on fd 182 [2:2:0]
[main] fd[183] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 17 80d5000 4) on fd 183 [10:2:17]
[main] fd[184] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] Setsockopt(10e 3 80d5000 ed) on fd 184 [16:3:16]
[main] fd[185] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[186] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 ec) on fd 186 [2:2:17]
[main] fd[187] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(0 15 80d5000 4) on fd 187 [10:2:17]
[main] fd[188] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] fd[189] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 b 80d5000 35) on fd 189 [1:5:1]
[main] fd[190] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 9 80d5000 4) on fd 190 [2:1:6]
[main] fd[191] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(11 1 80d5000 4) on fd 191 [10:2:0]
[main] fd[192] = domain:16 (PF_NETLINK) type:0x2 protocol:10
[main] Setsockopt(10e 5 80d5000 d9) on fd 192 [16:2:10]
[main] fd[193] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 2d 80d5000 4) on fd 193 [1:1:1]
[main] fd[194] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(6 3 80d5000 4) on fd 194 [2:1:6]
[main] fd[195] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[196] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 3 80d5000 4) on fd 196 [2:1:0]
[main] fd[197] = domain:16 (PF_NETLINK) type:0x2 protocol:4
[main] Setsockopt(10e 3 80d5000 4) on fd 197 [16:2:4]
[main] fd[198] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[199] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 4 80d5000 17) on fd 199 [10:1:0]
[main] fd[200] = domain:16 (PF_NETLINK) type:0x2 protocol:4
[main] fd[201] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[202] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 ca) on fd 202 [2:1:0]
[main] fd[203] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[204] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 a 80d5000 cd) on fd 204 [2:1:0]
[main] fd[205] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 2 80d5000 4) on fd 205 [10:2:0]
[main] fd[206] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[207] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 86) on fd 207 [2:2:17]
[main] fd[208] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 cc) on fd 208 [10:2:17]
[main] fd[209] = domain:16 (PF_NETLINK) type:0x3 protocol:0
[main] Setsockopt(1 10 80d5000 4) on fd 209 [16:3:0]
[main] fd[210] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 b 80d5000 4) on fd 210 [1:2:1]
[main] fd[211] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(6 3 80d5000 e9) on fd 211 [2:1:6]
[main] fd[212] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] fd[213] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[214] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(1 25 80d5000 e6) on fd 214 [2:2:0]
[main] fd[215] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 4) on fd 215 [10:2:17]
[main] fd[216] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[217] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 17 0 4) on fd 217 [10:2:17]
[main] fd[218] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 10 80d5000 3b) on fd 218 [1:2:1]
[main] fd[219] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 64 80d5000 4) on fd 219 [2:2:0]
[main] fd[220] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(0 1 80d5000 4) on fd 220 [10:2:0]
[main] fd[221] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[222] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 8 80d5000 4) on fd 222 [2:1:0]
[main] fd[223] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 4 80d5000 4) on fd 223 [10:1:0]
[main] fd[224] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[225] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 9 80d5000 4) on fd 225 [2:1:0]
[main] fd[226] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 2 0 4) on fd 226 [10:1:0]
[main] fd[227] = domain:16 (PF_NETLINK) type:0x2 protocol:2
[main] Setsockopt(10e 3 80d5000 92) on fd 227 [16:2:2]
[main] fd[228] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 15 80d5000 8) on fd 228 [1:2:1]
[main] fd[229] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(0 2 80d5000 41) on fd 229 [10:1:0]
[main] fd[230] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 6 80d5000 4) on fd 230 [1:2:1]
[main] fd[231] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 64 80d5000 47) on fd 231 [2:2:0]
[main] fd[232] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(1 a 80d5000 4f) on fd 232 [10:2:0]
[main] fd[233] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[234] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(0 1 80d5000 9d) on fd 234 [2:2:0]
[main] fd[235] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 5 80d5000 4) on fd 235 [10:1:0]
[main] fd[236] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[237] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(1 f 80d5000 4) on fd 237 [2:2:0]
[main] fd[238] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 28 80d5000 bb) on fd 238 [1:1:1]
[main] fd[239] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(0 15 80d5000 1) on fd 239 [2:2:17]
[main] fd[240] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 29 80d5000 e) on fd 240 [10:1:0]
[main] fd[241] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[242] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 10 0 35) on fd 242 [10:2:0]
[main] fd[243] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 10 80d5000 4) on fd 243 [1:5:1]
[main] fd[244] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(88 64 80d5000 4) on fd 244 [2:2:0]
[main] fd[245] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 14 80d5000 8) on fd 245 [10:1:0]
[main] fd[246] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[247] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 10) on fd 247 [10:2:17]
[main] fd[248] = domain:16 (PF_NETLINK) type:0x2 protocol:4
[main] fd[249] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[250] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 7 80d5000 4) on fd 250 [2:1:6]
[main] fd[251] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[252] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(0 2 80d5000 4) on fd 252 [2:2:17]
[main] fd[253] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] Setsockopt(10e 3 80d5000 e) on fd 253 [16:3:16]
[main] fd[254] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2c 80d5000 4) on fd 254 [1:2:1]
[main] fd[255] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 c 80d5000 4) on fd 255 [2:1:6]
[main] fd[256] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[257] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 3 80d5000 5d) on fd 257 [10:1:0]
[main] fd[258] = domain:16 (PF_NETLINK) type:0x3 protocol:16
[main] Setsockopt(10e 3 80d5000 4) on fd 258 [16:3:16]
[main] fd[259] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 8 80d5000 46) on fd 259 [1:5:1]
[main] fd[260] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 1a 0 4) on fd 260 [10:1:0]
[main] fd[261] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[262] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(1 9 80d5000 e) on fd 262 [2:1:0]
[main] fd[263] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[264] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 4) on fd 264 [2:2:17]
[main] fd[265] = domain:16 (PF_NETLINK) type:0x3 protocol:0
[main] Setsockopt(10e 4 80d5000 a1) on fd 265 [16:3:0]
[main] fd[266] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[267] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(0 1 80d5000 4) on fd 267 [10:2:17]
[main] fd[268] = domain:16 (PF_NETLINK) type:0x3 protocol:15
[main] fd[269] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 2c 80d5000 74) on fd 269 [1:5:1]
[main] fd[270] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(6 12 80d5000 70) on fd 270 [2:1:6]
[main] fd[271] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(1 8 80d5000 4) on fd 271 [10:2:17]
[main] fd[272] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 2b 80d5000 4) on fd 272 [1:2:1]
[main] fd[273] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 13 0 4) on fd 273 [10:2:0]
[main] fd[274] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 1d 80d5000 4) on fd 274 [1:1:1]
[main] fd[275] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(0 1 80d5000 4) on fd 275 [10:1:0]
[main] fd[276] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 29 80d5000 48) on fd 276 [1:5:1]
[main] fd[277] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 4) on fd 277 [2:2:17]
[main] fd[278] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 df) on fd 278 [10:2:17]
[main] fd[279] = domain:16 (PF_NETLINK) type:0x3 protocol:0
[main] Setsockopt(1 29 80d5000 4) on fd 279 [16:3:0]
[main] fd[280] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[281] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 9 80d5000 4) on fd 281 [2:1:0]
[main] fd[282] = domain:16 (PF_NETLINK) type:0x2 protocol:9
[main] fd[283] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 8 80d5000 4) on fd 283 [1:1:1]
[main] fd[284] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 46) on fd 284 [2:2:17]
[main] fd[285] = domain:16 (PF_NETLINK) type:0x2 protocol:9
[main] fd[286] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[287] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 4) on fd 287 [2:2:17]
[main] fd[288] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(88 1 80d5000 4) on fd 288 [10:2:0]
[main] fd[289] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 1d 80d5000 cd) on fd 289 [1:5:1]
[main] fd[290] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 4 0 4) on fd 290 [10:1:0]
[main] fd[291] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] Setsockopt(1 5 80d5000 18) on fd 291 [1:1:1]
[main] fd[292] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(1 c 80d5000 4) on fd 292 [2:1:0]
[main] fd[293] = domain:16 (PF_NETLINK) type:0x2 protocol:16
[main] Setsockopt(1 2d 80d5000 5c) on fd 293 [16:2:16]
[main] fd[294] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[295] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 ea) on fd 295 [2:2:17]
[main] fd[296] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 2d 80d5000 ea) on fd 296 [1:5:1]
[main] fd[297] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(0 f 80d5000 4) on fd 297 [2:1:0]
[main] fd[298] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 7 80d5000 4) on fd 298 [10:1:0]
[main] fd[299] = domain:16 (PF_NETLINK) type:0x3 protocol:10
[main] fd[300] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[301] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 51) on fd 301 [2:2:17]
[main] fd[302] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 4) on fd 302 [10:2:17]
[main] fd[303] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 1a 80d4bb0 8) on fd 303 [1:2:1]
[main] fd[304] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 23 80d5000 9f) on fd 304 [2:1:6]
[main] fd[305] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 3 80d5000 4) on fd 305 [10:2:17]
[main] fd[306] = domain:16 (PF_NETLINK) type:0x2 protocol:15
[main] Setsockopt(1 10 80d5000 37) on fd 306 [16:2:15]
[main] fd[307] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[308] = domain:2 (PF_INET) type:0x1 protocol:0
[main] fd[309] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 2d 80d5000 9b) on fd 309 [10:1:0]
[main] fd[310] = domain:16 (PF_NETLINK) type:0x3 protocol:15
[main] Setsockopt(1 c 80d5000 2c) on fd 310 [16:3:15]
[main] fd[311] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[312] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 10 80d5000 7e) on fd 312 [10:1:0]
[main] fd[313] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[314] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(1 2d 80d5000 ec) on fd 314 [10:1:0]
[main] fd[315] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 1d 80d5000 4) on fd 315 [1:5:1]
[main] fd[316] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(1 10 80d5000 4c) on fd 316 [2:1:6]
[main] fd[317] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 13 80d5000 4) on fd 317 [10:1:0]
[main] fd[318] = domain:16 (PF_NETLINK) type:0x3 protocol:0
[main] Setsockopt(10e 3 80d5000 4) on fd 318 [16:3:0]
[main] fd[319] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 1d 80d5000 4) on fd 319 [1:5:1]
[main] fd[320] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 64 80d5000 4) on fd 320 [2:2:17]
[main] fd[321] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 b 80d5000 4) on fd 321 [10:2:17]
[main] fd[322] = domain:16 (PF_NETLINK) type:0x3 protocol:15
[main] Setsockopt(1 c 80d5000 4) on fd 322 [16:3:15]
[main] fd[323] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[324] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 15 80d5000 8) on fd 324 [1:5:1]
[main] fd[325] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(0 6 80d5000 1) on fd 325 [10:1:0]
[main] fd[326] = domain:16 (PF_NETLINK) type:0x2 protocol:4
[main] fd[327] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[328] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(1 12 80d5000 4) on fd 328 [10:2:0]
[main] fd[329] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[330] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(0 1 80d5000 1) on fd 330 [2:2:0]
[main] fd[331] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 12 80d5000 54) on fd 331 [10:2:0]
[main] fd[332] = domain:16 (PF_NETLINK) type:0x2 protocol:2
[main] Setsockopt(1 6 80d5000 2f) on fd 332 [16:2:2]
[main] fd[333] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[334] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 60) on fd 334 [2:2:17]
[main] fd[335] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[336] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 2 80d5000 3e) on fd 336 [10:1:0]
[main] fd[337] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[338] = domain:16 (PF_NETLINK) type:0x3 protocol:2
[main] Setsockopt(1 29 80d5000 4) on fd 338 [16:3:2]
[main] fd[339] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[340] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 52) on fd 340 [10:2:17]
[main] fd[341] = domain:16 (PF_NETLINK) type:0x2 protocol:9
[main] Setsockopt(10e 3 80d5000 b2) on fd 341 [16:2:9]
[main] fd[342] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[343] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 26) on fd 343 [2:2:17]
[main] fd[344] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 6 80d5000 4) on fd 344 [10:1:0]
[main] fd[345] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[346] = domain:16 (PF_NETLINK) type:0x2 protocol:9
[main] Setsockopt(1 2b 80d5000 4) on fd 346 [16:2:9]
[main] fd[347] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] fd[348] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 4) on fd 348 [2:2:17]
[main] fd[349] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 5 80d5000 ab) on fd 349 [10:1:0]
[main] fd[350] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[351] = domain:2 (PF_INET) type:0x2 protocol:17
[main] fd[352] = domain:16 (PF_NETLINK) type:0x3 protocol:2
[main] Setsockopt(10e 3 80d5000 1c) on fd 352 [16:3:2]
[main] fd[353] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[354] = domain:2 (PF_INET) type:0x1 protocol:6
[main] Setsockopt(0 7 80d5000 4) on fd 354 [2:1:6]
[main] fd[355] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(6 17 80d5000 4) on fd 355 [10:1:0]
[main] fd[356] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[357] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 4) on fd 357 [2:1:0]
[main] fd[358] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 2 80d5000 c0) on fd 358 [10:2:17]
[main] fd[359] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[360] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 7 80d5000 4) on fd 360 [2:1:0]
[main] fd[361] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(88 1 80d5000 4) on fd 361 [10:2:0]
[main] fd[362] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 e 80d5000 4) on fd 362 [1:5:1]
[main] fd[363] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 17 80d5000 4) on fd 363 [10:2:0]
[main] fd[364] = domain:1 (PF_LOCAL) type:0x5 protocol:1
[main] Setsockopt(1 2d 80d5000 c2) on fd 364 [1:5:1]
[main] fd[365] = domain:2 (PF_INET) type:0x1 protocol:0
[main] Setsockopt(6 1 80d5000 4) on fd 365 [2:1:0]
[main] fd[366] = domain:10 (PF_INET6) type:0x2 protocol:17
[main] Setsockopt(29 12 0 4) on fd 366 [10:2:17]
[main] fd[367] = domain:16 (PF_NETLINK) type:0x2 protocol:0
[main] Setsockopt(10e 3 80d5000 67) on fd 367 [16:2:0]
[main] fd[368] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] Setsockopt(1 d 80d5000 8) on fd 368 [1:2:1]
[main] fd[369] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[370] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(11 1 80d5000 4) on fd 370 [2:2:17]
[main] fd[371] = domain:16 (PF_NETLINK) type:0x2 protocol:10
[main] Setsockopt(1 23 80d5000 13) on fd 371 [16:2:10]
[main] fd[372] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[373] = domain:2 (PF_INET) type:0x2 protocol:17
[main] Setsockopt(88 1 80d5000 e) on fd 373 [2:2:17]
[main] fd[374] = domain:10 (PF_INET6) type:0x1 protocol:0
[main] Setsockopt(29 2 0 27) on fd 374 [10:1:0]
[main] fd[375] = domain:16 (PF_NETLINK) type:0x2 protocol:15
[main] Setsockopt(1 5 80d5000 72) on fd 375 [16:2:15]
[main] fd[376] = domain:1 (PF_LOCAL) type:0x1 protocol:1
[main] fd[377] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 64 80d5000 4) on fd 377 [2:2:0]
[main] fd[378] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(29 11 0 15) on fd 378 [10:2:0]
[main] fd[379] = domain:1 (PF_LOCAL) type:0x2 protocol:1
[main] fd[380] = domain:2 (PF_INET) type:0x2 protocol:0
[main] Setsockopt(11 64 80d5000 9d) on fd 380 [2:2:0]
[main] fd[381] = domain:10 (PF_INET6) type:0x2 protocol:0
[main] Setsockopt(1 c 80d5000 4) on fd 381 [10:2:0]
[main] created 375 sockets
[main] fd[6] = pipe
[main] fd[382] = pipe
[main] fd[383] = pipe
[main] fd[384] = pipe
[main] fd[385] = epoll
[main] fd[386] = epoll
[main] fd[387] = epoll
[main] fd[388] = epoll
[main] fd[389] = epoll
[main] fd[390] = epoll
[main] fd[391] = epoll
[main] fd[392] = epoll
[main] fd[393] = epoll
[main] fd[394] = epoll
[main] fd[395] = eventfd
[main] fd[396] = eventfd
[main] fd[397] = eventfd
[main] fd[398] = eventfd
[main] fd[399] = eventfd
[main] fd[400] = eventfd
[main] fd[401] = eventfd
[main] fd[402] = eventfd
[main] Generating file descriptors
[main] Added 15 filenames from /dev
[main] Added 6491 filenames from /proc
[main] Added 1320 filenames from /sys
[main] fd[403] = /proc/sys/net/ipv4/ip_default_ttl (read-only) flags:341c00
[main] fd[404] = /sys/kernel/slab/kmalloc-4096 (read-only) flags:230400
[main] fd[405] = /sys/devices/virtual/tty/tty11/dev (read-only) flags:3a5c00
[main] fd[406] = /proc/102/net/mcfilter6 (read-only) flags:b100
[main] fd[407] = /proc/1350/fdinfo/132 (read-only) flags:42000
[main] fd[408] = /proc/1348/task/1348/smaps (read-only) flags:8100
[main] fd[409] = /proc/7/net/protocols (read-only) flags:2c0000
[main] fd[410] = /proc/812/net/sockstat (read-only) flags:209400
[main] fd[411] = /proc/1350/fdinfo/384 (read-only) flags:22000
[main] fd[412] = /proc/107/task/107/statm (read-only) flags:264c00
[main] fd[413] = /proc/sys/net/ipv6/conf/all (read-only) flags:389c80
[main] fd[414] = /proc/1326/comm (read-only) flags:221580
[main] fd[415] = /proc/1337/ns (read-only) flags:37d480
[main] fd[416] = /proc/549/net/rpc/auth.unix.gid (read-only) flags:20cc80
[main] fd[417] = /proc/1350/fdinfo/380 (read-only) flags:281800
[main] fd[418] = /proc/1227/net/snmp (read-only) flags:800
[main] fd[419] = /proc/7/limits (read-only) flags:325800
[main] fd[420] = /proc/sys/net/ipv6/conf/lo/regen_max_retry (read-only) flags:24a780
[main] fd[421] = /proc/93/net/rpc/nfsd (read-only) flags:288780
[main] fd[422] = /proc/1350/fdinfo/219 (read-only) flags:8400
[main] fd[423] = /proc/103/task/103/mounts (read-only) flags:80
[main] fd[424] = /proc/1203/net/rpc/nfs4.nametoid (read-only) flags:389280
[main] fd[425] = /sys/devices/virtual/block/loop1/queue/physical_block_size (read-only) flags:287400
[main] fd[426] = /proc/104/net/dev_snmp6/sit0 (read-only) flags:264f80
[main] fd[427] = /proc/sys/net/ipv6/neigh/sit0/retrans_time (read-only) flags:480
[main] fd[428] = /proc/104/net/icmp (read-only) flags:201080
[main] fd[429] = /proc/1348/comm (read-write) flags:2c5d00
[main] fd[430] = /proc/1349/fdinfo/0 (read-only) flags:202000
[main] fd[431] = /proc/1227/net/ip6_flowlabel (read-only) flags:202000
[main] fd[432] = /proc/sys/net/ipv6/route/min_adv_mss (read-only) flags:303600
[main] fd[433] = /proc/1296/task/1296/mountinfo (read-only) flags:264900
[main] fd[434] = /proc/1349 (read-only) flags:40000
[main] fd[435] = /proc/1350/fdinfo/16 (read-only) flags:101000
[main] fd[436] = /proc/sys/net/ipv4/ipfrag_low_thresh (read-only) flags:129000
[main] fd[437] = /proc/1337/net/igmp6 (read-only) flags:23180
[main] fd[438] = /proc/sys/net/ipv4/neigh/sit0 (read-only) flags:3bf380
[main] fd[439] = /sys/kernel/slab/revoke_table (read-only) flags:8000
[main] fd[440] = /proc/sys/net/ipv4/conf/eth0/route_localnet (read-only) flags:381900
[main] fd[441] = /proc/84/net/raw (read-only) flags:101800
[main] fd[442] = /proc/1348/stat (read-only) flags:20c200
[main] fd[443] = /proc/1227/task/1227/mountinfo (read-only) flags:2ef580
[main] fd[444] = /proc/1203/task/1203/mounts (read-only) flags:a1100
[main] fd[445] = /proc/104/mountinfo (read-only) flags:28fa80
[main] fd[446] = /sys/devices/platform/uml-blkdev.0/block/ubda/queue/iosched (read-only) flags:2fd080
[main] fd[447] = /proc/8/net/tcp6 (read-only) flags:183400
[main] fd[448] = /proc/82/net/softnet_stat (read-only) flags:121000
[main] fd[449] = /proc/sys/vm/dirty_expire_centisecs (read-only) flags:3e5180
[main] fd[450] = /proc/91/autogroup (read-only) flags:21000
[main] fd[451] = /proc/1296/net (read-only) flags:10000
[main] fd[452] = /proc/10/net/netstat (read-only) flags:2ad00
[main] fd[453] = /sys/module/block/parameters/events_dfl_poll_msecs (read-only) flags:220000
[main] fd[454] = /proc/7/oom_score (read-only) flags:2000
[main] fd[455] = /dev/disk/by-path (read-only) flags:30b400
[main] fd[456] = /proc/sys/kernel/random/poolsize (read-only) flags:80000
[main] fd[457] = /proc/556/net/snmp6 (read-only) flags:303280
[main] fd[458] = /proc/104/wchan (read-only) flags:2e5c00
[main] fd[459] = /proc/sys/vm/panic_on_oom (read-only) flags:249f80
[main] fd[460] = /proc/100/net/dev_snmp6/eth0 (read-only) flags:2080
[main] fd[461] = /sys/devices/virtual/block/dm-0/alignment_offset (read-only) flags:c80
[main] fd[462] = /proc/1350/net/rt6_stats (read-only) flags:30f480
[main] fd[463] = /proc/1348/net/rpc (read-only) flags:80
[main] fd[464] = /proc/1350/task/1350/fdinfo/232 (read-only) flags:229000
[main] fd[465] = /proc/sys/net/ipv4/ip_early_demux (read-only) flags:88080
[main] fd[466] = /proc/sys/net/ipv6/conf/sit0/max_addresses (read-only) flags:3ebe80
[main] fd[467] = /proc/9/net/rpc/nfsd.fh (read-only) flags:101d80
[main] fd[468] = /sys/kernel/slab/skbuff_fclone_cache (read-only) flags:38f280
[main] fd[469] = /proc/549/net/mcfilter6 (read-only) flags:1000
[main] fd[470] = /proc/1251/task/1251/limits (read-only) flags:181480
[main] fd[471] = /proc/107/net/packet (read-only) flags:a0000
[main] fd[472] = /proc/sys/net/ipv4/tcp_allowed_congestion_control (read-only) flags:8080
[main] fd[473] = /proc/9/net/udplite (read-only) flags:20000
[main] fd[474] = /proc/sys/fs/file-max (read-only) flags:38fd00
[main] fd[475] = /proc/1350/task/1350/fdinfo/320 (read-only) flags:101000
[main] fd[476] = /proc/8/net/packet (read-only) flags:1a1900
[main] fd[477] = /proc/91/net/sockstat6 (read-only) flags:80400
[main] fd[478] = /proc/1279/net/protocols (read-only) flags:480
[main] fd[479] = /proc/809/stat (read-only) flags:26e800
[main] fd[480] = /proc/sys/kernel/keys/root_maxbytes (read-only) flags:2cb900
[main] fd[481] = /proc/sys/net/ipv4/neigh/lo/anycast_delay (read-only) flags:301000
[main] fd[482] = /proc/9/task/9/smaps (read-only) flags:244300
[main] fd[483] = /proc/88/net/udplite (read-only) flags:204c00
[main] fd[484] = /proc/1278/wchan (read-only) flags:3cb900
[main] fd[485] = /proc/1098/net/rpc/auth.rpcsec.context (read-only) flags:a980
[main] fd[486] = /sys/devices/virtual/net/lo/dev_port (read-only) flags:30d300
[main] fd[487] = /proc/4/task/4 (read-only) flags:229280
[main] fd[488] = /proc/91/loginuid (read-only) flags:2080
[main] fd[489] = /proc/84/cmdline (read-only) flags:28e500
[main] fd[490] = /proc/1/net/udplite (read-only) flags:349800
[main] fd[491] = /proc/1337/task/1337/personality (read-only) flags:20000
[main] fd[492] = /sys/kernel/slab/kmalloc-8 (read-only) flags:101000
[main] fd[493] = /proc/4/net/mcfilter6 (read-only) flags:2ad780
[main] fd[494] = /proc/1350/task/1350/fdinfo/87 (read-only) flags:1c1800
[main] fd[495] = /sys/module/printk/parameters/time (read-only) flags:2000
[main] fd[496] = /proc/1350/fdinfo/46 (read-only) flags:283900
[main] fd[497] = /proc/1123/task/1123/comm (read-only) flags:341000
[main] fd[498] = /proc/1350/fdinfo/102 (read-only) flags:1880
[main] fd[499] = /proc/sys/fs/file-nr (read-only) flags:203800
[main] fd[500] = /sys/devices/virtual/block/loop1/removable (read-only) flags:100
[main] fd[501] = /proc/812/net/softnet_stat (read-only) flags:101000
[main] fd[502] = /proc/1350/fdinfo/57 (read-only) flags:307580
[main] fd[503] = /proc/88/oom_score (read-only) flags:228000
[main] fd[504] = /sys/devices/virtual/block/loop3/stat (read-only) flags:81100
[main] fd[505] = /proc/84/net/raw6 (read-only) flags:200000
[main] fd[506] = /proc/556/net/rt_cache (read-only) flags:32dd80
[main] fd[507] = /proc/1350/fdinfo/169 (read-only) flags:400
[main] fd[508] = /proc/82/net/dev_snmp6/lo (read-only) flags:289900
[main] fd[509] = /proc/108/net/dev_snmp6/eth0 (read-only) flags:303400
[main] fd[510] = /sys/kernel/mm (read-only) flags:3100
[main] fd[511] = /proc/104/task/104/stat (read-only) flags:1800
[main] fd[512] = /proc/812/task/812/maps (read-only) flags:101000
[main] fd[513] = /proc/1350/mounts (read-only) flags:20ab80
[main] fd[514] = /proc/1279/net/rpc/nfsd (read-only) flags:20000
[main] fd[515] = /sys/devices/virtual/tty/ttyS14/dev (read-only) flags:205d80
[main] fd[516] = /proc/1251/net/route (read-only) flags:204000
[main] fd[517] = /sys/devices/virtual/mem/urandom/dev (read-only) flags:220480
[main] fd[518] = /proc/812/net/rpc/auth.unix.gid (read-only) flags:2000
[main] fd[519] = /proc/93/net/stat/rt_cache (read-only) flags:20000
[main] fd[520] = /sys/devices/virtual/bdi/7:0/uevent (read-only) flags:28be80
[main] fd[521] = /proc/3/net/rpc/auth.unix.ip (read-only) flags:3f7c80
[main] fd[522] = /proc/1203/net/packet (read-only) flags:9800
[main] fd[523] = /proc/1326/cmdline (read-only) flags:2000
[main] fd[524] = /proc/1099/task/1281/comm (read-only) flags:181080
[main] fd[525] = /sys/devices/virtual/block/loop2/queue/discard_zeroes_data (read-only) flags:305900
[main] fd[526] = /proc/811/net/stat/ndisc_cache (read-only) flags:24ff00
[main] fd[527] = /sys/devices/virtual/tty/ttyS48/dev (read-only) flags:101000
[main] fd[528] = /proc/107/net/anycast6 (read-only) flags:21000
[main] fd[529] = /proc/103/smaps (read-only) flags:3c7100
[main] fd[530] = /proc/sys/net/ipv4/inet_peer_maxttl (read-only) flags:121000
[main] fd[531] = /sys/devices/virtual/block/loop2/queue/discard_granularity (read-only) flags:2c2100
[main] fd[532] = /sys/class/bdi (read-only) flags:a000
[main] fd[533] = /proc/1251/net/udplite6 (read-only) flags:221600
[main] fd[534] = /proc/103/net/icmp6 (read-only) flags:400
[main] fd[535] = /proc/800/net/rpc/nfs4.nametoid (read-only) flags:305180
[main] fd[536] = /proc/1350/task/1350/fdinfo/41 (read-only) flags:121000
[main] fd[537] = /proc/7/net/stat (read-only) flags:27e300
[main] fd[538] = /sys/devices/virtual/net/lo/flags (read-only) flags:3cb500
[main] fd[539] = /proc/108/net/rpc/nfs4.idtoname (read-only) flags:2d7000
[main] fd[540] = /proc/549/task/549/statm (read-only) flags:2e0180
[main] fd[541] = /proc/1350/task/1350/fdinfo/32 (read-only) flags:260000
[main] fd[542] = /proc/1279/net/stat/rt_cache (read-only) flags:323c80
[main] fd[543] = /sys/devices/virtual/block/loop0/queue/max_sectors_kb (read-only) flags:201000
[main] fd[544] = /proc/811/wchan (read-only) flags:22f800
[main] fd[545] = /proc/82/net/udplite (read-only) flags:222080
[main] fd[546] = /proc/800/net/raw6 (read-only) flags:260980
[main] fd[547] = /proc/1203/task/1203/comm (read-only) flags:82480
[main] fd[548] = /proc/100/net/rpc/nfsd.fh (read-only) flags:109400
[main] fd[549] = /proc/1326/net/mcfilter6 (read-only) flags:8000
[main] fd[550] = /proc/91/net/udp6 (read-only) flags:280000
[main] fd[551] = /proc/810/net (read-only) flags:31d200
[main] fd[552] = /proc/1279/net/netstat (read-only) flags:224e00
[main] fd[553] = /proc/1251/mounts (read-only) flags:285b80
[main] fd[554] = /proc/1349/net/fib_trie (read-only) flags:80
[main] fd[555] = /proc/sys/net/ipv4/tcp_syncookies (read-only) flags:189000
[main] fd[556] = /proc/3/task/3/wchan (read-only) flags:280000
[main] fd[557] = /sys/devices/virtual/net/sit0/statistics/multicast (read-only) flags:34d800
[main] fd[558] = /proc/sys/net/ipv6/neigh/eth0/unres_qlen_bytes (read-only) flags:88880
[main] fd[559] = /proc/1098/task (read-only) flags:101400
[main] fd[560] = /proc/82/net/stat/rt_cache (read-only) flags:8400
[main] fd[561] = /proc/4/net/rpc/nfsd (read-only) flags:2ee880
[main] fd[562] = /proc/1251/loginuid (read-only) flags:265780
[main] fd[563] = /proc/1348/net/rpc/auth.rpcsec.init (read-only) flags:81000
[main] fd[564] = /proc/2/net/route (read-only) flags:100
[main] fd[565] = /proc/1350/task/1350/fdinfo/257 (read-only) flags:82100
[main] fd[566] = /proc/sys/net/ipv4/ipfrag_max_dist (read-only) flags:80000
[main] fd[567] = /proc/7/net/ip6_flowlabel (read-only) flags:22bd00
[main] fd[568] = /proc/93/net/stat/ndisc_cache (read-only) flags:2a5700
[main] fd[569] = /proc/108/net/tcp6 (read-only) flags:2c6500
[main] fd[570] = /proc/sys/net/ipv4/route/mtu_expires (read-only) flags:1a1400
[main] fd[571] = /sys/devices/virtual/sound (read-only) flags:22e000
[main] fd[572] = /proc/102/comm (read-only) flags:100
[main] fd[573] = /proc/1350/fdinfo/336 (read-only) flags:3ed080
[main] fd[574] = /proc/108/net/ip6_flowlabel (read-only) flags:2000
[main] fd[575] = /proc/103/net/dev (read-only) flags:34f100
[main] fd[576] = /proc/1350/task/1350/fdinfo/268 (read-only) flags:a8c00
[main] fd[577] = /proc/1123/task/1123/mounts (read-only) flags:a1980
[main] fd[578] = /proc/sys/vm/oom_kill_allocating_task (read-only) flags:121000
[main] fd[579] = /proc/1350/fdinfo/244 (read-only) flags:3c7100
[main] fd[580] = /sys/kernel/slab/key_jar (read-only) flags:200000
[main] fd[581] = /proc/811/loginuid (read-only) flags:3a5b80
[main] fd[582] = /sys/devices/virtual/bdi/7:6/read_ahead_kb (read-only) flags:900
[main] fd[583] = /proc/1277/wchan (read-only) flags:22400
[main] fd[584] = /proc/3/wchan (read-only) flags:101000
[main] fd[585] = /proc/94/limits (read-only) flags:201000
[main] fd[586] = /proc/1275/net/icmp6 (read-only) flags:2c9780
[main] fd[587] = /proc/108/net/protocols (read-only) flags:245480
[main] fd[588] = /proc/85/net (read-only) flags:800
[main] fd[589] = /proc/sys/net/ipv6/conf/sit0 (read-only) flags:81000
[main] fd[590] = /proc/1277/net/fib_trie (read-only) flags:26d700
[main] fd[591] = /proc/1203/net/rpc/nfsd (read-only) flags:22d900
[main] fd[592] = /proc/8/net/dev (read-only) flags:2000
[main] fd[593] = /proc/1350/task/1350/fdinfo/356 (read-only) flags:800
[main] fd[594] = /proc/1203/net/icmp6 (read-only) flags:20000
[main] fd[595] = /proc/1350/fdinfo/243 (read-only) flags:1800
[main] fd[596] = /proc/sys/net/ipv6/neigh/sit0/base_reachable_time (read-only) flags:100
[main] fd[597] = /proc/sys/net/ipv6/conf/default/autoconf (read-only) flags:220000
[main] fd[598] = /proc/805/net/dev (read-only) flags:2ca600
[main] fd[599] = /proc/90/task/90/stat (read-only) flags:288800
[main] fd[600] = /dev/disk/by-uuid (read-only) flags:2000
[main] fd[601] = /proc/1350/task/1350/fdinfo/316 (read-only) flags:285300
[main] fd[602] = /proc/102/stat (read-only) flags:3c9e80
[main] fd[603] = /proc/805/net/fib_trie (read-only) flags:3e3700
[main] fd[604] = /proc/1350/fdinfo/179 (read-only) flags:100
[main] fd[605] = /proc/5/net/sockstat (read-only) flags:2c3500
[main] fd[606] = /proc/1/net/softnet_stat (read-only) flags:82000
[main] fd[607] = /proc/91/net/rpc/nfs4.nametoid (read-only) flags:2da100
[main] fd[608] = /proc/104/net/snmp6 (read-only) flags:2c0180
[main] fd[609] = /proc/103/task/103/cgroup (read-only) flags:2a6d80
[main] fd[610] = /sys/module/soundcore (read-only) flags:23a300
[main] fd[611] = /sys/kernel/slab/kmalloc-2048 (read-only) flags:341900
[main] fd[612] = /proc/sys/net/ipv6/conf/default/force_mld_version (read-only) flags:3e9700
[main] fd[613] = /sys/module/kernel/parameters/panic (read-only) flags:303b00
[main] fd[614] = /proc/94 (read-only) flags:349400
[main] fd[615] = /proc/1296/net/rpc/auth.rpcsec.init (read-only) flags:101800
[main] fd[616] = /sys/kernel/slab/request_sock_TCP (read-only) flags:246200
[main] fd[617] = /proc/812/net/netstat (read-only) flags:800
[main] fd[618] = /proc/107/net/sockstat (read-only) flags:28400
[main] fd[619] = /proc/1/net/tcp (read-only) flags:3cf180
[main] fd[620] = /proc/12/net/rpc/auth.unix.gid (read-only) flags:235900
[main] fd[621] = /sys/module/sunrpc/parameters/tcp_max_slot_table_entries (read-only) flags:1100
[main] fd[622] = /proc/1326/net/netstat (read-only) flags:3e1a00
[main] fd[623] = /proc/1348/net/dev_snmp6/eth0 (read-only) flags:264800
[main] fd[624] = /proc/1098/net/rpc/nfsd.export (read-only) flags:119880
[main] fd[625] = /proc/1098/net/mcfilter6 (read-only) flags:8400
[main] fd[626] = /proc/107/net/rpc/nfsd.export (read-only) flags:8000
[main] fd[627] = /proc/1278/net/protocols (read-only) flags:208080
[main] fd[628] = /proc/82/net/igmp6 (read-only) flags:2e3500
[main] fd[629] = /proc/1296/net/rt6_stats (read-only) flags:28d200
[main] fd[630] = /proc/549/net/sockstat (read-only) flags:8480
[main] fd[631] = /proc/sys/net/ipv6/conf/lo/max_desync_factor (read-only) flags:189000
[main] fd[632] = /sys/devices/virtual/block/loop7/queue/add_random (read-only) flags:3e1500
[main] fd[633] = /proc/sys/kernel/shm_rmid_forced (read-only) flags:101000
[main] fd[634] = /proc/82/net/softnet_stat (read-only) flags:1ab900
[main] fd[635] = /proc/sys/kernel/keys/root_maxkeys (read-only) flags:221280
[main] fd[636] = /proc/1098/task/1098/cgroup (read-only) flags:101400
[main] fd[637] = /proc/549/loginuid (read-only) flags:220200
[main] fd[638] = /proc/9/net/igmp6 (read-only) flags:36d700
[main] fd[639] = /proc/1350/task/1350/oom_score (read-only) flags:100
[main] fd[640] = /proc/sys/kernel/sched_autogroup_enabled (read-only) flags:3cf000
[main] fd[641] = /proc/1326/statm (read-only) flags:3abe80
[main] fd[642] = /sys/devices/virtual/block/loop4/inflight (read-only) flags:1a9800
[main] fd[643] = /proc/103/net/if_inet6 (read-only) flags:880
[main] fd[644] = /proc/100/net/route (read-only) flags:20800
[main] fd[645] = /proc/10/autogroup (read-only) flags:2480
[main] fd[646] = /proc/1350/fdinfo/329 (read-only) flags:1100
[main] fd[647] = /proc/1123/net/dev_snmp6/eth0 (read-only) flags:201000
[main] fd[648] = /proc/sys/net/ipv4/neigh/lo/gc_stale_time (read-only) flags:38f180
[main] fd[649] = /proc/107/net/dev_snmp6 (read-only) flags:800
[main] fd[650] = /proc/1350/task/1350/fdinfo/191 (read-only) flags:243200
[main] fd[651] = /proc/90/net (read-only) flags:11000
[main] fd[652] = /proc/94/net/udplite (read-only) flags:220c00
[child1:1370] [0] mremap[0m(addr=0x40480000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x3[0m, new_addr=0x200000[0m) [1;32m= 0x200000[0m
[child1:1370] [1] mremap[0m(addr=0x40280000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x2[0m, new_addr=0xa00000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [2] mremap[0m(addr=0x4027c000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [3] mremap[0m(addr=0x4027c000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x3[0m, new_addr=0x400000[0m) [1;32m= 0x400000[0m
[child1:1370] [4] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40780000[0m
[child1:1370] [5] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40780000[0m
[child1:1370] [6] mremap[0m(addr=0x400000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [7] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [8] mremap[0m(addr=0x200000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [9] mremap[0m(addr=0x4027e000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [10] mremap[0m(addr=0x42180000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x2[0m, new_addr=0xa00000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [11] mremap[0m(addr=0x200000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x200000[0m
[child1:1370] [12] mremap[0m(addr=0x41380000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x41380000[0m
[child1:1370] [13] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x2[0m, new_addr=0x400000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1370] [14] mremap[0m(addr=0x41780000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x3[0m, new_addr=0x100000[0m) [main] Random reseed: 1755273157
[child1:1371] [0] mremap[0m(addr=0x42b80000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x3[0m, new_addr=0x200000[0m) [1;32m= 0x200000[0m
[child1:1371] [1] mremap[0m(addr=0x4027e000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0xa00000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [2] mremap[0m(addr=0x40580000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40580000[0m
[child1:1371] [3] mremap[0m(addr=0x40b80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40b80000[0m
[child1:1371] [4] mremap[0m(addr=0x40380000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40380000[0m
[child1:1371] [5] mremap[0m(addr=0x40280000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x3[0m, new_addr=0x80000000[0m) [1;32m= 0x80000000[0m
[child1:1371] [6] mremap[0m(addr=0x40380000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [7] mremap[0m(addr=0x4027c000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x40000000[0m) [1;31m= -1 (Invalid argument)[0m
[watchdog] Watchdog is alive. (pid:1349)
[child0:1369] [0] mremap[0m(addr=0x41380000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x41380000[0m
[child0:1369] [1] mremap[0m(addr=0x40f80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1369] [2] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40780000[0m
[child0:1369] [3] mremap[0m(addr=0x41780000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x3[0m, new_addr=0x40000000[0m) [child1:1371] [8] mremap[0m(addr=0x200000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x2[0m, new_addr=0x40000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [9] mremap[0m(addr=0x40980000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40980000[0m
[child1:1371] [10] mremap[0m(addr=0x200000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x3[0m, new_addr=0x400000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [11] mremap[0m(addr=0x40f80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [12] mremap[0m(addr=0x200000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x200000[0m
[child1:1371] [13] mremap[0m(addr=0x4027a000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0xa00000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [14] mremap[0m(addr=0x200000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x2[0m, new_addr=0x200000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [15] mremap[0m(addr=0x40580000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x3[0m, new_addr=0x80000000[0m) [1;32m= 0x80000000[0m
[child1:1371] [16] mremap[0m(addr=0x4027c000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x3[0m, new_addr=0x100000[0m) [1;32m= 0x100000[0m
[child1:1371] [17] mremap[0m(addr=0x42180000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x2[0m, new_addr=0x400000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [18] mremap[0m(addr=0x40980000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40980000[0m
[child1:1371] [19] mremap[0m(addr=0x4027e000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x4027e000[0m
[child1:1371] [20] mremap[0m(addr=0x40980000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40980000[0m
[child1:1371] [21] mremap[0m(addr=0x40b80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40b80000[0m
[child1:1371] [22] mremap[0m(addr=0x41380000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1371] [23] mremap[0m(addr=0x41380000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x3[0m, new_addr=0x40000000[0m) [main] Random reseed: 549616238
[child1:1382] [0] mremap[0m(addr=0x4027e000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1382] [1] mremap[0m(addr=0x4027e000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x4027e000[0m
[child1:1382] [2] mremap[0m(addr=0x41380000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x3[0m, new_addr=0x100000[0m) [main] Random reseed: 2546966117
[child1:1383] [0] mremap[0m(addr=0x40f80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40f80000[0m
[child1:1383] [1] mremap[0m(addr=0x4027a000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0xa00000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1383] [2] mremap[0m(addr=0x4027a000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x40000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1383] [3] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40780000[0m
[child1:1383] [4] mremap[0m(addr=0x42180000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x42180000[0m
[child1:1383] [5] mremap[0m(addr=0x42b80000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x3[0m, new_addr=0x80000000[0m) [1;32m= 0x80000000[0m
[child1:1383] [6] mremap[0m(addr=0x80000000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x3[0m, new_addr=0x400000[0m) [1;32m= 0x400000[0m
[child1:1383] [7] mremap[0m(addr=0x40980000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x2[0m, new_addr=0x40000000[0m) [1;31m= -1 (Invalid argument)[0m
[child1:1383] [8] mremap[0m(addr=0x4027a000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x3[0m, new_addr=0x200000[0m) [1;32m= 0x200000[0m
[child1:1383] [9] mremap[0m(addr=0x4027c000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x4027c000[0m
[child1:1383] [10] mremap[0m(addr=0x200000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x3[0m, new_addr=0x40000000[0m) [main] Random reseed: 3710087508
[child0:1386] [0] mremap[0m(addr=0x40380000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x3[0m, new_addr=0x40000000[0m) [main] Random reseed: 1274040552
[child0:1387] [0] mremap[0m(addr=0x40b80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40b80000[0m
[child0:1387] [1] mremap[0m(addr=0x42b80000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x42b80000[0m
[child0:1387] [2] mremap[0m(addr=0x4027c000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x4027c000[0m
[child0:1387] [3] mremap[0m(addr=0x4027e000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1387] [4] mremap[0m(addr=0x40780000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1387] [5] mremap[0m(addr=0x41780000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x41780000[0m
[child0:1387] [6] mremap[0m(addr=0x41780000[0m, old_len=0xa00000[0m[0m, new_len=0xa00000[0m[0m, flags=0x2[0m, new_addr=0x100000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1387] [7] mremap[0m(addr=0x41380000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x3[0m, new_addr=0x400000[0m) [1;32m= 0x400000[0m
[child0:1387] [8] mremap[0m(addr=0x40580000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40580000[0m
[child0:1387] [9] mremap[0m(addr=0x40580000[0m, old_len=0x200000[0m[0m, new_len=0x200000[0m[0m, flags=0x2[0m, new_addr=0xa00000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1387] [10] mremap[0m(addr=0x40b80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40b80000[0m
[child0:1387] [11] mremap[0m(addr=0x40480000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x3[0m, new_addr=0x200000[0m) [1;32m= 0x200000[0m
[child0:1387] [12] mremap[0m(addr=0x40380000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x2[0m, new_addr=0x40000000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1387] [13] mremap[0m(addr=0x40b80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x1[0m, new_addr=0x0[0m) [1;32m= 0x40b80000[0m
[child0:1387] [14] mremap[0m(addr=0x200000[0m, old_len=0x100000[0m[0m, new_len=0x100000[0m[0m, flags=0x3[0m, new_addr=0x400000[0m) [1;32m= 0x400000[0m
[child0:1387] [15] mremap[0m(addr=0x400000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x3[0m, new_addr=0x400000[0m) [1;31m= -1 (Invalid argument)[0m
[main] Random reseed: 1388322824
[child0:1391] [0] mremap[0m(addr=0x40b80000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x3[0m, new_addr=0xa00000[0m) [1;32m= 0xa00000[0m
[child0:1391] [1] mremap[0m(addr=0x4027a000[0m, old_len=8192[0m[0m, new_len=8192[0m[0m, flags=0x2[0m, new_addr=0x80000000[0m) [1;31m= -1 (Invalid argument)[0m
[child0:1391] [2] mremap[0m(addr=0xa00000[0m, old_len=0x400000[0m[0m, new_len=0x400000[0m[0m, flags=0x3[0m, new_addr=0x100000[0m) 
--------------030104010505060007000306--
