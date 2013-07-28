From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Fwd: Re: fuzz tested user mode linux core dumps in fs/lockd/clntproc.c:131
Date: Sun, 28 Jul 2013 20:56:09 +0200
Message-ID: <51F56949.3010505@gmx.de>
References: <20130728175828.GA15020@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130728175828.GA15020@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: "user-mode-linux-devel@lists.sourceforge.net" <user-mode-linux-devel@lists.sourceforge.net>


Hi Dave,

just for the record of your trinity scored card - the following bug was
found with the help of your tool.


-------- Original Message --------
Subject: Re: fuzz tested user mode linux core dumps in
fs/lockd/clntproc.c:131
Date: Sun, 28 Jul 2013 19:58:28 +0200
=46rom: Oleg Nesterov <oleg@redhat.com>
To: Toralf F=C3=B6rster <toralf.foerster@gmx.de>,        Andrey Vagin
<avagin@openvz.org>
CC: Serge E. Hallyn <serue@us.ibm.com>,        Eric W. Biederman
<ebiederm@xmission.com>,        Al Viro <viro@zeniv.linux.org.uk>,
  Linux NFS mailing list <linux-nfs@vger.kernel.org>

On 07/28, Toralf F=C3=B6rster wrote:
>
> The attached patch works - applied on top of current git -
> at least the issue cannot be reproduced then.

Thanks Toralf.

I'll write the changelog and send the patch tomorrow.

Andrey, any chance you can check that with this patch free_ipc_ns()
doesn't have any problem with ->shm_file ?

e7b2c406 should be enough to fix that leak, but it would be nice if
you can confirm.

> On 07/27/2013 07:00 PM, Oleg Nesterov wrote:
> > On 07/27, Toralf F=C3=B6rster wrote:
> >>
> >> I do have a user mode linux image (stable 32 bit Gentoo Linux ) wh=
ich erratically crashes
> >> while fuzz tested with trinity if the victim files are located on =
a NFS share.
> >>
> >> The back trace of the core dumps always looks like the attached.
> >>
> >> To bisect it is hard. However after few attempts in the last weeks=
 the following
> >> commit is either the first bad commit or at least the upper limit =
(less likely).
> >>
> >>
> >> commit 8aac62706adaaf0fab02c4327761561c8bda9448
> >> Author: Oleg Nesterov <oleg@redhat.com>
> >> Date:   Fri Jun 14 21:09:49 2013 +0200
> >>
> >>     move exit_task_namespaces() outside of exit_notify()
> >>
> >> #15 nlmclnt_setlockargs (req=3D0x48e18860, fl=3D0x48f27c8c) at fs/=
lockd/clntproc.c:131
> >=20
> > Thanks.
> >=20
> > So nlmclnt_setlockargs()->utsname() crashes and we probably need
> > the patch below.
> >=20
> > But is it correct? I know _absolutely_ nothing about nfs/sunrpc/etc=
 and
> > I never looked into this code before, most probably I am wrong.
> >=20
> > But it seems that __nlm_async_call() relies on workqueues.
> > nlmclnt_async_call() does rpc_wait_for_completion_task(), but what =
if
> > the caller is killed?
> >=20
> > nlm_rqst can't go away, ->a_count was incremented. But can't the ca=
ller
> > exit before call->name is used? In this case the memory it points t=
o
> > can be already freed.
> >=20
> > Oleg.
> >=20
> > --- x/kernel/exit.c
> > +++ x/kernel/exit.c
> > @@ -783,8 +783,8 @@ void do_exit(long code)
> >  	exit_shm(tsk);
> >  	exit_files(tsk);
> >  	exit_fs(tsk);
> > -	exit_task_namespaces(tsk);
> >  	exit_task_work(tsk);
> > +	exit_task_namespaces(tsk);
> >  	check_stack_usage();
> >  	exit_thread();
> > =20
> >=20
> >=20
>=20
>=20
> --=20
> MfG/Sincerely
> Toralf F=C3=B6rster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3



