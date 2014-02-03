From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: BUG ip_dst_cache (Not tainted): Poison overwritten
Date: Mon, 3 Feb 2014 21:35:24 +0200
Message-ID: <CA+ydwto5CTDSED=pZ_DfAZyh6Jx7xKJafRuDFUtV4ZZCb70ULA@mail.gmail.com>
References: <CA+ydwtrWCgi=v7v=8yjNMV37Aa4ua9zbqYM5_uUdQrLSQt+VEw@mail.gmail.com>
	<1391201873.28432.86.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+ydwtpmFbhkck9z8G7tfHQZW+4rWSepQMgPURqVCwrZ77v2bA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=sIls2iLmnzp4jtQ79847+OkZHIYllTEo3OLpHJcwaHY=;
        b=Gtd9Ie768b4cnjKJhN/EJ6KWURLnuFAHwcKY7Pi2nL65jtBnOuoc9ElWM5o+ySVD4O
         RakuzKTChNOuY8x0Nd3naKDGBg7Gx1zisZ56ELxpaCMGDNnSp1/w/RySS15adSUbHgDV
         S7FC3gDKP9COM0QRLGt41bfaZ/lguny4e8Bvof6rfKKJvnpraDmE7bjsrlVMGr6huWqw
         jmHe0ueHwn4tf2dz85/vuy7oLrVkfvAYDgtPd0yt6X07N0tLVO/U5Q9b+3O2+YAdptbT
         w3EcA72+J1no7d3QTNekfsPrCq0HxdcTJKjsIpbQOsfuOMTGDslVxe94ZvLZI5KTmo9a
         iDDg==
In-Reply-To: <CA+ydwtpmFbhkck9z8G7tfHQZW+4rWSepQMgPURqVCwrZ77v2bA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

2014-02-01 Tommi Rantala <tt.rantala@gmail.com>:
> 2014-01-31 Eric Dumazet <eric.dumazet@gmail.com>:
>> On Fri, 2014-01-31 at 22:11 +0200, Tommi Rantala wrote:
>>> Hello,
>>>
>>> Hit this while fuzzing v3.13-9218-g0e47c96 with trinity in a qemu
>>> virtual machine.
>>>
>>> Tommi
>>
>> Hi Tommi
>>
>> Could you please try the following fix ?
>
> Thanks, giving this a spin. This does not reproduce very easily with
> Trinity, I'll let you know if anything blows up.

Looking good after two days of fuzzing in several virtual machines.
The bug has not been reproduced, and no other ill effects visible.

Thanks!

Tommi
