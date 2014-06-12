From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: *** Error in `trinity': double free or corruption (!prev): 0x08208e78
 ***
Date: Thu, 12 Jun 2014 23:04:30 +0200
Message-ID: <539A15DE.7020101@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

Just like to report this in case it is an unknown issue:

The current trinity git tree gives with kernel 3.15-x something like the following at a 32 bit stable Gentoo Linux user mode linux guest :



tfoerste@n22 ~ $ nice trinity.sh -t "-q -q -q" -u "-l /usr/local/bin/linux-v3.15"
 starting UML ...  UML started

 prepare trinity job at Thu Jun 12 22:54:29 CEST 2014 1#-1, M=
Trinity v1.5pre  Dave Jones <davej@redhat.com>                               <------- and I'm wondering if here something like "git describe --tags" should be add too to the version string ?
Done parsing arguments.      
Marking all syscalls as enabled.
*** Error in `trinity': double free or corruption (!prev): 0x08208e78 ***
======= Backtrace: =========
/lib/libc.so.6(+0x7a202)[0x400a3202]
/lib/libc.so.6(+0x7af80)[0x400a3f80]
trinity(mkcall+0x17a)[0x805b09a]
trinity(child_process+0x95)[0x80548f5]
trinity(main_loop+0x1e3)[0x80583d3]
trinity(main+0x252)[0x8053712]
/lib/libc.so.6(__libc_start_main+0xf5)[0x40045cc5]
trinity[0x8053c95]
======= Memory map: ========
00100000-00102000 r-xp 00000000 00:00 0 
08048000-08079000 r-xp 00000000 62:00 75867      /usr/bin/trinity
08079000-0807a000 r--p 00030000 62:00 75867      /usr/bin/trinity
0807a000-080d7000 rw-p 00031000 62:00 75867      /usr/bin/trinity
080d7000-080f8000 rw-p 00000000 00:00 0          [heap]
080f8000-0817f000 rw-p 00000000 00:00 0          [heap]
0817f000-083b0000 rw-p 00000000 00:00 0          [heap]
40000000-40020000 r-xp 00000000 62:00 31279      /lib/ld-2.17.so
40020000-40021000 r--p 0001f000 62:00 31279      /lib/ld-2.17.so
40021000-40022000 rw-p 00020000 62:00 31279      /lib/ld-2.17.so
40022000-40023000 rw-p 00000000 00:00 0 
40023000-40024000 rw-s 00000000 00:04 1569       /dev/zero (deleted)
40024000-40026000 rw-p 00000000 00:00 0 
40026000-40028000 rw-s 00000000 00:04 1572       /dev/zero (deleted)
40028000-40029000 rw-p 00000000 00:00 0 
40029000-401d1000 r-xp 00000000 62:00 31281      /lib/libc-2.17.so
401d1000-401d3000 r--p 001a8000 62:00 31281      /lib/libc-2.17.so
401d3000-401d4000 rw-p 001aa000 62:00 31281      /lib/libc-2.17.so
401d4000-401d8000 rw-p 00000000 00:00 0 
401d8000-40230000 rw-s 00000000 00:04 1567       /dev/zero (deleted)
40230000-4024e000 ---s 00000000 00:04 1568       /dev/zero (deleted)
4024e000-40253000 rw-s 0001e000 00:04 1568       /dev/zero (deleted)
40253000-40271000 ---s 00023000 00:04 1568       /dev/zero (deleted)
40271000-4027e000 rw-s 00000000 00:04 1570       /dev/zero (deleted)
4027e000-40280000 rw-s 00000000 00:04 1573       /dev/zero (deleted)
40280000-40282000 rw-s 00000000 00:04 1574       /dev/zero (deleted)
40282000-40382000 rw-s 00000000 00:04 1575       /dev/zero (deleted)
40382000-40482000 rw-s 00000000 00:04 1576       /dev/zero (deleted)
40482000-404c6000 rw-s 00000000 00:04 1577       /dev/zero (deleted)
404c6000-404c7000 rw-p 00000000 00:00 0
404c7000-40582000 rw-s 00045000 00:04 1577       /dev/zero (deleted)
40582000-40782000 rw-s 00000000 00:04 1578       /dev/zero (deleted)
40782000-40982000 rw-s 00000000 00:04 1579       /dev/zero (deleted)
40982000-40b82000 rw-s 00000000 00:04 1580       /dev/zero (deleted)
40b82000-40f82000 rw-s 00000000 00:04 1581       /dev/zero (deleted)
40f82000-41382000 rw-s 00000000 00:04 1582       /dev/zero (deleted)
41382000-41782000 rw-s 00000000 00:04 1583       /dev/zero (deleted)
41782000-42182000 rw-s 00000000 00:04 1584       /dev/zero (deleted)
42182000-42b82000 rw-s 00000000 00:04 1585       /dev/zero (deleted)
42b82000-43582000 rw-s 00000000 00:04 1586       /dev/zero (deleted)
43588000-435a2000 r-xp 00000000 62:00 28288      /usr/lib/gcc/i686-pc-linux-gnu/4.7.3/libgcc_s.so.1
435a2000-435a3000 r--p 00019000 62:00 28288      /usr/lib/gcc/i686-pc-linux-gnu/4.7.3/libgcc_s.so.1
435a3000-435a4000 rw-p 0001a000 62:00 28288      /usr/lib/gcc/i686-pc-linux-gnu/4.7.3/libgcc_s.so.1
bfc89000-bfcaa000 rw-p 00000000 00:00 0




-- 
Toralf
