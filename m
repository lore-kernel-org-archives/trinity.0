From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: Patch suggestion - logs cleanup
Date: Fri, 4 Oct 2013 12:34:35 -0700
Message-ID: <CAEGbLtsVDped4dT1z7Bbr6dxXbhET+R9D-P3uEjsx+GeFM6rBg@mail.gmail.com>
References: <CAEGbLtsZfQXE1Qs+5ruEsJwaSdeJ0upeoW0qnEOrAk3RRdZ6YQ@mail.gmail.com>
	<20131003001157.GA17386@redhat.com>
	<CAEGbLtsZRWzgLqGNww0S2jFgjcPOK-Jx=7oefL7-6nqUtkVDVw@mail.gmail.com>
	<20131003175000.GA12445@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=elfoQACMTYslE2yjWqh4q0YfVFaKxtbFmG8LgAIktCU=;
        b=EYwfif/qj7TgBALTbB15Ui1HKoxiAem5leTd/NrQkhmuiEgcQ5NPJA8Uy4sJENP2t9
         n3gnUAuPl9+OYWyvrUQGEzkAIszC+uLTe8tOagb17J1qD9wA5OAxzVvUgFbBXYI8BWSl
         3RaMDV2OhPHMYGQunbnV6xMV/PV1gEBc5uPbGz991mYqkKoOcLmrjX7KQ3WaqZBf9KkO
         zex0yJKHxDujgap4H9jPoGkoHjO/YvU0ud7RHMWh55uKj7FpZldVIPnJ+tQ092vcq89L
         o05a9fPrZOb6yr6NWXyD03B5+h7ByMNRGfIWOyo6cCrj/GGn32IiBVJms0cKpps6m9Az
         jgtA==
In-Reply-To: <20131003175000.GA12445@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

What do you think if we combine -l, -q and -v parameters in the following way:
absence of the parameter will set log level to base (1)
-l off will work as it is right now (logging is off)
-l N is setup of the level (i.e., -l 1 will be equal to the default
settings, where N can be from 0 to 2 as it is right now).

This way we can simplify the log handling from source code point of
view. Having three parameters which might collide with each other
seems rather error prone.

On Thu, Oct 3, 2013 at 10:50 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Oct 03, 2013 at 10:31:03AM -0700, Ildar Muslukhov wrote:
>  > Sure, let me deal with the printf first and then I will take a look at
>  > debugf. BTW, before I jump to printf, can I ask you to push the last
>  > patch I've sent, just want to avoid painful merge after with it, since
>  > it does move some printf around a bit.
>
> done, thanks.
>
>         Dave
