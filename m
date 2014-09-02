From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net v2] ipv6: fix rtnl locking in setsockopt for anycast
 and multicast
Date: Tue, 02 Sep 2014 12:07:25 +0200
Message-ID: <1409652445.22584.16.camel@localhost>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
	 <CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
	 <20140829195339.GA9780@kria> <1409363489.2980.17.camel@localhost>
	 <20140830105821.GB18155@kria> <1409599348.21965.6.camel@localhost>
	 <20140901210520.GB25543@kria> <1409610378.21965.52.camel@localhost>
	 <20140902082929.GA8483@kria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	stressinduktion.org; h=message-id:subject:from:to:cc:date
	:in-reply-to:references:content-type:mime-version
	:content-transfer-encoding; s=mesmtp; bh=KOtkBh9Tz37S97vK+TSdMi4
	jI+Y=; b=Nh+vVXBHotlu5nIsNlvE1s5V55lt4b01s+YWmNr5KTmUl5bp1aAt68x
	UqexTM8vBRQugzB7/BwTmMGqJ+NDeZBfpi8BvAzV8zLcPpOOWNixZYVAPIps3oAT
	bR+UO8AhQS0RuHtqd4a4qMobbIzYuFi70qnTMie8LozXxbMyIH+I=
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:subject:from:to:cc:date
	:in-reply-to:references:content-type:mime-version
	:content-transfer-encoding; s=smtpout; bh=KOtkBh9Tz37S97vK+TSdMi
	4jI+Y=; b=HKQOcJUksUK6YN1YZgyRpd/sCFe+z9T0p7Ep2OwF+qnRPaiq6p32Mh
	0BcMWwywliZ/CHd9QEHd6Kycg+IwY+venlKZ3Dxf3B23/ai8KWM/kPuX+Z93Jyai
	fGrv8p55GD0yiEQNg+VZib5pLB8NRTgvLUNtBPUkVAjpnE6PuOjmw=
In-Reply-To: <20140902082929.GA8483@kria>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Cong Wang <cwang@twopensource.com>, Tommi Rantala <tt.rantala@gmail.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

On Di, 2014-09-02 at 10:29 +0200, Sabrina Dubroca wrote:
> Calling setsockopt with IPV6_JOIN_ANYCAST or IPV6_LEAVE_ANYCAST
> triggers the assertion in addrconf_join_solict()/addrconf_leave_solict()
> 
> ipv6_sock_ac_join(), ipv6_sock_ac_drop(), ipv6_sock_ac_close() need to
> take RTNL before calling ipv6_dev_ac_inc/dec. Same thing with
> ipv6_sock_mc_join(), ipv6_sock_mc_drop(), ipv6_sock_mc_close() before
> calling ipv6_dev_mc_inc/dec.
> 
> This patch moves ASSERT_RTNL() up a level in the call stack.
> 
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> ---
> As was said earlier, this should go in stable.
> 
> v2:
>  - based on net
>  - keep dev_get_by_flags_rcu and RCU in ipv6_sock_ac_*
>  - remove two ASSERT_RTNL() that are not necessary
> 
> Thank you for your help, Hannes!

Thanks for fixing! ;)

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

