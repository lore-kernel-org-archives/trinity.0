From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: x86; *** Error in `trinity': free(): invalid pointer: 0xb6ffe000 ***
Date: Thu, 3 Sep 2015 17:38:37 +0200
Message-ID: <55E8697D.5090902@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

After a long while I run the latest git trinity against in a x86 stable
32 bit Gentoo KVM guest with kernel 4.2.0 located at a 64 bit hardened
Gentoo host with grsecurity kernel 4.0.8:


Here's what I did within KVM:

tfoerste@n22kvm-clone ~ $ sudo su -c "mkdir /mnt/ramdisk/ext4; truncate
-s 497M /mnt/ramdisk/ext4.fs; /sbin/mkfs.ext4 /mnt/ramdisk/ext4.fs;
mount -o loop,lazytime /mnt/ramdisk/ext4.fs /mnt/ramdisk/ext4; chmod 777
/mnt/ramdisk/ext4"          
mke2fs 1.42.13 (17-May-2015)
Discarding device blocks: done                           
Creating filesystem with 508928 1k blocks and 127512 inodes
Filesystem UUID: d303af59-c184-492d-ae80-c07475ec89ea
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: done                           
Writing inode tables: done                           
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

tfoerste@n22kvm-clone ~ $ D=/mnt/ramdisk/ext4; while :; do cd ~; sudo rm
-rf $D/t3 && mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in
$(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 2 -N
100000 -V $D/t3/v1/v2 -qqq; echo; echo " done"; echo; sleep 4; done




and I got this backtrace:




Trinity 9  Dave Jones <davej@codemonkey.org.uk>
shm:0xb7721000-0xcf72c330 (5 pages)
[init] Registered 11 fd providers.
Marking all syscalls as enabled.
[init] Enabled 374 syscalls. Disabled 0 syscalls.
Free memory: 2.80GB
Low on memory, disabling mmaping of 1GB pages
[init] Using pid_max = 32768
[init] Started watchdog process, PID is 12461
[main] Main thread is alive.
[main] Added 201 filenames from /mnt/ramdisk/ext4/t3/v1/v2
[main] Enabled 11 fd providers.
[watchdog] Watchdog is alive. (pid:12461)
*** Error in `trinity': free(): invalid pointer: 0xb6ffe000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x72658)[0xb75f6658]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
b41d8000-b41f3000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f4000-b41f5000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fd000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rw-s 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6e06000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6e07000-b6ffe000 rw-s 00009000 00:05 28368      /dev/zero (deleted)
b6ffe000-b715b000 rw-s 00000000 00:05 28367      /dev/zero (deleted)
b715b000-b715c000 rw-p 00000000 00:00 0
b715c000-b71fe000 rw-s 0015e000 00:05 28367      /dev/zero (deleted)
b71fe000-b72fe000 rw-s 00000000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b74fe000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
*** Error in `trinity': free(): invalid pointer: 0xb6ffe000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x72658)[0xb75f6658]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
b41d7000-b41f2000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f2000-b41f3000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fc000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rw-s 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6ffe000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6ffe000-b71fe000 rw-s 00000000 00:05 28367      /dev/zero (deleted)
b71fe000-b72fe000 rw-s 00000000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b74fe000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
*** Error in `trinity': double free or corruption (out): 0xb6dfe000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x72658)[0xb75f6658]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
b41d7000-b41f2000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f2000-b41f3000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fc000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rw-s 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6ffe000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6ffe000-b71fe000 rw-s 00000000 00:05 28367      /dev/zero (deleted)
b71fe000-b72fe000 rw-s 00000000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b74fe000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
*** Error in `trinity': free(): invalid pointer: 0xb771f000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x72658)[0xb75f6658]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
08727000-0873f000 rw-p 00000000 00:00 0          [heap]
b41d8000-b41f3000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f4000-b41f5000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fd000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6a58000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6a59000-b6bfe000 rw-s 0025b000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rw-s 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6ffe000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6ffe000-b71fe000 rw-s 00000000 00:05 28367      /dev/zero (deleted)
b71fe000-b728b000 ---s 00000000 00:05 28366      /dev/zero (deleted)
b728b000-b72fe000 rw-s 0008d000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b745d000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b745d000-b74d9000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b74d9000-b74fe000 rw-s 000db000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-p 00000000 00:00 0
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
[watchdog] 10274 iterations. [F:7832 S:2583 HI:289]
*** Error in `trinity': double free or corruption (out): 0xb72fe000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x72658)[0xb75f6658]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
b41d7000-b41f2000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f2000-b41f3000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fc000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rw-s 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6ffe000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6ffe000-b6fff000 rw-s 00001000 00:05 28367      /dev/zero (deleted)
b6fff000-b71fe000 rw-s 00001000 00:05 28367      /dev/zero (deleted)
b71fe000-b72fe000 rw-s 00000000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b74fe000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
*** Error in `trinity': free(): invalid pointer: 0xb5ffe000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x72658)[0xb75f6658]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
b41d7000-b41f2000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f2000-b41f3000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fc000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rw-s 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6ffe000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6ffe000-b71fe000 rw-s 00000000 00:05 28367      /dev/zero (deleted)
b71fe000-b72fe000 rw-s 00000000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b74fe000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
[watchdog] 21492 iterations. [F:16224 S:5550 HI:289]
*** Error in `trinity': free(): invalid pointer: 0xb6bfe000 ***
======= Backtrace:
=========                                                                                                                                         

