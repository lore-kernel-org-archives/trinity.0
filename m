From: Jiri Olsa <jolsa@redhat.com>
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
Date: Mon, 8 Jul 2013 15:50:48 +0200
Message-ID: <20130708135048.GA1069@krava.brq.redhat.com>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
 <20130703074929.GE23916@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130703074929.GE23916@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Wed, Jul 03, 2013 at 09:49:29AM +0200, Peter Zijlstra wrote:
> On Tue, Jul 02, 2013 at 11:15:59PM -0400, Vince Weaver wrote:
> > 
> > OK, I have bisected this problem to the following change:
> > 
> > commit 8dc85d547285668e509f86c177bcd4ea055bcaaf
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Thu Sep 2 16:50:03 2010 +0200
> > 
> >     perf: Multiple task contexts
> >     
> >     Provide the infrastructure for multiple task contexts.
> > 
> 
> Thanks, that narrows down the scope a bit. As it happens I was also
> narrowing down on that particular area so that's good.
> 

hi,
patch below gets rid of the warning, and probably the
crash as well

the reason seems to be when HW context is cloned based
on SW event that happened to get there because of the
HW leader, which got closed just before (fd[15] event
in the reproducer)

and the consequence is that in HW context we access
SW's cpuctx -> and thus overwriting its task_ctx variable
any time there's *sched_in routine

need to check if that does not break anything else ;-)

jirka

---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1833bc5..1d1f030 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7465,7 +7465,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
+		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
 		if (!child_ctx)
 			return -ENOMEM;
 
