From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: trinity-main is in an endless loop
Date: Sat, 13 Apr 2013 19:14:49 +0200
Message-ID: <51699289.7070307@gmx.de>
References: <51695CF2.2010108@gmx.de> <20130413145849.GA32144@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130413145849.GA32144@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>

On 04/13/2013 04:58 PM, Dave Jones wrote:
> ok, all 4 children are stuck sleeping. it would be interesting to get=
 sysrq-T backtraces of those to see where
> they're sleeping.=20

Well, changing the directory perms doesn't help always, now I've this s=
ituation :

#  ps axf | grep trinity | grep -v grep
  904 ?        Ss     0:00  |       \_ bash -c pkill -9 trinity; cd ~; =
T=3D/mnt/n22/v/victims; mkdir -p $T; for i in $(seq -w 1 100); do touch=
 $T/f$i; mkdir $T/d$i; done; cd $T/../; trinity --children 4 --victims =
$T -x mremap -q
 1109 ?        S      0:00  |           \_ trinity --children 4 --victi=
ms /mnt/n22/v/victims -x mremap -q
 1110 ?        S      0:01  |               \_ trinity --children 4 --v=
ictims /mnt/n22/v/victims -x mremap -q
 1111 ?        R     19:08  |               \_ trinity --children 4 --v=
ictims /mnt/n22/v/victims -x mremap -q
 1287 ?        SNL    0:00  |                   \_ trinity --children 4=
 --victims /mnt/n22/v/victims -x mremap -q
 1291 ?        SN     0:00  |                   \_ trinity --children 4=
 --victims /mnt/n22/v/victims -x mremap -q
 1300 ?        SN     0:00  |                   \_ trinity --children 4=
 --victims /mnt/n22/v/victims -x mremap -q
 1301 ?        S      0:05  |                   \_ trinity --children 4=
 --victims /mnt/n22/v/victims -x mremap -q



and an tail -f at the logfiles shows no activity :

=2E..
id=3D0x40371000m, egid=3D0m, sgid=3D0x80c4000ge_zeros]=3D -1 (Bad addre=
ss)[1291] [242] pread64=3Duf=3D0x80ca000ge_rand]ount=3D0m, pos=3D682ae8=
am) =3D 0[1291] [243] getitimerich=3D75ac268m, value=3D126m) =3D -1 (In=
valid argument)[1291] [244] readahead=3D[0m, offset=3D660ca5bm, count=3D=
219m) =3D -1 (Invalid argument)[1291] [245] fchown16=3Dser=3D0000m, gro=
up=3D[0m=3D -1 (Operation not permitted)[1291] [246] fanotify_marknotif=
y_fd=3Dlags=3D62m, mask=3D58m, dfd=3Dathname=3D""=3D -1 (Invalid argume=
nt)[1291] [247] getdents=3Dirent=3D4m, count=3D4095m) =3D -1 (Not a dir=
ectory)[1291] [248] getcwdf=3D4097m, size=3D0m) =3D -1 (Numerical resul=
t out of range)tail: unrecognized file system type 0x00c0ffee for =E2=80=
=98/mnt/n22/v/trinity-child3.log=E2=80=99. please report this to bug-co=
reutils@gnu.org. reverting to polling

=3D=3D> /mnt/n22/v/trinity.log <=3D=3D
[1111] Random reseed: 1226440414
[1111] Random reseed: 1856582971
[1111] Random reseed: 1841156799
[watchdog] pid 1257 hasn't made progress in 30 seconds! (last:136587195=
9 now:1365871989 diff:30). Stuck in syscall 267:clock_nanosleep. Sendin=
g SIGKILL.
[1111] Random reseed: 2124266190
[1111] Random reseed: 775945931
[1111] Random reseed: 725547373
[1111] Random reseed: 2055143371
[1111] Regenerating random pages, fd's etc.
[watchdog] Triggering periodic reseed.
tail: unrecognized file system type 0x00c0ffee for =E2=80=98/mnt/n22/v/=
trinity.log=E2=80=99. please report this to bug-coreutils@gnu.org. reve=
rting to polling



The sysrq-t gives :


