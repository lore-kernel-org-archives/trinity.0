From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: vhost && kernel BUG at /build/linux/mm/slub.c:3352!
Date: Wed, 5 Jun 2013 15:06:33 +0300
Message-ID: <CA+ydwtq6FNSXhjGuqtQBUKVQJNOD_iKWpnUqj4rbfQJTkw+bog@mail.gmail.com>
References: <CA+ydwtrtpA3jXojG3tKt_-ueJOWDSOL1trM9h6F5qLvdoonUOw@mail.gmail.com>
	<20130605115408.GA2643@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=onvohc2hMAy1fRfPiaCIHq51MtCQG8ERZkx36tOEbuM=;
        b=U/gARzeaXj8l1bHDWLh06R/zfs2xy6UkIeQ5VmbwBX/cp9gkK/XFQ8uYJv0tL3v92q
         4qpMSsEfhcCPVF60sxyYaJTnB1lUCZWRCy+BwyNAhGZVYhMgEJlTnEeQMZDfVU3f2qBX
         vGVv6wAbLpuvehy3a6DFXrqvcQiy3oqUcLtse/doBg7PyPriC2TpxumqoKjeB8wG1WNw
         DaVx89WR1OVU7BvKfhk2q2vF7aGedxW+SioJR8N5UUKX9gT3dOm7nJ2Ous++trsw26Kq
         eT0ljh1OxYXjuqbixgEEawhE/3O0t6aMIOzEixxh+ZK4MqrPs3/+I9gOjE8rVOVfIEs9
         XvPg==
In-Reply-To: <20130605115408.GA2643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, trinity@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>

2013/6/5 Michael S. Tsirkin <mst@redhat.com>:
> On Tue, Jun 04, 2013 at 09:50:59PM +0300, Tommi Rantala wrote:
>> Hello,
>>
>> Hit this right after killing trinity with Ctrl-C. Was fuzzing
>> v3.10-rc4-0-gd683b96 in a qemu virtual machine as the root user.
>>
>> Tommi
>
> Thanks a lot for the report. If found some bugs when looking
> at this: I think they were introduced by
> 2839400f8fe28ce216eeeba3fb97bdf90977f7ad
> though I don't exactly see how ctrl-c can trigger this.
> I'll work on patches - is this reproducible at all?

Thanks, glad to hear that the report was useful.

Yes, I did reproduce this quite quickly yesterday with trinity, but
did not dig any deeper into what was going on.

Tommi
