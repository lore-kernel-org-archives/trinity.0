From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 5/8] move perf_event.h to include/
Date: Sun, 30 Jun 2013 19:29:15 -0400
Message-ID: <20130630232915.GA4325@redhat.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
 <1372620792-16384-6-git-send-email-tt.rantala@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1372620792-16384-6-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: trinity@vger.kernel.org

On Sun, Jun 30, 2013 at 10:33:09PM +0300, Tommi Rantala wrote:
 > The perf header will be used also in a few other places beyond syscalls,
 > so move it to the include/ directory so that it is easily available.
 > ---
 >  {syscalls => include}/perf_event.h | 0
 >  1 file changed, 0 insertions(+), 0 deletions(-)
 >  rename {syscalls => include}/perf_event.h (100%)
 > 
 > diff --git a/syscalls/perf_event.h b/include/perf_event.h
 > similarity index 100%
 > rename from syscalls/perf_event.h
 > rename to include/perf_event.h

can you elaborate on this one ?

	Dave
