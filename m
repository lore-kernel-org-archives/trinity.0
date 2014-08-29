From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: compile error of trinity related to an outdated gcc ?
Date: Fri, 29 Aug 2014 18:43:53 +0200
Message-ID: <5400ADC9.1090000@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

I'm wondering why I can't compile trinity within a KVM running an 32 bit x86 Gentoo Linux whereas I can compile the same package within a user mode linuc chroot environment image having also a x86 Gentoo.

The only difference seems to be the compiler (gcc-4.8.3 in UML works) whereas within KVM I do have the gcc 4.7.3-r1


n22kvm ~ # emerge trinity

These are the packages that would be merged, in reverse order:

Calculating dependencies  .... done!
[ebuild  N    ~] dev-util/trinity-9  USE="-examples" 

>>> Verifying ebuild manifests
>>> Emerging (1 of 1) dev-util/trinity-9 from toralf
>>> Failed to emerge dev-util/trinity-9, Log file:
>>>  '/var/log/portage/dev-util:trinity-9:20140829-163835.log.gz'
>>> Jobs: 0 of 1 complete, 1 failed                 Load avg: 0.94, 0.61, 0.29
 * Package:    dev-util/trinity-9
 * Repository: toralf
 * USE:        abi_x86_32 elibc_glibc kernel_linux userland_GNU x86
 * FEATURES:   compressdebug preserve-libs sandbox splitdebug userpriv usersandbox
>>> Unpacking source...
>>> Unpacking trinity-9.tar.xz to /var/tmp/portage/dev-util/trinity-9/work
>>> Source unpacked in /var/tmp/portage/dev-util/trinity-9/work
>>> Preparing source in /var/tmp/portage/dev-util/trinity-9/work/trinity-9 ...
>>> Source prepared.
>>> Configuring source in /var/tmp/portage/dev-util/trinity-9/work/trinity-9 ...
[*] Checking system headers.
[*] Checking if pppox can use pppol2tpin6..  [YES] 
[*] Checking if pppox can use pppol2tv3..  [YES] 
[*] Checking if pppox can use pptp..  [YES] 
[*] Checking if llc can use LLC_OPT_PKTINFO..  [YES] 
[*] Checking if glibc headers provide termios2..  [NO] 
[*] Checking header linux/caif/caif_socket.h ...  [YES] 
[*] Checking header linux/if_alg.h ...  [YES] 
[*] Checking header linux/rds.h ...  [YES] 
[*] Checking header linux/vfio.h ...  [YES] 
[*] Checking header linux/btrfs.h ...  [YES] 
[*] Checking header drm/drm.h ...  [NO] 
[*] Checking header drm/exynos_drm.h ...  [NO] 
[*] Checking header sound/compress_offload.h ...  [YES] 
[*] Checking header linux/kvm.h ...  [YES] 
[*] Checking header linux/seccomp.h ...  [YES] 
[*] Checking header linux/vhost.h ...  [YES] 
[-] Some header definitions were missing. This is not fatal.
    It usually means you're building on an older distribution which doesn't
    have header files describing newer kernel features.
    Trinity will still compile and run, it just won't use those new features.
    Go ahead, and run 'make'
>>> Source configured.
>>> Compiling source in /var/tmp/portage/dev-util/trinity-9/work/trinity-9 ...
make -j2 V=1 
i686-pc-linux-gnu-gcc -O2 -march=i686 -pipe -g -ggdb -Wall -W -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-statement -Wformat=2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3  -o arg-decoder.o -c arg-decoder.c
fatal: Not a git repository (or any of the parent directories): .git
i686-pc-linux-gnu-gcc -O2 -march=i686 -pipe -g -ggdb -Wall -W -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-statement -Wformat=2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3  -o blockdevs.o -c blockdevs.c
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by default]
arg-decoder.c:1:0: note: this is the location of the previous definition
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by default]
blockdevs.c:1:0: note: this is the location of the previous definition
i686-pc-linux-gnu-gcc -O2 -march=i686 -pipe -g -ggdb -Wall -W -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-statement -Wformat=2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3  -o child.o -c child.c
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by default]
child.c:1:0: note: this is the location of the previous definition
i686-pc-linux-gnu-gcc -O2 -march=i686 -pipe -g -ggdb -Wall -W -g -O2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D__linux__ -Wdeclaration-after-statement -Wformat=2 -Winit-self -Wnested-externs -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-format-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Wstrict-aliasing=3  -o debug.o -c debug.c
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by default]
debug.c:1:0: note: this is the location of the previous definition
debug.c:15:21: fatal error: version.h: No such file or directory
compilation terminated.
make: *** [debug.o] Error 1
make: *** Waiting for unfinished jobs....
 * ERROR: dev-util/trinity-9::toralf failed (compile phase):
 *   emake failed
 *
 

-- 
Toralf
pgp key: 0076 E94E
