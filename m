From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [patch] perf_event_open: update features to 4.14-rc6
Date: Thu, 26 Oct 2017 12:07:54 -0400
Message-ID: <20171026160754.zvomdyzzneimun7x@codemonkey.org.uk>
References: <alpine.DEB.2.20.1710261111210.26934@macbook-air>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1710261111210.26934@macbook-air>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Thu, Oct 26, 2017 at 11:18:13AM -0400, Vince Weaver wrote:

 > It might be too late to hit the release, but the e-mail reminded me to 
 > send this.
 > 
 > This patch brings perf_event_open() support up to date as of 4.14-rc6.

I just added some last minute missing flags to various syscalls, and
this is pretty much the same thing, so applied.

	Dave
