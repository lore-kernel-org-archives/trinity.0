From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH 5/8] move perf_event.h to include/
Date: Mon, 1 Jul 2013 17:35:05 +0300
Message-ID: <CA+ydwtqCM0_TahM2y3AHG=tbwwyzp14jmMM0WspACic+QiVACw@mail.gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
	<1372620792-16384-6-git-send-email-tt.rantala@gmail.com>
	<20130630232915.GA4325@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Bm722wYawAO1xjlD3DVDNShsjMOHVELyj29wd63jBnM=;
        b=kHxtnPI4tXSN65ikKm0kXcX9CKizD4mAyHue912xorcrny797g28IZYc90tXk2f2G1
         Vce4ljmYdtmZ5qbKOT+coc3BekXKYZFn7Kn7un6cJHtSXjD/nwokPtalhFcdNBVTvJI/
         I3MGu1EtfOU85BarUHZrJ9+6qvRZaNRIGKbZNqOzHBebl8xWvVFRJLn+C1JqFxDDJ80+
         WCwsR7oLLMSBk35gPCqLJdXNIFIlFbxnvBffbWh8YkQejrmMFNegQedz3OlMQ5+u4uy+
         5Bzwe6+Ct+Sw6xSds4bzP8hsHtDubrgRIQPWXUXksf3lb/Z3sciFuWFk4snp0smNUL8l
         HyHw==
In-Reply-To: <20130630232915.GA4325@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

2013/7/1 Dave Jones <davej@redhat.com>:
> On Sun, Jun 30, 2013 at 10:33:09PM +0300, Tommi Rantala wrote:
>  > The perf header will be used also in a few other places beyond syscalls,
>  > so move it to the include/ directory so that it is easily available.
>  > ---
>  >  {syscalls => include}/perf_event.h | 0
>  >  1 file changed, 0 insertions(+), 0 deletions(-)
>  >  rename {syscalls => include}/perf_event.h (100%)
>  >
>  > diff --git a/syscalls/perf_event.h b/include/perf_event.h
>  > similarity index 100%
>  > rename from syscalls/perf_event.h
>  > rename to include/perf_event.h
>
> can you elaborate on this one ?

I'm working on some patches (that I hope to finish sometime soon) to
open more types of file descriptors at Trinity startup, and this
header will be useful for that purpose. (Might also be possible to use
something from syscalls/perf_event_open.c, and perhaps avoid requiring
the header, but did not look into that.)

I also want the ioctl definitions from the header (in code living in ioctls/).

Tommi
