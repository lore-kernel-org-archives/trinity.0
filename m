From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user addresses
Date: Tue, 28 May 2013 10:54:35 +0200
Message-ID: <20130528085435.GC30172@gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
 <20130522.142847.791230763817666795.davem@davemloft.net>
 <20130528082514.GA29730@gmail.com>
 <20130528.015105.1513437101791265718.davem@davemloft.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pp4DMVuKRWeZxMGbVk6gMobY8ni97Vvcgw/CDuNExpo=;
        b=V3zgDSRdetIt3NAvJeRenVQfysdPBmJRkRp5lftvKBLl1neYQ0/YDVfYYtyqp0+Y2H
         DfAlke9C2Ddwx+D7mfMxLheDILyxaR26LpCUFHsLy65NlXIEiXZ5vUo8i8uDDNW6+jaw
         7iEQHYp6hjMGq+eEQhPpv1pUX4iA7XMSAN6RsXCIR/cszo3uaeyc28sMBDGRwAqGTiZf
         T2/0nRaYREP2hQByom+Gke6FIOyQZRMoxdAtxvj5fCTYWM2a6QvO24KmP2fQkxKji/x8
         fx8up2nhhQq1myE5a1iPICriQOvq/wVsVrGmsTQszbcMWukcIQrcM4HayKRpRjtsS+Or
         WRPw==
Content-Disposition: inline
In-Reply-To: <20130528.015105.1513437101791265718.davem@davemloft.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, x86@kernel.org, trinity@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@kernel.org>
> Date: Tue, 28 May 2013 10:25:14 +0200
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> >> Please don't mix networking and non-networking changes into a patch
> >> series.
> > 
> > As explained in 0/5 the networking fix justifies the first 4 patches. The 
> > networking fix is independent of the first 4 patches.
> > 
> >> Submit the networking patch to netdev@vger.kernel.org
> > 
> > He Cc:-ed the patch to netdev@vger.kernel.org. If you agree with it then 
> > the fix should probably be picked up ASAP.
> 
> He submitted it as part of a series which implies that it belongs together
> with the others.

And then described it in the 0/5 patch that it's not. It's also visible 
from the title, the changelog and the diff of the 5/5 patch that it's a 
separate fix.

So please consider it submitted.

Thanks,

	Ingo
