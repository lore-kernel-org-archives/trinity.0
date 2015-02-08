From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: BUG!: unreachable! BUG!: [29809] generate-args.c:fill_arg:360
Date: Sun, 08 Feb 2015 11:41:49 +0100
Message-ID: <54D73D6D.90003@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

Today I got at a 32 bit stable Gentoo Linux w/ kernel 3.19.0-rc6 KVM gave :

tfoerste@t44 ~/devel/glibc $ ssh tfoerste@n22kvm-clone

tfoerste@n22kvm-clone ~ $ cd /mnt/ramdisk/ && rm -rf t3 && mkdir t3 &&
cd t3 && trinity -C5 -qq
Trinity 9  Dave Jones <davej@codemonkey.org.uk>
shm: redzone:0xb74d2000. shmdata:0xb74f0000. redzone:0xb74f5000
end:0xb7513000.
[init] Registered 9 fd providers.
[init] Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 359 syscalls. Disabled 0 syscalls.
[init] Using pid_max = 32768
[init] Started watchdog process, PID is 2214
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] created 375 sockets
[main] Generating file descriptors
[main] Added 31 filenames from /dev
[main] Added 10716 filenames from /proc
[main] Added 6372 filenames from /sys
[main] Enabled 9 fd providers.
[watchdog] Watchdog is alive. (pid:2214)
[child4:16349] migrate_pages (294) returned ENOSYS, marking as inactive.
[child0:16344] sysctl (149) returned ENOSYS, marking as inactive.
[child4:16349] kcmp (349) returned ENOSYS, marking as inactive.
[child4:16349] move_pages (317) returned ENOSYS, marking as inactive.
[child4:16349] bpf (357) returned ENOSYS, marking as inactive.
[child0:16344] nfsservctl (169) returned ENOSYS, marking as inactive.
[child2:16346] kcmp (349) returned ENOSYS, marking as inactive.
[child2:16346] quotactl (131) returned ENOSYS, marking as inactive.
[child0:16344] open_by_handle_at (342) returned ENOSYS, marking as inactive.
[child2:16346] mbind (274) returned ENOSYS, marking as inactive.
[child2:16346] set_mempolicy (276) returned ENOSYS, marking as inactive.
[child2:16346] name_to_handle_at (341) returned ENOSYS, marking as inactive.
[child2:16346] get_mempolicy (275) returned ENOSYS, marking as inactive.
[child2:16346] lookup_dcookie (253) returned ENOSYS, marking as inactive.
[watchdog] 11766 iterations. [F:9280 S:2486 HI:1026]
[watchdog] 22841 iterations. [F:18016 S:4826 HI:1637]
[watchdog] 32906 iterations. [F:25907 S:7000 HI:1637]
[watchdog] 43358 iterations. [F:34090 S:9269 HI:1637]
[watchdog] 53453 iterations. [F:42043 S:11411 HI:1637]
[watchdog] 63824 iterations. [F:50153 S:13672 HI:1765]
[watchdog] 74406 iterations. [F:58421 S:15987 HI:1765]
[watchdog] 84951 iterations. [F:66666 S:18287 HI:1765]
[watchdog] 95146 iterations. [F:74687 S:20461 HI:1765]
[watchdog] 105485 iterations. [F:82842 S:22645 HI:1765]
[watchdog] 116212 iterations. [F:91255 S:24959 HI:1765]
[watchdog] 126310 iterations. [F:99190 S:27123 HI:2120]
[watchdog] 136361 iterations. [F:107139 S:29225 HI:2120]
[watchdog] 146880 iterations. [F:115432 S:31451 HI:2120]
[watchdog] 156908 iterations. [F:123296 S:33615 HI:2120]
[watchdog] 168118 iterations. [F:132082 S:36039 HI:2120]
[watchdog] 178427 iterations. [F:140205 S:38225 HI:2120]
[watchdog] 189106 iterations. [F:148584 S:40525 HI:2120]
[watchdog] 199955 iterations. [F:157034 S:42924 HI:2120]
[watchdog] 210768 iterations. [F:165460 S:45311 HI:2120]
[watchdog] 221753 iterations. [F:174103 S:47653 HI:2120]
[watchdog] 231791 iterations. [F:181980 S:49814 HI:2963]
[watchdog] 244421 iterations. [F:191918 S:52506 HI:2963]
[watchdog] 255049 iterations. [F:200329 S:54724 HI:2963]
[watchdog] 265268 iterations. [F:208400 S:56872 HI:2963]
[watchdog] 275414 iterations. [F:216394 S:59024 HI:2963]
[watchdog] 285689 iterations. [F:224522 S:61171 HI:2963]
[watchdog] 295738 iterations. [F:232430 S:63312 HI:2963]
[watchdog] 306838 iterations. [F:241206 S:65636 HI:2963]
[watchdog] 317117 iterations. [F:249249 S:67872 HI:2963]
[watchdog] 329288 iterations. [F:258819 S:70473 HI:2963]
[watchdog] 340106 iterations. [F:267303 S:72807 HI:2963]
[watchdog] 351211 iterations. [F:275988 S:75228 HI:2963]
[watchdog] 361501 iterations. [F:284054 S:77451 HI:2963]
[watchdog] 371625 iterations. [F:291999 S:79631 HI:2963]
[watchdog] 381927 iterations. [F:300087 S:81845 HI:2963]
[watchdog] 392381 iterations. [F:308284 S:84102 HI:2963]
[watchdog] 402557 iterations. [F:316273 S:86289 HI:2963]
[watchdog] 413385 iterations. [F:324745 S:88645 HI:2963]
[watchdog] 423479 iterations. [F:332678 S:90806 HI:2963]
[watchdog] 433555 iterations. [F:340566 S:92994 HI:2963]
[watchdog] 443979 iterations. [F:348803 S:95181 HI:2963]
[watchdog] 454601 iterations. [F:357089 S:97516 HI:2963]
[watchdog] 464719 iterations. [F:365012 S:99711 HI:2963]
[watchdog] 475510 iterations. [F:373402 S:102112 HI:2963]
[watchdog] 486005 iterations. [F:381676 S:104333 HI:2963]
[watchdog] 496163 iterations. [F:389670 S:106497 HI:2963]
[watchdog] 506869 iterations. [F:398101 S:108772 HI:2963]
[watchdog] 516922 iterations. [F:405952 S:110974 HI:2963]
[watchdog] 527148 iterations. [F:413973 S:113179 HI:2963]
[watchdog] 537454 iterations. [F:422038 S:115420 HI:2963]
[watchdog] 548002 iterations. [F:430363 S:117643 HI:2963]
[watchdog] 559194 iterations. [F:439175 S:120024 HI:2963]
[watchdog] 569699 iterations. [F:447467 S:122237 HI:2963]
[watchdog] 579812 iterations. [F:455375 S:124442 HI:2963]
[watchdog] 591078 iterations. [F:464265 S:126818 HI:2963]
[watchdog] 601469 iterations. [F:472442 S:129032 HI:2963]
[watchdog] 612223 iterations. [F:480861 S:131366 HI:2963]
[watchdog] 623546 iterations. [F:489717 S:133833 HI:2963]
[watchdog] 633953 iterations. [F:497935 S:136022 HI:2963]
BUG!: unreachable!

