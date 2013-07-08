From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
Date: Mon, 8 Jul 2013 19:46:22 +0200
Message-ID: <20130708174622.GA25631@dyad.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
 <20130703074929.GE23916@twins.programming.kicks-ass.net>
 <20130708135048.GA1069@krava.brq.redhat.com>
 <20130708165023.GD22923@dyad.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130708165023.GD22923@dyad.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Olsa <jolsa@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Mon, Jul 08, 2013 at 06:50:23PM +0200, Peter Zijlstra wrote:
> 
> [  324.983534] ------------[ cut here ]------------
> [  324.984420] WARNING: at /usr/src/linux-2.6/kernel/events/core.c:1953 __perf_event_enable+0x187/0x190()
> [  324.984420] Modules linked in:
> [  324.984420] CPU: 19 PID: 2715 Comm: nmi_bug_snb Not tainted 3.10.0+ #246
> [  324.984420] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
> [  324.984420]  0000000000000009 ffff88043fce3ec8 ffffffff8160ea0b ffff88043fce3f00
> [  324.984420]  ffffffff81080ff0 ffff8802314fdc00 ffff880231a8f800 ffff88043fcf7860
> [  324.984420]  0000000000000286 ffff880231a8f800 ffff88043fce3f10 ffffffff8108103a
> [  324.984420] Call Trace:
> [  324.984420]  <IRQ>  [<ffffffff8160ea0b>] dump_stack+0x19/0x1b
> [  324.984420]  [<ffffffff81080ff0>] warn_slowpath_common+0x70/0xa0
> [  324.984420]  [<ffffffff8108103a>] warn_slowpath_null+0x1a/0x20
> [  324.984420]  [<ffffffff81134437>] __perf_event_enable+0x187/0x190
> [  324.984420]  [<ffffffff81130030>] remote_function+0x40/0x50
> [  324.984420]  [<ffffffff810e51de>] generic_smp_call_function_single_interrupt+0xbe/0x130
> [  324.984420]  [<ffffffff81066a47>] smp_call_function_single_interrupt+0x27/0x40
> [  324.984420]  [<ffffffff8161fd2f>] call_function_single_interrupt+0x6f/0x80
> [  324.984420]  <EOI>  [<ffffffff816161a1>] ? _raw_spin_unlock_irqrestore+0x41/0x70
> [  324.984420]  [<ffffffff8113799d>] perf_event_exit_task+0x14d/0x210
> [  324.984420]  [<ffffffff810acd04>] ? switch_task_namespaces+0x24/0x60
> [  324.984420]  [<ffffffff81086946>] do_exit+0x2b6/0xa40
> [  324.984420]  [<ffffffff8161615c>] ? _raw_spin_unlock_irq+0x2c/0x30
> [  324.984420]  [<ffffffff81087279>] do_group_exit+0x49/0xc0
> [  324.984420]  [<ffffffff81096854>] get_signal_to_deliver+0x254/0x620
> [  324.984420]  [<ffffffff81043057>] do_signal+0x57/0x5a0
> [  324.984420]  [<ffffffff8161a164>] ? __do_page_fault+0x2a4/0x4e0
> [  324.984420]  [<ffffffff8161665c>] ? retint_restore_args+0xe/0xe
> [  324.984420]  [<ffffffff816166cd>] ? retint_signal+0x11/0x84
> [  324.984420]  [<ffffffff81043605>] do_notify_resume+0x65/0x80
> [  324.984420]  [<ffffffff81616702>] retint_signal+0x46/0x84
> [  324.984420] ---[ end trace 442ec2f04db3771a ]---

OK, this looks like an unrelated issue. Still wants fixing though.

It looks like we get an IPI from perf_event_enable() right after we release
child_ctx->lock in perf_event_exit_task_context().

I don't see what we could do here other than write a comment and remove the
WARN. It seems a valid, albeit, unlikely scenario.
