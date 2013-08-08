From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: perf,arm -- another (different) fuzzer oops
Date: Thu, 8 Aug 2013 09:40:08 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1308080931570.22047@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com> <5202D5B0.9020107@codeaurora.org> <alpine.DEB.2.10.1308072227060.16962@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308072251210.20629@vincent-weaver-1.um.maine.edu> <20130808121337.GC18724@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130808121337.GC18724@mudshark.cambridge.arm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Stephen Boyd <sboyd@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Thu, 8 Aug 2013, Will Deacon wrote:

> On the flip side, the good news is that we know the problem is there. We're
> probably generating interrupts at some horrendous rate for the lock-up....
> are you running your fuzzer as root?

No, I'm running the fuzzer as a regular user.

> Also, is your fuzzer available somewhere? I could take it for a spin on some
> different architectures if you like.

Yes:

  git clone https://github.com/deater/perf_event_tests.git

and it's in the "fuzzer" subdirectory.  I think I've committed all of the 
ARM related patches.

To run the tool it's just "./perf_fuzzer" and away you go.  There's a lot 
of other tools for generating and analyzing fuzzer syscall traces but 
unfortunately they're not very user-friendly yet.


As for other architectures (at least ARM) in addition to the pandaboard I 
also have a beagleboard and a cortex-A15 chromebook.  The challenge is 
always getting recent Linus-git kernels running on the things.

I also have a raspberry-pi.  I've successfully accessed the perf counters 
on that by reading the low-level registers directly with a kernel 
modulue.  There's no perf driver because the PMU interrupt isn't hooked 
up.  I've been meaning to get perf support going by making things 
periodically polled rather than interrupt driven: has anybody looked into 
doing that yet?

Vince
