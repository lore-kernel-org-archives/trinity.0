From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: is -1 really too "large" ?
Date: Mon, 21 Oct 2013 22:39:12 +0200
Message-ID: <526590F0.6020101@gmx.de>
References: <52657514.3020707@gmx.de> <20131021195210.GA28909@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20131021195210.GA28909@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 10/21/2013 09:52 PM, Dave Jones wrote:
> On Mon, Oct 21, 2013 at 08:40:20PM +0200, Toralf F=C3=B6rster wrote:
>  > got today :
>  >=20
>  >  run trinity at Mon Oct 21 20:38:27 CEST 2013 28#-1 M=3D/mnt/nfsv4
>  >=20
>  > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs000000000000492400=
0000cb': Device or resource busy
>  > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000003fdd00=
0000a9': Device or resource busy
>  > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs000000000000342300=
00007a': Device or resource busy
>  > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000002d3200=
00006b': Device or resource busy
>  > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000001a7c00=
000035': Device or resource busy
>  > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs000000000000176000=
00002a': Device or resource busy
>  > Trinity v1.3pre  Dave Jones <davej@redhat.com>
>  > Done parsing arguments.
>  > Marking all syscalls as enabled.
>  > [init] Enabled 351 syscalls. Disabled 0 syscalls.
>  > [init] Using pid_max =3D 32768
>  > [init] Started watchdog process, PID is 15311
>  > [main] Main thread is alive.
>  > [main] Generating file descriptors
>  > [main] Something went wrong during nftw(/mnt/nfsv4/victims/v1/v2).=
 (-1:Value too large for defined data type)
>=20
> So NFS returned -EOVERFLOW. Not sure why it would do that, but I'm go=
ingto guess it
> came from nftw internally doing an lseek.  lseek's man page suggests.=
=2E
>=20
>        EOVERFLOW
>               The resulting file offset cannot be represented in an o=
ff_t.
>=20
> 64bit server and 32 bit client perhaps ?
>=20
I do only run 32 bit Gentoo Linux (both at host and as user mode linux =
client).


=46WIW in this particular test case I run both an NFS service and a NFS=
 client software at the same UML image do find a reliable rest case to =
reproduce this hang/cpu burner of one of the linux processes at the hos=
t :

tfoerste@n22 ~ $ sudo gdb /home/tfoerste/devel/linux/linux 23921 -n -ba=
tch -ex bt
0x08298edc in radix_tree_next_chunk (root=3D0x14, iter=3D0x46cc7c60, fl=
ags=3D12) at lib/radix-tree.c:770
770                                             if (node->slots[offset]=
)
#0  0x08298edc in radix_tree_next_chunk (root=3D0x14, iter=3D0x46cc7c60=
, flags=3D12) at lib/radix-tree.c:770
#1  0x080cc11e in find_get_pages (mapping=3D0x46ef9b00, start=3D0, nr_p=
ages=3D14, pages=3D0xc) at mm/filemap.c:844
#2  0x080d5c8a in pagevec_lookup (pvec=3D0x46cc7cc4, mapping=3D0x14, st=
art=3D20, nr_pages=3D20) at mm/swap.c:914
#3  0x080d607a in truncate_inode_pages_range (mapping=3D0x46ef9b00, lst=
art=3D0, lend=3D-1) at mm/truncate.c:241
#4  0x080d641f in truncate_inode_pages (mapping=3D0x14, lstart=3D515396=
07572) at mm/truncate.c:358
#5  0x08260818 in hostfs_evict_inode (inode=3D0x46ef9a48) at fs/hostfs/=
hostfs_kern.c:242
#6  0x0811a8af in evict (inode=3D0x46ef9a48) at fs/inode.c:549
#7  0x0811b28d in iput_final (inode=3D<optimized out>) at fs/inode.c:13=
91
#8  iput (inode=3D0x46ef9a48) at fs/inode.c:1409
#9  0x08117628 in dentry_iput (dentry=3D<optimized out>) at fs/dcache.c=
:331
#10 d_kill (dentry=3D0x4915d6e0, parent=3D0x49171dc0) at fs/dcache.c:47=
7
#11 0x08118048 in dentry_kill (dentry=3D<optimized out>, unlock_on_fail=
ure=3D<optimized out>) at fs/dcache.c:586
#12 dput (dentry=3D0x4915d6e0) at fs/dcache.c:641
#13 0x081048e3 in __fput (file=3D0x46cfe900) at fs/file_table.c:264
#14 0x0810494b in ____fput (work=3D0x46cfe900) at fs/file_table.c:282
#15 0x08094496 in task_work_run () at kernel/task_work.c:123
#16 0x0807efd2 in exit_task_work (task=3D<optimized out>) at include/li=
nux/task_work.h:21
#17 do_exit (code=3D1213106688) at kernel/exit.c:787
#18 0x0807f5dd in do_group_exit (exit_code=3D0) at kernel/exit.c:920
#19 0x0807f649 in SYSC_exit_group (error_code=3D<optimized out>) at ker=
nel/exit.c:931
#20 SyS_exit_group (error_code=3D0) at kernel/exit.c:929
#21 0x08062984 in handle_syscall (r=3D0x46f493d4) at arch/um/kernel/ska=
s/syscall.c:35
#22 0x08074fb5 in handle_trap (local_using_sysemu=3D<optimized out>, re=
gs=3D<optimized out>, pid=3D<optimized out>) at arch/um/os-Linux/skas/p=
rocess.c:198
#23 userspace (regs=3D0x46f493d4) at arch/um/os-Linux/skas/process.c:43=
1
#24 0x0805f750 in fork_handler () at arch/um/kernel/process.c:160
#25 0x5a5a5a5a in ?? ()




--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
