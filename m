From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Fwd: Fwd: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x161/0x170()
Date: Mon, 13 May 2013 19:12:12 +0200
Message-ID: <51911EEC.9010701@gmx.de>
References: <51911EC7.3040800@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51911EC7.3040800@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

gah - used the wrong email address


-------- Original Message --------
Subject: Fwd: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x16=
1/0x170()
Date: Mon, 13 May 2013 19:11:35 +0200
=46rom: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
To: Dave Jones <davej@redhat.com>

Hi Dave,

may I ask you, how do you handle process_vm_writev() with trinity?


-------- Original Message --------
Subject: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x161/0x1=
70()
Date: Mon, 13 May 2013 09:12:15 +0200
=46rom: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
CC: user-mode-linux-devel@lists.sourceforge.net <user-mode-linux-devel@=
lists.sourceforge.net>

On Mon, May 13, 2013 at 12:13 AM, Toralf F=C3=B6rster <toralf.foerster@=
gmx.de> wrote:
> On 05/12/2013 11:28 PM, richard -rw- weinberger wrote:
>> Toralf, please test the attached patch.
>
> This happens here after applying the strnlen + stub4 patch on top of =
3.10-rc1

This looks like another issue.
Are you testing process_vm_writev() with trinity?
Looks like it managed to overwrite the stub page of a process, which
is not good.

>
> 2013-05-12T23:49:11.000+02:00 trinity sshd[1034]: pam_unix(sshd:sessi=
on): session opened for user root by (uid=3D0)
> 2013-05-12T23:50:01.000+02:00 trinity cron[1048]: (root) CMD (test -x=
 /usr/sbin/run-crons && /usr/sbin/run-crons)
> 2013-05-12T23:50:58.943+02:00 trinity kernel: Stub registers -
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   0 - 100000
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   1 - 2000
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   2 - 0
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   3 - 0
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   4 - 0
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   5 - 0
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   6 - 0
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   7 - 7b
> 2013-05-12T23:50:58.943+02:00 trinity kernel:   8 - 7b
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   9 - 0
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   10 - 33
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   11 - ffffffff
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   12 - 1000c3
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   13 - 73
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   14 - 10206
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   15 - 101028
> 2013-05-12T23:50:58.947+02:00 trinity kernel:   16 - 7b
> 2013-05-12T23:50:58.947+02:00 trinity kernel: wait_stub_done : failed=
 to wait for SIGTRAP, pid =3D 21982, n =3D 21982, errno =3D 0, status =3D=
 0xb7f
> 2013-05-12T23:54:30.012+02:00 trinity kernel: INFO: task trinity-chil=
d1:1079 blocked for more than 120 seconds.
> 2013-05-12T23:54:30.012+02:00 trinity kernel: "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
> 2013-05-12T23:54:30.012+02:00 trinity kernel: trinity-child1  D 40001=
282     0  1079   1025 0x00000000
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 41090aac 00000001 00000=
000 4027fc78 0805f98f 4014caac 41090aac 40278000
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 4014c600 4027fca8 08360=
71c 4014c600 41090600 00000001 0a554200 4027fcb8
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 18f581ac 40278000 4014c=
600 4014c600 400ba71c 4027fcbc 083607b5 4027fcbc 4027fc64:  [<0805f98f>=
] __switch_to+0x5f/0x100
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 4027fc7c:  [<0836071c>]=
 __schedule+0x32c/0x370
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 4027fcac:  [<083607b5>]=
 schedule+0x55/0x60
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 4027fcc0:  [<083612b5>]=
 __down_read+0x95/0xb0
> 2013-05-12T23:54:30.012+02:00 trinity kernel: 4027fcf4:  [<0835ff51>]=
 down_read+0x11/0x20
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027fd00:  [<080f20f5>]=
 process_vm_rw_core.isra.5+0x1f5/0x5c0
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027fdd8:  [<080f258d>]=
 process_vm_rw+0xcd/0x110
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027fe94:  [<080f2640>]=
 SyS_process_vm_writev+0x30/0x40
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027feac:  [<08062ac2>]=
 handle_syscall+0x82/0xb0
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027fef4:  [<0807519d>]=
 userspace+0x46d/0x590
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027ffec:  [<0805f7fc>]=
 fork_handler+0x6c/0x70
> 2013-05-12T23:54:30.017+02:00 trinity kernel: 4027fffc:  [<00000000>]=
 0x0
