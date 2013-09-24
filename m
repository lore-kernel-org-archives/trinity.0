From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Tue, 24 Sep 2013 12:03:28 -0700
Message-ID: <CAEGbLtvwBxQwRZVq0s2_UETzn8gn8x6sWrgDSC+FMQAVazB=6g@mail.gmail.com>
References: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
	<20130924185045.GB21307@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=QwxBGkGJtNck+i79Slpg+ZWe2EstaR97K63vVtoJcos=;
        b=d8vTUk3ODdLg2rql6OJcb4sffOxCyAtMYswyOAvE+8SFdPWS8Wv9PUrIePn7cmdJUc
         xJpMQztzNLIL+/Gkcvj0XImREGfK8/TewDu19XUfZpUijfFWsT5geIqz3in7i1S9USOi
         6eyF2F/QnJDvJQj01Xlf/d/a7PauZ/8FUHFd0Lg4u3eDDAQyDDBryp9KAZzvONpicEqH
         LXPRkcnYWoNtimE7TrkDFSzgZl/4aZf14zntPpMl8f9I7nbNbZgb4KkcJmghvUGMzT5E
         Sj+z0OwNszR3y2kLavt8Wjt76+f5zdij4SbGuAtX4OXAmbAKgLQM9b2NNAKELaMTb9TV
         aZeA==
In-Reply-To: <20130924185045.GB21307@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Is there any specific steps to reproduce this behaviour? Or just
calling random syscalls will do it?

Ildar

On Tue, Sep 24, 2013 at 11:50 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Sep 24, 2013 at 11:36:53AM -0700, Ildar Muslukhov wrote:
>  > Hi everyone,
>  >
>  > In the children/random-syscalls.c file (function choose_syscall_table)
>  > there is a FIXME section that right now disables 32 bit version of
>  > syscall if a 64 bit version is present and enabled.
>  >
>  > // FIXME: I forgot why this got disabled. Revisit.
>  > //                      if (rand() % 100 < 10)
>  > //
>  >
>  > Just want to clear this one out. Should it be a command line
>  > parameter? Something like -P 50 (for 50% probability, lets say of 32
>  > bit). If so, what should be a default behaviour when the parameter is
>  > not present 50/50 or 0/100 as it is right now.
>
> So that got disabled a long time ago. Back in May of last year in commit
> 2d4de3c15fa80c42cccb1863fbd7879ef5aeaf38.
>
> I'm not sure that ever got fixed up. It might be worth doing some long
> runs to see if it's still a problem.
>
>         Dave
>
>
>
