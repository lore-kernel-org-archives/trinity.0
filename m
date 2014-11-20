From: Dave Jones <davej@redhat.com>
Subject: Re: trinity doesn't exit after its finished
Date: Thu, 20 Nov 2014 13:21:54 -0500
Message-ID: <20141120182154.GA15680@redhat.com>
References: <546E2E0F.1010708@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <546E2E0F.1010708@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Nov 20, 2014 at 07:08:15PM +0100, Toralf F=F6rster wrote:
 > With latest git tree of trinity at a user mode linux image it stays =
here forever:
 > [child0:5249] <timed out>
 > [main] Bailing main loop because Completed maximum number of operati=
ons..
 > [watchdog] [5096] Watchdog exiting because Completed maximum number =
of operations..

So that [main] line is the last line in main_loop()
On return, we do this..

159                 main_loop();
160=20
161                 shm->mainpid =3D 0;
162                 _exit(EXIT_SUCCESS);

and yet..

 > The proces list shows:
 >=20
 > $ ps fx -eo pid,start_time,command | grep -e trinity -e sleep | grep=
 -v grep
 >  4878 18:30  |       \_ bash -c logger "2#-1, M=3D/mnt/hostfs"; cd ~=
; sudo su -c 'if [[ -d ./t3 ]]; then sudo chmod -R a+rwx ./t3; sudo rm =
-rf ./t3; fi'; mkdir ./t3 && cd ./t3 || exit; if [[ -n /mnt/hostfs ]]; =
then if [[ -d /mnt/hostfs/victims/v1 ]]; then sudo chmod -R a+rwx /mnt/=
hostfs/victims/v1; sudo rm -rf /mnt/hostfs/victims/v1 || exit; fi; mkdi=
r -p /mnt/hostfs/victims/v1/v2; for i in $(seq -w 0 99); do touch /mnt/=
hostfs/victims/v1/v2/f$i; mkdir /mnt/hostfs/victims/v1/v2/d$i; done; fi=
; MALLOC_CHECK_=3D2 trinity -C 2 -N 25000 -q -V /mnt/hostfs/victims/v1/=
v2
 >  5095 18:30  |           \_ trinity -C 2 -N 25000 -q -V /mnt/hostfs/=
victims/v1/v2
 >  5096 18:30  |               \_ [trinity-watchdo] <defunct>
 >  5097 18:30  |               \_ [trinity-main]

Somehow it's still around.

 > Here are the stacks:
 >=20
 > $ sudo cat /proc/5097/stack
 >=20
 > [<0805f8b4>] __switch_to+0x44/0x70                                  =
                                                                       =
           =20
 > [<0850b194>] __schedule+0x2f4/0x3a0                                 =
                                                                       =
           =20
 > [<08097b8a>] __cond_resched+0x1a/0x30                               =
                                                                       =
           =20
 > [<0850b371>] _cond_resched+0x31/0x50
 > [<080dbbb2>] truncate_inode_pages_range+0x192/0x650
 > [<080dc102>] truncate_inode_pages_final+0x52/0x60
 > [<08275f18>] hostfs_evict_inode+0x18/0x40
 > [<08126e8d>] evict+0xdd/0x1b0
 > [<08127b0d>] iput+0x16d/0x180
 > [<08123538>] __dentry_kill+0x138/0x200
 > [<08123f66>] dput+0x156/0x180
 > [<0810fa15>] __fput+0x175/0x190
 > [<0810fa6b>] ____fput+0xb/0x10
 > [<08092956>] task_work_run+0x76/0x90
 > [<0807e92d>] do_exit+0x32d/0x940
 > [<0807f022>] do_group_exit+0xa2/0xf0
 > [<0807f087>] SyS_exit_group+0x17/0x20
 > [<08062980>] handle_syscall+0x60/0x80
 > [<080746fc>] userspace+0x46c/0x5e0
 > [<0805f720>] fork_handler+0x60/0x70
 > [<ffffffff>] 0xffffffff

This is the interesting part. The process is about to exit,
but hostfs is doing.. something.  It might just be taking a really
long time, or it might be stuck.  If it happens again, you might
be able to use ftrace to figure out if hostfs is actually making
forward progress or not.

Perhaps the UML folks have some ideas.

 > Maybe it helps you to improve trinity, if not, ignore this mail
 > ;-)

afaics, there's nothing here that trinity can do, once we've
called _exit(), we're done. Anything that happens afterwards is
the kernels fault :)

	Dave
