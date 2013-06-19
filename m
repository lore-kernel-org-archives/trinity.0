From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Wed, 19 Jun 2013 11:27:22 -0400
Message-ID: <20130619152722.GA22109@redhat.com>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
 <CA+ydwtr7eTOjtzWumr998TcxqhmX_M30aW99S=DF6mOwNURL=w@mail.gmail.com>
 <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Tommi Rantala <tt.rantala@gmail.com>, trinity@vger.kernel.org

On Thu, Jun 13, 2013 at 03:58:37PM -0400, Vince Weaver wrote:
 > On Thu, 13 Jun 2013, Tommi Rantala wrote:
 > 
 > > Unable to opendir /sys/bus/event_source/devices : Resource temporarily
 > > unavailable
 >
 > Though in the case where /sys/bus/event_source/devices isn't available
 > trinity will try opening it again each time it tries to do a 
 > PERF_TYPE_READ_FROM_SYSFS type (1 time in 7).  Not sure if it's
 > worth rate-limiting that.

I'm puzzled why I'm seeing opendir() fail with -ENOMEM when there's gigabytes
of free memory available.  Likewise, getting -EAGAIN seems.. weird.

Is there actually a problem there ? Or can we just remove the output from
the failure paths, and fail silently ?

init_pmus might be simpler if it was converted to use nftw() too.

	Dave