> 2013-05-12T23:54:30.017+02:00 trinity kernel:
> 2013-05-12T23:54:30.017+02:00 trinity kernel: INFO: task trinity-chil=
d0:1081 blocked for more than 120 seconds.
> 2013-05-12T23:54:30.017+02:00 trinity kernel: "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
> 2013-05-12T23:54:30.022+02:00 trinity kernel: trinity-child0  D 40001=
282     0  1081   1025 0x00000002
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 41090aac 00000001 00000=
000 402f79e4 0805f98f 4014e2ac 41090aac 402f0000
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 4014de00 402f7a14 08360=
71c 4014de00 41090600 00000001 080fad7d 41350390
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 000000bb 402f0000 400ba=
70c 400ba708 4014de00 402f7a28 083607b5 402f7a28 402f79d0:  [<0805f98f>=
] __switch_to+0x5f/0x100
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 402f79e8:  [<0836071c>]=
 __schedule+0x32c/0x370
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 402f7a18:  [<083607b5>]=
 schedule+0x55/0x60
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 402f7a2c:  [<08361337>]=
 __down_write_nested+0x67/0xb0
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 402f7a60:  [<08361399>]=
 __down_write+0x19/0x1b
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 402f7a70:  [<0835ff71>]=
 down_write+0x11/0x13
> 2013-05-12T23:54:30.022+02:00 trinity kernel: 402f7a7c:  [<0814cc9a>]=
 do_coredump+0x16a/0x1090
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7b48:  [<0808c943>]=
 get_signal_to_deliver+0x553/0x580
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7b74:  [<08060adc>]=
 kern_do_signal+0x28c/0x370
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7c4c:  [<08060bdd>]=
 do_signal+0x1d/0x20
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7c58:  [<08061ed8>]=
 fatal_sigsegv+0x28/0x30
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7c6c:  [<080749fb>]=
 wait_stub_done+0xeb/0x100
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7c98:  [<08073edf>]=
 run_syscall_stub+0x16f/0x2c0
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7ccc:  [<080744ef>]=
 unmap+0xff/0x110
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7d14:  [<080610c4>]=
 do_ops+0xa4/0x150
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7d54:  [<0806168e>]=
 fix_range_common+0x46e/0x4b0
> 2013-05-12T23:54:30.026+02:00 trinity kernel: 402f7dd4:  [<080619ee>]=
 flush_tlb_mm_range+0x2e/0x30
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7dec:  [<080e8cab>]=
 unmap_region+0xcb/0xe0
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7e28:  [<080ea951>]=
 do_munmap+0x231/0x2a0
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7e60:  [<080ecf53>]=
 SyS_mremap+0x263/0x480
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7eac:  [<08062ac2>]=
 handle_syscall+0x82/0xb0
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7ef4:  [<0807519d>]=
 userspace+0x46d/0x590
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7fec:  [<0805f7fc>]=
 fork_handler+0x6c/0x70
> 2013-05-12T23:54:30.030+02:00 trinity kernel: 402f7ffc:  [<00000000>]=
 0x0
> 2013-05-12T23:54:30.030+02:00 trinity kernel:
> 2013-05-12T23:56:30.026+02:00 trinity kernel: INFO: task trinity-chil=
d1:1079 blocked for more than 120 seconds.
> 2013-05-12T23:56:30.026+02:00 trinity kernel: "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
> 2013-05-12T23:56:30.026+02:00 trinity kernel: trinity-child1  D 40001=
282     0  1079   1025 0x00000000
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 41090aac 00000001 00000=
000 4027fc78 0805f98f 4014caac 41090aac 40278000
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 4014c600 4027fca8 08360=
71c 4014c600 41090600 00000001 0a554200 4027fcb8
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 18f581ac 40278000 4014c=
600 4014c600 400ba71c 4027fcbc 083607b5 4027fcbc 4027fc64:  [<0805f98f>=
] __switch_to+0x5f/0x100
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 4027fc7c:  [<0836071c>]=
 __schedule+0x32c/0x370
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 4027fcac:  [<083607b5>]=
 schedule+0x55/0x60
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 4027fcc0:  [<083612b5>]=
 __down_read+0x95/0xb0
> 2013-05-12T23:56:30.026+02:00 trinity kernel: 4027fcf4:  [<0835ff51>]=
 down_read+0x11/0x20
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027fd00:  [<080f20f5>]=
 process_vm_rw_core.isra.5+0x1f5/0x5c0
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027fdd8:  [<080f258d>]=
 process_vm_rw+0xcd/0x110
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027fe94:  [<080f2640>]=
 SyS_process_vm_writev+0x30/0x40
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027feac:  [<08062ac2>]=
 handle_syscall+0x82/0xb0
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027fef4:  [<0807519d>]=
 userspace+0x46d/0x590
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027ffec:  [<0805f7fc>]=
 fork_handler+0x6c/0x70
