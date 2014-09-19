From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Error in `trinity': free(): invalid next size (normal): 0x08683438
 ***
Date: Fri, 19 Sep 2014 23:31:36 +0200
Message-ID: <541CA0B8.4060809@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

After a rather longer time w/o any issue I saw today this at a 32 bit Gentoox86 Linux KVM guest w/ v1.4-611-g01c61fc :

...
[child1:18922] <timed out>
[child1:18933] <timed out>
*** Error in `trinity': free(): invalid next size (normal): 0x08683438 ***
======= Backtrace: =========
/lib/libc.so.6(+0x734ef)[0xb76064ef]
/lib/libc.so.6(+0x79992)[0xb760c992]
/lib/libc.so.6(+0x7aac1)[0xb760dac1]
trinity(output_syscall_prefix+0x1b5)[0x8054465]
trinity(child_random_syscalls+0x1ce)[0x805f52e]
trinity(child_process+0x7e)[0x8054f8e]
trinity(main_loop+0x1f9)[0x8059469]
trinity(main+0x254)[0x8053b94]
/lib/libc.so.6(__libc_start_main+0xf5)[0xb75afee5]
trinity[0x8054135]
======= Memory map: ========
08048000-0807a000 r-xp 00000000 fe:04 156960     /usr/bin/trinity
0807a000-0807b000 r--p 00031000 fe:04 156960     /usr/bin/trinity
0807b000-080e4000 rw-p 00032000 fe:04 156960     /usr/bin/trinity
0865e000-0867f000 rw-p 00000000 00:00 0          [heap]
0867f000-086a0000 rw-p 00000000 00:00 0          [heap]
b41c4000-b41e0000 r-xp 00000000 fe:04 270617     /usr/lib/gcc/i686-pc-linux-gnu/4.7.3/libgcc_s.so.1
b41e0000-b41e1000 r--p 0001b000 fe:04 270617     /usr/lib/gcc/i686-pc-linux-gnu/4.7.3/libgcc_s.so.1
b41e1000-b41e2000 rw-p 0001c000 fe:04 270617     /usr/lib/gcc/i686-pc-linux-gnu/4.7.3/libgcc_s.so.1
b41e9000-b4be9000 -w-s 00000000 00:04 75464      /dev/zero (deleted)
b4be9000-b55e9000 r--s 00000000 00:04 75463      /dev/zero (deleted)
b55e9000-b5fe9000 rw-s 00000000 00:04 75462      /dev/zero (deleted)
b5fe9000-b63e9000 -w-s 00000000 00:04 75461      /dev/zero (deleted)
b63e9000-b67e9000 r--s 00000000 00:04 75460      /dev/zero (deleted)
b67e9000-b6be9000 rw-s 00000000 00:04 75459      /dev/zero (deleted)
b6be9000-b6de9000 -w-s 00000000 00:04 75458      /dev/zero (deleted)
b6de9000-b6fe9000 rw-s 00000000 00:04 75457      /dev/zero (deleted)
b6fe9000-b71e9000 rw-s 00000000 00:04 75456      /dev/zero (deleted)
b71e9000-b72e9000 rw-s 00000000 00:04 75455      /dev/zero (deleted)
b72e9000-b73e9000 r--s 00000000 00:04 75454      /dev/zero (deleted)
b73e9000-b74e9000 rw-s 00000000 00:04 75453      /dev/zero (deleted)
b74e9000-b74eb000 -w-s 00000000 00:04 75452      /dev/zero (deleted)
b74eb000-b74ed000 r--s 00000000 00:04 75451      /dev/zero (deleted)
b74ed000-b750b000 ---s 00000000 00:04 75446      /dev/zero (deleted)
b750b000-b7510000 rw-s 0001e000 00:04 75446      /dev/zero (deleted)
b7510000-b752e000 ---s 00023000 00:04 75446      /dev/zero (deleted)
b752e000-b7592000 rw-s 00000000 00:04 75445      /dev/zero (deleted)
b7592000-b7593000 rw-p 00000000 00:00 0 
b7593000-b7738000 r-xp 00000000 fe:04 267078     /lib/libc-2.19.so
b7738000-b7739000 ---p 001a5000 fe:04 267078     /lib/libc-2.19.so
b7739000-b773b000 r--p 001a5000 fe:04 267078     /lib/libc-2.19.so
b773b000-b773c000 rw-p 001a7000 fe:04 267078     /lib/libc-2.19.so
b773c000-b773f000 rw-p 00000000 00:00 0 
b773f000-b7740000 rw-p 00000000 00:00 0 
b7740000-b7741000 rw-s 00000000 00:04 75450      /dev/zero (deleted)
b7741000-b7742000 rw-p 00000000 00:00 0
b7742000-b7743000 rw-s 00000000 00:04 75449      /dev/zero (deleted)
b7743000-b7744000 rw-s 00000000 00:04 75448      /dev/zero (deleted)
b7744000-b7746000 rw-p 00000000 00:00 0
b7746000-b7748000 r--p 00000000 00:00 0          [vvar]
b7748000-b774a000 r-xp 00000000 00:00 0          [vdso]
b774a000-b776a000 r-xp 00000000 fe:04 267077     /lib/ld-2.19.so
b776a000-b776b000 rw-p 00000000 00:00 0
b776b000-b776c000 r--p 0001f000 fe:04 267077     /lib/ld-2.19.so
b776c000-b776d000 rw-p 00020000 fe:04 267077     /lib/ld-2.19.so
bf92e000-bf94f000 rw-p 00000000 00:00 0          [stack]
[child0:18948] <timed out>
[child0:18948] <timed out>
[child0:18959] <timed out>


-- 
Toralf
pgp key: 0076 E94E
