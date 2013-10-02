From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Wed, 2 Oct 2013 14:03:24 -0700
Message-ID: <CAEGbLttF_6KyyHO1YwgDBbnvioHYSqwb=rA2gKV_sXFtpZ9eAQ@mail.gmail.com>
References: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
	<20131002151244.GA10872@redhat.com>
	<CAEGbLtv4wtaRuTVDPxpQcg0WWv2jDaa59vpX5MHTWe=gz-zBoQ@mail.gmail.com>
	<20131002164337.GA17276@redhat.com>
	<CAEGbLtuTi3BZffyGLahgGDVp2YhqWMPwY6VLUOBdnfnVzZDeQQ@mail.gmail.com>
	<20131002181537.GA30862@redhat.com>
	<CAEGbLttVfFEc0-LNGPYfFthQwx7j5ME38R8a4uCGa8NNWaxueQ@mail.gmail.com>
	<20131002204830.GA7803@redhat.com>
	<CAEGbLtsSsEVwThAf677d3-DGjUMpSqQNVGmyyzJP5Fidiui8=g@mail.gmail.com>
	<20131002205733.GA8531@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qGdEuAqSMQG1WfaW3sJv2Oi6F3cssTLE8HbKbSntNJo=;
        b=b/G8nQSPQVwxDgVlSXflKAMScT42BjCs1J6/Tg8w5cEbubYYtCi/7bW4NiNGqg55M4
         i8zCuEoBTFDQx3DEU/m4Xo21mrwE9WCS0u3BQqYQakwWf57LL5tsljp3IsDsYdufyE3+
         OInuHI56FNUUlrdJXfST069yd9RZxSgj5bQBhNG4UZpzlxb5mYunetCydBeFFUWYSma3
         rdeji70fGgksTb+tKJM6imHlcmEdGrCB5ynJnQRT+Q+5FcmZHO4D3GGUnbGA4E3kH2OQ
         ll/4Kzce0k7vBiLTTb3zYNx9EDxOfWGCXQdPHjqV5BSVrXgVRfM266KPtmXqrdqghvqa
         1QmQ==
In-Reply-To: <20131002205733.GA8531@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

OK, I've looked through logs of several runs and seems to me that
32bit faults look legit, they just doing something bad or hang the
process and thus getting killed by the os or by watchdog. At the end
of the day, if someone does not want to have such noise on x86_64 arch
use "-a 64" argument to switch off all 32bit calls.

On Wed, Oct 2, 2013 at 1:57 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Oct 02, 2013 at 01:53:15PM -0700, Ildar Muslukhov wrote:
>  > Got it. I wonder, what are the settings you running the trinity
>  > yourself? Are you fuzzing all calls at the same time, or you limit
>  > your self to a set or one function at a time?
>
> depends. if I'm not looking for anything specific, I'll just fire off
> scripts/test-multi.sh   Once I've triggered something, I might narrow
> it down with more specific parameters (see scripts/find.sh) for eg.
>
> Also sometimes I'll add something like -x perf_event_open or the like
> to the scripts to avoid hitting certain bugs until they're fixed.
>
> Sometimes I'll remove the '-l off' if I want to try and pick through the logs
> after hitting a bug.
>
>
>         Dave
>
