From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Thu, 03 Oct 2013 20:54:21 +0200
Message-ID: <524DBD5D.1040203@gmx.de>
References: <524C6643.2040209@gmx.de> <CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On 10/02/2013 09:55 PM, Richard Weinberger wrote:
> On Wed, Oct 2, 2013 at 8:30 PM, Toralf F=C3=B6rster <toralf.foerster@=
gmx.de> wrote:
>> Running trinity (1 process, no victim files, just "$>trinity -C1) fo=
r a longer time
>> within a 32 bit user mode linux image with a recent git kernel (host=
: 3.11.3 guest 3.12-rc3-g...)
>> yields into this konsole message :
>>
>>  * Starting local
>> net.core.warnings =3D 0                                             =
                            [ ok ]
>> BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child0:2031]
>>
>>
>> and at the host t1 of the "linux"-processes eats all CPU cycles at 1=
 CPU core.
>> 2 subsequent made back traces made with
>>
>> $> sudo gdb /home/tfoerste/devel/linux/linux 28144 -n -batch -ex bt
>>
>> shows nearly a similar position around __get_user_pages() - both are=
 attached.
>>
>> I'm not surprised that trinity harms a systems - I'm just wondering =
whether this particular picture is
>> expected or if it points to an issue.
>>
>>
>> FWIW the last lines of trinity log were :
>>
>>
>> [2031] [94] setsid() =3D 2031
>> [2031] [95] setresgid(rgid=3D0xffff33e3, egid=3D0xffffff93, sgid=3D0=
x22000040) =3D -1 (Operation not permitted)
>> [2031] [96] vmsplice(fd=3D5, iov=3D0x85501e0, nr_segs=3D300, flags=3D=
9) =3D 0x3000
>> [2031] [97] setresuid(ruid=3D0x80549193, euid=3D0xc61041e0, suid=3D0=
xff19b6fa) =3D -1 (Operation not permitted)
>> [2031] [98] setpriority(which=3D0xff010000, who=3D0xf3737373, niceva=
l=3D0x8088960c) =3D -1 (Invalid argument)
>> [2031] [99] socketcall(call=3D1, args=3D0x8550200) =3D -1 (Address f=
amily not supported by protocol)
>> [2031] [100] access(filename=3D"=EF=BF=BD", mode=3D2017) =3D -1 (Inv=
alid argument)
>> [2031] [101] getgroups(gidsetsize=3D0, grouplist=3D0x80d0000[page_ra=
nd]) =3D 3
>> [2031] [102] msync(start=3D0xc0100220, len=3D0, flags=3D3) =3D -1 (I=
nvalid argument)
>> [2031] [103] sigpending(set=3D0x40025000) =3D 0
>> [2031] [104] signalfd4(ufd=3D383, user_mask=3D1, sizemask=3D0xa42000=
00, flags=3D0x80800) =3D -1 (Invalid argument)
>> [2031] [105] sendfile(out_fd=3D383, in_fd=3D382, offset=3D0, count=3D=
4096) =3D -1 (Invalid argument)
>> [2031] [106] fanotify_mark(fanotify_fd=3D382, flags=3D5, mask=3D0x80=
00023, dfd=3D382, pathname=3D"/proc/1092/task/1092/fdinfo/68") =3D -1 (=
Invalid argument)
>> [2031] [107] wait4(upid=3D1, stat_addr=3D4, options=3D0xd761979b, ru=
=3D8) =3D -1 (Invalid argument)
>> [2031] [108] sigpending(set=3D0x80ca000[page_zeros]) =3D 0
>> [2031] [109] setresuid(ruid=3D0xefffd6fc, euid=3D0x1bf4c92f, suid=3D=
0xffff2e33) =3D -1 (Operation not permitted)
>> [2031] [110] munlock(addr=3D0x40025000, len=3D34) =3D 0
>> [2031] [111] timer_delete(timer_id=3D0xffffffdc) =3D -1 (Invalid arg=
ument)
>> [2031] [112] sched_get_priority_max(policy=3D0x10000040) =3D -1 (Inv=
alid argument)
>> [2031] [113] syslog(type=3D0xc1000000, buf=3D1, len=3D0x82a5) =3D -1=
 (Operation not permitted)
