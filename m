From: Vince Weaver <vince@deater.net>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Wed, 24 Jul 2013 14:54:49 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1307241449450.8520@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
 <51EF222D.9070909@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51EF222D.9070909@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org

On Tue, 23 Jul 2013, Sasha Levin wrote:

> It's probably fine to change a testing ABI once in a while, but when things
> like trinity start breaking that often due to ABI changes in the same exact
> place, that's too much IMO.

The problem is they want the ABI to be "whatever our closely-coupled 
userspace perf tool accepts as input" which is an often-changing 
complicated (and undocumented) set of LEX and YACC parsers.

I guess we could just give in and declare that to be the official 
perf sysfs interface in the ABI documentation.  

It's frustrating trying to maintain tools that use the perf_event 
interface because the inclusion of perf in the kernel is used as an excuse 
to constantly break the ABI.

Vince
