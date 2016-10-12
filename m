From: "Andersen, John" <john.s.andersen@intel.com>
Subject: [BUG] invalid open call: O_CREAT or O_TMPFILE without mode
Date: Wed, 12 Oct 2016 11:32:16 -0700
Message-ID: <20161012183216.GB32045@pdxjohnny>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Log attached. When I tried to fuzz devices in /dev. Hoping to fuzz an ioctl.
Trinity gets killed and displays the message seen in the subject.

'invalid open call: O_CREAT or O_TMPFILE without mode'

I am running on Android which may have something / everything to do with this.
I just wanted to see if anyone has experienced this issue before. Otherwise
some pointers on where I might start looking to make a patch would be
appreciated.

Thanks,
John

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trinity.log"

# /data/trinity --dangerous --victims /dev/
Trinity 1.6  Dave Jones <davej@codemonkey.org.uk>
shm:0x7f3dd0282000-0x7f3de8355308 (5 pages)
[init] Registered 11 fd providers.
[init] Done parsing arguments.
[init] shm is at 0x7f3dd0282000
[init] Kernel was tainted on startup. Will ignore flags that are already set.
Marking all syscalls as enabled.
[init] 32-bit syscalls: 375 enabled.  64-bit syscalls: 324 enabled.
Free memory: 0.49GB
Low on memory, disabling mmaping of 1GB pages
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious problems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a firmware reset.
You might want to check out running with --dropprivs (currently experimental).

