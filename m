From: Dave Jones <davej@redhat.com>
Subject: Re: rand64 change
Date: Fri, 12 Jul 2013 17:46:35 -0400
Message-ID: <20130712214635.GA20555@redhat.com>
References: <alpine.DEB.2.10.1307121746060.28314@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307121746060.28314@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Fri, Jul 12, 2013 at 05:48:37PM -0400, Vince Weaver wrote:
 > 
 > I noticed the following change.  The perf_event_open() syscall has various 
 > 64-bit fields (that are 64-bit even on 32-bit machines) that I set with 
 > rand64().  Do I need to change something to get that to work?

Ah, I forgot about that. No, I'll change it so it returns u64 even on 32bit.

	Dave
 
