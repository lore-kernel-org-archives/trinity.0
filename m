From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] Added ability to select only 32 or 64 bit syscall
Date: Mon, 30 Sep 2013 09:51:02 -0700
Message-ID: <CAEGbLtsonrCxxeNxfDW0t91R32=6HhfeWWh7_dwnJChNM7pbhg@mail.gmail.com>
References: <CAEGbLtsPA2MvD_=s7ASTg8fkWD-cGHPk=ePGNPnZaALc_XDtsg@mail.gmail.com>
	<20130927214946.GA30967@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ti5Ym2bMWpGs0gWZf/epi8/0rZQmxJdjfTLhUljnZ+0=;
        b=I/QQON8Gkqthoq+oLwj0EYrL3S8RWMHJcd8m6aN7A7W8OPyB1MjPXP6Mt+QOx0Ebas
         EN+BdJ8Aj9r0KPLotQO/Qbj/BQBonbpz1+LyoOf8jw8BQjoUVAQq3cTll+Dg+i+ShQxW
         Bp1tfTyOwQ8zlDAHPWom/Vaz6VaVSHxxYYXgDjrrmt1s+FZDJJPA/j275FliWvVZC0JR
         R31wVN/k6YjymF/GfHwIxwnUHBA87W1MBqdRaZUnYuXVccYMB6vlIaGQKLmm6q29yuoh
         oTgwXph21S1w3xj5PaCufVZIjB+bmmO1omTJDt9prWlZKNxRNXU+eKFXdiALGznEuLaM
         Coag==
In-Reply-To: <20130927214946.GA30967@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Nope,

The splitting of the parameter is done in the toggle_syscall function.

-Ildar

On Fri, Sep 27, 2013 at 2:49 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Sep 13, 2013 at 12:53:16PM -0700, Ildar Muslukhov wrote:
>  > This patch explicit selection of 32 or 64 bit version of a syscall via
>  > parameter.
>
> I only just noticed this..
>
>  > - fprintf(stderr, " -c#: target specific syscall (takes syscall name as parameter).\n");
>  > + fprintf(stderr, " -c#,@: target specific syscall (takes syscall name as parameter and @ as architecture. No @ defaults to both archs.).\n");
>
> The patch I ended up applying looks like it doesn't touch -c parsing.
> Is this incomplete ?
>
>         Dave
>