ctrl-c now unless you really know what you are doing.
[init] mapping[0]: (zeropage PROT_READ | PROT_WRITE) 0x7f3dd024d000 (4KB)
[init] mapping[1]: (zeropage PROT_READ) 0x7f3dd024c000 (4KB)
[init] mapping[2]: (zeropage PROT_WRITE) 0x7f3dd024b000 (4KB)
[init] mapping[3]: (zeropage PROT_READ | PROT_WRITE) 0x7f3dd014b000 (1MB)
[init] mapping[4]: (zeropage PROT_READ) 0x7f3dd004b000 (1MB)
[init] mapping[5]: (zeropage PROT_WRITE) 0x7f3dcff4b000 (1MB)
[init] mapping[6]: (zeropage PROT_READ | PROT_WRITE) 0x7f3dcfd4b000 (2MB)
[init] mapping[7]: (zeropage PROT_READ) 0x7f3dcfb4b000 (2MB)
[init] mapping[8]: (zeropage PROT_WRITE) 0x7f3dcf94b000 (2MB)
[init] mapping[9]: (zeropage PROT_READ | PROT_WRITE) 0x7f3dcf54b000 (4MB)
[init] mapping[10]: (zeropage PROT_READ) 0x7f3dcf14b000 (4MB)
[init] mapping[11]: (zeropage PROT_WRITE) 0x7f3dced4b000 (4MB)
[init] mapping[12]: (zeropage PROT_READ | PROT_WRITE) 0x7f3dce34b000 (10MB)
[init] mapping[13]: (zeropage PROT_READ) 0x7f3dcd94b000 (10MB)
[init] mapping[14]: (zeropage PROT_WRITE) 0x7f3dccf4b000 (10MB)
[init] There are 15 entries in the map table
[init]  start: 0x7f3dd024d000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x7f3dd024c000  name: anon(PROT_READ)
[init]  start: 0x7f3dd024b000  name: anon(PROT_WRITE)
[init]  start: 0x7f3dd014b000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x7f3dd004b000  name: anon(PROT_READ)
[init]  start: 0x7f3dcff4b000  name: anon(PROT_WRITE)
[init]  start: 0x7f3dcfd4b000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x7f3dcfb4b000  name: anon(PROT_READ)
[init]  start: 0x7f3dcf94b000  name: anon(PROT_WRITE)
[init]  start: 0x7f3dcf54b000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x7f3dcf14b000  name: anon(PROT_READ)
[init]  start: 0x7f3dced4b000  name: anon(PROT_WRITE)
[init]  start: 0x7f3dce34b000  name: anon(PROT_READ | PROT_WRITE)
[init]  start: 0x7f3dcd94b000  name: anon(PROT_READ)
[init]  start: 0x7f3dccf4b000  name: anon(PROT_WRITE)
[init] Parsed 38 char devices, 22 block devices, 37 misc devices.
[init] Using pid_max = 32768
[init] Started watchdog process, PID is 27223
[main] Main thread is alive.
[main] fd[6] = pipe([reader] flags:0)
[main] fd[7] = pipe([writer] flags:0)
[main] fd[8] = pipe([reader] flags:800)
[main] fd[9] = pipe([writer] flags:800)
[main] fd[10] = pipe([reader] flags:80000)
[main] fd[11] = pipe([writer] flags:80000)
[main] fd[12] = pipe([reader] flags:80800)
[main] fd[13] = pipe([writer] flags:80800)
[main] fd[14] = perf
[main] fd[15] = perf
[main] fd[16] = perf
[main] fd[17] = perf
[main] fd[18] = perf
[main] fd[19] = perf
[main] fd[20] = perf
[main] fd[21] = perf
[main] fd[22] = perf
[main] fd[23] = perf
[main] fd[24] = epoll
[main] fd[25] = epoll
[main] fd[26] = epoll
[main] fd[27] = epoll
[main] fd[28] = epoll
[main] fd[29] = epoll
[main] fd[30] = epoll
[main] fd[31] = epoll
[main] fd[32] = epoll
[main] fd[33] = epoll
[main] fd[34] = eventfd
[main] fd[35] = eventfd
[main] fd[36] = eventfd
[main] fd[37] = eventfd
[main] fd[38] = eventfd
[main] fd[39] = eventfd
[main] fd[40] = eventfd
[main] fd[41] = eventfd
[main] Generating file descriptors
[main] Added 267 filenames from /dev/
[main] fd[42] = fopen /dev/i2c-12 (read-write) flags:2 fcntl_flags:42400
[main] fd[43] = fopen /dev/__properties__/u:object_r:shell_prop:s0 (read-only) flags:0 fcntl_flags:400
[main] fd[44] = fopen /dev/cpu_freq_min (read-write) flags:2 fcntl_flags:46000
[main] fd[45] = open /dev/__properties__/u:object_r:logd_prop:s0 (read-only) flags:183200
[main] fd[46] = fopen /dev/block/ram0 (read-write) flags:2 fcntl_flags:40800
*** invalid open call: O_CREAT or O_TMPFILE without mode ***: /data/trinity terminated
======= Backtrace: =========
[0x429561]
[0x464682]
[0x45d34d]
[0x40a25e]
[0x40991e]
[0x400aee]
[0x416416]
[0x41660a]
[0x401159]
======= Memory map: ========
00400000-0050e000 r-xp 00000000 fd:00 16                                 /data/trinity
0070d000-007c6000 rw-p 0010d000 fd:00 16                                 /data/trinity
007c6000-007c9000 rw-p 00000000 00:00 0
020d5000-020d9000 rw-p 00000000 00:00 0                                  [heap]
020d9000-020da000 r--p 00000000 00:00 0                                  [heap]
020da000-020f8000 rw-p 00000000 00:00 0                                  [heap]
020f8000-0213f000 rw-p 00000000 00:00 0                                  [heap]
7f3dccf4a000-7f3dccf4b000 rw-p 00000000 00:00 0
7f3dccf4b000-7f3dcd94b000 rw-s 00000000 00:01 501482                     /dev/zero (deleted)
7f3dcd94b000-7f3dce34b000 rw-s 00000000 00:01 501481                     /dev/zero (deleted)
7f3dce34b000-7f3dced4b000 rw-s 00000000 00:01 501480                     /dev/zero (deleted)
7f3dced4b000-7f3dcf14b000 rw-s 00000000 00:01 501479                     /dev/zero (deleted)
7f3dcf14b000-7f3dcf54b000 rw-s 00000000 00:01 501478                     /dev/zero (deleted)
7f3dcf54b000-7f3dcf94b000 rw-s 00000000 00:01 501477                     /dev/zero (deleted)
7f3dcf94b000-7f3dcfb4b000 rw-s 00000000 00:01 501476                     /dev/zero (deleted)
7f3dcfb4b000-7f3dcfd4b000 rw-s 00000000 00:01 501475                     /dev/zero (deleted)
7f3dcfd4b000-7f3dcff4b000 rw-s 00000000 00:01 501474                     /dev/zero (deleted)
7f3dcff4b000-7f3dd004b000 rw-s 00000000 00:01 501473                     /dev/zero (deleted)
7f3dd004b000-7f3dd014b000 rw-s 00000000 00:01 501472                     /dev/zero (deleted)
7f3dd014b000-7f3dd024b000 rw-s 00000000 00:01 501471                     /dev/zero (deleted)
7f3dd024b000-7f3dd024c000 rw-s 00000000 00:01 501470                     /dev/zero (deleted)
7f3dd024c000-7f3dd024d000 rw-s 00000000 00:01 501469                     /dev/zero (deleted)
7f3dd024d000-7f3dd024e000 rw-s 00000000 00:01 501468                     /dev/zero (deleted)
7f3dd024e000-7f3dd025b000 rw-s 00000000 00:01 501465                     /dev/zero (deleted)
7f3dd025b000-7f3dd0268000 rw-s 00000000 00:01 501464                     /dev/zero (deleted)
7f3dd0268000-7f3dd0275000 rw-s 00000000 00:01 501463                     /dev/zero (deleted)
7f3dd0275000-7f3dd0282000 rw-s 00000000 00:01 501462                     /dev/zero (deleted)
7f3dd0282000-7f3dd0287000 rw-s 00000000 00:01 501461                     /dev/zero (deleted)
7f3dd0287000-7f3dd033c000 rw-s 00000000 00:01 501460                     /dev/zero (deleted)
7f3dd033c000-7f3dd03d9000 rw-s 00000000 00:01 501459                     /dev/zero (deleted)
7ffe4176b000-7ffe4178c000 rw-p 00000000 00:00 0                          [stack]
7ffe417ba000-7ffe417bb000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
[watchdog] main pid 27224 has disappeared.
[watchdog] [27223] Watchdog exiting because Main process disappeared..
[init] Ran 0 syscalls. Successes: 0  Failures: 0

--M9NhX3UHpAaciwkO--