BUG!: 9
BUG!: [29809] generate-args.c:fill_arg:360
BUG!: unreachable!

BUG!: 9
BUG!: [29814] generate-args.c:fill_arg:360
[child3:29814] trinity(show_backtrace+0x32) [0x80533c2]
[child3:29814] trinity(__BUG+0x85) [0x80534c5]
[child3:29814] trinity() [0x80569ac]
[child3:29814] trinity(generic_sanitise+0xd4) [0x8056c04]
[child3:29814] trinity(generate_syscall_args+0x5f) [0x8056ccf]
[child3:29814] trinity(child_random_syscalls+0x1c1) [0x805d541]
[child3:29814] trinity(child_process+0x85) [0x8053025]
[child3:29814] trinity(main_loop+0x1be) [0x8057f4e]
[child3:29814] trinity(main+0x269) [0x8051d29]
[child3:29814] /lib/libc.so.6(__libc_start_main+0xf5) [0xb7594ee5]
[child3:29814] trinity() [0x80522c5]
BUG!: unreachable!

BUG!: 9
BUG!: [29828] generate-args.c:fill_arg:360
[child1:29828] trinity(show_backtrace+0x32) [0x80533c2]
[child1:29828] trinity(__BUG+0x85) [0x80534c5]
[child1:29828] trinity() [0x80569ac]
[child1:29828] trinity(generic_sanitise+0xd4) [0x8056c04]
[child1:29828] trinity(generate_syscall_args+0x5f) [0x8056ccf]
[child1:29828] trinity(child_random_syscalls+0x1c1) [0x805d541]
[child1:29828] trinity(child_process+0x85) [0x8053025]
[child1:29828] trinity(main_loop+0x1be) [0x8057f4e]
[child1:29828] trinity(main+0x269) [0x8051d29]
[child1:29828] /lib/libc.so.6(__libc_start_main+0xf5) [0xb7594ee5]
[child1:29828] trinity() [0x80522c5]
BUG!: unreachable!

BUG!: 9
BUG!: [29831] generate-args.c:fill_arg:360
[child0:29831] trinity(show_backtrace+0x32) [0x80533c2]
[child0:29831] trinity(__BUG+0x85) [0x80534c5]
[child0:29831] trinity() [0x80569ac]
[child0:29831] trinity(generic_sanitise+0xd4) [0x8056c04]
[child0:29831] trinity(generate_syscall_args+0x5f) [0x8056ccf]
[child0:29831] trinity(child_random_syscalls+0x1c1) [0x805d541]
[child0:29831] trinity(child_process+0x85) [0x8053025]
[child0:29831] trinity(main_loop+0x1be) [0x8057f4e]
[child0:29831] trinity(main+0x269) [0x8051d29]
[child0:29831] /lib/libc.so.6(__libc_start_main+0xf5) [0xb7594ee5]
[child0:29831] trinity() [0x80522c5]
BUG!: unreachable!

BUG!: 9
BUG!: [29834] generate-args.c:fill_arg:360
[child4:29834] trinity(show_backtrace+0x32) [0x80533c2]
[child4:29834] trinity(__BUG+0x85) [0x80534c5]
[child4:29834] trinity() [0x80569ac]
[child4:29834] trinity(generic_sanitise+0xd4) [0x8056c04]
[child4:29834] trinity(generate_syscall_args+0x5f) [0x8056ccf]
[child4:29834] trinity(child_random_syscalls+0x1c1) [0x805d541]
[child4:29834] trinity(child_process+0x85) [0x8053025]
[child4:29834] trinity(main_loop+0x1be) [0x8057f4e]
[child4:29834] trinity(main+0x269) [0x8051d29]
[child4:29834] /lib/libc.so.6(__libc_start_main+0xf5) [0xb7594ee5]
[child4:29834] trinity() [0x80522c5]
^C[main] Bailing main loop because ctrl-c.
^C[watchdog] [2214] Watchdog exiting because ctrl-c.

[init] Ran 641555 syscalls. Successes: 137664  Failures: 503896


-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
