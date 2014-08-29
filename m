From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: compile error of trinity related to an outdated gcc ?
Date: Fri, 29 Aug 2014 19:01:09 +0200
Message-ID: <5400B1D5.5030104@gmx.de>
References: <5400ADC9.1090000@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <5400ADC9.1090000@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

ick, solved that issue by tweaking the Makefile, but there's another cu=
lprit  to build it:

=2E..
cal-op -Wstrict-aliasing=3D3  -o debug.o -c debug.c
debug.c:15:21: fatal error: version.h: No such file or directory
compilation terminated.
make: *** [debug.o] Error 1
make: *** Waiting for unfinished jobs....
 * ERROR: dev-util/trinity-9::toralf failed (compile phase):
 *   emake failed


This happens in a KVM machine where I build it with the same Gentoo ebu=
ild definition file as in a UML chroot environment, the difference is j=
ust the fact, that git is installed within the KVM , but not within the=
 UML.




On 08/29/2014 06:43 PM, Toralf F=C3=B6rster wrote:
> I'm wondering why I can't compile trinity within a KVM running an 32 =
bit x86 Gentoo Linux whereas I can compile the same package within a us=
er mode linuc chroot environment image having also a x86 Gentoo.
>=20
> The only difference seems to be the compiler (gcc-4.8.3 in UML works)=
 whereas within KVM I do have the gcc 4.7.3-r1
>=20
>=20
> n22kvm ~ # emerge trinity
>=20
> These are the packages that would be merged, in reverse order:
>=20
> Calculating dependencies  .... done!
> [ebuild  N    ~] dev-util/trinity-9  USE=3D"-examples"=20
>=20
>>>> Verifying ebuild manifests
>>>> Emerging (1 of 1) dev-util/trinity-9 from toralf
>>>> Failed to emerge dev-util/trinity-9, Log file:
>>>>  '/var/log/portage/dev-util:trinity-9:20140829-163835.log.gz'
>>>> Jobs: 0 of 1 complete, 1 failed                 Load avg: 0.94, 0.=
61, 0.29
>  * Package:    dev-util/trinity-9
>  * Repository: toralf
>  * USE:        abi_x86_32 elibc_glibc kernel_linux userland_GNU x86
>  * FEATURES:   compressdebug preserve-libs sandbox splitdebug userpri=
v usersandbox
>>>> Unpacking source...
>>>> Unpacking trinity-9.tar.xz to /var/tmp/portage/dev-util/trinity-9/=
work
>>>> Source unpacked in /var/tmp/portage/dev-util/trinity-9/work
>>>> Preparing source in /var/tmp/portage/dev-util/trinity-9/work/trini=
ty-9 ...
>>>> Source prepared.
>>>> Configuring source in /var/tmp/portage/dev-util/trinity-9/work/tri=
nity-9 ...
> [*] Checking system headers.
> [*] Checking if pppox can use pppol2tpin6..  [YES]=20
> [*] Checking if pppox can use pppol2tv3..  [YES]=20
> [*] Checking if pppox can use pptp..  [YES]=20
> [*] Checking if llc can use LLC_OPT_PKTINFO..  [YES]=20
> [*] Checking if glibc headers provide termios2..  [NO]=20
> [*] Checking header linux/caif/caif_socket.h ...  [YES]=20
> [*] Checking header linux/if_alg.h ...  [YES]=20
> [*] Checking header linux/rds.h ...  [YES]=20
> [*] Checking header linux/vfio.h ...  [YES]=20
> [*] Checking header linux/btrfs.h ...  [YES]=20
> [*] Checking header drm/drm.h ...  [NO]=20
> [*] Checking header drm/exynos_drm.h ...  [NO]=20
> [*] Checking header sound/compress_offload.h ...  [YES]=20
> [*] Checking header linux/kvm.h ...  [YES]=20
> [*] Checking header linux/seccomp.h ...  [YES]=20
> [*] Checking header linux/vhost.h ...  [YES]=20
> [-] Some header definitions were missing. This is not fatal.
>     It usually means you're building on an older distribution which d=
oesn't
>     have header files describing newer kernel features.
>     Trinity will still compile and run, it just won't use those new f=
eatures.
>     Go ahead, and run 'make'
>>>> Source configured.
>>>> Compiling source in /var/tmp/portage/dev-util/trinity-9/work/trini=
ty-9 ...
> make -j2 V=3D1=20
> i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W -g -O=
2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=3D2 -D_GNU_SOURCE -D__lin=
ux__ -Wdeclaration-after-statement -Wformat=3D2 -Winit-self -Wnested-ex=
terns -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-form=
at-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Ws=
trict-aliasing=3D3  -o arg-decoder.o -c arg-decoder.c
> fatal: Not a git repository (or any of the parent directories): .git
> i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W -g -O=
2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=3D2 -D_GNU_SOURCE -D__lin=
ux__ -Wdeclaration-after-statement -Wformat=3D2 -Winit-self -Wnested-ex=
terns -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-form=
at-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Ws=
trict-aliasing=3D3  -o blockdevs.o -c blockdevs.c
> <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by =
default]
> arg-decoder.c:1:0: note: this is the location of the previous definit=
ion
> <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by =
default]
> blockdevs.c:1:0: note: this is the location of the previous definitio=
n
> i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W -g -O=
2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=3D2 -D_GNU_SOURCE -D__lin=
ux__ -Wdeclaration-after-statement -Wformat=3D2 -Winit-self -Wnested-ex=
terns -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-form=
at-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Ws=
trict-aliasing=3D3  -o child.o -c child.c
> <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by =
default]
> child.c:1:0: note: this is the location of the previous definition
> i686-pc-linux-gnu-gcc -O2 -march=3Di686 -pipe -g -ggdb -Wall -W -g -O=
2 -I. -Iinclude/ -Wimplicit -D_FORTIFY_SOURCE=3D2 -D_GNU_SOURCE -D__lin=
ux__ -Wdeclaration-after-statement -Wformat=3D2 -Winit-self -Wnested-ex=
terns -Wpacked -Wshadow -Wswitch-enum -Wundef -Wwrite-strings -Wno-form=
at-nonliteral -Wstrict-prototypes -Wmissing-prototypes -Wlogical-op -Ws=
trict-aliasing=3D3  -o debug.o -c debug.c
> <command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by =
default]
> debug.c:1:0: note: this is the location of the previous definition
> debug.c:15:21: fatal error: version.h: No such file or directory
> compilation terminated.
> make: *** [debug.o] Error 1
> make: *** Waiting for unfinished jobs....
>  * ERROR: dev-util/trinity-9::toralf failed (compile phase):
>  *   emake failed
>  *
> =20
>=20


--=20
Toralf
pgp key: 0076 E94E
