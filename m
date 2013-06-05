From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/3] use config.h in USE_* users
Date: Wed, 5 Jun 2013 15:14:33 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306051509060.7184@vincent-weaver-1.um.maine.edu>
References: <1370339304-26492-1-git-send-email-jslaby@suse.cz> <51ADB877.9050705@suse.cz>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51ADB877.9050705@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: davej@redhat.com, trinity@vger.kernel.org

On Tue, 4 Jun 2013, Jiri Slaby wrote:

> Even if I apply those three, I still see:
> syscalls/perf_event_open.c: In function 'setup_breakpoints':
> syscalls/perf_event_open.c:237: error: 'struct perf_event_attr' has no
> member named 'bp_type'

you must be using an older distro, as some of these features that are 
missing were added to perf_event_open() in 2.6.33.

the perf_event_open() syscall is a bit annoying as fields get added
pretty regularly so it's hard to write code that's backward compatible at 
the API level.  

The authors of the "perf" tool don't care because their code is in the 
kernel tree and they always have an up-to-date include file.  Other users, 
like libpfm4, PAPI, and my various tools have just given up and carry 
along our own copy of perf_event.h, which makes things easier in the long run.

I'm not sure what the trinity policy is here.  Is it better to have a 
really elaborate config-type interface for this?  There's at least 5 or 6 
different versions you'd have to check for to catch all the changes 
between 2.6.32 and current.

Vince
