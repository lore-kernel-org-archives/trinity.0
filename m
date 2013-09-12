From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: softirq: soft lockup in __do_softirq
Date: Thu, 12 Sep 2013 21:45:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1309122142450.4089@ionos.tec.linutronix.de>
References: <522C8D27.30600@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <522C8D27.30600@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: fweisbec@gmail.com, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Sun, 8 Sep 2013, Sasha Levin wrote:

> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest, running latest -next
> kernel, I've
> stumbled on the following:
> 
> [ 8096.714511] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child16:37848]
> [ 8096.724284]  [<ffffffff84109bee>] ? _raw_spin_unlock+0x4e/0x60
> [ 8096.724284]  [<ffffffff8112b4be>] irq_exit+0x8e/0x140
> [ 8096.724284]  [<ffffffff84114975>] do_IRQ+0xb5/0xe0
> [ 8096.724284]  [<ffffffff8410a06d>] common_interrupt+0x6d/0x6d
> [ 8096.724284]  <EOI>
> [ 8096.724284]  [<ffffffff8115f19d>] ? finish_task_switch+0xad/0x150
> [ 8096.724284]  [<ffffffff84109acc>] ? _raw_spin_unlock_irq+0x4c/0x80
> [ 8096.724284]  [<ffffffff84109aab>] ? _raw_spin_unlock_irq+0x2b/0x80
> [ 8096.724284]  [<ffffffff8115f19d>] finish_task_switch+0xad/0x150
> [ 8096.724284]  [<ffffffff8115f160>] ? finish_task_switch+0x70/0x150
> [ 8096.724284]  [<ffffffff84106a29>] __schedule+0x719/0x7c0
> [ 8096.724284]  [<ffffffff84107114>] preempt_schedule_irq+0xb4/0x100
> [ 8096.724284]  [<ffffffff8410a226>] retint_kernel+0x26/0x30
> [ 8096.724284]  [<ffffffff812220c5>] ? context_tracking_user_enter+0x175/0x180
> [ 8096.724284]  [<ffffffff810768cf>] syscall_trace_leave+0xff/0x130
> [ 8096.724284]  [<ffffffff84112985>] int_check_syscall_exit_work+0x34/0x3d
> [ 8096.724284] Code: 48 89 55 80 0f 1f 00 65 c7 04 25 40 47 1d 00 00 00 00 00
> 48 83 3d dc b6 91 04 00 75 0a 0f 0b eb fe 66 0f 1f 44 00 00 fb 66 66 90 <66>
> 66 90 65 4c 8b 34 25 48 da 00 00 31 db 49 8d 96 28 e0 ff ff

All I can guess from that sparse information that you are observing an
interrupt storm caused by what ever the heck. It's not a softirq storm
as softirq breaks out after N iterations.

Thanks,

	tglx

