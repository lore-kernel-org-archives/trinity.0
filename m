From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] Added ability to select only 32 or 64 bit syscall
Date: Mon, 30 Sep 2013 10:28:27 -0700
Message-ID: <CAEGbLttCZo8nXwn_tAeouG_m_v7RHkt3h9YayYo1Jx=UHJjcCQ@mail.gmail.com>
References: <CAEGbLtsPA2MvD_=s7ASTg8fkWD-cGHPk=ePGNPnZaALc_XDtsg@mail.gmail.com>
	<20130927214946.GA30967@redhat.com>
	<CAEGbLtsonrCxxeNxfDW0t91R32=6HhfeWWh7_dwnJChNM7pbhg@mail.gmail.com>
	<20130930170712.GA9455@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=9EiP0oec0dkLpA2GbCI8XcQNiFdBGuuWxoPKd1Whpfo=;
        b=JwanxAnmow4ZMJa+DXoO20Cj90GMJw+t0rsI7ZUUwsA9V/JsOjIusbj1hZDGvohBS2
         0yrmrf38HUctSXvgvEos0rcRpqyYfVSZql4JMcm7rCefIGFSSS7RvuQSq2Kjsi4RkFoE
         cR8Hu/ghk8LFp81O5EXUpkHqQO40Ior5mGP07rU3ZHtbumybd8kgFtGLCstWNhkvouhG
         8vBqmWi3jVS6Tybf9GYS25IahpbZR8gbdFQKr/gJOtv7J71fLcXPRpsX2nCBkVfw0nm6
         17X+o0adzh+9Yb99C/rGidhfL2pm/sdbjE8MXa8Q5m46SzDO0DcCHFQertKk+reL5JwP
         +U4g==
In-Reply-To: <20130930170712.GA9455@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

I see, I though of this as a bad wording since architecture means
different things but what we are really doing in this parameter is
picking between 64 and 32 bit types, which is also an architecture.
Right now it expects 32 or 64 as an architecture. Thus you need to run
like
$./trinity -c open,32

On Mon, Sep 30, 2013 at 10:07 AM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Sep 30, 2013 at 09:51:02AM -0700, Ildar Muslukhov wrote:
>
>  > On Fri, Sep 27, 2013 at 2:49 PM, Dave Jones <davej@redhat.com> wrote:
>  > > On Fri, Sep 13, 2013 at 12:53:16PM -0700, Ildar Muslukhov wrote:
>  > >  > This patch explicit selection of 32 or 64 bit version of a syscall via
>  > >  > parameter.
>  > >
>  > > I only just noticed this..
>  > >
>  > >  > - fprintf(stderr, " -c#: target specific syscall (takes syscall name as parameter).\n");
>  > >  > + fprintf(stderr, " -c#,@: target specific syscall (takes syscall name as parameter and @ as architecture. No @ defaults to both archs.).\n");
>  > >
>  > > The patch I ended up applying looks like it doesn't touch -c parsing.
>  > > Is this incomplete ?
>  >
>  > Nope,
>  >
>  > The splitting of the parameter is done in the toggle_syscall function.
>
> Ok, then I'm confused, because the syntax above doesn't seem to parse architecture.
>
> $ ./trinity -c open,x86_64
> Trinity v1.3pre  Dave Jones <davej@redhat.com>
> No idea what architecture for syscall (open,x86_64) is
>
>         Dave
>
