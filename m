From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Tue, 23 Jul 2013 20:39:09 -0400
Message-ID: <51EF222D.9070909@oracle.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130723225150.GT6123@two.firstfloor.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org

On 07/23/2013 06:51 PM, Andi Kleen wrote:
> On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
>> >
>> >I hate having to justify why breaking the ABI is unacceptable.
> Well it's a testing ABI, so we can do changes to it.

The testing ABI has a simple policy about changes:

	The interface can be changed to add new features, but the
	current interface will not break by doing this, unless grave
	errors or security problems are found in them.

It's probably fine to change a testing ABI once in a while, but when things
like trinity start breaking that often due to ABI changes in the same exact
place, that's too much IMO.


Thanks,
Sasha
