From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 1/4] Add support for cross building using CROSS_COMPILE
Date: Fri, 7 Jun 2013 15:04:26 +1000
Message-ID: <20130607050425.GA26425@concordia>
References: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

On Sat, Jun 01, 2013 at 09:46:15PM +1000, Michael Ellerman wrote:
> Similarly to the kernel.  CROSS_COMPILE is optional, when specified it's
> a prefix, eg. myarch-linux-gnu-
> 
> We still allow overriding CC, separately, or in addition to setting
> CROSS_COMPILE.
> 
> There is also support for cross configuring, because at the moment all
> the configure tests only need to build, they're not run.

Did this series make it to the list? They were the first I sent just
after I subscribed. Or did you just not like them ? :)

Anyway the .gitignore patch conflicts now, I can rebase and resend if
you like.

cheers
