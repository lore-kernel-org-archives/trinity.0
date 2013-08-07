From: Will Deacon <will.deacon@arm.com>
Subject: Re: perf,arm -- oops in validate_event
Date: Wed, 7 Aug 2013 14:00:27 +0100
Message-ID: <20130807130027.GA16474@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu>
 <20130806111932.GA25383@e106331-lin.cambridge.arm.com>
 <20130806115921.GA14798@mudshark.cambridge.arm.com>
 <20130806130815.GC25383@e106331-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130806130815.GC25383@e106331-lin.cambridge.arm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Tue, Aug 06, 2013 at 02:08:15PM +0100, Mark Rutland wrote:
> On Tue, Aug 06, 2013 at 12:59:21PM +0100, Will Deacon wrote:
> > But we already check `event->pmu != leader_pmu' in validate_event, so we
> > shouldn't get anywhere nearer calling get_event_idx in the case you
> > describe. It sounds more like we have an inconsistency with one of the
> > events.
> 
> Note in my example that the software event was the group leader (so in
> fact we'd *only* be checking those events which we can't actually
> handle...).
> 
> I was also under the impression that in the case of mixed hardware and
> software events, a hardware event must be the group leader. That
> doesn't seem to be the case. If a hardware event is added to a software
> group, the group is moved to hardware context but the original software
> event stays as the group leader.

Ok, so the following quick hack below should solve the issue (can you confirm
it please, since I don't have access to any hardware atm?)

We should revisit this for 3.12 though, because I'm not sure that our
validation code even does the right thing when there are multiple PMUs
involved.

Will

--->8

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index d9f5cd4..0500f10b 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -253,6 +253,9 @@ validate_event(struct pmu_hw_events *hw_events,
        struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
        struct pmu *leader_pmu = event->group_leader->pmu;
 
+       if (is_software_event(event))
+               return 1;
+
        if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
                return 1;
