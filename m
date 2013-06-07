From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 1/4] Add support for cross building using CROSS_COMPILE
Date: Fri, 07 Jun 2013 16:44:49 +1000
Message-ID: <1370587489.4996.1.camel@concordia>
References: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
	 <20130607050425.GA26425@concordia> <20130607053037.GB2888@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130607053037.GB2888@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Fri, 2013-06-07 at 01:30 -0400, Dave Jones wrote:
> On Fri, Jun 07, 2013 at 03:04:26PM +1000, Michael Ellerman wrote:
>  > On Sat, Jun 01, 2013 at 09:46:15PM +1000, Michael Ellerman wrote:
>  > > Similarly to the kernel.  CROSS_COMPILE is optional, when specified it's
>  > > a prefix, eg. myarch-linux-gnu-
>  > > 
>  > > We still allow overriding CC, separately, or in addition to setting
>  > > CROSS_COMPILE.
>  > > 
>  > > There is also support for cross configuring, because at the moment all
>  > > the configure tests only need to build, they're not run.
>  > 
>  > Did this series make it to the list? They were the first I sent just
>  > after I subscribed. Or did you just not like them ? :)
> 
> Sorry, I just overlooked them.

No stress.

>  > Anyway the .gitignore patch conflicts now, I can rebase and resend if
>  > you like.
> 
> All applied and pushed out.
> 
> (For small 1-2 liners I don't mind fixing up git merges. Bigger stuff I'd I've
>  asked for a rebase.)

Thanks.

cheers
