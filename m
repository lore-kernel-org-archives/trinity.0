From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
Date: Tue, 8 Oct 2013 22:07:39 +0200
Message-ID: <CAMuHMdWs6Y7y12STJ+YXKJjxRF0k5yU9C9+0fiPPmq-GgeW-6Q@mail.gmail.com>
References: <524C6643.2040209@gmx.de>
	<CAFLxGvwiH7L4oAW8tw6FyeGczg+rKjUDCdkLKdegy9yX==2cMA@mail.gmail.com>
	<524DBD5D.1040203@gmx.de>
	<524DBFBB.1050002@nod.at>
	<524DC278.3020106@gmx.de>
	<524DC394.6030406@nod.at>
	<524DC675.4020201@gmx.de>
	<524E57BA.805@nod.at>
	<52517109.90605@gmx.de>
	<CAMuHMdXrU0e_6AxvdboMkDs+N+tSWD+b8ou92j28c0vsq2eQQA@mail.gmail.com>
	<5251C334.3010604@gmx.de>
	<CAMuHMdUo8dSd4s3089ZDEc485wL1sFxBKLeaExJuqNiQY+S-Lw@mail.gmail.com>
	<5251CF94.5040101@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=AclGMv7IgyXW24KqzDHU0BXmTvROffWJ/8/yFY5PLro=;
        b=zw7t/P1AUB90h2Tq1WYiAHwswiWKICn91L+Ns75D9n2nevpgBbE1JsBeQcunPcYTwc
         NcKrngKa1s0TmtAKZi9xNL6/eYzfXgGsiSL/xBfjfiZ+W1NXmciEK6tgal2C+PGmYSP4
         zI2iySiqA4n8uo1O612Rqf5n9/2k9BfmeUNuVnvFJkgizR4eZ2QOY1V+XLDGRXCDIWSg
         ICtTkVX93aXD7n50iOm/OvkRa21IjVT7KjkiNcdUxupTlXtWBPaT1whv8XGwK8Yge4dk
         ZGuC32UKFAD1oXHdOjJGlsGLfaBxHfVpAMsP4btttgm5DQDTihHFEo23sAS2bitkNWH/
         mmZg==
In-Reply-To: <5251CF94.5040101@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>, UML devel <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

On Sun, Oct 6, 2013 at 11:01 PM, Toralf F=C3=B6rster <toralf.foerster@g=
mx.de> wrote:
>> Hmm, now pages_dirtied is zero, according to the backtrace, but the =
BUG_ON()
>> asserts its strict positive?!?
>>
>> Can you please try the following instead of the BUG_ON():
>>
>> if (pause < 0) {
>>         printk("pages_dirtied =3D %lu\n", pages_dirtied);
>>         printk("task_ratelimit =3D %lu\n", task_ratelimit);
>>         printk("pause =3D %ld\n", pause);
>> }
>>
>> Gr{oetje,eeting}s,
>>
>>                         Geert
> I tried it in different ways already - I'm completely unsuccessful in=
 getting any printk output.
> As soon as the issue happens I do have a
>
> BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:1521]
>
> at stderr of the UML and then no further input is accepted. With uml_=
mconsole I'm however able
> to run very basic commands like a crash dump, sysrq ond so on.

You may get an idea of the magnitude of pages_dirtied by using a chain =
of
BUG_ON()s, like:

BUG_ON(pages_dirtied > 2000000000);
BUG_ON(pages_dirtied > 1000000000);
BUG_ON(pages_dirtied > 100000000);
BUG_ON(pages_dirtied > 10000000);
BUG_ON(pages_dirtied > 1000000);

Probably 1 million is already too much for normal operation?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