>> [2031] [114] setpriority(which=3D0xc4c806c6, who=3D0xffffff01, nicev=
al=3D0xffff0682) =3D -1 (Invalid argument)
>> [2031] [115] getgroups16(gidsetsize=3D0xfffe, grouplist=3D1) =3D -1 =
(Bad address)
>> [2031] [116] rename(oldname=3D4, newname=3D8) =3D -1 (Bad address)
>> [2031] [117] inotify_init() =3D 654
>> [2031] [118] getgid() =3D 100
>> [2031] [119] fstatat64(dfd=3D382, filename=3D"/sys/devices/virtual/n=
et/sit0/duplex", statbuf=3D0, flag=3D0xb545d727) =3D -1 (Invalid argume=
nt)
>> [2031] [120] unlinkat(dfd=3D382, pathname=3D"/proc/sys/net/ipv4/neig=
h/default/retrans_time", flag=3D0xc00ef76) =3D -1 (Invalid argument)
>> [2031] [121] timerfd_create(clockid=3D0, flags=3D0) =3D 655
>> [2031] [122] munlock(addr=3D4, len=3D0x3fff) =3D -1 (Cannot allocate=
 memory)
>> [2031] [123] fremovexattr(fd=3D382, name=3D0) =3D -1 (Bad address)
>> [2031] [124] sched_get_priority_min(policy=3D0xff58bfef) =3D -1 (Inv=
alid argument)
>> [2031] [125] mq_timedreceive(mqdes=3D397, u_msg_ptr=3D4, msg_len=3D5=
245, u_msg_prio=3D0xc0100220, u_abs_timeout=3D0xc0100220) =3D -1 (Bad a=
ddress)
>> [2031] [126] chdir(filename=3D"/proc/116/net/ptype") =3D -1 (Not a d=
irectory)
>> [2031] [127] ssetmask(newmask=3D0x88000092) =3D 0
>> [2031] [128] statfs(pathname=3D"/proc/6/mounts", buf=3D0) =3D -1 (Ba=
d address)
>> [2031] [129] fchown16(fd=3D397, user=3D104, group=3D0x94100000) =3D =
-1 (Operation not permitted)
>> [2031] [130] fchdir(fd=3D397) =3D -1 (Not a directory)
>> [2031] [131] mkdir(pathname=3D"/proc/1092/task/1092/fdinfo/316", mod=
e=3D525) =3D -1 (File exists)
>> [2031] [132] fsetxattr(fd=3D386, name=3D0x856f158, value=3D0x8571160=
, size=3D0, flags=3D0) =3D -1 (Numerical result out of range)
>> [2031] [133] io_setup(nr_events=3D4095, ctxp=3D0x40266000) ^CKilled =
by signal 2.
>=20
> Reading your gdb backtraces show that schedule_timeout() got called
> with a negative value.
> Looks like an integer overflow.
> The soft-lockup might also origin from that (very big integer which
> did not overflow jet)
>=20

If the culprit is solved by this patch I'd like to send it out. But I'm
unsure whether it catches the culprit or if it just covers the root cau=
se.

ommit 7b367d5478dfcba1635e8cde3c663515fee129ec
Author: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
Date:   Thu Oct 3 20:46:38 2013 +0200

    mm/page-writeback.c: avoid integer overflow in balance_dirty_pages(=
)

    avoid crash of a 32 bit UML (found using fuzz tool trinity)

    Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f5236f8..f5a3096 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1462,7 +1462,8 @@ static void balance_dirty_pages(struct
address_space *mapping,
                        pause =3D max_pause;
                        goto pause;
                }
-               period =3D HZ * pages_dirtied / task_ratelimit;
+               period =3D ((long) HZ) * pages_dirtied / task_ratelimit=
;
+
                pause =3D period;
                if (current->dirty_paused_when)
                        pause -=3D now - current->dirty_paused_when;


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
