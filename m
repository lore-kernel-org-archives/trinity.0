From: Dave Jones <davej@redhat.com>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Tue, 9 Jul 2013 18:47:06 -0400
Message-ID: <20130709224706.GA13855@redhat.com>
References: <51DC902F.3070403@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51DC902F.3070403@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Tue, Jul 09, 2013 at 06:35:27PM -0400, Sasha Levin wrote:
 > Hi all,
 > 
 > While fuzzing with trinity inside a KVM tools guest running latest -next, I've
 > stumbled on the following spew:
 > 
 > [ 2536.440007] BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child86:12368]
 > [ 2536.440007] Call Trace:
 > [ 2536.440007]  <IRQ>
 > [ 2536.440007]  [<ffffffff8113d180>] run_timer_softirq+0x2d0/0x330
 > [ 2536.440007]  [<ffffffff8113b400>] ? lock_timer_base+0x70/0x70
 > [ 2536.440007]  [<ffffffff81132b21>] __do_softirq+0x261/0x4d0
 > [ 2536.440007]  [<ffffffff81132ed6>] irq_exit+0x86/0x120
 > [ 2536.440007]  [<ffffffff841a43ea>] smp_apic_timer_interrupt+0x4a/0x60
 > [ 2536.440007]  [<ffffffff841a2d32>] apic_timer_interrupt+0x72/0x80
 > [ 2536.440007]  <EOI>
 > [ 2536.440007]  [<ffffffff84198ef7>] ? retint_restore_args+0x13/0x13
 > [ 2536.440007]  [<ffffffff812355e5>] ? user_enter+0x135/0x150
 > [ 2536.440007]  [<ffffffff81077d6d>] syscall_trace_leave+0x12d/0x160
 > [ 2536.440007]  [<ffffffff841a2337>] int_check_syscall_exit_work+0x34/0x3d
 > [ 2536.440007] Code: 01 fd 48 89 df e8 45 5b 8f fd e8 b0 f1 00 fd 48 83 3d 30 e6 8a 01 00 75 0e 0f 
 > 0b 0f 1f 40 00 eb fe 66 0f 1f 44 00 00 fb 66 66 90 <66> 66 90 bf 01 00 00 00 e8 17 4f 00 00 65 48 8b 
 > 04 25 88 d9 00
 > 
 > While going through the NMI dump, I noticed that it's very incomplete, and full of:
 > 
 > [ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 
 > 697182.008 msecs

I've been reporting these (and other traces) for a while https://lkml.org/lkml/2013/7/5/185 [1]
on bare-metal.

I've not managed to find time yet to try and narrow down the exact combination
of trinity syscalls that causes this. Sometimes it happens quickly, sometimes
after a few hours (even when run with the same seeds, it seems variable)

	Dave
 
[1] lkml.org seems to be down right now. again. Sigh.
  See
  Subject: Yet more softlockups.
   and
  Subject: scheduling while atomic & hang

