From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Wed, 24 Jul 2013 03:33:15 +0200
Message-ID: <20130724013315.GU6123@two.firstfloor.org>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <51EF222D.9070909@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51EF222D.9070909@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org

On Tue, Jul 23, 2013 at 08:39:09PM -0400, Sasha Levin wrote:
> On 07/23/2013 06:51 PM, Andi Kleen wrote:
> >On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> >>>
> >>>I hate having to justify why breaking the ABI is unacceptable.
> >Well it's a testing ABI, so we can do changes to it.
> 
> The testing ABI has a simple policy about changes:
> 
> 	The interface can be changed to add new features, but the
> 	current interface will not break by doing this, unless grave
> 	errors or security problems are found in them.
> 
> It's probably fine to change a testing ABI once in a while, but when things
> like trinity start breaking that often due to ABI changes in the same exact
> place, that's too much IMO.

It sounds like trinity is breaking (well printing a message, not really
breaking) on any addition. So if we follow that the perf sysfs interface
would be completely frozen and can never be extended over today.

I don't think it's a big problem that a test tool needs to be extended
when the software it's testing changes.

If there are enough other widely used programs that actually break from
additions probably would need a v2 of the sysfs interface for extensions
(with new file or directory names), and keep v1 frozen for
compatibility. 

But I don't think that's the case today?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
