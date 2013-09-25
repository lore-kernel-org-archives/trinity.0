From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Wed, 25 Sep 2013 13:25:21 -0700
Message-ID: <CAEGbLtuLgwY2PzZPLNRwRTpw0pFqvadsxGrsAnVHukwvPefmKQ@mail.gmail.com>
References: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
	<20130924185045.GB21307@redhat.com>
	<CAEGbLtvwBxQwRZVq0s2_UETzn8gn8x6sWrgDSC+FMQAVazB=6g@mail.gmail.com>
	<20130924192130.GC21307@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=zH51y3ja9TjKhvLQiBt7mNc//2wLmDJ17feqEAqS2Po=;
        b=M9oxxyvEATEvd04MsrwiBKx0u2jfCFMIVJtHgb9LwfhSnAlH6Me7nsWpF4YjQN1hNx
         A71XEcDGYY8wAyKBymTZy/WTP9gCAAuXReJXXyQg/aJPh4kKyb+fhBayq8epUHOAnE8l
         RU3YFtkQVSrujApdHefLnG7SeXeuI2kXHJyipG615aYDVAaC0IWheG1XaljXmTrgNWuI
         fvuNfWDnlTYItm5q4loDS4tHw/65LNIpVRV/d+RnAQKhebRYvRYVOL6mU0cCS8wOhNWi
         wpfjMMoqTrbGnrw0fCEtvvOASy/UDyPwyaVRbNOuvLzyURQD167qJ0qXMngJV82BvHyc
         R/ag==
In-Reply-To: <20130924192130.GC21307@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Any luck with the test?

On Tue, Sep 24, 2013 at 12:21 PM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Sep 24, 2013 at 12:03:28PM -0700, Ildar Muslukhov wrote:
>  > Is there any specific steps to reproduce this behaviour? Or just
>  > calling random syscalls will do it?
>
> yeah, nothing special.  I've been running it here for the last half hour
> without seeing anything weird so far. ( I changed the rand to be < 50 just
> to exercise it more).
>
> I'll leave it run for the afternoon, and see if anything falls out.
>
>         Dave
