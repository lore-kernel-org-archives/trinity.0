From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [patch] update perf_event_open() for Linux 3.19
Date: Wed, 4 Feb 2015 15:31:00 -0500
Message-ID: <20150204203100.GA1842@codemonkey.org.uk>
References: <alpine.DEB.2.11.1502031159070.30766@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1502031159070.30766@vincent-weaver-1.umelst.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Tue, Feb 03, 2015 at 12:01:23PM -0500, Vince Weaver wrote:


 > @@ -237,6 +238,7 @@ enum perf_event_read_format {
 >  #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 >  #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 >  					/* add: sample_stack_user */
 > +#define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */

I've not given this a lot of thought before, but I'm assuming these
are the 64-bit struct sizes.  It might be interesting to also
throw some 32-bit sizes in the mix.  Who knows what horrors
lie in wait for the compat syscalls.

	Dave
