From: Dave Jones <davej@redhat.com>
Subject: Re: [patch 1/2] add init() function to struct syscall
Date: Wed, 19 Jun 2013 22:38:27 -0400
Message-ID: <20130620023827.GA24618@redhat.com>
References: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Wed, Jun 19, 2013 at 10:09:09PM -0400, Vince Weaver wrote:
 > 
 > While working on the perf_event_open() sysfs init problem, I was wondering
 > if it might be easier if we added the possibility of an init() routine
 > to each syscall structure.  That way trinity can support doing setup
 > before fuzzing begins.
 > 
 > Below is a quick patch implementing this, it seems to work but I still 
 > don't have the best grasp of trinity internals.

Looks ok to me. Good idea actually. I'll queue these up.

	Dave
