From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: Patch suggestion - logs cleanup
Date: Fri, 4 Oct 2013 13:07:52 -0700
Message-ID: <CAEGbLtt92MLR8zoZEneoe2LT31QPOVL2N1nGaCSJWOd=FEVy_A@mail.gmail.com>
References: <CAEGbLtsZfQXE1Qs+5ruEsJwaSdeJ0upeoW0qnEOrAk3RRdZ6YQ@mail.gmail.com>
	<20131003001157.GA17386@redhat.com>
	<CAEGbLtsZRWzgLqGNww0S2jFgjcPOK-Jx=7oefL7-6nqUtkVDVw@mail.gmail.com>
	<20131003175000.GA12445@redhat.com>
	<CAEGbLtsVDped4dT1z7Bbr6dxXbhET+R9D-P3uEjsx+GeFM6rBg@mail.gmail.com>
	<20131004200519.GA10511@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=qgGR3GU8OlOJeVwjJ0tcZbNe3uSyKEzn16eVYdT+MHk=;
        b=dFM8RB1OO3JxR3+vBXBkyt6gZ/S1fcXnU2/WLQEOG2CSPNsxsnvdlQFfvPV1melIGn
         23o6qgtK9Uk6KbTaB45/2kjSNarCNVMRPA1gZath7+hsd3h6sVc7KF0cm091c5qyshZd
         CZXhH9LeYx2qZ6DewbEGAbzenCkly03XK7jQWlRSN1cJGHmZsZhRz+pa+v8K4TAF08nK
         s8eTLBsv2LOM/an1sdfcjhJiMDIptwP1PTnzOf2X+QejM/5kranmsFDnngOn2Z7wzWUe
         495AhCkWnv/JfUaznx4X9etCUfOThkEZM8vH0CYbAQCWqfqCCyGC7OghPU/zNzLQoX/3
         PRFw==
In-Reply-To: <20131004200519.GA10511@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

got it, then lets keep it as is.

On Fri, Oct 4, 2013 at 1:05 PM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Oct 04, 2013 at 12:34:35PM -0700, Ildar Muslukhov wrote:
>  > What do you think if we combine -l, -q and -v parameters in the following way:
>  > absence of the parameter will set log level to base (1)
>  > -l off will work as it is right now (logging is off)
>  > -l N is setup of the level (i.e., -l 1 will be equal to the default
>  > settings, where N can be from 0 to 2 as it is right now).
>  >
>  > This way we can simplify the log handling from source code point of
>  > view. Having three parameters which might collide with each other
>  > seems rather error prone.
>
> Combining them might mean we can't express some existing use-cases though.
> Verbosity of the messages to the screen vs what gets logged to disk are kind
> of separate things.
>
> Valid right now:
>
> logging to disk, no output to screen other than seed. (-qq)
> logging to disk, output seeds & watchdog progress counter (-q)
> logging to disk, syscall details (no args)
> logging to disk, verbose output (-v)
>
> and 'no log' variants of all.
> I'm not sure we can really express 8 possibilities into one arg and
> without people needing to look up what the values represent.
>
>
>         Dave
>
