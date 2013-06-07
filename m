From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/4] Add support for cross building using CROSS_COMPILE
Date: Fri, 7 Jun 2013 01:30:37 -0400
Message-ID: <20130607053037.GB2888@redhat.com>
References: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
 <20130607050425.GA26425@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130607050425.GA26425@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <michael@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Fri, Jun 07, 2013 at 03:04:26PM +1000, Michael Ellerman wrote:
 > On Sat, Jun 01, 2013 at 09:46:15PM +1000, Michael Ellerman wrote:
 > > Similarly to the kernel.  CROSS_COMPILE is optional, when specified it's
 > > a prefix, eg. myarch-linux-gnu-
 > > 
 > > We still allow overriding CC, separately, or in addition to setting
 > > CROSS_COMPILE.
 > > 
 > > There is also support for cross configuring, because at the moment all
 > > the configure tests only need to build, they're not run.
 > 
 > Did this series make it to the list? They were the first I sent just
 > after I subscribed. Or did you just not like them ? :)

Sorry, I just overlooked them.

 > Anyway the .gitignore patch conflicts now, I can rebase and resend if
 > you like.

All applied and pushed out.

(For small 1-2 liners I don't mind fixing up git merges. Bigger stuff I'd I've
 asked for a rebase.)

thanks,

	Dave
