From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RTNL: assertion failed at net/ipv6/addrconf.c (1699)
Date: Tue, 02 Sep 2014 11:21:33 -0700
Message-ID: <1409682093.26422.5.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CA+ydwtoDwQVg_BWrxxdpUyJ7Up60GtxTCLYe_5vFdV2td_kGhQ@mail.gmail.com>
	 <CAHA+R7MZCDGRhSf=UuVCGQvNo03wVziZQB_X30rwNf6hmHipQA@mail.gmail.com>
	 <20140829195339.GA9780@kria> <1409363489.2980.17.camel@localhost>
	 <CAHA+R7ODa+LrdwSrS7HcBfwwq8_fpj-Ld0OCDtcOqkpCdZCvxg@mail.gmail.com>
	 <1409680684.972417.162793869.03CF8A61@webmail.messagingengine.com>
	 <CAHA+R7Mwy1SCpEUgGf9BdLEro6N-3t89KU=xL0iuzgOppXELrQ@mail.gmail.com>
	 <1409681487.26422.1.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAHA+R7PY=Pu7VKA3wp1DxeJRckxPNWL-xfv2XXkpaY935kt61A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:content-transfer-encoding:mime-version;
        bh=8IQPqHY0OjJfZxJv4VpJ1qKvn/tJ2QLXEtTS8TflRkQ=;
        b=LdNsSfHuUZlMS6ZkCAxZoDJNjKSeXZ39aqtiPMsqwuiGzr9aafU2SbWYHb5gC8qP2p
         Y7evuVMyaqXtZoc3Njs2JzkgM5Hl1I3v0JygqaNw35ENgt+ieHXMd4YP63I6MGLZoG74
         xavXMLjckcz/uKXYrlZ8b0O+Yiq+OdEuERQwWcNENRZ6lcBBrSzOHYEtSZjb8WJxlSQ5
         8v91pKp2amUA9XhWMXzT+X7RVFJvIHhC/oUkMVIpudd1ZdB5AgfpZ5uvpI4A1Iw0VJZN
         kPuDfhZleBb1LaJRhcEjYG2MpeNpFG23yk7u4x0ZDHm9o2zhPRjnOCGKN7lKc4GFfzPo
         kj/g==
In-Reply-To: <CAHA+R7PY=Pu7VKA3wp1DxeJRckxPNWL-xfv2XXkpaY935kt61A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Cong Wang <cwang@twopensource.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>, Sabrina Dubroca <sd@queasysnail.net>, Tommi Rantala <tt.rantala@gmail.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

On Tue, 2014-09-02 at 11:15 -0700, Cong Wang wrote:

> That is what we do when backporting patches, I can do that if David asks
> me to backport it, but you know for netdev that is David's work.
> 
> (I am not saying I don't want to help him, I just want to point out the fact.
> I am very pleased to help David for stable backports as long as he asks)

Problem is : your patch submission do not identify bug origin.

You claim you want to help, but you do not provide the basic thing that
_really_ helps.

The proper way to identify bug origin is to add in the headers one
line :

Fixes: 12-digit-SHA1 ("patch title")


