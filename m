From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/3] use config.h in USE_* users
Date: Thu, 6 Jun 2013 12:17:42 -0400
Message-ID: <20130606161742.GA13108@redhat.com>
References: <1370339304-26492-1-git-send-email-jslaby@suse.cz>
 <51ADB877.9050705@suse.cz>
 <alpine.DEB.2.10.1306051509060.7184@vincent-weaver-1.um.maine.edu>
 <20130605191857.GB24567@redhat.com>
 <alpine.DEB.2.10.1306061210120.23627@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306061210120.23627@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Jiri Slaby <jslaby@suse.cz>, trinity@vger.kernel.org

On Thu, Jun 06, 2013 at 12:14:34PM -0400, Vince Weaver wrote:
 > On Wed, 5 Jun 2013, Dave Jones wrote:
 > > 
 > > For "we don't care about out of tree compatibility" like this, carrying our
 > > own copy of the header sounds like probably the best option.
 > 
 > So something like the following patch?  I stuck perf_event.h in the 
 > syscalls directory, not sure if it should go in include instead?

syscalls/ works. We already have setsockopt.h there.

We can also drop some bits from compat.h if we do this.
Want to respin that diff with that ? (or send an incremental, I don't care which)

	Dave
