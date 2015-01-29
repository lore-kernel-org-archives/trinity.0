From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: *** Error in `trinity': free(): invalid pointer: 0xb755c014 ***
Date: Thu, 29 Jan 2015 19:59:33 +0100
Message-ID: <54CA8315.70408@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

At a 64 bit Gentoo KVM I updated kernel from 3.19-rc5 to -rc6 *and* trinity to latest git tree and got now :

tfoerste@n22kvm-clone /mnt/ramdisk/t3 $ trinity -C 1 -N 100 -qq 
Trinity 9  Dave Jones <davej@codemonkey.org.uk>
shm: redzone:0xb7569000. shmdata:0xb7587000. redzone:0xb758c000 end:0xb75aa000.
[init] Registered 9 fd providers.
[init] Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 359 syscalls. Disabled 0 syscalls.
[init] Using pid_max = 32768
[init] Started watchdog process, PID is 27721
[main] Main thread is alive.
[main] 375 sockets created based on info from socket cachefile.
[main] Generating file descriptors
[main] Added 31 filenames from /dev
[main] Added 10602 filenames from /proc
[main] Added 6372 filenames from /sys
[main] Enabled 9 fd providers.
[watchdog] Watchdog is alive. (pid:27721)
[child0:27725] lookup_dcookie (253) returned ENOSYS, marking as inactive.
[child0:27725] move_pages (317) returned ENOSYS, marking as inactive.
*** Error in `trinity': free(): invalid pointer: 0xb755c014 ***
======= Backtrace: =========
/lib/libc.so.6(+0x734ef)[0xb76824ef]
/lib/libc.so.6(+0x79992)[0xb7688992]
/lib/libc.so.6(+0x7aac1)[0xb7689ac1]
trinity(freeptr+0x14)[0x805cd04]
trinity[0x8062123]
trinity(handle_syscall_ret+0x28)[0x805a728]
trinity(child_random_syscalls+0x225)[0x805d595]
trinity(child_process+0x85)[0x8053025]
trinity(main_loop+0x1be)[0x8057f4e]
trinity(main+0x269)[0x8051d29]
/lib/libc.so.6(__libc_start_main+0xf5)[0xb762bee5]
trinity[0x80522c5]
======= Memory map: ========
08048000-08079000 r-xp 00000000 08:04 280283     /usr/bin/trinity
08079000-0807a000 r--p 00030000 08:04 280283     /usr/bin/trinity
0807a000-080e3000 rw-p 00031000 08:04 280283     /usr/bin/trinity
080e3000-080e4000 rw-p 00000000 00:00 0 
099ec000-09a0d000 rw-p 00000000 00:00 0          [heap]
09a0d000-09b80000 rw-p 00000000 00:00 0          [heap]
b4236000-b4250000 r-xp 00000000 08:04 228329     /usr/lib/gcc/i686-pc-linux-gnu/4.8.3/libgcc_s.so.1
b4250000-b4251000 r--p 0001a000 08:04 228329     /usr/lib/gcc/i686-pc-linux-gnu/4.8.3/libgcc_s.so.1
b4251000-b4252000 rw-p 0001b000 08:04 228329     /usr/lib/gcc/i686-pc-linux-gnu/4.8.3/libgcc_s.so.1
b4259000-b425a000 rw-p 00000000 00:00 0 
b425a000-b4c5a000 rw-s 00000000 00:05 67548      /dev/zero (deleted)
b4c5a000-b565a000 rw-s 00000000 00:05 67547      /dev/zero (deleted)
b565a000-b605a000 rw-s 00000000 00:05 67546      /dev/zero (deleted)
b605a000-b645a000 rw-s 00000000 00:05 67545      /dev/zero (deleted)
b645a000-b685a000 rw-s 00000000 00:05 67544      /dev/zero (deleted)
b685a000-b6c5a000 rw-s 00000000 00:05 67543      /dev/zero (deleted)
b6c5a000-b6e5a000 rw-s 00000000 00:05 67542      /dev/zero (deleted)
b6e5a000-b705a000 rw-s 00000000 00:05 67541      /dev/zero (deleted)
b705a000-b725a000 rw-s 00000000 00:05 67540      /dev/zero (deleted)
b725a000-b735a000 rw-s 00000000 00:05 67539      /dev/zero (deleted)
b735a000-b745a000 rw-s 00000000 00:05 67538      /dev/zero (deleted)
b745a000-b755a000 rw-s 00000000 00:05 67537      /dev/zero (deleted)
b755a000-b755c000 rw-s 00000000 00:05 67536      /dev/zero (deleted)
b755c000-b7569000 rw-s 00000000 00:05 67533      /dev/zero (deleted)
b7569000-b7587000 ---s 00000000 00:05 67531      /dev/zero (deleted)
b7587000-b758c000 rw-s 0001e000 00:05 67531      /dev/zero (deleted)
b758c000-b75aa000 ---s 00023000 00:05 67531      /dev/zero (deleted)
b75aa000-b760e000 rw-s 00000000 00:05 67530      /dev/zero (deleted)
b760e000-b760f000 rw-p 00000000 00:00 0 
b760f000-b77b4000 r-xp 00000000 08:04 267078     /lib/libc-2.19.so
b77b4000-b77b5000 ---p 001a5000 08:04 267078     /lib/libc-2.19.so
b77b5000-b77b7000 r--p 001a5000 08:04 267078     /lib/libc-2.19.so
b77b7000-b77b8000 rw-p 001a7000 08:04 267078     /lib/libc-2.19.so
b77b8000-b77bb000 rw-p 00000000 00:00 0 
b77bb000-b77bc000 rw-p 00000000 00:00 0 
b77bc000-b77be000 rw-s 00000000 00:05 67535      /dev/zero (deleted)
b77be000-b77c0000 rw-s 00000000 00:05 67534      /dev/zero (deleted)
b77c0000-b77c2000 rw-p 00000000 00:00 0 
b77c2000-b77c4000 r--p 00000000 00:00 0          [vvar]
b77c4000-b77c6000 r-xp 00000000 00:00 0          [vdso]
b77c6000-b77e6000 r-xp 00000000 08:04 267077     /lib/ld-2.19.so
b77e6000-b77e7000 rw-p 00000000 00:00 0 
b77e7000-b77e8000 r--p 0001f000 08:04 267077     /lib/ld-2.19.so
b77e8000-b77e9000 rw-p 00020000 08:04 267077     /lib/ld-2.19.so
bfa09000-bfa2a000 rw-p 00000000 00:00 0          [stack]
*** Error in `trinity': free(): invalid pointer: 0xb755c00c ***
======= Backtrace: =========
/lib/libc.so.6(+0x734ef)[0xb76824ef]
/lib/libc.so.6(+0x79992)[0xb7688992]
/lib/libc.so.6(+0x7aac1)[0xb7689ac1]
trinity(freeptr+0x14)[0x805cd04]
trinity(handle_syscall_ret+0x28)[0x805a728]
trinity(child_random_syscalls+0x225)[0x805d595]
trinity(child_process+0x85)[0x8053025]
trinity(main_loop+0x1be)[0x8057f4e]
trinity(main+0x269)[0x8051d29]
/lib/libc.so.6(__libc_start_main+0xf5)[0xb762bee5]
trinity[0x80522c5]
======= Memory map: ========
08048000-08079000 r-xp 00000000 08:04 280283     /usr/bin/trinity
08079000-0807a000 r--p 00030000 08:04 280283     /usr/bin/trinity
0807a000-080e3000 rw-p 00031000 08:04 280283     /usr/bin/trinity
080e3000-080e4000 rw-p 00000000 00:00 0 
099ec000-09a0d000 rw-p 00000000 00:00 0          [heap]
09a0d000-09b80000 rw-p 00000000 00:00 0          [heap]
b4236000-b4250000 r-xp 00000000 08:04 228329     /usr/lib/gcc/i686-pc-linux-gnu/4.8.3/libgcc_s.so.1
b4250000-b4251000 r--p 0001a000 08:04 228329     /usr/lib/gcc/i686-pc-linux-gnu/4.8.3/libgcc_s.so.1
b4251000-b4252000 rw-p 0001b000 08:04 228329     /usr/lib/gcc/i686-pc-linux-gnu/4.8.3/libgcc_s.so.1
b4259000-b425a000 rw-p 00000000 00:00 0 
b425a000-b4c5a000 rw-s 00000000 00:05 67548      /dev/zero (deleted)
b4c5a000-b565a000 rw-s 00000000 00:05 67547      /dev/zero (deleted)
b565a000-b605a000 rw-s 00000000 00:05 67546      /dev/zero (deleted)
b605a000-b645a000 rw-s 00000000 00:05 67545      /dev/zero (deleted)
b645a000-b685a000 rw-s 00000000 00:05 67544      /dev/zero (deleted)
b685a000-b6c5a000 rw-s 00000000 00:05 67543      /dev/zero (deleted)
b6c5a000-b6e5a000 rw-s 00000000 00:05 67542      /dev/zero (deleted)
b6e5a000-b705a000 rw-s 00000000 00:05 67541      /dev/zero (deleted)
b705a000-b725a000 rw-s 00000000 00:05 67540      /dev/zero (deleted)
b725a000-b735a000 rw-s 00000000 00:05 67539      /dev/zero (deleted)
b735a000-b745a000 rw-s 00000000 00:05 67538      /dev/zero (deleted)
b745a000-b755a000 rw-s 00000000 00:05 67537      /dev/zero (deleted)
b755a000-b755c000 rw-s 00000000 00:05 67536      /dev/zero (deleted)
b755c000-b7569000 rw-s 00000000 00:05 67533      /dev/zero (deleted)
b7569000-b7587000 ---s 00000000 00:05 67531      /dev/zero (deleted)
b7587000-b758c000 rw-s 0001e000 00:05 67531      /dev/zero (deleted)
b758c000-b75aa000 ---s 00023000 00:05 67531      /dev/zero (deleted)
b75aa000-b760e000 rw-s 00000000 00:05 67530      /dev/zero (deleted)
b760e000-b760f000 rw-p 00000000 00:00 0 
b760f000-b77b4000 r-xp 00000000 08:04 267078     /lib/libc-2.19.so
b77b4000-b77b5000 ---p 001a5000 08:04 267078     /lib/libc-2.19.so
b77b5000-b77b7000 r--p 001a5000 08:04 267078     /lib/libc-2.19.so
b77b7000-b77b8000 rw-p 001a7000 08:04 267078     /lib/libc-2.19.so
b77b8000-b77bb000 rw-p 00000000 00:00 0 
b77bb000-b77bc000 rw-p 00000000 00:00 0 
b77bc000-b77be000 rw-s 00000000 00:05 67535      /dev/zero (deleted)
b77be000-b77c0000 rw-s 00000000 00:05 67534      /dev/zero (deleted)
b77c0000-b77c2000 rw-p 00000000 00:00 0 
b77c2000-b77c4000 r--p 00000000 00:00 0          [vvar]
b77c4000-b77c6000 r-xp 00000000 00:00 0          [vdso]
b77c6000-b77e6000 r-xp 00000000 08:04 267077     /lib/ld-2.19.so
b77e6000-b77e7000 rw-p 00000000 00:00 0 
b77e7000-b77e8000 r--p 0001f000 08:04 267077     /lib/ld-2.19.so
b77e8000-b77e9000 rw-p 00020000 08:04 267077     /lib/ld-2.19.so
bfa09000-bfa2a000 rw-p 00000000 00:00 0          [stack]
[child0:27727] set_mempolicy (276) returned ENOSYS, marking as inactive.
[child0:27727] mbind (274) returned ENOSYS, marking as inactive.
[main] Bailing main loop because Completed maximum number of operations..
[watchdog] [27721] Watchdog exiting because Completed maximum number of operations..
[init] Ran 100 syscalls. Successes: 20  Failures: 80


Points this to a trinity or to a kernel regression ?
-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
