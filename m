From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: perf,arm -- oops in validate_event
Date: Tue, 6 Aug 2013 12:19:32 +0100
Message-ID: <20130806111932.GA25383@e106331-lin.cambridge.arm.com>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

Hi Vince,

Thanks for the report.

On Mon, Aug 05, 2013 at 10:17:37PM +0100, Vince Weaver wrote:
> On Mon, 5 Aug 2013, Vince Weaver wrote:
> 
> > My perf_fuzzer quickly triggers this oops on my ARM Cortex A9 pandaboard
> > running Linux 3.11-rc4.
> > 
> > Below is the oops, I've attached a simple C test case that triggers the 
> > bug.
> 
> Also, if it helps, the disassembled code in question.
> 
> It looks like in validate_event() we do
> 
>         struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
>         ...
>         return armpmu->get_event_idx(hw_events, event) >= 0;
> 
> armpmu is read into r3, and somehow the value at the offset of
> armpmu->get_event_idx is either -1 or 0, so when it does a "blx" 
> branch to the address at this offset we get the ooops.
> 
>   c001bf8c:       e3120010        tst     r2, #16
>   c001bf90:       0a000004        beq     c001bfa8 <validate_event+0x48>
>   c001bf94:       e5933070        ldr     r3, [r3, #112]  ; 0x70
> * c001bf98:       e12fff33        blx     r3
>   c001bf9c:       e1e00000        mvn     r0, r0
> 
> I'm having trouble tracing the code back past that, and I don't have time
> to start adding printk's and recompiling right now.
> 
> Vince

I think I can save you the effort :)

From the looks of the test case and the kernel code in question, it
looks like the following happens:

* We create a software event, which becomes its own group leader.
* We create a hardware event, with the software event as its group
  leader.
* When we try to schedule the hardware event, we try to validate all
  events in its event group (the leader + siblings), but in doing so we
  treat the software event as a hardware event, and erroneously try to
  get its (non-existent) arm_pmu container, and call some garbage value
  as get_event_idx(...).

This could also happen if we tried to add events from different hardware
PMUs to the same groups. I'm not sure if that's valid, but I couldn't
see any code preventing that, and it seems the x86 validation logic is
wired to allow this. If it's not valid, we could skip validation of
software events by checking with is_software_event.

Either way, I believe the patch below should solve the issue.

Thanks,
Mark.

---->8----

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index d9f5cd4..a7609a0 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -262,9 +262,15 @@ validate_event(struct pmu_hw_events *hw_events,
 	return armpmu->get_event_idx(hw_events, event) >= 0;
 }
 
+static bool is_pmu_event(struct pmu *pmu, struct perf_event *event)
+{
+	return pmu == event->pmu;
+}
+
 static int
 validate_group(struct perf_event *event)
 {
+	struct pmu *pmu = event->pmu;
 	struct perf_event *sibling, *leader = event->group_leader;
 	struct pmu_hw_events fake_pmu;
 	DECLARE_BITMAP(fake_used_mask, ARMPMU_MAX_HWEVENTS);
@@ -276,10 +282,17 @@ validate_group(struct perf_event *event)
 	memset(fake_used_mask, 0, sizeof(fake_used_mask));
 	fake_pmu.used_mask = fake_used_mask;
 
-	if (!validate_event(&fake_pmu, leader))
+	if (is_pmu_event(pmu, leader) && !validate_event(&fake_pmu, leader))
 		return -EINVAL;
 
 	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
+		/*
+		 * We do not validate events for other PMUs (e.g. software
+		 * events). Software events are always schedulable, and other
+		 * PMU events must be validated elsewhere.
+		 */
+		if (!is_pmu_event(pmu, sibling))
+			continue;
 		if (!validate_event(&fake_pmu, sibling))
 			return -EINVAL;
 	}
