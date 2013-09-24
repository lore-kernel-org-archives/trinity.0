From: Dave Jones <davej@redhat.com>
Subject: Re: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Tue, 24 Sep 2013 14:50:45 -0400
Message-ID: <20130924185045.GB21307@redhat.com>
References: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Tue, Sep 24, 2013 at 11:36:53AM -0700, Ildar Muslukhov wrote:
 > Hi everyone,
 > 
 > In the children/random-syscalls.c file (function choose_syscall_table)
 > there is a FIXME section that right now disables 32 bit version of
 > syscall if a 64 bit version is present and enabled.
 > 
 > // FIXME: I forgot why this got disabled. Revisit.
 > //                      if (rand() % 100 < 10)
 > //
 > 
 > Just want to clear this one out. Should it be a command line
 > parameter? Something like -P 50 (for 50% probability, lets say of 32
 > bit). If so, what should be a default behaviour when the parameter is
 > not present 50/50 or 0/100 as it is right now.

So that got disabled a long time ago. Back in May of last year in commit
2d4de3c15fa80c42cccb1863fbd7879ef5aeaf38.

I'm not sure that ever got fixed up. It might be worth doing some long
runs to see if it's still a problem.

	Dave


