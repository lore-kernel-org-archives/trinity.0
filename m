From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: Reproducible run and binary logs (ideas)
Date: Thu, 19 Sep 2013 09:03:41 -0700
Message-ID: <CAEGbLtvKqXuGNvFCTTkjL5pr0xKeXrWem36cFYrXBrq_5hLVNw@mail.gmail.com>
References: <CAEGbLtsg8_xLx9YvdrZ-gLWR4UqSQ+DT4mzEV9BfGnf-uHxDjQ@mail.gmail.com>
	<20130919150746.GA2416@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Urk8twwDkWMG8nuWJhuH+dzL1povoHQ0TSKI41S1dD8=;
        b=CmY+nnYddsT/6dl2oSEcgtlpg6GDBLB/3Nd5DY+8DOv9hiGMHLI2hMEHikx2cE5KO0
         TLDmGYL6STwyEcq/YGdBFWoKMWAPckAtccnV+HoSNsQNM/rzObV6P5PJW81HXlmxPQwl
         g1Hq1MqHnQEJa/HcREKlY5RCHHKEFgULGYdHjnFjuKozu8LovOgCpe5USolJtDybt2Kb
         eHAJZNfkH+JvqQZPdIigcH3K5HIqJv6XGagrucqv1A0le+xWkmWLK7GlxbCJIUna30SR
         WeBiissIwOwvFfJqNpK2Kitiu/12RitrXKRMynn6TzoKOC/69Oc5HiciMfLsP9MiU6hR
         Hn6Q==
In-Reply-To: <20130919150746.GA2416@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Ok, lets me just make some tests on that. But what about synching
multiple children processes? And what do you make of a binary log,
that allows to do that.

Ildar

On Thu, Sep 19, 2013 at 8:07 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Sep 18, 2013 at 12:48:40PM -0700, Ildar Muslukhov wrote:
>
>  > Although, the way it is implemented right now is a bit risky, since
>  > the rand functions are called in place, and we cannot guarantee that
>  > no other code (like gcc libraries) hasn't made a call to rand()
>  > function, thus moving the rand queue forward.
>
> This whole idea seems to hang on this statement, and it bothers me.
>
> Can this even happen ? I'm not sure it can.
> And even if it can, surely it's going to happen again when we re-run
> with the same seed, so we don't need to compensate for it.
>
> Before going too far down this rabbit hole, I want to be sure we're not
> over-engineering for a problem that actually isn't.
>
>         Dave
>
