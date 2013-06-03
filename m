From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: minor trinity patch
Date: Mon, 3 Jun 2013 08:55:46 +0300
Message-ID: <CA+ydwtqCfUJhq-g-wG442GAs3yyTTfi3xnUNwgDfnGiWqh5D3w@mail.gmail.com>
References: <20121220165100.GA8748@ngolde.de>
	<20121220171726.GA7543@redhat.com>
	<20121220172246.GA16285@ngolde.de>
	<20121220172741.GA17760@redhat.com>
	<20121220200255.GB16285@ngolde.de>
	<20121220201903.GA14944@redhat.com>
	<20130522141458.GA18931@ngolde.de>
	<CA+ydwtrggwedMpTeOfbSDAYDT7H=zZU7qAzSs6SzDW1Yx3Gi4g@mail.gmail.com>
	<20130523234712.GS14739@ngolde.de>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=d71OZFwMXPETxgA7cSsRzffCCKtB0OjRvjRgo7XRssU=;
        b=WUs8mQry1GIeryDc7pDRbStG2QOp827etOgKRiYvO6w4+AxI/TT+6/M/oZoHyxIaRk
         QmW5R0qd7wob6FR+LL+wiiB5+Z6rl3wFbvuVfAZNYGBH6U7wTp/JJH4JU3+o6xwvx4xd
         fNoOvG1ELctNjL3qdQEpf6PZlAGkW0d3ZrlLVhFR6JwCYDNecK4Kg8NvOsWJEnTVyvXi
         OfENNWkykyi3y/NkHavyWa1EmJMjNZrRoMVR+lRWL5GZCDiRQ9kKhGTdMSY4EJvZpU1C
         W4L+N00BceIXZKWJde8x5VGABGo9k5F4xJy96CGJsNMOj0Ws2/UmouwaoUAJ9rGe5fQC
         7FPw==
In-Reply-To: <20130523234712.GS14739@ngolde.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nico Golde <nico@ngolde.de>
Cc: trinity@vger.kernel.org

2013/5/24 Nico Golde <nico@ngolde.de>:
> Hi,
> * Tommi Rantala <tt.rantala@gmail.com> [2013-05-23 20:58]:
>> 2013/5/22 Nico Golde <nico@ngolde.de>:
>> > I changed the code the following way:
>> > @@ -21,7 +22,8 @@ static size_t bldevs, chrdevs, miscdevs;
>> >  static void parse_proc_devices(void)
>> >  {
>> >         FILE *fp;
>> > -       char *name, *line = NULL;
>> > +       char *line = NULL;
>> > +       char name[32];
>>
>> It would be IMO preferable to not hardcode the max length.
>
> I agree, this is actually left over from quickly changing this.
> Are you aware of a proper maximum defined in the kernel headers or do we want to
> allocate this completely dynamically?

dynamic please!

> Cheers
> Nico
> --
> To unsubscribe from this list: send the line "unsubscribe trinity" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
