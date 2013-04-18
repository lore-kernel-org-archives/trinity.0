From: Michael Abshoff <mabshoff@gmail.com>
Subject: Re: syscall vmsplice gives a lot of : *** glibc detected *** trinity:
 malloc(): smallbin double linked list corrupted:
Date: Thu, 18 Apr 2013 19:03:36 +0200
Message-ID: <CAANmmGFS6-8M5dmSkKQUNHN0JzJSphbQboV+01GR1AU-Rq07+w@mail.gmail.com>
References: <517022C4.90400@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        bh=uAjSj9tBFhM011xHx8R/ybTWUFdEBh7VNAtY5CI38o8=;
        b=AZiXEyyZKAA2jM5BA7i6RPPc0yGJ49TmpN2YBBcyHL1DsgnANUtPQ07qMEBvTIKU7R
         FtSUz55mPvhUNn80xnBGYmoilNUz6EN0TPqc+l1bdG/C2HKwfZxhNUSFiXPgyeuR7JAp
         1hZC2REOpEhmc1yGh+ThePdIU8zidXh6IxbqPDWqinpeluhavl5EJXboZWbzn2YUEFr1
         ECKC92L7XsHvxLP3WyiFP+HRfiZEb3MAV7ussJaXmPpjGgP/tObGCQLaWdAZ4oow6scR
         GVgniF7dgsruzFeqHas/layb4t8g2dwCca5T6uSYGrcrj8KiZGnbL4jiZB1PwDZ/q6DA
         Wb/g==
In-Reply-To: <517022C4.90400@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

[Attempting to resend as plain text since gmail will hopefully not
screw me this time]

On Thu, Apr 18, 2013 at 6:43 PM, Toralf F=F6rster <toralf.foerster@gmx.=
de> wrote:
>
> When I tried the syscall vmsplice under a 32 bit (Gentoo Linux) user =
mode linux I get tons of :
>
>

<SNIP>

>
> vex x86->IR: unhandled instruction bytes: 0xC5 0xF9 0x6E 0x40


<SNIP>


>
> Is this just related to valgrind or is this a trinity thing ?
>

It is a valgrind issue, i.e. AVX instructions in 32 bit mode - see

   https://bugs.kde.org/show_bug.cgi?id=3D301967

Cheers,

Michael
