From: Vince Weaver <vince@deater.net>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Wed, 24 Jul 2013 14:31:44 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1307241427550.8230@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
 <51EF222D.9070909@oracle.com> <20130724013315.GU6123@two.firstfloor.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130724013315.GU6123@two.firstfloor.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi@firstfloor.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org

On Wed, 24 Jul 2013, Andi Kleen wrote:

> On Tue, Jul 23, 2013 at 08:39:09PM -0400, Sasha Levin wrote:
> It sounds like trinity is breaking (well printing a message, not really
> breaking) on any addition. So if we follow that the perf sysfs interface
> would be completely frozen and can never be extended over today.

Trinity is breaking on any *ABI-breaking* additions.
You can add arbitrary fields to sysfs events/* as long as there's
a corresponding format/* entry.

> I don't think it's a big problem that a test tool needs to be extended
> when the software it's testing changes.

Trinity isn't the only tool that would break, I just picked it as an 
example because it's one that kernel devs have likely heard of.

Vince
