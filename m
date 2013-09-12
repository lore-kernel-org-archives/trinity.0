From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Thu, 12 Sep 2013 15:35:52 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1309121515440.10687@vincent-weaver-1.um.maine.edu>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130912165733.GA23698@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>, =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Thu, 12 Sep 2013, Ingo Molnar wrote:
 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> > > 
> > > I hate having to justify why breaking the ABI is unacceptable.
> > 
> > Well it's a testing ABI, so we can do changes to it.
> > 
> > I hope you're not suggesting that perf cannot be extended anymore.
> 
> It obviously should remain extensible, limiting it to 'config' is rather 
> stupid. If a parser sees something it cannot parse it should ignore that 
> event.

Well 

     Documentation/ABI/testing/sysfs-bus-event_source-devices-events

implies that you won't find field names that aren't in a format file, and

     Documentation/ABI/testing/sysfs-bus-event_source-devices-format

specifies that only "config" fields will appear there.

So if this will be changing you might want to update the documentation, or 
just remove it altogether because it is getting increasingly inaccurate.

I've tried getting this documentation updated
  ( https://lkml.org/lkml/2013/7/25/2 ) 
but the patches have been ignored.



In any case, I notice perf also uses the "open" syscall, so I look forward 
to your eventual creation of
  /sys/bus/open/file_permissions/*

$ cat /sys/bus/open/file_permissions/write
flags=0101,mode=0666

Because what every system call needs is some sort of tree under sysfs
exporting various common settings in unswappable kernel memory that 
require a complex LEX/YACC parser to interpret.  

That's much simpler than using a library, or having a user looking 
things up in a manpage and placing a few comments in their code.

Vince
