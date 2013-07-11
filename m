From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: timer: lockup in run_timer_softirq()
Date: Thu, 11 Jul 2013 12:02:39 +0200
Message-ID: <20130711100239.GB25631@dyad.programming.kicks-ass.net>
References: <51DC902F.3070403@oracle.com>
 <20130710095459.GE17211@twins.programming.kicks-ass.net>
 <51DD740C.5090000@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51DD740C.5090000@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On Wed, Jul 10, 2013 at 10:47:40AM -0400, Sasha Levin wrote:
> On 07/10/2013 05:54 AM, Peter Zijlstra wrote:
> >On Tue, Jul 09, 2013 at 06:35:27PM -0400, Sasha Levin wrote:
> >>While going through the NMI dump, I noticed that it's very incomplete, and full of:
> >>
> >>[ 2536.500130] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler)
> >>took too long to run: 697182.008 msecs
> >
> >Now I would actually expect arch_trigger_all_cpu_backtrace_handler() to
> >issue this warning, that said, ~700 seconds is a bit long, I'm fairly
> >sure it didn't actually take that long, you'd have noticed your vm being
> >'away' for 10+ minutes I'd think, no?
> >
> >
> >There's something entirely fishy with that stuff, let me to stare at it.
> 
> Yeah, it didn't actually hang that long - that number is bogus.

This might help..

---
 arch/x86/kernel/nmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 0920212..4e54911 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -123,8 +123,8 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 			continue;
 
 		nmi_longest_ns = delta;
-		whole_msecs = do_div(delta, (1000 * 1000));
-		decimal_msecs = do_div(delta, 1000) % 1000;
+		whole_msecs = div_u64(delta, (1000 * 1000));
+		decimal_msecs = div_u64(delta, 1000) % 1000;
 		printk_ratelimited(KERN_INFO
 			"INFO: NMI handler (%ps) took too long to run: "
 			"%lld.%03d msecs\n", a->handler, whole_msecs,
