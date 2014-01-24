From: Tommi Rantala <tt.rantala@gmail.com>
Subject: sched_rr_get_interval NULL pointer OOPS
Date: Fri, 24 Jan 2014 22:55:56 +0200
Message-ID: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=Oy/DoqI4CB8ZoxZhIRZlJYc5oZybfUw6+dyYab/89fM=;
        b=bK/q3AbYSPDELhDSQEyzJAMCaUEAaG3NCz8+KpeXTjJ7JpNDO3xpsLOu19k5+CyR+h
         uHmrLVe2JKxzZ0ipNSAX90/E7NtCyRMy+sc1Diw4iTD9ePykDr1GAcE1fGEYKcp5fpXA
         XeCMt0iXTdw2CsJlrDcOLq+qGsEK218zUpDEm1RlqqukKkmSR8RpgRRHausDxdymm3mD
         YwpX/xrfbSB+ve7+22T8vdwfm2XToEWeZWpKrtfJDTwPiaPoP7lapijyyW51XUtUx6qL
         9MThCAWejHRSxmRg7ysTj/6ackXVE6a6mnU4RdHr+Cjl0tSCKIFFUEWRhlbs3laPkbyg
         LXHQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Hello,

Trinity triggered the following bug in two separate qemu virtual
machines after fuzzing v3.13-3995-g0dc3fd0 for a day or two. I have
not been running Trinity in a while, so no idea if this is a
regression or not.

If I'm reading this right, it's oopsing in kernel/sched/core.c:

SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
    struct timespec __user *, interval)
{
...
    rq = task_rq_lock(p, &flags);
    time_slice = p->sched_class->get_rr_interval(rq, p);   <==
    task_rq_unlock(rq, p, &flags);
...

The first trace:

[21451.975552] trinity-c9: vm86 mode not supported on 64 bit kernel
[21452.242792] trinity-c23: vm86 mode not supported on 64 bit kernel
[21452.309518] trinity-c30: vm86 mode not supported on 64 bit kernel
[21456.862415] type=1401 audit(1390484421.888:396): SELinux:
unrecognized netlink message type=0 for sclass=34
[21456.862415]
[21472.032599] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[21472.034764] IP: [<          (null)>]           (null)
[21472.036117] PGD a6243067 PUD a712a067 PMD 0
[21472.037345] Oops: 0010 [#1] SMP DEBUG_PAGEALLOC
[21472.038616] CPU: 0 PID: 15522 Comm: trinity-c8 Not tainted 3.13.0+ #1
[21472.040309] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[21472.041823] task: ffff88006f8f0000 ti: ffff8800a101e000 task.ti:
ffff8800a101e000
[21472.043814] RIP: 0010:[<0000000000000000>]  [<          (null)>]
       (null)
[21472.045823] RSP: 0018:ffff8800a101ff30  EFLAGS: 00010046
[21472.047225] RAX: ffffffff82434ae0 RBX: ffff8800b926ca40 RCX: 00000000000002c0
[21472.049143] RDX: ffff8800bf60e460 RSI: ffff8800b926ca40 RDI: ffff8800bf7d4fc0
[21472.050900] RBP: ffff8800a101ff78 R08: fffe8fd25bb38016 R09: 0000000000000001
[21472.052621] R10: ffff88006f8f0000 R11: 0000000000000000 R12: 0000000000000004
[21472.054469] R13: ffff8800bf7d4fc0 R14: 0000000000000094 R15: 200000008465485f
[21472.056303] FS:  00007f904f260700(0000) GS:ffff8800bf600000(0000)
knlGS:0000000000000000
[21472.058211] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[21472.059516] CR2: 0000000000000000 CR3: 0000000044ec3000 CR4: 00000000000006f0
[21472.061143] DR0: 000000000276a000 DR1: 000000000276aff8 DR2: 0000000000000000
[21472.062762] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[21472.064445] Stack:
[21472.064975]  ffffffff81160cdf ffffffff81160c23 0000000000000282
0000000000000001
[21472.067017]  00000000000004ae 0000000000000008 0000000000000008
00007f904f233de0
[21472.069053]  0000000000000094 0000000000000094 ffffffff8235ba79
0000000000000246
[21472.071089] Call Trace:
[21472.071761]  [<ffffffff81160cdf>] ? SyS_sched_rr_get_interval+0xdf/0x230
[21472.073570]  [<ffffffff81160c23>] ? SyS_sched_rr_get_interval+0x23/0x230
[21472.075401]  [<ffffffff8235ba79>] system_call_fastpath+0x16/0x1b
[21472.076987] Code:  Bad RIP value.
[21472.077929] RIP  [<          (null)>]           (null)
[21472.079302]  RSP <ffff8800a101ff30>
[21472.080247] CR2: 0000000000000000
[21472.117066] ---[ end trace cc44b07941fc4905 ]---

The second trace looks more or less identical:

[106143.588795] RDS: rds_bind() could not find a transport, load
rds_tcp or rds_rdma?
[106146.597725] trinity-c1: vm86 mode not supported on 64 bit kernel
[106146.865957] trinity-c36: vm86 mode not supported on 64 bit kernel
[106156.562726] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[106156.565411] IP: [<          (null)>]           (null)
[106156.567021] PGD a61e6067 PUD a03a4067 PMD 0
[106156.568451] Oops: 0010 [#1] SMP DEBUG_PAGEALLOC
[106156.569929] CPU: 0 PID: 19875 Comm: trinity-c23 Not tainted 3.13.0+ #1
[106156.571987] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[106156.573758] task: ffff8800b65d8000 ti: ffff880009ac8000 task.ti:
ffff880009ac8000
[106156.576051] RIP: 0010:[<0000000000000000>]  [<          (null)>]
        (null)
[106156.578322] RSP: 0018:ffff880009ac9f30  EFLAGS: 00010046
[106156.579920] RAX: ffffffff82434ae0 RBX: ffff8800b4cb2520 RCX:
00000000000002c0
[106156.582122] RDX: ffff8800bf60e460 RSI: ffff8800b4cb2520 RDI:
ffff8800bf7d4fc0
[106156.584225] RBP: ffff880009ac9f78 R08: fffe8fd25bb38016 R09:
0000000000000001
[106156.586340] R10: ffff8800b65d8000 R11: 0000000000000000 R12:
00000000008c8000
[106156.588513] R13: ffff8800bf7d4fc0 R14: 0000000000000094 R15:
40000000ffff4a1b
[106156.590684] FS:  00007f75c3e23700(0000) GS:ffff8800bf600000(0000)
knlGS:0000000000000000
[106156.593171] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[106156.594922] CR2: 0000000000000000 CR3: 00000000a69c1000 CR4:
00000000000006f0
[106156.597114] DR0: 00000000008c8000 DR1: 0000000000ca5000 DR2:
00000000024dc000
[106156.599295] DR3: 00000000026df000 DR6: 00000000ffff0ff0 DR7:
0000000000030602
[106156.601449] Stack:
[106156.602085]  ffffffff81160cdf ffffffff81160c23 0000000000000282
0000000000000001
[106156.604423]  000000000003d7dc 0000000000000017 0000000000000017
00007f75c3df6de0
[106156.606758]  0000000000000094 0000000000000094 ffffffff8235ba79
0000000000000246
[106156.609117] Call Trace:
[106156.609913]  [<ffffffff81160cdf>] ? SyS_sched_rr_get_interval+0xdf/0x230
[106156.611967]  [<ffffffff81160c23>] ? SyS_sched_rr_get_interval+0x23/0x230
[106156.614128]  [<ffffffff8235ba79>] system_call_fastpath+0x16/0x1b
[106156.615960] Code:  Bad RIP value.
[106156.617089] RIP  [<          (null)>]           (null)
[106156.618699]  RSP <ffff880009ac9f30>
[106156.619803] CR2: 0000000000000000
[106156.659615] ---[ end trace e8acb270f417a4d3 ]---

(gdb) list *0xffffffff8235ba79
0xffffffff8235ba79 is at /build/linux/arch/x86/kernel/entry_64.S:630.
625             cmpl $__NR_syscall_max,%eax
626     #endif
627             ja badsys
628             movq %r10,%rcx
629             call *sys_call_table(,%rax,8)  # XXX:    rip relative
630             movq %rax,RAX-ARGOFFSET(%rsp)
631     /*
632      * Syscall return path ending with SYSRET (fast path)
633      * Has incomplete stack frame and undefined top of stack.
634      */

(gdb) disassemble SyS_sched_rr_get_interval
Dump of assembler code for function SyS_sched_rr_get_interval:
   0xffffffff81160c00 <+0>:     push   %rbp
   0xffffffff81160c01 <+1>:     mov    %rsp,%rbp
   0xffffffff81160c04 <+4>:     sub    $0x40,%rsp
   0xffffffff81160c08 <+8>:     test   %edi,%edi
   0xffffffff81160c0a <+10>:    mov    %rbx,-0x20(%rbp)
   0xffffffff81160c0e <+14>:    mov    %r12,-0x18(%rbp)
   0xffffffff81160c12 <+18>:    mov    %rdi,%rbx
   0xffffffff81160c15 <+21>:    mov    %r13,-0x10(%rbp)
   0xffffffff81160c19 <+25>:    mov    %r14,-0x8(%rbp)
   0xffffffff81160c1d <+29>:    js     0xffffffff81160e08
<SyS_sched_rr_get_interval+520>
   0xffffffff81160c23 <+35>:    incl   %gs:0xc9a0
   0xffffffff81160c2b <+43>:    mov    %rsi,%r12
   0xffffffff81160c2e <+46>:    xor    %r9d,%r9d
   0xffffffff81160c31 <+49>:    xor    %edx,%edx
   0xffffffff81160c33 <+51>:    xor    %esi,%esi
   0xffffffff81160c35 <+53>:    mov    $0x1,%r8d
   0xffffffff81160c3b <+59>:    mov    $0x2,%ecx
   0xffffffff81160c40 <+64>:    mov    $0xffffffff82c50b40,%rdi
   0xffffffff81160c47 <+71>:    movq   $0xffffffff81160c23,(%rsp)
   0xffffffff81160c4f <+79>:    callq  0xffffffff811814d0 <lock_acquire>
   0xffffffff81160c54 <+84>:    callq  0xffffffff81191a00
<debug_lockdep_rcu_enabled>
   0xffffffff81160c59 <+89>:    test   %eax,%eax
   0xffffffff81160c5b <+91>:    je     0xffffffff81160c90
<SyS_sched_rr_get_interval+144>
   0xffffffff81160c5d <+93>:    cmpb   $0x0,0x1c904f6(%rip)        #
0xffffffff82df115a <__warned.8371>
   0xffffffff81160c64 <+100>:   jne    0xffffffff81160c90
<SyS_sched_rr_get_interval+144>
   0xffffffff81160c66 <+102>:   callq  0xffffffff81194380 <rcu_is_watching>
   0xffffffff81160c6b <+107>:   test   %al,%al
   0xffffffff81160c6d <+109>:   jne    0xffffffff81160c90
<SyS_sched_rr_get_interval+144>
   0xffffffff81160c6f <+111>:   mov    $0xffffffff828c5338,%rdx
   0xffffffff81160c76 <+118>:   mov    $0x32e,%esi
   0xffffffff81160c7b <+123>:   mov    $0xffffffff828c5368,%rdi
   0xffffffff81160c82 <+130>:   movb   $0x1,0x1c904d1(%rip)        #
0xffffffff82df115a <__warned.8371>
   0xffffffff81160c89 <+137>:   callq  0xffffffff811807a0
<lockdep_rcu_suspicious>
   0xffffffff81160c8e <+142>:   xchg   %ax,%ax
   0xffffffff81160c90 <+144>:   mov    %ebx,%edi
   0xffffffff81160c92 <+146>:   callq  0xffffffff811588e0 <find_process_by_pid>
   0xffffffff81160c97 <+151>:   test   %rax,%rax
   0xffffffff81160c9a <+154>:   mov    %rax,%rbx
   0xffffffff81160c9d <+157>:   je     0xffffffff81160d90
<SyS_sched_rr_get_interval+400>
   0xffffffff81160ca3 <+163>:   mov    %rax,%rdi
   0xffffffff81160ca6 <+166>:   callq  0xffffffff81498be0
<security_task_getscheduler>
   0xffffffff81160cab <+171>:   test   %eax,%eax
   0xffffffff81160cad <+173>:   je     0xffffffff81160cc0
<SyS_sched_rr_get_interval+192>
   0xffffffff81160caf <+175>:   movslq %eax,%rbx
   0xffffffff81160cb2 <+178>:   jmpq   0xffffffff81160da0
<SyS_sched_rr_get_interval+416>
   0xffffffff81160cb7 <+183>:   nopw   0x0(%rax,%rax,1)
   0xffffffff81160cc0 <+192>:   lea    -0x38(%rbp),%rsi
   0xffffffff81160cc4 <+196>:   mov    %rbx,%rdi
   0xffffffff81160cc7 <+199>:   callq  0xffffffff81158360 <task_rq_lock>
   0xffffffff81160ccc <+204>:   mov    %rax,%r13
   0xffffffff81160ccf <+207>:   mov    0x60(%rbx),%rax
   0xffffffff81160cd3 <+211>:   mov    %rbx,%rsi
   0xffffffff81160cd6 <+214>:   mov    %r13,%rdi
   0xffffffff81160cd9 <+217>:   callq  *0xc0(%rax)
   0xffffffff81160cdf <+223>:   mov    %r13,%rdi
   0xffffffff81160ce2 <+226>:   mov    %eax,%r14d
   0xffffffff81160ce5 <+229>:   callq  0xffffffff8235a2c0 <_raw_spin_unlock>
   0xffffffff81160cea <+234>:   mov    -0x38(%rbp),%rsi
   0xffffffff81160cee <+238>:   lea    0x728(%rbx),%rdi
   0xffffffff81160cf5 <+245>:   callq  0xffffffff8235a2f0
<_raw_spin_unlock_irqrestore>
   0xffffffff81160cfa <+250>:   callq  0xffffffff81191a00
<debug_lockdep_rcu_enabled>
   0xffffffff81160cff <+255>:   test   %eax,%eax
   0xffffffff81160d01 <+257>:   je     0xffffffff81160d38
<SyS_sched_rr_get_interval+312>
   0xffffffff81160d03 <+259>:   cmpb   $0x0,0x1c90451(%rip)        #
0xffffffff82df115b <__warned.8375>
   0xffffffff81160d0a <+266>:   jne    0xffffffff81160d38
<SyS_sched_rr_get_interval+312>
   0xffffffff81160d0c <+268>:   callq  0xffffffff81194380 <rcu_is_watching>
   0xffffffff81160d11 <+273>:   test   %al,%al
   0xffffffff81160d13 <+275>:   jne    0xffffffff81160d38
<SyS_sched_rr_get_interval+312>
   0xffffffff81160d15 <+277>:   mov    $0xffffffff828c5390,%rdx
   0xffffffff81160d1c <+284>:   mov    $0x343,%esi
   0xffffffff81160d21 <+289>:   mov    $0xffffffff828c5368,%rdi
   0xffffffff81160d28 <+296>:   movb   $0x1,0x1c9042c(%rip)        #
0xffffffff82df115b <__warned.8375>
   0xffffffff81160d2f <+303>:   callq  0xffffffff811807a0
<lockdep_rcu_suspicious>
   0xffffffff81160d34 <+308>:   nopl   0x0(%rax)
   0xffffffff81160d38 <+312>:   mov    $0xffffffff81160d38,%rdx
   0xffffffff81160d3f <+319>:   mov    $0x1,%esi
   0xffffffff81160d44 <+324>:   mov    $0xffffffff82c50b40,%rdi
   0xffffffff81160d4b <+331>:   callq  0xffffffff811811c0 <lock_release>
   0xffffffff81160d50 <+336>:   lea    -0x30(%rbp),%rsi
   0xffffffff81160d54 <+340>:   mov    %r14d,%edi
   0xffffffff81160d57 <+343>:   decl   %gs:0xc9a0
   0xffffffff81160d5f <+351>:   callq  0xffffffff81129710 <jiffies_to_timespec>
   0xffffffff81160d64 <+356>:   callq  0xffffffff81229670 <might_fault>
   0xffffffff81160d69 <+361>:   lea    -0x30(%rbp),%rsi
   0xffffffff81160d6d <+365>:   mov    $0x10,%edx
   0xffffffff81160d72 <+370>:   mov    %r12,%rdi
   0xffffffff81160d75 <+373>:   callq  0xffffffff81529130 <_copy_to_user>
   0xffffffff81160d7a <+378>:   cmp    $0x1,%rax
   0xffffffff81160d7e <+382>:   sbb    %rbx,%rbx
   0xffffffff81160d81 <+385>:   not    %rbx
   0xffffffff81160d84 <+388>:   and    $0xfffffffffffffff2,%rbx
   0xffffffff81160d88 <+392>:   jmpq   0xffffffff81160e10
<SyS_sched_rr_get_interval+528>
   0xffffffff81160d8d <+397>:   nopl   (%rax)
   0xffffffff81160d90 <+400>:   mov    $0xfffffffffffffffd,%rbx
   0xffffffff81160d97 <+407>:   nopw   0x0(%rax,%rax,1)
   0xffffffff81160da0 <+416>:   callq  0xffffffff81191a00
<debug_lockdep_rcu_enabled>
   0xffffffff81160da5 <+421>:   test   %eax,%eax
   0xffffffff81160da7 <+423>:   je     0xffffffff81160de0
<SyS_sched_rr_get_interval+480>
   0xffffffff81160da9 <+425>:   cmpb   $0x0,0x1c903ab(%rip)        #
0xffffffff82df115b <__warned.8375>
   0xffffffff81160db0 <+432>:   jne    0xffffffff81160de0
<SyS_sched_rr_get_interval+480>
   0xffffffff81160db2 <+434>:   callq  0xffffffff81194380 <rcu_is_watching>
   0xffffffff81160db7 <+439>:   test   %al,%al
   0xffffffff81160db9 <+441>:   jne    0xffffffff81160de0
<SyS_sched_rr_get_interval+480>
   0xffffffff81160dbb <+443>:   mov    $0xffffffff828c5390,%rdx
   0xffffffff81160dc2 <+450>:   mov    $0x343,%esi
   0xffffffff81160dc7 <+455>:   mov    $0xffffffff828c5368,%rdi
   0xffffffff81160dce <+462>:   movb   $0x1,0x1c90386(%rip)        #
0xffffffff82df115b <__warned.8375>
   0xffffffff81160dd5 <+469>:   callq  0xffffffff811807a0
<lockdep_rcu_suspicious>
   0xffffffff81160dda <+474>:   nopw   0x0(%rax,%rax,1)
   0xffffffff81160de0 <+480>:   mov    $0xffffffff81160de0,%rdx
   0xffffffff81160de7 <+487>:   mov    $0x1,%esi
   0xffffffff81160dec <+492>:   mov    $0xffffffff82c50b40,%rdi
   0xffffffff81160df3 <+499>:   callq  0xffffffff811811c0 <lock_release>
   0xffffffff81160df8 <+504>:   decl   %gs:0xc9a0
   0xffffffff81160e00 <+512>:   jmp    0xffffffff81160e10
<SyS_sched_rr_get_interval+528>
   0xffffffff81160e02 <+514>:   nopw   0x0(%rax,%rax,1)
   0xffffffff81160e08 <+520>:   mov    $0xffffffffffffffea,%rbx
   0xffffffff81160e0f <+527>:   nop
   0xffffffff81160e10 <+528>:   mov    %rbx,%rax
   0xffffffff81160e13 <+531>:   mov    -0x18(%rbp),%r12
   0xffffffff81160e17 <+535>:   mov    -0x20(%rbp),%rbx
   0xffffffff81160e1b <+539>:   mov    -0x10(%rbp),%r13
   0xffffffff81160e1f <+543>:   mov    -0x8(%rbp),%r14
   0xffffffff81160e23 <+547>:   leaveq
   0xffffffff81160e24 <+548>:   retq
End of assembler dump.

Tommi