/lib/libc.so.6(+0x6be1d)[0xb75efe1d]                                                                                                                                 

/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]                                                                                                                                 

/lib/libc.so.6(+0x72658)[0xb75f6658]                                                                                                                                 

trinity(freeptr+0x16)[0x80595a6]                                                                                                                                     

trinity(handle_syscall_ret+0x28)[0x8056e78]                                                                                                                          

trinity(child_random_syscalls+0x2db)[0x8059f8b]                                                                                                                      

trinity(child_process+0x139)[0x8053219]                                                                                                                              

trinity(main_loop+0x1be)[0x805589e]                                                                                                                                  

trinity(main+0x247)[0x8051e57]                                                                                                                                       

/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]                                                                                                                   

trinity[0x8052434]                                                                                                                                                   

======= Memory map:
========                                                                                                                                         

08048000-0807a000 r-xp 00000000 08:04 163106    
/usr/bin/trinity                                                                                                    

0807a000-0807b000 r--p 00032000 08:04 163106    
/usr/bin/trinity                                                                                                    

0807b000-080e4000 rw-p 00033000 08:04 163106    
/usr/bin/trinity                                                                                                    

080e4000-080e5000 rw-p 00000000 00:00
0                                                                                                                              

086a8000-086a9000 rw-p 00000000 00:00 0         
[heap]                                                                                                              

086a9000-086aa000 r--p 00000000 00:00 0         
[heap]                                                                                                              

086aa000-086c9000 rw-p 00000000 00:00 0         
[heap]                                                                                                              

086c9000-08727000 rw-p 00000000 00:00 0         
[heap]                                                                                                              

08727000-08738000 rw-p 00000000 00:00 0         
[heap]                                                                                                              

b41fd000-b41fe000 rw-p 00000000 00:00
0                                                                                                                                                

b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero
(deleted)                                                                                                                   

b4bfe000-b55fe000 rw-s 00000000 00:05 28374      /dev/zero
(deleted)                                                                                                                   

b55fe000-b574c000 rw-s 00000000 00:05 28373      /dev/zero
(deleted)                                                                                                                   

b574c000-b5ffe000 rw-s 0014e000 00:05 28373      /dev/zero
(deleted)                                                                                                                   

b5ffe000-b62a4000 rw-s 00000000 00:05 28372      /dev/zero
(deleted)                                                                                                                   

b62a9000-b62c4000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1                                                                                    

b62c4000-b62c5000 r--p 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1                                                                                                           

b62c5000-b62c6000 rw-p 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1                                                                                                           

b62ce000-b62cf000 rw-p 00000000 00:00
0                                                                                                                                                                       

b62cf000-b63fe000 rw-s 002d1000 00:05 28372      /dev/zero
(deleted)                                                                                                                                                                        

b63fe000-b67fe000 rw-s 00000000 00:05 28371      /dev/zero
(deleted)                                                                                                                                                                        

b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero
(deleted)                                                                                                                                                                        

b6bfe000-b6d51000 rw-s 00000000 00:05 28369      /dev/zero
(deleted)                                                                                                                                                                        

b6d51000-b6dfe000 rw-s 00153000 00:05 28369      /dev/zero
(deleted)                                                                                                                                                                        

b6dfe000-b6ffe000 rw-s 00000000 00:05 28368      /dev/zero
(deleted)                                                                                                                                                                        

b6ffe000-b71fe000 rw-s 00000000 00:05 28367      /dev/zero
(deleted)                                                                                                                                                                        

b71fe000-b72fe000 rw-s 00000000 00:05 28366      /dev/zero
(deleted)                                                                                                                                                                        

b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero
(deleted)                                                                                                                                                                        

b73fe000-b74fe000 rw-s 00000000 00:05 28364      /dev/zero
(deleted)                                                                                                                                                                        

b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero
(deleted)                                                                                                                                                                        

b74ff000-b7500000 rw-s 00000000 00:05 28362      /dev/zero
(deleted)                                                                                                                                                                        

b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero
(deleted)                                                                                                                                                                        

b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero
(deleted)                                                                                                                                                                        

b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero
(deleted)                                                                                                                                                                        

b7583000-b7584000 rw-p 00000000 00:00
0                                                                                                                                                                                                     

