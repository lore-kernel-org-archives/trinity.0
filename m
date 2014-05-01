From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [uml-devel] trinity commit 23dc478aba breaks syscall "mremap"
 at a 32 bit user mode linux
Date: Thu, 01 May 2014 23:34:09 +0200
Message-ID: <5362BDD1.9070105@gmx.de>
References: <53613E96.2030006@gmx.de> <CAFLxGvyyMMSajwOtS1O6R-_XnJv7dc_61k3Hx9JJB7nmVLNWng@mail.gmail.com> <536221F4.6000405@gmx.de> <53623EFE.3040603@nod.at> <5362651A.1020504@gmx.de> <5362B53E.5060601@nod.at>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <5362B53E.5060601@nod.at>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Richard Weinberger <richard@nod.at>
Cc: trinity@vger.kernel.org, UML devel <user-mode-linux-devel@lists.sourceforge.net>

On 05/01/2014 10:57 PM, Richard Weinberger wrote:
> Toralf,
> 
> Yeah, this is because trinity destroys the UML stub code.
> Please test the attached patch, it should fix the root cause of the problem.
> 
> Thanks,
> //richard
> 

If I do just apply fix2.patch onto latest git tree  v3.15-rc3-113-gba6728f then I do get after a while :

 * Starting sshd ...                                                                                                  [ ok ]
 * Starting local
net.core.warnings = 0                                                                                                 [ ok ]
Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed, errno = 3

CPU: 0 PID: 1728 Comm: trinity-c0 Not tainted 3.15.0-rc3-00113-gba6728f-dirty #5
Stack:
BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c0:1728]

EIP: c500:[<47c6cf00>] CPU: 0 Not tainted EFLAGS: 476af700
    Not tainted
EAX: 47cfc500 EBX: 0a024d00 ECX: 086c75fc EDX: 080fff88
ESI: 0839f4bc EDI: 47cfc500 EBP: 0839f4bc DS: c500 ES: cd62
EXT4-fs (ubda): error count: 1
EXT4-fs (ubda): initial error at 1398962134: ext4_mb_generate_buddy:756
EXT4-fs (ubda): last error at 1398962134: ext4_mb_generate_buddy:756


which is a big improvement because before it crashes immediately after few seconds.

After applying both fixes the test case runs w/o a crash till now.


-- 
Toralf
