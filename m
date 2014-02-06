From: Vince Weaver <vincent.weaver@maine.edu>
Subject: trinity: lots of corrupted double-linked list errors when run on
 x32
Date: Thu, 6 Feb 2014 11:45:49 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1402061142030.17478@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


I'm running trinity compiled for x32 (by adding -mx32 to the CFLAGS
and -static in the LDFLGAS as for some reason my debian system with x32 
libs installed gives "FATAL: kernel too old" if I try to run the 
dynamically linked version).

Anyway I think glibc is reporting these particular errors.  Should I try 
tracking them down?  Or is this normal when running trinity?

Vince

*** Error in `./trinity': corrupted double-linked list: 0x018c31f8 ***
*** Error in `./trinity': corrupted double-linked list: 0x01a68038 ***
*** Error in `./trinity': corrupted double-linked list: 0x0170a448 ***
*** Error in `./trinity': corrupted double-linked list: 0x01a0cd08 ***
*** Error in `./trinity': free(): invalid size: 0x01a150d0 ***
======= Backtrace: =========
[0x41e3de]
[0x41f10c]
[0x408b9a]
[0x40bd07]
[0x401a56]
[0x405138]
[0x400fcc]
[0x413862]
[0x4015a2]
======= Memory map: ========
00400000-004eb000 r-xp 00000000 08:01 1318269                            
/home/vince/research/trinity/trinity.git/trinity
006ea000-00749000 rw-p 000ea000 08:01 1318269                            
/home/vince/research/trinity/trinity.git/trinity
00749000-0074a000 rw-p 00000000 00:00 0 
01195000-015b6000 rw-p 00000000 00:00 0                                  
[heap]
015b6000-0189e000 rw-p 00000000 00:00 0                                  
[heap]
0189e000-01a17000 rw-p 00000000 00:00 0                                  
[heap]
f3434000-f3e34000 -w-s 00000000 00:03 21531                              
/dev/zero (deleted)
f3e34000-f4834000 r--s 00000000 00:03 21530                              
/dev/zero (deleted)
f4834000-f5234000 rw-s 00000000 00:03 21529                              
/dev/zero (deleted)
f5234000-f5634000 -w-s 00000000 00:03 21528                              
/dev/zero (deleted)
f5634000-f5a34000 r--s 00000000 00:03 21527                              
/dev/zero (deleted)
f5a34000-f5e34000 rw-s 00000000 00:03 21526                              
/dev/zero (deleted)
f5e34000-f6034000 -w-s 00000000 00:03 21525                              
/dev/zero (deleted)
f6034000-f6234000 r--s 00000000 00:03 21524                              
/dev/zero (deleted)
f6234000-f6434000 rw-s 00000000 00:03 21523                              
/dev/zero (deleted)
f6434000-f6534000 -w-s 00000000 00:03 21522                              
/dev/zero (deleted)
f6634000-f6734000 rw-s 00000000 00:03 21520                              
/dev/zero (deleted)
f6734000-f6752000 ---s 00000000 00:03 21516                              
/dev/zero (deleted)
f6752000-f675e000 rw-s 0001e000 00:03 21516                              
/dev/zero (deleted)
f675e000-f677c000 ---s 0002a000 00:03 21516                              
/dev/zero (deleted)
f677c000-f67d3000 rw-s 00000000 00:03 21515                              
/dev/zero (deleted)
f67d3000-f6821000 rw-s 00000000 00:03 21514                              
/dev/zero (deleted)
f6821000-f682c000 r-xp 00000000 08:01 1181188                            
/libx32/libnss_files-2.17.so
f682c000-f6a2b000 ---p 0000b000 08:01 1181188                            
/libx32/libnss_files-2.17.so
f6a2b000-f6a2c000 r--p 0000a000 08:01 1181188                            
/libx32/libnss_files-2.17.so
f6a2c000-f6a2d000 rw-p 0000b000 08:01 1181188                            
/libx32/libnss_files-2.17.so
f6a2d000-f6a37000 r-xp 00000000 08:01 1181186                            
/libx32/libnss_nis-2.17.so
f6a37000-f6c36000 ---p 0000a000 08:01 1181186                            
/libx32/libnss_nis-2.17.so
f6c36000-f6c37000 r--p 00009000 08:01 1181186                            
/libx32/libnss_nis-2.17.so
f6c37000-f6c38000 rw-p 0000a000 08:01 1181186                            
/libx32/libnss_nis-2.17.so
f6c38000-f6d38000 rw-p 00000000 00:00 0 
f6d38000-f6d59000 r-xp 00000000 08:01 1181182                            
/libx32/ld-2.17.so
f6d59000-f6f58000 ---p 00021000 08:01 1181182                            
/libx32/ld-2.17.so
f6f58000-f6f59000 r--p 00020000 08:01 1181182                            
/libx32/ld-2.17.so
f6f59000-f6f5a000 rw-p 00021000 08:01 1181182                            
/libx32/ld-2.17.so
f6f5a000-f70f6000 r-xp 00000000 08:01 1181192                            
/libx32/libc-2.17.so
f70f6000-f72f6000 ---p 0019c000 08:01 1181192                            
/libx32/libc-2.17.so
f72f6000-f72f8000 r--p 0019c000 08:01 1181192                            
/libx32/libc-2.17.so
f72f8000-f72f9000 rw-p 0019e000 08:01 1181192                            
/libx32/libc-2.17.so
f72f9000-f72fc000 rw-p 00000000 00:00 0 
f72fc000-f7310000 r-xp 00000000 08:01 1181545                            
/libx32/libnsl-2.17.so
f7310000-f750f000 ---p 00014000 08:01 1181545                            
/libx32/libnsl-2.17.so*** Error in `./trinity': corrupted double-linked 
list: 0x017ae008 ***
*** Error in `./trinity': corrupted double-linked list: 0x0193b618 ***

