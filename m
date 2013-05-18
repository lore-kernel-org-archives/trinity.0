From: Dave Jones <davej@redhat.com>
Subject: Re: a perf_event_open() update
Date: Fri, 17 May 2013 21:01:49 -0400
Message-ID: <20130518010149.GA21455@redhat.com>
References: <alpine.DEB.2.02.1305171115180.8633@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305171115180.8633@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Fri, May 17, 2013 at 11:18:39AM -0400, Vince Weaver wrote:
 > 
 > Here's a patch that improves slightly the coverage in perf_event_open().
 > 
 > It handles cache events and breakpoint events.
 > 
 > perf_event_open() is such a complicated syscall it's fairly unlikely to 
 > generate a valid event randomly, even with these changes.
 > 
 > Also a question: is there a way to easily generate a 64-bit random number?
 > >From what I can tell rand() only generates a 32-bit one?

I was going to wait until I get back from vacation, but
your comment persuaded me to push out what's in my
current tree.  check out rand64.

totally untested so far beyond compile testing.
more when I get back on Tuesday.

	Dave

