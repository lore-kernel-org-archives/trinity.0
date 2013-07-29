From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: why does git describe shows 1.1-639-g4f6418b
Date: Mon, 29 Jul 2013 10:02:09 +0300
Message-ID: <CA+ydwtrqzWfyOCufCJCP7ebhKCi4G_wQqsNVwHDuJGRAsmAxBw@mail.gmail.com>
References: <51F3EC8E.5010308@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=MZZv4mvPlQiCxb4rrIGRCghPfO82SDFppAtv6RMyLng=;
        b=T6JtvBkDHgf/WIgov004nmbp++kbupZ8emRP6iQtg/LSiohRqiPUYRuxYFm7BP4CNP
         /SSDadGdp1T5ptMek5c18T8g44PSit1YInZRuKPrX1trUkdVaYmKFtW3RRhVBr/ceZ+M
         Cyen8tyNZHDwPwpc6c9uanU5mck7/ab9SGxMNeo3VXH69WiiSb2klA/CO9VbuQzuQpwg
         sI9r+3oz5C7ixIqiNwW8jgWk2GjM/8Ve1QJoUktTAQLU+b3d/P6Xk16Fy/R88GyWLnjj
         bek5yIA7HFj4SyJcvvhNVORFbr1FUwQV3PWXggHuPBzxD37W5Hk1Jvy8JR1c6zMJJOIj
         oXew==
In-Reply-To: <51F3EC8E.5010308@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

2013/7/27 Toralf F=F6rster <toralf.foerster@gmx.de>:
> and not something like v1.2-... ?

It's because "v1.2" is a lightweight tag. Try:

$ git describe --tags
v1.2-7-g4f6418b
