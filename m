From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Fri, 02 May 2014 16:07:59 +0200
Message-ID: <5363A6BF.4060001@gmx.de>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com> <536221F4.6000405@gmx.de> <53623EFE.3040603@nod.at> <5362651A.1020504@gmx.de> <5362B53E.5060601@nod.at> <5362BDD1.9070105@gmx.de> <53634D64.5060407@nod.at>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <53634D64.5060407@nod.at>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Richard Weinberger <richard@nod.at>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On 05/02/2014 09:46 AM, Richard Weinberger wrote:
> Am 01.05.2014 23:34, schrieb Toralf F=C3=B6rster:
>> On 05/01/2014 10:57 PM, Richard Weinberger wrote:
>>> Toralf,
>>>
>>> Yeah, this is because trinity destroys the UML stub code.
>>> Please test the attached patch, it should fix the root cause of the=
 problem.
>>>
>>> Thanks,
>>> //richard
>>>
>>
>> If I do just apply fix2.patch onto latest git tree  v3.15-rc3-113-gb=
a6728f then I do get after a while :
>>
>>  * Starting sshd ...                                                =
                                                  [ ok ]
>>  * Starting local
>> net.core.warnings =3D 0                                             =
                                                    [ ok ]
>> Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed,=
 errno =3D 3
>>
>> CPU: 0 PID: 1728 Comm: trinity-c0 Not tainted 3.15.0-rc3-00113-gba67=
28f-dirty #5
>> Stack:
>> BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c0:1728]
>>
>> EIP: c500:[<47c6cf00>] CPU: 0 Not tainted EFLAGS: 476af700
>>     Not tainted
>> EAX: 47cfc500 EBX: 0a024d00 ECX: 086c75fc EDX: 080fff88
>> ESI: 0839f4bc EDI: 47cfc500 EBP: 0839f4bc DS: c500 ES: cd62
>> EXT4-fs (ubda): error count: 1
>> EXT4-fs (ubda): initial error at 1398962134: ext4_mb_generate_buddy:=
756
>> EXT4-fs (ubda): last error at 1398962134: ext4_mb_generate_buddy:756
>>
>>
>> which is a big improvement because before it crashes immediately aft=
er few seconds.
>>
>> After applying both fixes the test case runs w/o a crash till now.
>=20
> Can you please also try fix3 (without fix1/2)?
> I think I've found the other hidden issue.
> So far trinity did not crash my kernel...
>=20
> Thanks,
> //richard
>=20

fix3 made it - till now it runs fine.
Of course the syslog of the UML guest is flooded with messages like :

May  2 15:45:59 trinity kernel: BUG: Bad rss-counter state mm:47d4d8c0 =
idx:0 val:2
May  2 15:46:00 trinity kernel: fix_range_common: failed, killing curre=
nt process: 2983
May  2 15:46:00 trinity kernel: fix_range_common: failed, killing curre=
nt process: 2984
May  2 15:46:30 trinity kernel: fix_range_common: failed, killing curre=
nt process: 2986
May  2 15:46:30 trinity kernel: fix_range_common: failed, killing curre=
nt process: 2989
May  2 15:46:30 trinity kernel: fix_range_common: failed, killing curre=
nt process: 2991
May  2 15:46:32 trinity kernel: Stub registers -
May  2 15:46:32 trinity kernel:         0 - 100000
May  2 15:46:32 trinity kernel:         1 - 1000
May  2 15:46:32 trinity kernel:         2 - 7
May  2 15:46:32 trinity kernel:         3 - 11
May  2 15:46:32 trinity kernel:         4 - 3
May  2 15:46:32 trinity kernel:         5 - 3cbae
May  2 15:46:32 trinity kernel:         6 - 100000
May  2 15:46:32 trinity kernel:         7 - 7b
May  2 15:46:32 trinity kernel:         8 - 7b
May  2 15:46:32 trinity kernel:         9 - 0
May  2 15:46:32 trinity kernel:         10 - 33
May  2 15:46:32 trinity kernel:         11 - ffffffff
May  2 15:46:32 trinity kernel:         12 - 100fff
May  2 15:46:32 trinity kernel:         13 - 73
May  2 15:46:32 trinity kernel:         14 - 10206
May  2 15:46:32 trinity kernel:         15 - 101028
May  2 15:46:32 trinity kernel:         16 - 7b
May  2 15:46:32 trinity kernel: wait_stub_done : failed to wait for SIG=
TRAP, pid =3D 483, n =3D 483, errno =3D 0, status =3D 0xb7f
May  2 15:46:32 trinity kernel: BUG: Bad rss-counter state mm:47d4d8c0 =
idx:0 val:1
May  2 15:46:32 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3000
May  2 15:46:33 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3002
May  2 15:46:33 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3004
May  2 15:46:33 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3006
May  2 15:46:34 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3009
May  2 15:46:34 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3010
May  2 15:46:34 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3012
May  2 15:46:35 trinity kernel: BUG: Bad rss-counter state mm:47d4d8c0 =
idx:0 val:2
May  2 15:46:35 trinity kernel: fix_range_common: failed, killing curre=
nt process: 3015



which is expected (right ?) b/c I hammered the UML with the syscall "mr=
emap" by 2 trinity childs for a while.


Thx
--=20
Toralf
