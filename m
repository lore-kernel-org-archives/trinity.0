From: Will Deacon <will.deacon@arm.com>
Subject: Re: perf,arm -- oops in validate_event
Date: Wed, 7 Aug 2013 23:35:50 +0100
Message-ID: <20130807223550.GB17118@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu>
 <20130806111932.GA25383@e106331-lin.cambridge.arm.com>
 <20130806115921.GA14798@mudshark.cambridge.arm.com>
 <20130806130815.GC25383@e106331-lin.cambridge.arm.com>
 <20130807130027.GA16474@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1308071122470.8139@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308071129000.8139@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308071129000.8139@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Wed, Aug 07, 2013 at 04:30:33PM +0100, Vince Weaver wrote:
> On Wed, 7 Aug 2013, Vince Weaver wrote:
> > On Wed, 7 Aug 2013, Will Deacon wrote:
> > > diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> > > index d9f5cd4..0500f10b 100644
> > > --- a/arch/arm/kernel/perf_event.c
> > > +++ b/arch/arm/kernel/perf_event.c
> > > @@ -253,6 +253,9 @@ validate_event(struct pmu_hw_events *hw_events,
> > >         struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
> > >         struct pmu *leader_pmu = event->group_leader->pmu;
> > >  
> > > +       if (is_software_event(event))
> > > +               return 1;
> > > +
> > >         if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
> > >                 return 1;
> > 
> > this isn't enough.  You can also trigger the oops by using
> > tracepoint or breakpoint events as group leaders in addition to software
> > events.
> 
> I take that back, it turns out tracepoint and breakpoint both
> have task_ctx_nr set to perf_sw_context (althouth breakpoint has
> a comment saying this may change in the future).
> 
> Let me compile and verify the fix.  It may take some time for the compile 
> to finish as it's not a very fast machine.

Ok, thanks for testing, I'll send the fix to rmk with a CC for stable.

As for future work, we want to support multiple HW PMUs on ARM yet restrict
event groups to accept events targetting the same HW PMU. If we allow groups
to have a software event as a leader, yet still accept HW events, then this
check becomes a real pain because we essentially have to stash the PMU for
the first HW event added to the group.

I think I'd rather fail validation when adding a HW event to a group with a
SW event as a group leader.

PeterZ: any thoughts? This sort of stuff feels like it should really belong
in core code...

Will