b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]
*** Error in `trinity': munmap_chunk(): invalid pointer: 0xb74ff000 ***
======= Backtrace: =========
/lib/libc.so.6(+0x6be1d)[0xb75efe1d]
/lib/libc.so.6(+0x71a0a)[0xb75f5a0a]
/lib/libc.so.6(+0x71ad8)[0xb75f5ad8]
trinity(freeptr+0x16)[0x80595a6]
trinity(handle_syscall_ret+0x28)[0x8056e78]
trinity(child_random_syscalls+0x2db)[0x8059f8b]
trinity(child_process+0x139)[0x8053219]
trinity(main_loop+0x1be)[0x805589e]
trinity(main+0x247)[0x8051e57]
/lib/libc.so.6(__libc_start_main+0xf3)[0xb759d943]
trinity[0x8052434]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 08:04 163106     /usr/bin/trinity
0807a000-0807b000 r--p 00032000 08:04 163106     /usr/bin/trinity
0807b000-080e4000 rw-p 00033000 08:04 163106     /usr/bin/trinity
080e4000-080e5000 rw-p 00000000 00:00 0
086a8000-086a9000 rw-p 00000000 00:00 0          [heap]
086a9000-086aa000 r--p 00000000 00:00 0          [heap]
086aa000-086c9000 rw-p 00000000 00:00 0          [heap]
086c9000-08727000 rw-p 00000000 00:00 0          [heap]
08727000-0873f000 rw-p 00000000 00:00 0          [heap]
b41d8000-b41f3000 r-xp 00000000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f3000-b41f4000 r-xp 0001a000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41f4000-b41f5000 rwxp 0001b000 08:04 188117    
/usr/lib/gcc/i686-pc-linux-gnu/4.8.4/libgcc_s.so.1
b41fd000-b41fe000 rw-p 00000000 00:00 0
b41fe000-b4bfe000 rw-s 00000000 00:05 28375      /dev/zero (deleted)
b4bfe000-b55fe000 rwxs 00000000 00:05 28374      /dev/zero (deleted)
b55fe000-b5ffe000 rw-s 00000000 00:05 28373      /dev/zero (deleted)
b5ffe000-b63fe000 rw-s 00000000 00:05 28372      /dev/zero (deleted)
b63fe000-b67fe000 rwxs 00000000 00:05 28371      /dev/zero (deleted)
b67fe000-b6bfe000 rw-s 00000000 00:05 28370      /dev/zero (deleted)
b6bfe000-b6dfe000 rwxs 00000000 00:05 28369      /dev/zero (deleted)
b6dfe000-b6eab000 rw-s 00000000 00:05 28368      /dev/zero (deleted)
b6eab000-b6ffe000 rw-s 000ad000 00:05 28368      /dev/zero (deleted)
b6ffe000-b71fe000 rw-s 00000000 00:05 28367      /dev/zero (deleted)
b71fe000-b7263000 rw-s 00000000 00:05 28366      /dev/zero (deleted)
b7264000-b72fe000 rw-s 00066000 00:05 28366      /dev/zero (deleted)
b72fe000-b73fe000 rw-s 00000000 00:05 28365      /dev/zero (deleted)
b73fe000-b746d000 rw-s 00000000 00:05 28364      /dev/zero (deleted)
b746d000-b746e000 rwxp 00000000 00:00 0
b746e000-b74fe000 rw-s 00070000 00:05 28364      /dev/zero (deleted)
b74fe000-b74ff000 rw-s 00000000 00:05 28363      /dev/zero (deleted)
b74ff000-b7500000 rwxs 00000000 00:05 28362      /dev/zero (deleted)
b7500000-b750d000 rw-s 00000000 00:05 28359      /dev/zero (deleted)
b750d000-b751a000 rw-s 00000000 00:05 28358      /dev/zero (deleted)
b751a000-b7583000 rw-s 00000000 00:05 28356      /dev/zero (deleted)
b7583000-b7584000 rw-p 00000000 00:00 0
b7584000-b7718000 r-xp 00000000 08:04 225655     /lib/libc-2.20.so
b7718000-b7719000 ---p 00194000 08:04 225655     /lib/libc-2.20.so
b7719000-b771b000 r--p 00194000 08:04 225655     /lib/libc-2.20.so
b771b000-b771c000 rw-p 00196000 08:04 225655     /lib/libc-2.20.so
b771c000-b771f000 rw-p 00000000 00:00 0
b771f000-b7720000 rw-s 00000000 00:05 28361      /dev/zero (deleted)
b7720000-b7721000 rw-p 00000000 00:00 0
b7721000-b7726000 rw-s 00000000 00:05 28357      /dev/zero (deleted)
b7726000-b7728000 rw-p 00000000 00:00 0
b7728000-b772a000 r--p 00000000 00:00 0          [vvar]
b772a000-b772c000 r-xp 00000000 00:00 0          [vdso]
b772c000-b774c000 r-xp 00000000 08:04 225656     /lib/ld-2.20.so
b774c000-b774d000 r--p 0001f000 08:04 225656     /lib/ld-2.20.so
b774d000-b774e000 rw-p 00020000 08:04 225656     /lib/ld-2.20.so
bfaad000-bface000 rw-p 00000000 00:00 0          [stack]

-- 
Toralf, pgp key: 872AE508 0076E94E
