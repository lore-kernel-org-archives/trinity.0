From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Sun, 06 Oct 2013 16:17:45 +0200
Message-ID: <52517109.90605@gmx.de>
References: <524C6643.2040209@gmx.de> <CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com> <524DBD5D.1040203@gmx.de> <524DBFBB.1050002@nod.at> <524DC278.3020106@gmx.de> <524DC394.6030406@nod.at> <524DC675.4020201@gmx.de> <524E57BA.805@nod.at>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <524E57BA.805@nod.at>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Richard Weinberger <richard@nod.at>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On 10/04/2013 07:52 AM, Richard Weinberger wrote:
> Am 03.10.2013 21:33, schrieb Toralf F=C3=B6rster:
>> On 10/03/2013 09:20 PM, Richard Weinberger wrote:
>>> Am 03.10.2013 21:16, schrieb Toralf F=C3=B6rster:
>>>> On 10/03/2013 09:04 PM, Richard Weinberger wrote:
>>>>> Am 03.10.2013 20:54, schrieb Toralf F=C3=B6rster:
>>>>>> On 10/02/2013 09:55 PM, Richard Weinberger wrote:
>>>>>>> On Wed, Oct 2, 2013 at 8:30 PM, Toralf F=C3=B6rster <toralf.foe=
rster@gmx.de> wrote:
>>>>>>>> Running trinity (1 process, no victim files, just "$>trinity -=
C1) for a longer time
>>>>>>>> within a 32 bit user mode linux image with a recent git kernel=
 (host: 3.11.3 guest 3.12-rc3-g...)
>>>>>>>> yields into this konsole message :
>>>>>>>>
>>>>>>>>  * Starting local
>>>>>>>> net.core.warnings =3D 0                                       =
                                  [ ok ]
>>>>>>>> BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child0:2031]
>>>>>>>>
>>>>>>>>
>>>>>>>> and at the host t1 of the "linux"-processes eats all CPU cycle=
s at 1 CPU core.
>>>>>>>> 2 subsequent made back traces made with
>>>>>>>>
>>>>>>>> $> sudo gdb /home/tfoerste/devel/linux/linux 28144 -n -batch -=
ex bt
>>>>>>>>
>>>>>>>> shows nearly a similar position around __get_user_pages() - bo=
th are attached.
>>>>>>>>
>>>>>>>> I'm not surprised that trinity harms a systems - I'm just wond=
ering whether this particular picture is
>>>>>>>> expected or if it points to an issue.
>>>>>>>>
>>>>>>>>
>>>>>>>> FWIW the last lines of trinity log were :
>>>>>>>>
>>>>>>>>
>>>>>>>> [2031] [94] setsid() =3D 2031
>>>>>>>> [2031] [95] setresgid(rgid=3D0xffff33e3, egid=3D0xffffff93, sg=
id=3D0x22000040) =3D -1 (Operation not permitted)
>>>>>>>> [2031] [96] vmsplice(fd=3D5, iov=3D0x85501e0, nr_segs=3D300, f=
lags=3D9) =3D 0x3000
>>>>>>>> [2031] [97] setresuid(ruid=3D0x80549193, euid=3D0xc61041e0, su=
id=3D0xff19b6fa) =3D -1 (Operation not permitted)
>>>>>>>> [2031] [98] setpriority(which=3D0xff010000, who=3D0xf3737373, =
niceval=3D0x8088960c) =3D -1 (Invalid argument)
>>>>>>>> [2031] [99] socketcall(call=3D1, args=3D0x8550200) =3D -1 (Add=
ress family not supported by protocol)
>>>>>>>> [2031] [100] access(filename=3D"=EF=BF=BD", mode=3D2017) =3D -=
1 (Invalid argument)
>>>>>>>> [2031] [101] getgroups(gidsetsize=3D0, grouplist=3D0x80d0000[p=
age_rand]) =3D 3
>>>>>>>> [2031] [102] msync(start=3D0xc0100220, len=3D0, flags=3D3) =3D=
 -1 (Invalid argument)
