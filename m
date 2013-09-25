From: Dave Jones <davej@redhat.com>
Subject: Re: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Wed, 25 Sep 2013 16:32:01 -0400
Message-ID: <20130925203201.GA12603@redhat.com>
References: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
 <20130924185045.GB21307@redhat.com>
 <CAEGbLtvwBxQwRZVq0s2_UETzn8gn8x6sWrgDSC+FMQAVazB=6g@mail.gmail.com>
 <20130924192130.GC21307@redhat.com>
 <CAEGbLtuLgwY2PzZPLNRwRTpw0pFqvadsxGrsAnVHukwvPefmKQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtuLgwY2PzZPLNRwRTpw0pFqvadsxGrsAnVHukwvPefmKQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Sep 25, 2013 at 01:25:21PM -0700, Ildar Muslukhov wrote:
 > Any luck with the test?

Nothing specifically problematic with 32bit syscalls, but I've got a bunch
of changes that I'll push out over the next day or so as a result of yesterdays
run.  I found a bunch of cases where we end up with all the children stuck
reading fd's, and ignoring sigkill after the sigalarm has gone off. Still tweaking it.

	Dave
