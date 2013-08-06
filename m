From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: perf,arm -- oops in validate_event
Date: Tue, 6 Aug 2013 14:08:15 +0100
Message-ID: <20130806130815.GC25383@e106331-lin.cambridge.arm.com>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu>
 <20130806111932.GA25383@e106331-lin.cambridge.arm.com>
 <20130806115921.GA14798@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130806115921.GA14798@mudshark.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Tue, Aug 06, 2013 at 12:59:21PM +0100, Will Deacon wrote:
> On Tue, Aug 06, 2013 at 12:19:32PM +0100, Mark Rutland wrote:
> > On Mon, Aug 05, 2013 at 10:17:37PM +0100, Vince Weaver wrote:
> > > It looks like in validate_event() we do
> > > 
> > >         struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
> > >         ...
> > >         return armpmu->get_event_idx(hw_events, event) >= 0;
> > > 
> > > armpmu is read into r3, and somehow the value at the offset of
> > > armpmu->get_event_idx is either -1 or 0, so when it does a "blx" 
> > > branch to the address at this offset we get the ooops.
> > > 
> > >   c001bf8c:       e3120010        tst     r2, #16
> > >   c001bf90:       0a000004        beq     c001bfa8 <validate_event+0x48>
> > >   c001bf94:       e5933070        ldr     r3, [r3, #112]  ; 0x70
> > > * c001bf98:       e12fff33        blx     r3
> > >   c001bf9c:       e1e00000        mvn     r0, r0
> > > 
> > > I'm having trouble tracing the code back past that, and I don't have time
> > > to start adding printk's and recompiling right now.
> > > 
> > > Vince
> > 
> > I think I can save you the effort :)
> > 
> > From the looks of the test case and the kernel code in question, it
> > looks like the following happens:
> > 
> > * We create a software event, which becomes its own group leader.
> > * We create a hardware event, with the software event as its group
> >   leader.
> > * When we try to schedule the hardware event, we try to validate all
> >   events in its event group (the leader + siblings), but in doing so we
> >   treat the software event as a hardware event, and erroneously try to
> >   get its (non-existent) arm_pmu container, and call some garbage value
> >   as get_event_idx(...).
> > 
> > This could also happen if we tried to add events from different hardware
> > PMUs to the same groups. I'm not sure if that's valid, but I couldn't
> > see any code preventing that, and it seems the x86 validation logic is
> > wired to allow this. If it's not valid, we could skip validation of
> > software events by checking with is_software_event.
> 
> But we already check `event->pmu != leader_pmu' in validate_event, so we
> shouldn't get anywhere nearer calling get_event_idx in the case you
> describe. It sounds more like we have an inconsistency with one of the
> events.

Note in my example that the software event was the group leader (so in
fact we'd *only* be checking those events which we can't actually
handle...).

I was also under the impression that in the case of mixed hardware and
software events, a hardware event must be the group leader. That
doesn't seem to be the case. If a hardware event is added to a software
group, the group is moved to hardware context but the original software
event stays as the group leader.

Thanks,
Mark.

> 
> Can you dump the events as they're processed in validate_group please?

Sure. Patch and output below. I only get one output line before it
explodes.

Thanks,
Mark.

---->8----

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index d9f5cd4..cdff367 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -253,6 +253,11 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	printk("Event %p, PMU %p %s, leader PMU %p %s %s\n",
+		event, event->pmu, event->pmu->name,
+		leader_pmu, leader_pmu->name,
+		is_software_event(event) ? "Software" : "Hardware");
+
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f86599e..796f82b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5668,7 +5668,7 @@ static struct pmu perf_swevent = {
 	.start		= perf_swevent_start,
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-
+	.name		= "perf_swevent",
 	.event_idx	= perf_swevent_event_idx,
 };
 
@@ -5788,6 +5788,7 @@ static struct pmu perf_tracepoint = {
 	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
 
+	.name		= "perf_tracepoint",
 	.event_idx	= perf_swevent_event_idx,
 };
 
@@ -6014,7 +6015,7 @@ static struct pmu perf_cpu_clock = {
 	.start		= cpu_clock_event_start,
 	.stop		= cpu_clock_event_stop,
 	.read		= cpu_clock_event_read,
-
+	.name		= "perf_cpu_clock",
 	.event_idx	= perf_swevent_event_idx,
 };
 
@@ -6094,7 +6095,7 @@ static struct pmu perf_task_clock = {
 	.start		= task_clock_event_start,
 	.stop		= task_clock_event_stop,
 	.read		= task_clock_event_read,
-
+	.name		= "perf_task_clock",
 	.event_idx	= perf_swevent_event_idx,
 };

---->8----

Event 87210800, PMU 804d440c perf_task_clock, leader PMU 804d440c perf_task_clock Software
Unable to handle kernel NULL pointer dereference at virtual address 00000f58
pgd = 87380000
[00000f58] *pgd=672f9831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1235 Comm: a.out Not tainted 3.11.0-rc4+ #154
task: 87a0f840 ti: 866b6000 task.ti: 866b6000
PC is at 0x80000000
LR is at validate_event+0x98/0xa8
pc : [<80000000>]    lr : [<80016ac8>]    psr: 20000013
sp : 866b7e08  ip : 00000000  fp : 866b7f20
r10: 87a0f840  r9 : 00000001  r8 : 866b7e3c
r7 : 80417588  r6 : 804d440c  r5 : 804d440c  r4 : 87210800
r3 : 80000000  r2 : 80612974  r1 : 87210800  r0 : 866b7e3c
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c53c7d  Table: 6738004a  DAC: 00000015
Process a.out (pid: 1235, stack limit = 0x866b6238)
Stack: (0x866b7e08 to 0x866b8000)
7e00:                   804d440c 80417588 80410e30 87210400 87a5859c 87210400
7e20: 87a58500 87210800 000000d3 87a585a0 00000000 80016cc8 00000000 867501b8
7e40: 866b7e38 87380000 87a58500 87210400 804d42d4 00000000 87210400 800856d0
7e60: 87210800 87a58500 00000000 00000001 00000000 00000002 00000000 800859d4
7e80: 00000000 00000000 00000000 00000000 00000029 00000800 00000000 87a0f840
7ea0: 87210800 00000000 00000000 00000000 866b6000 00000000 8790d9c0 80086754
7ec0: 00000000 00000000 00000000 00000004 00000004 00000000 00000000 00000000
7ee0: 00000000 00000000 00000000 00000000 00000000 00000000 0009104c 866b7fb0
7f00: 00000000 76f3b000 00000000 80008468 8742d388 87ae0000 00000001 00000000
7f20: 00000004 00000050 8dfff7d3 00000000 00000000 00000000 00000000 00000000
7f40: 00000000 00000000 001d4a0b 00000000 00000000 00000000 00000000 00000000
7f60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7f80: 866b6000 00000000 00000003 00000000 0000016c 8000e348 866b6000 00000000
7fa0: 00000000 8000e1a0 00000000 00000003 00093040 00000000 00000000 00000003
7fc0: 00000000 00000003 00000000 0000016c 00000000 00000000 76f3b000 00000000
7fe0: 7eb41740 7eb41730 00008451 76ec1ed0 40000010 00093040 e4836563 8503c5f2
[<80016ac8>] (validate_event+0x98/0xa8) from [<80016cc8>] (armpmu_event_init+0x1b8/0x27c)
[<80016cc8>] (armpmu_event_init+0x1b8/0x27c) from [<800856d0>] (perf_init_event+0xc8/0x104)
[<800856d0>] (perf_init_event+0xc8/0x104) from [<800859d4>] (perf_event_alloc+0x2c8/0x478)
[<800859d4>] (perf_event_alloc+0x2c8/0x478) from [<80086754>] (SyS_perf_event_open+0x86c/0x9d0)
[<80086754>] (SyS_perf_event_open+0x86c/0x9d0) from [<8000e1a0>] (ret_fast_syscall+0x0/0x30)
Code: bad PC value
---[ end trace 85dac5c0d80aac6d ]---