>>>>>>>> [2031] [103] sigpending(set=3D0x40025000) =3D 0
>>>>>>>> [2031] [104] signalfd4(ufd=3D383, user_mask=3D1, sizemask=3D0x=
a4200000, flags=3D0x80800) =3D -1 (Invalid argument)
>>>>>>>> [2031] [105] sendfile(out_fd=3D383, in_fd=3D382, offset=3D0, c=
ount=3D4096) =3D -1 (Invalid argument)
>>>>>>>> [2031] [106] fanotify_mark(fanotify_fd=3D382, flags=3D5, mask=3D=
0x8000023, dfd=3D382, pathname=3D"/proc/1092/task/1092/fdinfo/68") =3D =
-1 (Invalid argument)
>>>>>>>> [2031] [107] wait4(upid=3D1, stat_addr=3D4, options=3D0xd76197=
9b, ru=3D8) =3D -1 (Invalid argument)
>>>>>>>> [2031] [108] sigpending(set=3D0x80ca000[page_zeros]) =3D 0
>>>>>>>> [2031] [109] setresuid(ruid=3D0xefffd6fc, euid=3D0x1bf4c92f, s=
uid=3D0xffff2e33) =3D -1 (Operation not permitted)
>>>>>>>> [2031] [110] munlock(addr=3D0x40025000, len=3D34) =3D 0
>>>>>>>> [2031] [111] timer_delete(timer_id=3D0xffffffdc) =3D -1 (Inval=
id argument)
>>>>>>>> [2031] [112] sched_get_priority_max(policy=3D0x10000040) =3D -=
1 (Invalid argument)
>>>>>>>> [2031] [113] syslog(type=3D0xc1000000, buf=3D1, len=3D0x82a5) =
=3D -1 (Operation not permitted)
>>>>>>>> [2031] [114] setpriority(which=3D0xc4c806c6, who=3D0xffffff01,=
 niceval=3D0xffff0682) =3D -1 (Invalid argument)
>>>>>>>> [2031] [115] getgroups16(gidsetsize=3D0xfffe, grouplist=3D1) =3D=
 -1 (Bad address)
