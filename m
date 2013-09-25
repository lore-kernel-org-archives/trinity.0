From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Wed, 25 Sep 2013 13:43:51 -0700
Message-ID: <CAEGbLtscsmvxrqHASFGnO5s-NK2u4+Xrv7gFbH+u7XVGk7Xh6w@mail.gmail.com>
References: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
	<20130924185045.GB21307@redhat.com>
	<CAEGbLtvwBxQwRZVq0s2_UETzn8gn8x6sWrgDSC+FMQAVazB=6g@mail.gmail.com>
	<20130924192130.GC21307@redhat.com>
	<CAEGbLtuLgwY2PzZPLNRwRTpw0pFqvadsxGrsAnVHukwvPefmKQ@mail.gmail.com>
	<20130925203201.GA12603@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=L01Sw8M3Ff/4IO8UwylsrrAN4Zs0ZU5OV00xORgh0tQ=;
        b=Pl13Clo/fxMqdEYU/9mMQZgT1xw4cC8cFYkplB6CJ7ni69Va19i0Lgo8pUDu2ys3fC
         NZRwvLwjLq95Uz6WAYHM1mUWyqtg+H/PI8LrPyJ/rSNsOv/uEXW7H4h1JmMTs581Izut
         mhGVmoiTkKUBIHWcp+E0x/bo7VAWw0urPVQjbXWxL4+ZtJuov78szN/uaFPanTLLQvNe
         EUnk72/lYsZkAEgCpp8poR4pOb5I28/tVHt243CptWyVD3UWdfiWuSJQzowihGlhxO+s
         hjXpuZ81NmI9jUdW0by4bnc+vreLMDkZQh1KEIyTsQ1+gU7fkZojLHVcZrcrE4QeE9uw
         UCFw==
In-Reply-To: <20130925203201.GA12603@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

OK, then I will wait till that push to submit my other patches.

On Wed, Sep 25, 2013 at 1:32 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Sep 25, 2013 at 01:25:21PM -0700, Ildar Muslukhov wrote:
>  > Any luck with the test?
>
> Nothing specifically problematic with 32bit syscalls, but I've got a bunch
> of changes that I'll push out over the next day or so as a result of yesterdays
> run.  I found a bunch of cases where we end up with all the children stuck
> reading fd's, and ignoring sigkill after the sigalarm has gone off. Still tweaking it.
>
>         Dave
>
