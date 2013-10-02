From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Wed, 2 Oct 2013 21:55:56 +0200
Message-ID: <CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>
References: <524C6643.2040209@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=Qf6xWj23j0EKmp0bbuzxM60EzQoJhbt5dIktB07UyYM=;
        b=Ubs07HOx5zlG6j0Hk3dW6a/cpsJPDE2u26PpxubfjUYz46FQPpEijLfjRz3v8eLZqs
         YXAAQleA/dfc8S5aj4/fn2686CeMUyPhHVMULXWem9PeAAXHAf5YJniTgTUtfU6kHAYb
         Rr2FSMr09Pu3RxNZIgd2ZGLWi84xfpC1W2UaB1wmLq3oQXfwYsYSOOQrksXwQ5Q1EWiI
         YG0gaOpcGrpKrfUtblNnqM0bDqVm36ed0ItnpzBM2Yv72231hg3yrnBQqXZxC7Kj8JW7
         /N9DeLXROlQ9Gq1ZIgj783gKuH+RVPiYYyOUBngQeRqUwzasyCjhjqFewOc7ZXf+af2K
         d6nw==
In-Reply-To: <524C6643.2040209@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On Wed, Oct 2, 2013 at 8:30 PM, Toralf F=C3=B6rster <toralf.foerster@gm=
x.de> wrote:
> Running trinity (1 process, no victim files, just "$>trinity -C1) for=
 a longer time
> within a 32 bit user mode linux image with a recent git kernel (host:=
 3.11.3 guest 3.12-rc3-g...)
> yields into this konsole message :
>
>  * Starting local
> net.core.warnings =3D 0                                              =
                           [ ok ]
> BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child0:2031]
>
>
> and at the host t1 of the "linux"-processes eats all CPU cycles at 1 =
CPU core.
> 2 subsequent made back traces made with
>
> $> sudo gdb /home/tfoerste/devel/linux/linux 28144 -n -batch -ex bt
>
> shows nearly a similar position around __get_user_pages() - both are =
attached.
>
> I'm not surprised that trinity harms a systems - I'm just wondering w=
hether this particular picture is
> expected or if it points to an issue.
>
>
> FWIW the last lines of trinity log were :
>
>
> [2031] [94] setsid() =3D 2031
> [2031] [95] setresgid(rgid=3D0xffff33e3, egid=3D0xffffff93, sgid=3D0x=
22000040) =3D -1 (Operation not permitted)
> [2031] [96] vmsplice(fd=3D5, iov=3D0x85501e0, nr_segs=3D300, flags=3D=
9) =3D 0x3000
> [2031] [97] setresuid(ruid=3D0x80549193, euid=3D0xc61041e0, suid=3D0x=
ff19b6fa) =3D -1 (Operation not permitted)
> [2031] [98] setpriority(which=3D0xff010000, who=3D0xf3737373, niceval=
=3D0x8088960c) =3D -1 (Invalid argument)
> [2031] [99] socketcall(call=3D1, args=3D0x8550200) =3D -1 (Address fa=
mily not supported by protocol)
> [2031] [100] access(filename=3D"=EF=BF=BD", mode=3D2017) =3D -1 (Inva=
lid argument)
> [2031] [101] getgroups(gidsetsize=3D0, grouplist=3D0x80d0000[page_ran=
d]) =3D 3
> [2031] [102] msync(start=3D0xc0100220, len=3D0, flags=3D3) =3D -1 (In=
valid argument)
> [2031] [103] sigpending(set=3D0x40025000) =3D 0
> [2031] [104] signalfd4(ufd=3D383, user_mask=3D1, sizemask=3D0xa420000=
0, flags=3D0x80800) =3D -1 (Invalid argument)
> [2031] [105] sendfile(out_fd=3D383, in_fd=3D382, offset=3D0, count=3D=
4096) =3D -1 (Invalid argument)
> [2031] [106] fanotify_mark(fanotify_fd=3D382, flags=3D5, mask=3D0x800=
0023, dfd=3D382, pathname=3D"/proc/1092/task/1092/fdinfo/68") =3D -1 (I=
nvalid argument)
> [2031] [107] wait4(upid=3D1, stat_addr=3D4, options=3D0xd761979b, ru=3D=
8) =3D -1 (Invalid argument)
> [2031] [108] sigpending(set=3D0x80ca000[page_zeros]) =3D 0
> [2031] [109] setresuid(ruid=3D0xefffd6fc, euid=3D0x1bf4c92f, suid=3D0=
xffff2e33) =3D -1 (Operation not permitted)
> [2031] [110] munlock(addr=3D0x40025000, len=3D34) =3D 0
> [2031] [111] timer_delete(timer_id=3D0xffffffdc) =3D -1 (Invalid argu=
ment)
> [2031] [112] sched_get_priority_max(policy=3D0x10000040) =3D -1 (Inva=
lid argument)
> [2031] [113] syslog(type=3D0xc1000000, buf=3D1, len=3D0x82a5) =3D -1 =
(Operation not permitted)
> [2031] [114] setpriority(which=3D0xc4c806c6, who=3D0xffffff01, niceva=
l=3D0xffff0682) =3D -1 (Invalid argument)
> [2031] [115] getgroups16(gidsetsize=3D0xfffe, grouplist=3D1) =3D -1 (=
Bad address)
> [2031] [116] rename(oldname=3D4, newname=3D8) =3D -1 (Bad address)
> [2031] [117] inotify_init() =3D 654
> [2031] [118] getgid() =3D 100
> [2031] [119] fstatat64(dfd=3D382, filename=3D"/sys/devices/virtual/ne=
t/sit0/duplex", statbuf=3D0, flag=3D0xb545d727) =3D -1 (Invalid argumen=
t)
> [2031] [120] unlinkat(dfd=3D382, pathname=3D"/proc/sys/net/ipv4/neigh=
/default/retrans_time", flag=3D0xc00ef76) =3D -1 (Invalid argument)
> [2031] [121] timerfd_create(clockid=3D0, flags=3D0) =3D 655
> [2031] [122] munlock(addr=3D4, len=3D0x3fff) =3D -1 (Cannot allocate =
memory)
> [2031] [123] fremovexattr(fd=3D382, name=3D0) =3D -1 (Bad address)
> [2031] [124] sched_get_priority_min(policy=3D0xff58bfef) =3D -1 (Inva=
lid argument)
> [2031] [125] mq_timedreceive(mqdes=3D397, u_msg_ptr=3D4, msg_len=3D52=
45, u_msg_prio=3D0xc0100220, u_abs_timeout=3D0xc0100220) =3D -1 (Bad ad=
dress)
> [2031] [126] chdir(filename=3D"/proc/116/net/ptype") =3D -1 (Not a di=
rectory)
> [2031] [127] ssetmask(newmask=3D0x88000092) =3D 0
> [2031] [128] statfs(pathname=3D"/proc/6/mounts", buf=3D0) =3D -1 (Bad=
 address)
> [2031] [129] fchown16(fd=3D397, user=3D104, group=3D0x94100000) =3D -=
1 (Operation not permitted)
> [2031] [130] fchdir(fd=3D397) =3D -1 (Not a directory)
> [2031] [131] mkdir(pathname=3D"/proc/1092/task/1092/fdinfo/316", mode=
=3D525) =3D -1 (File exists)
> [2031] [132] fsetxattr(fd=3D386, name=3D0x856f158, value=3D0x8571160,=
 size=3D0, flags=3D0) =3D -1 (Numerical result out of range)
> [2031] [133] io_setup(nr_events=3D4095, ctxp=3D0x40266000) ^CKilled b=
y signal 2.

Reading your gdb backtraces show that schedule_timeout() got called
with a negative value.
Looks like an integer overflow.
The soft-lockup might also origin from that (very big integer which
did not overflow jet)

--=20
Thanks,
//richard