>>>>>>>> [2031] [116] rename(oldname=3D4, newname=3D8) =3D -1 (Bad addr=
ess)
>>>>>>>> [2031] [117] inotify_init() =3D 654
>>>>>>>> [2031] [118] getgid() =3D 100
>>>>>>>> [2031] [119] fstatat64(dfd=3D382, filename=3D"/sys/devices/vir=
tual/net/sit0/duplex", statbuf=3D0, flag=3D0xb545d727) =3D -1 (Invalid =
argument)
>>>>>>>> [2031] [120] unlinkat(dfd=3D382, pathname=3D"/proc/sys/net/ipv=
4/neigh/default/retrans_time", flag=3D0xc00ef76) =3D -1 (Invalid argume=
nt)
>>>>>>>> [2031] [121] timerfd_create(clockid=3D0, flags=3D0) =3D 655
>>>>>>>> [2031] [122] munlock(addr=3D4, len=3D0x3fff) =3D -1 (Cannot al=
locate memory)
>>>>>>>> [2031] [123] fremovexattr(fd=3D382, name=3D0) =3D -1 (Bad addr=
ess)
>>>>>>>> [2031] [124] sched_get_priority_min(policy=3D0xff58bfef) =3D -=
1 (Invalid argument)
>>>>>>>> [2031] [125] mq_timedreceive(mqdes=3D397, u_msg_ptr=3D4, msg_l=
en=3D5245, u_msg_prio=3D0xc0100220, u_abs_timeout=3D0xc0100220) =3D -1 =
(Bad address)
>>>>>>>> [2031] [126] chdir(filename=3D"/proc/116/net/ptype") =3D -1 (N=
ot a directory)
>>>>>>>> [2031] [127] ssetmask(newmask=3D0x88000092) =3D 0
>>>>>>>> [2031] [128] statfs(pathname=3D"/proc/6/mounts", buf=3D0) =3D =
-1 (Bad address)
>>>>>>>> [2031] [129] fchown16(fd=3D397, user=3D104, group=3D0x94100000=
) =3D -1 (Operation not permitted)
>>>>>>>> [2031] [130] fchdir(fd=3D397) =3D -1 (Not a directory)
>>>>>>>> [2031] [131] mkdir(pathname=3D"/proc/1092/task/1092/fdinfo/316=
", mode=3D525) =3D -1 (File exists)
>>>>>>>> [2031] [132] fsetxattr(fd=3D386, name=3D0x856f158, value=3D0x8=
571160, size=3D0, flags=3D0) =3D -1 (Numerical result out of range)
>>>>>>>> [2031] [133] io_setup(nr_events=3D4095, ctxp=3D0x40266000) ^CK=
illed by signal 2.
>>>>>>>
>>>>>>> Reading your gdb backtraces show that schedule_timeout() got ca=
lled
>>>>>>> with a negative value.
>>>>>>> Looks like an integer overflow.
>>>>>>> The soft-lockup might also origin from that (very big integer w=
hich
>>>>>>> did not overflow jet)
>>>>>>>
>>>>>>
>>>>>> If the culprit is solved by this patch I'd like to send it out. =
But I'm
>>>>>> unsure whether it catches the culprit or if it just covers the r=
oot cause.
>>>>>
>>>>> I fear your Patch will not fix the issue.
>>>>>
>>>>> Does the issue only trigger on 32bit UMLs?
>>>> No diea, I do only have a 32 bit system here (both host and client=
).
>>>>
>>>>> How long does it take till trinity hits it?
>>>> a command like
>>>>
>>>> $> ssh tfoerste@trinity "rm -rf t3; mkdir t3; cd t3; trinity -C4"
>>>>
>>>> usually needs 10 till 15 min to trigger the issue. With just 1 tri=
nity
>>>> task (-C1) however it needs often a hour or more.
>>>
>>> That's good. :-)
>>> You can place some printk()s into balance_dirty_pages() and observe=
 the values
>>> of period, max_pause, min_pause, etc...
>>> Maybe this will give us a clue.
>>
>> Will do it again. I did it before already but period was the only th=
ing
>> which becames otherwise negative -
>> and because pages_dirtied was often in the range of 20 - 30 and peri=
oad
>> around -3000
>=20
> Did you print it before or after
>                 if (current->dirty_paused_when)
>                         pause -=3D now - current->dirty_paused_when;
>=20
> I'm also wondering why
> 		if (pause < min_pause) {
> did not trigger or did it?
>=20
>> I just wondered if HZ is casts as a short int in the calculation ?
>> BTW printk doesn't showed anything in the syslog (ok, I used
>> printk(KERN_ERR ...)
>=20
> syslog or dmesg?
>=20
> Thanks,
> //richard
>=20

back from going a mushroom foray - I nearly surrounded all "pause=3D" s=
tatements
with BUG_ON and downgrades trinity (b/c their latest enhancements made =
trinity too weak)

The UML stopped here :
=2E..
		if (unlikely(task_ratelimit =3D=3D 0)) {
			period =3D max_pause;
			pause =3D max_pause;
			BUG_ON(pause < 0);
			goto pause;
		}
		BUG_ON(pages_dirtied < 0);
		BUG_ON(task_ratelimit < 0);
		period =3D HZ * pages_dirtied / task_ratelimit;
		BUG_ON(period < 0);         <----------------------here
		pause =3D period;
		BUG_ON(pause < 0);
		if (current->dirty_paused_when)
			pause -=3D now - current->dirty_paused_when;
		BUG_ON(pause < 0);
=2E..

The back trace is :

tfoerste@n22 ~/devel/trinity $ gdb --core=3D/mnt/ramdisk/core /home/tfo=
erste/devel/linux/linux -batch -ex bt[New LWP 2522]
Core was generated by `/home/tfoerste/devel/linux/linux earlyprintk ubd=
a=3D/home/tfoerste/virtual/uml/tr'.
Program terminated with signal 6, Aborted.
#0  0xb777a424 in __kernel_vsyscall ()
#0  0xb777a424 in __kernel_vsyscall ()
#1  0x083b33b5 in kill ()
#2  0x0807190d in uml_abort () at arch/um/os-Linux/util.c:93
#3  0x08071c45 in os_dump_core () at arch/um/os-Linux/util.c:148
#4  0x08061417 in panic_exit (self=3D0x85b9558 <panic_exit_notifier>, u=
nused1=3D0, unused2=3D0x85ef720 <buf.16084>) at arch/um/kernel/um_arch.=
c:240
#5  0x0809a7d8 in notifier_call_chain (nl=3D0x0, val=3D0, v=3D0x85ef720=
 <buf.16084>, nr_to_call=3D-2, nr_calls=3D0x0) at kernel/notifier.c:93
#6  0x0809a923 in __atomic_notifier_call_chain (nr_calls=3D<optimized o=
ut>, nr_to_call=3D<optimized out>, v=3D<optimized out>, val=3D<optimize=
d out>, nh=3D<optimized out>) at kernel/notifier.c:182
#7  atomic_notifier_call_chain (nh=3D0x85ef704 <panic_notifier_list>, v=
al=3D0, v=3D0x85ef720 <buf.16084>) at kernel/notifier.c:191
#8  0x08410d1c in panic (fmt=3D0x0) at kernel/panic.c:130
#9  0x08411c64 in balance_dirty_pages (pages_dirtied=3D9, mapping=3D<op=
timized out>) at mm/page-writeback.c:1471
#10 0x080d1ce4 in balance_dirty_pages_ratelimited (mapping=3D0x6) at mm=
/page-writeback.c:1663
#11 0x080e2d0c in __do_fault (mm=3D0x4870da00, vma=3D0x487484c8, addres=
s=3D1095131136, pmd=3D0x0, pgoff=3D0, flags=3D1212323992, orig_pte=3D<i=
ncomplete type>) at mm/memory.c:3452
#12 0x080e5286 in do_nonlinear_fault (orig_pte=3D..., flags=3D<optimize=
d out>, pmd=3D<optimized out>, address=3D<optimized out>, vma=3D<optimi=
zed out>, mm=3D<optimized out>, page_table=3D<optimized out>) at mm/mem=
ory.c:3518
#13 handle_pte_fault (flags=3D<optimized out>, pmd=3D<optimized out>, p=
te=3D<optimized out>, address=3D<optimized out>, vma=3D<optimized out>,=
 mm=3D<optimized out>) at mm/memory.c:3717
#14 __handle_mm_fault (flags=3D<optimized out>, address=3D<optimized ou=
t>, vma=3D<optimized out>, mm=3D<optimized out>) at mm/memory.c:3845
#15 handle_mm_fault (mm=3D0x4870da00, vma=3D0x487484c8, address=3D10951=
31136, flags=3D1) at mm/memory.c:3868
#16 0x080e5a07 in __get_user_pages (tsk=3D0x47d5a400, mm=3D0x4870da00, =
start=3D1095131136, nr_pages=3D1025, gup_flags=3D519, pages=3D0x47c5000=
0, vmas=3D0x0, nonblocking=3D0x0) at mm/memory.c:1822
#17 0x080e5cc3 in get_user_pages (tsk=3D0x0, mm=3D0x0, start=3D0, nr_pa=
ges=3D0, write=3D1, force=3D0, pages=3D0x47fafb98, vmas=3D0x6) at mm/me=
mory.c:2019
#18 0x08140d0e in aio_setup_ring (ctx=3D<optimized out>) at fs/aio.c:34=
0
#19 ioctx_alloc (nr_events=3D<optimized out>) at fs/aio.c:605
#20 SYSC_io_setup (ctxp=3D<optimized out>, nr_events=3D<optimized out>)=
 at fs/aio.c:1122
#21 SyS_io_setup (nr_events=3D65535, ctxp=3D135045120) at fs/aio.c:1105
#22 0x080619c2 in handle_syscall (r=3D0x47d5a5d4) at arch/um/kernel/ska=
s/syscall.c:35
#23 0x08073f2d in handle_trap (local_using_sysemu=3D<optimized out>, re=
gs=3D<optimized out>, pid=3D<optimized out>) at arch/um/os-Linux/skas/p=
rocess.c:198
#24 userspace (regs=3D0x47d5a5d4) at arch/um/os-Linux/skas/process.c:43=
1
#25 0x0805e6ac in fork_handler () at arch/um/kernel/process.c:160
#26 0x00000000 in ?? ()

I'll try again to see if printk's will help - how do I force a sync aft=
er a printk ?

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
