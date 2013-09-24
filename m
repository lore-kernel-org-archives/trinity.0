From: Dave Jones <davej@redhat.com>
Subject: Re: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Tue, 24 Sep 2013 15:21:30 -0400
Message-ID: <20130924192130.GC21307@redhat.com>
References: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
 <20130924185045.GB21307@redhat.com>
 <CAEGbLtvwBxQwRZVq0s2_UETzn8gn8x6sWrgDSC+FMQAVazB=6g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtvwBxQwRZVq0s2_UETzn8gn8x6sWrgDSC+FMQAVazB=6g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Tue, Sep 24, 2013 at 12:03:28PM -0700, Ildar Muslukhov wrote:
 > Is there any specific steps to reproduce this behaviour? Or just
 > calling random syscalls will do it?
 
yeah, nothing special.  I've been running it here for the last half hour
without seeing anything weird so far. ( I changed the rand to be < 50 just
to exercise it more).

I'll leave it run for the afternoon, and see if anything falls out.

	Dave