2013-04-13T19:10:22.416+02:00 trinity kernel:=20
2013-04-13T19:10:22.416+02:00 trinity kernel: trinity         S 4000128=
2     0  1109    904 0x00000000
2013-04-13T19:10:22.416+02:00 trinity kernel: 3ff876ac 00000001 0000000=
0 3fd3bdd8 0806194f 3ff87c6c 3ff876ac 3fd38000=20
2013-04-13T19:10:22.416+02:00 trinity kernel: 080a50a0 3fd3be04 083710d=
c 3ff877c0 3ff87200 00000001 400f1f10 3ff87200=20
2013-04-13T19:10:22.416+02:00 trinity kernel: 3fd38000 3ff877b8 3fd3be5=
4 3ff878bc 3fd3be18 08371175 3ff87200 3fd3be54 3fd3bdc4:  [<0806194f>] =
__switch_to+0x5f/0x100
2013-04-13T19:10:22.416+02:00 trinity kernel: 3fd3bddc:  [<083710dc>] _=
_schedule+0x2cc/0x310
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3be08:  [<08371175>] s=
chedule+0x55/0x60
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3be1c:  [<080838d6>] d=
o_wait+0x186/0x220
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3be48:  [<080848ce>] s=
ys_wait4+0xae/0xd0
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3be94:  [<08084917>] s=
ys_waitpid+0x27/0x30
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3beac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3bef4:  [<08076e6d>] u=
serspace+0x46d/0x590
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3bfec:  [<080617bc>] f=
ork_handler+0x6c/0x70
2013-04-13T19:10:22.418+02:00 trinity kernel: 3fd3bffc:  [<00000000>] 0=
x0
2013-04-13T19:10:22.418+02:00 trinity kernel:=20
2013-04-13T19:10:22.418+02:00 trinity kernel: trinity-watchdo S 4000128=
2     0  1110   1109 0x00000000
2013-04-13T19:10:22.421+02:00 trinity kernel: 4107b06c 00000001 0000000=
0 3fc7bdac 0806194f 3ff5052c 4107b06c 3fc78000=20
2013-04-13T19:10:22.421+02:00 trinity kernel: 080a50a0 3fc7bdd8 083710d=
c 3ff50080 4107abc0 00000001 00000000 3fc7be48=20
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc78000 3ff50080 3fc7be4=
8 00000001 3fc7bdec 08371175 0000c350 00000001 3fc7bd98:  [<0806194f>] =
__switch_to+0x5f/0x100
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7bdb0:  [<083710dc>] _=
_schedule+0x2cc/0x310
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7bddc:  [<08371175>] s=
chedule+0x55/0x60
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7bdf0:  [<083706c4>] d=
o_nanosleep+0xb4/0x110
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7be24:  [<0809e0d8>] h=
rtimer_nanosleep+0xc8/0x140
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7be88:  [<0809e1b7>] s=
ys_nanosleep+0x67/0x70
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7beac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-13T19:10:22.421+02:00 trinity kernel: 3fc7bef4:  [<08076e6d>] u=
serspace+0x46d/0x590
2013-04-13T19:10:22.424+02:00 trinity kernel: 3fc7bfec:  [<080617bc>] f=
ork_handler+0x6c/0x70
2013-04-13T19:10:22.424+02:00 trinity kernel: 3fc7bffc:  [<00000000>] 0=
x0
2013-04-13T19:10:22.424+02:00 trinity kernel:=20
2013-04-13T19:10:22.424+02:00 trinity kernel: trinity-main    R running=
      0  1111   1109 0x00000000
