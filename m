From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] Enabling masking of unimportant kernel taint falgs.
Date: Thu, 19 Sep 2013 10:36:16 -0700
Message-ID: <CAEGbLttZrdbBVPYzDZx9Fat2i2F6_nibFFpAWtA+WXkrY5xBQA@mail.gmail.com>
References: <alpine.DEB.2.02.1309171706510.10505@ildarm-linux.kir.corp.google.com>
	<20130919172013.GA9385@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=b82kzQnfTby5uiRjRmkWKSfygNtSZWtQ7UECbstJCXM=;
        b=V8DSbfbw7QaFconiNmbfCBndSEhVXVyZavqQS+11xIoIJ4PLqav8g2fWZVDSFez0LZ
         Mev+c+t/fy2jEaCSREXsI6Xkicse2FTcQrPAufIqYyazlrQP0uTCUBJSN2Qwthl0faQN
         mik2wRTKcefa5nIWpohzTSA/dDGa4+VQPrtUBmfjXc2+bTCmwEDgN6wCPT1iTtf80M+D
         BcB3AwHy3CMHSUyROoXt2dy7z6I8mh7tWTj0+M1NlXl0kMFhFZBaB/itaAt/e7hvwr0I
         QpGrjiEwGsC0ExVvkZLwqiUPO+OUj+yiFNDGVQlIFn8ZVWPpzOdmzLYvduuwgr5iSHjM
         F7+Q==
In-Reply-To: <20130919172013.GA9385@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Another way is to show the flags values in the help, as a reference
point, since we will have to show these literals in help anyway (or
readme file).

-Ildar

On Thu, Sep 19, 2013 at 10:20 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Sep 17, 2013 at 05:11:05PM -0700, Ildar Muslukhov wrote:
>  >
>  > This patch introduces a new parameter to mask unimportant kernel taint
>  > flags.
>
> No objection to the idea of this, but I think the user interface is a bit painful.
> Who remembers those bitmasks?  It would be better if it used the names the kernel uses,
> so we could do something like
>
> --taint=DIE,BAD_PAGE
>
> Makes the parser a little more complicated, but imo would be much more usable.
>
> thoughts?
>
>         Dave
>
