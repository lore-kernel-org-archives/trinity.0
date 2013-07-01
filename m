From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 5/8] move perf_event.h to include/
Date: Mon, 1 Jul 2013 11:30:42 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307011127150.8216@vincent-weaver-1.um.maine.edu>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com> <1372620792-16384-6-git-send-email-tt.rantala@gmail.com> <20130630232915.GA4325@redhat.com> <CA+ydwtqCM0_TahM2y3AHG=tbwwyzp14jmMM0WspACic+QiVACw@mail.gmail.com>
 <20130701144331.GA4441@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130701144331.GA4441@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>, trinity@vger.kernel.org

On Mon, 1 Jul 2013, Dave Jones wrote:
> On Mon, Jul 01, 2013 at 05:35:05PM +0300, Tommi Rantala wrote:
>  > I also want the ioctl definitions from the header (in code living in ioctls/).
> 
> Sounds good, I'll merge it and the other patches in a while.

I looked into adding the perf_event ioctls myself, but got lost a bit in 
trinity's ioctl code.  It seems to expect you are opening a file in /dev
to operate on, and perf_event ioctls don't work that way.  I could have 
been misunderstanding what it is doing though.

In any case, feel free to steal code from my perf_fuzzer which exercises 
all of the perf_event ioctls, although I need to add in code to explicitly 
fuzz the PERF_IOC_FLAG_GROUP ioctl paramater which I somehow didn't learn 
about until a few days ago.

Vince
