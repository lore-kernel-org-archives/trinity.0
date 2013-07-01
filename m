From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 5/8] move perf_event.h to include/
Date: Mon, 1 Jul 2013 10:43:31 -0400
Message-ID: <20130701144331.GA4441@redhat.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
 <1372620792-16384-6-git-send-email-tt.rantala@gmail.com>
 <20130630232915.GA4325@redhat.com>
 <CA+ydwtqCM0_TahM2y3AHG=tbwwyzp14jmMM0WspACic+QiVACw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ydwtqCM0_TahM2y3AHG=tbwwyzp14jmMM0WspACic+QiVACw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: trinity@vger.kernel.org

On Mon, Jul 01, 2013 at 05:35:05PM +0300, Tommi Rantala wrote:
 > 2013/7/1 Dave Jones <davej@redhat.com>:
 > > can you elaborate on this one ?
 > 
 > I'm working on some patches (that I hope to finish sometime soon) to
 > open more types of file descriptors at Trinity startup

Ah, excellent. I was thinking of that after seeing your hack a while back
for epoll descriptors. Looking forward to it. (And glad I don't have to
do it now ;)

 > and this header will be useful for that purpose. (Might also be possible to use
 > something from syscalls/perf_event_open.c, and perhaps avoid requiring
 > the header, but did not look into that.)
 > 
 > I also want the ioctl definitions from the header (in code living in ioctls/).

Sounds good, I'll merge it and the other patches in a while.

	Dave