> 2013-05-12T23:56:30.030+02:00 trinity kernel: 4027fffc:  [<00000000>]=
 0x0
> 2013-05-12T23:56:30.030+02:00 trinity kernel:
> 2013-05-12T23:56:30.030+02:00 trinity kernel: INFO: task trinity-chil=
d0:1081 blocked for more than 120 seconds.
> 2013-05-12T23:56:30.030+02:00 trinity kernel: "echo 0 > /proc/sys/ker=
nel/hung_task_timeout_secs" disables this message.
> 2013-05-12T23:56:30.034+02:00 trinity kernel: trinity-child0  D 40001=
282     0  1081   1025 0x00000002
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 41090aac 00000001 00000=
000 402f79e4 0805f98f 4014e2ac 41090aac 402f0000
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 4014de00 402f7a14 08360=
71c 4014de00 41090600 00000001 080fad7d 41350390
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 000000bb 402f0000 400ba=
70c 400ba708 4014de00 402f7a28 083607b5 402f7a28 402f79d0:  [<0805f98f>=
] __switch_to+0x5f/0x100
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 402f79e8:  [<0836071c>]=
 __schedule+0x32c/0x370
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 402f7a18:  [<083607b5>]=
 schedule+0x55/0x60
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 402f7a2c:  [<08361337>]=
 __down_write_nested+0x67/0xb0
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 402f7a60:  [<08361399>]=
 __down_write+0x19/0x1b
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 402f7a70:  [<0835ff71>]=
 down_write+0x11/0x13
> 2013-05-12T23:56:30.034+02:00 trinity kernel: 402f7a7c:  [<0814cc9a>]=
 do_coredump+0x16a/0x1090
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7b48:  [<0808c943>]=
 get_signal_to_deliver+0x553/0x580
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7b74:  [<08060adc>]=
 kern_do_signal+0x28c/0x370
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7c4c:  [<08060bdd>]=
 do_signal+0x1d/0x20
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7c58:  [<08061ed8>]=
 fatal_sigsegv+0x28/0x30
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7c6c:  [<080749fb>]=
 wait_stub_done+0xeb/0x100
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7c98:  [<08073edf>]=
 run_syscall_stub+0x16f/0x2c0
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7ccc:  [<080744ef>]=
 unmap+0xff/0x110
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7d14:  [<080610c4>]=
 do_ops+0xa4/0x150
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7d54:  [<0806168e>]=
 fix_range_common+0x46e/0x4b0
> 2013-05-12T23:56:30.041+02:00 trinity kernel: 402f7dd4:  [<080619ee>]=
 flush_tlb_mm_range+0x2e/0x30
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7dec:  [<080e8cab>]=
 unmap_region+0xcb/0xe0
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7e28:  [<080ea951>]=
 do_munmap+0x231/0x2a0
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7e60:  [<080ecf53>]=
 SyS_mremap+0x263/0x480
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7eac:  [<08062ac2>]=
 handle_syscall+0x82/0xb0
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7ef4:  [<0807519d>]=
 userspace+0x46d/0x590
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7fec:  [<0805f7fc>]=
 fork_handler+0x6c/0x70
> 2013-05-12T23:56:30.048+02:00 trinity kernel: 402f7ffc:  [<00000000>]=
 0x0
> 2013-05-12T23:56:30.048+02:00 trinity kernel:
>
>
> I restarted the trinity.sh test script again and it gave after few mi=
nutes :
>
>
> 2013-05-13T00:01:36.009+02:00 trinity kernel: Stub registers -
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   0 - 100000
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   1 - 2000
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   2 - 0
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   3 - 0
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   4 - 0
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   5 - 0
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   6 - 0
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   7 - 7b
> 2013-05-13T00:01:36.009+02:00 trinity kernel:   8 - 7b
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   9 - 0
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   10 - 33
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   11 - ffffffff
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   12 - 1000c3
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   13 - 73
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   14 - 10206
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   15 - 101028
> 2013-05-13T00:01:36.013+02:00 trinity kernel:   16 - 7b
> 2013-05-13T00:01:36.013+02:00 trinity kernel: wait_stub_done : failed=
 to wait for SIGTRAP, pid =3D 23566, n =3D 23566, errno =3D 0, status =3D=
 0xb7f
>
> and then repeated "INFO: task trinity-child0:1093 blocked for more th=
an 120 seconds."
>
> --
> MfG/Sincerely
> Toralf F=C3=B6rster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3



--
Thanks,
//richard