2013-04-13T19:10:22.424+02:00 trinity kernel: 0843f6b4 00000457 0000045=
5 00000000 00000000 3ff87200 0843f6e8 080a39bf=20
2013-04-13T19:10:22.424+02:00 trinity kernel: 3ff87200 3ff872ac 0000007=
4 0845f1e4 00000000 0843f6f4 0827d0b2 00000000=20
2013-04-13T19:10:22.424+02:00 trinity kernel: 0843f718 0827d3f6 0000007=
4 084038f2 00000001 01000000 08501c80 0806ad50 0843f688:  [<08062ccf>] =
show_stack+0xcf/0x100
2013-04-13T19:10:22.424+02:00 trinity kernel: 0843f6ac:  [<080a3920>] s=
ched_show_task+0xc0/0x120
2013-04-13T19:10:22.424+02:00 trinity kernel: 0843f6d0:  [<080a39bf>] s=
how_state_filter+0x3f/0x80
2013-04-13T19:10:22.424+02:00 trinity kernel: 0843f6ec:  [<0827d0b2>] s=
ysrq_handle_showstate+0x12/0x20
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f6f8:  [<0827d3f6>] _=
_handle_sysrq+0xa6/0x150
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f71c:  [<0827d57c>] h=
andle_sysrq+0x2c/0x30
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f72c:  [<0806ad64>] s=
ysrq_proc+0x14/0x20
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f738:  [<0806a971>] w=
ith_console+0x51/0xc0
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f770:  [<0806ad14>] m=
console_sysrq+0x64/0x70
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f790:  [<0806a70e>] m=
console_interrupt+0x2e/0x100
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f7b4:  [<080c4c8f>] h=
andle_irq_event_percpu+0x2f/0x150
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f7e4:  [<080c4dd7>] h=
andle_irq_event+0x27/0x40
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f7f8:  [<080c70b0>] h=
andle_edge_irq+0xd0/0x100
2013-04-13T19:10:22.427+02:00 trinity kernel: 0843f808:  [<080c4648>] g=
eneric_handle_irq+0x28/0x30
2013-04-13T19:10:22.508+02:00 trinity kernel: 0843f818:  [<08060e55>] d=
o_IRQ+0x25/0x40
2013-04-13T19:10:22.508+02:00 trinity kernel: 0843f828:  [<08060ed5>] s=
igio_handler+0x65/0x80
2013-04-13T19:10:22.508+02:00 trinity kernel: 0843f840:  [<08073a28>] s=
ig_handler_common+0xb8/0xe0
2013-04-13T19:10:22.508+02:00 trinity kernel: 0843fac4:  [<08073b6d>] s=
ig_handler+0x3d/0x50
2013-04-13T19:10:22.508+02:00 trinity kernel: 0843fad4:  [<080736bb>] h=
ard_handler+0x6b/0xa0
2013-04-13T19:10:22.508+02:00 trinity kernel: 0843fafc:  [<b772040c>] 0=
xb772040c
2013-04-13T19:10:22.508+02:00 trinity kernel:=20
2013-04-13T19:10:22.508+02:00 trinity kernel: trinity-child0  S 4000128=
2     0  1287   1111 0x00000000
2013-04-13T19:10:22.508+02:00 trinity kernel: 4107b06c 00000001 0000000=
0 4133fd34 0806194f 3ff870ec 4107b06c 4133c000=20
2013-04-13T19:10:22.508+02:00 trinity kernel: 080a50a0 4133fd60 083710d=
c 3ff86c40 4107abc0 00000001 11e1a378 00000000=20
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133c000 00000000 4133fd9=
8 4133fe18 4133fd74 08371175 00000000 4133fd98 4133fd20:  [<0806194f>] =
__switch_to+0x5f/0x100
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fd38:  [<083710dc>] _=
_schedule+0x2cc/0x310
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fd64:  [<08371175>] s=
chedule+0x55/0x60
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fd78:  [<0809bf45>] d=
o_cpu_nanosleep+0x105/0x1b0
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fe2c:  [<0809c112>] p=
osix_cpu_nsleep+0x62/0x110
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fe68:  [<0809c1e7>] p=
rocess_cpu_nsleep+0x27/0x30
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fe80:  [<08099be8>] s=
ys_clock_nanosleep+0xc8/0xd0
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133feac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133fef4:  [<08076e6d>] u=
serspace+0x46d/0x590
2013-04-13T19:10:22.520+02:00 trinity kernel: 4133ffec:  [<080617bc>] f=
ork_handler+0x6c/0x70
2013-04-13T19:10:22.531+02:00 trinity kernel: 4133fffc:  [<00000000>] 0=
x0
2013-04-13T19:10:22.531+02:00 trinity kernel:=20
2013-04-13T19:10:22.531+02:00 trinity kernel: trinity-child3  S 4000128=
2     0  1291   1111 0x00000000
2013-04-13T19:10:22.531+02:00 trinity kernel: 3ff870ec 00000001 0000000=
0 41437cc4 0806194f 41264b2c 3ff870ec 41434000=20
2013-04-13T19:10:22.531+02:00 trinity kernel: 080a50a0 41437cf0 083710d=
c 41264680 3ff86c40 00000001 41437cf0 3ff86c40=20
2013-04-13T19:10:22.531+02:00 trinity kernel: 41434000 41437d7c 0000000=
0 41437d88 41437d04 08371175 41437d7c 00000000 41437cb0:  [<0806194f>] =
__switch_to+0x5f/0x100
2013-04-13T19:10:22.531+02:00 trinity kernel: 41437cc8:  [<083710dc>] _=
_schedule+0x2cc/0x310
2013-04-13T19:10:22.531+02:00 trinity kernel: 41437cf4:  [<08371175>] s=
chedule+0x55/0x60
2013-04-13T19:10:22.531+02:00 trinity kernel: 41437d08:  [<080af449>] f=
utex_wait_queue_me+0xe9/0x110
2013-04-13T19:10:22.531+02:00 trinity kernel: 41437d3c:  [<080afca0>] f=
utex_wait+0x160/0x2b0
2013-04-13T19:10:22.542+02:00 trinity kernel: 41437df8:  [<080b1619>] d=
o_futex+0xa9/0x6e0
2013-04-13T19:10:22.542+02:00 trinity kernel: 41437e64:  [<080b1d71>] s=
ys_futex+0x121/0x140
2013-04-13T19:10:22.542+02:00 trinity kernel: 41437eac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-13T19:10:22.542+02:00 trinity kernel: 41437ef4:  [<08076e6d>] u=
serspace+0x46d/0x590
2013-04-13T19:10:22.542+02:00 trinity kernel: 41437fec:  [<080617bc>] f=
ork_handler+0x6c/0x70
2013-04-13T19:10:22.542+02:00 trinity kernel: 41437ffc:  [<00000000>] 0=
x0
2013-04-13T19:10:22.542+02:00 trinity kernel:=20
2013-04-13T19:10:22.542+02:00 trinity kernel: trinity-child2  S 4000128=
2     0  1300   1111 0x00000000
2013-04-13T19:10:22.542+02:00 trinity kernel: 3ff876ac 00000001 0000000=
0 41113dac 0806194f 3ff50aec 3ff876ac 41110000=20
2013-04-13T19:10:22.542+02:00 trinity kernel: 080a50a0 41113dd8 083710d=
c 3ff50640 3ff87200 00000001 00000000 3ff87200=20
2013-04-13T19:10:22.550+02:00 trinity kernel: 41110000 3ff50640 41113e4=
8 00000001 41113dec 08371175 0000c350 00000001 41113d98:  [<0806194f>] =
__switch_to+0x5f/0x100
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113db0:  [<083710dc>] _=
_schedule+0x2cc/0x310
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113ddc:  [<08371175>] s=
chedule+0x55/0x60
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113df0:  [<083706c4>] d=
o_nanosleep+0xb4/0x110
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113e24:  [<0809e0d8>] h=
rtimer_nanosleep+0xc8/0x140
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113e88:  [<0809e1b7>] s=
ys_nanosleep+0x67/0x70
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113eac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113ef4:  [<08076e6d>] u=
serspace+0x46d/0x590
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113fec:  [<080617bc>] f=
ork_handler+0x6c/0x70
2013-04-13T19:10:22.550+02:00 trinity kernel: 41113ffc:  [<00000000>] 0=
x0
2013-04-13T19:10:22.554+02:00 trinity kernel:=20
2013-04-13T19:10:22.554+02:00 trinity kernel: trinity-child1  S 4000128=
2     0  1301   1111 0x00000000
2013-04-13T19:10:22.554+02:00 trinity kernel: 3ff876ac 00000001 0000000=
0 41433dac 0806194f 41265c6c 3ff876ac 41430000=20
2013-04-13T19:10:22.554+02:00 trinity kernel: 080a50a0 41433dd8 083710d=
c 412657c0 3ff87200 00000001 00000000 3ff87200=20
2013-04-13T19:10:22.554+02:00 trinity kernel: 41430000 412657c0 41433e4=
8 00000001 41433dec 08371175 0000c350 00000001 41433d98:  [<0806194f>] =
__switch_to+0x5f/0x100
2013-04-13T19:10:22.554+02:00 trinity kernel: 41433db0:  [<083710dc>] _=
_schedule+0x2cc/0x310
2013-04-13T19:10:22.554+02:00 trinity kernel: 41433ddc:  [<08371175>] s=
chedule+0x55/0x60
2013-04-13T19:10:22.554+02:00 trinity kernel: 41433df0:  [<083706c4>] d=
o_nanosleep+0xb4/0x110
2013-04-13T19:10:22.554+02:00 trinity kernel: 41433e24:  [<0809e0d8>] h=
rtimer_nanosleep+0xc8/0x140
2013-04-13T19:10:22.554+02:00 trinity kernel: 41433e88:  [<0809e1b7>] s=
ys_nanosleep+0x67/0x70
2013-04-13T19:10:22.559+02:00 trinity kernel: 41433eac:  [<08064a92>] h=
andle_syscall+0x82/0xb0
2013-04-13T19:10:22.559+02:00 trinity kernel: 41433ef4:  [<08076e6d>] u=
serspace+0x46d/0x590
2013-04-13T19:10:22.559+02:00 trinity kernel: 41433fec:  [<080617bc>] f=
ork_handler+0x6c/0x70
2013-04-13T19:10:22.559+02:00 trinity kernel: 41433ffc:  [<00000000>] 0=
x0

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
