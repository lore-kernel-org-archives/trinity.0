From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net v2] ipv6: fix rtnl locking in setsockopt for anycast
 and multicast
Date: Tue, 2 Sep 2014 09:43:20 -0700
Message-ID: <CAM_iQpWs804KO4pNM302uc__i90MgUBHODA2cofWQTvCCx74jw@mail.gmail.com>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
	<CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
	<20140829195339.GA9780@kria>
	<1409363489.2980.17.camel@localhost>
	<20140830105821.GB18155@kria>
	<1409599348.21965.6.camel@localhost>
	<20140901210520.GB25543@kria>
	<1409610378.21965.52.camel@localhost>
	<20140902082929.GA8483@kria>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=dwIo0HeF5+Bpln9FZEt7mAKUhjzNYmz9NxGMCCIGCOg=;
        b=dAQLMxpXujM3uUQu1a9vnPJYDd7XyL9nWpO2aHTO4uRMRrBbZk/fE39NhWWRI1BWts
         A6GweRNpOj29uHNH+ndwSuUo4KNmWlu3j8BVns/FsoHcRxY8FeVmdFctOJiy02nkyuc5
         sJ5rSTmc4Tdpp7igDHXVhlzDf0rJjKoBQjdYIaJAhGfkxKkJLUBCh0GSCC9t1zk5pJxw
         yZ0R74hbTAEDq17PtcTafwje2XCwIDQ3AF1HnJN8pZnHO+XmyJrlk/UCvwa2NEAAd6XA
         +W1I4B7okrMWwEG1uyOs8yzLS9eEt3zzJB4WsNqkh+Arn4lPPGF2+5Fs+yMQ8/7Q+7gJ
         i0Sw==
In-Reply-To: <20140902082929.GA8483@kria>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>, Cong Wang <cwang@twopensource.com>, Tommi Rantala <tt.rantala@gmail.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

On Tue, Sep 2, 2014 at 1:29 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> v2:
>  - based on net
>  - keep dev_get_by_flags_rcu and RCU in ipv6_sock_ac_*
>  - remove two ASSERT_RTNL() that are not necessary

There is no point to keep RCU here. Hannes' reply doesn't make
any sense.
