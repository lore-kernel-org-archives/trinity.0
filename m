From: Dave Jones <davej@redhat.com>
Subject: Re: called althought it is marked as AVOID.
Date: Mon, 22 Apr 2013 15:53:48 -0400
Message-ID: <20130422195348.GA12899@redhat.com>
References: <5172F41A.7060704@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5172F41A.7060704@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Sat, Apr 20, 2013 at 10:01:30PM +0200, Toralf F=F6rster wrote:
 > Running trinity within a user mode linux image yield into :
 >=20
 >=20
 > 2013-04-20T21:48:16.000+02:00 trinity tfoerste: W=3D/mnt/nfs/n22/w
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: ------------[ cut here=
 ]------------
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: WARNING: at mm/mmap.c:=
2702 exit_mmap+0x161/0x170()
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bd90:  [<0836fe08>=
] dump_stack+0x22/0x24
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bda8:  [<0807f1da>=
] warn_slowpath_common+0x5a/0x80
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bdd0:  [<0807f2a3>=
] warn_slowpath_null+0x23/0x30
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bde0:  [<080e9231>=
] exit_mmap+0x161/0x170
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844be18:  [<0807cdd9>=
] mmput+0x39/0x90
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844be2c:  [<08083f00>=
] do_exit+0x2d0/0x820
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844be7c:  [<08084527>=
] do_group_exit+0x97/0xe0
 > 2013-04-20T21:48:21.926+02:00 trinity kernel: 1844bea0:  [<08084589>=
] sys_exit_group+0x19/0x20
 > 2013-04-20T21:48:21.930+02:00 trinity kernel: 1844beac:  [<08064a92>=
] handle_syscall+0x82/0xb0
 > 2013-04-20T21:48:21.930+02:00 trinity kernel: 1844bef4:  [<08076f2d>=
] userspace+0x46d/0x590
 > 2013-04-20T21:48:21.930+02:00 trinity kernel: 1844bfec:  [<080617fc>=
] fork_handler+0x6c/0x70
 > 2013-04-20T21:48:21.930+02:00 trinity kernel: 1844bffc:  [<00000000>=
] 0x0
 > 2013-04-20T21:48:21.930+02:00 trinity kernel:
 > 2013-04-20T21:48:21.930+02:00 trinity kernel: ---[ end trace 9f50221=
4d4921e53 ]---
 >=20
 >=20
 > The trinity command line was :
 >=20
 > $> trinity.sh -x mremap -x mount -x add_key -x request_key -x keyctl=
 -x clock_nanosleep
 >=20
 > I'm wondering what does AVOID took to be ignored ?

That trace is a process exiting, not a syscall being called.
Looks like something in uml leaked page table entries.

	Dave
