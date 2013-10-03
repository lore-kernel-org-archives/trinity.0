From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: Patch suggestion - logs cleanup
Date: Thu, 3 Oct 2013 10:31:03 -0700
Message-ID: <CAEGbLtsZRWzgLqGNww0S2jFgjcPOK-Jx=7oefL7-6nqUtkVDVw@mail.gmail.com>
References: <CAEGbLtsZfQXE1Qs+5ruEsJwaSdeJ0upeoW0qnEOrAk3RRdZ6YQ@mail.gmail.com>
	<20131003001157.GA17386@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=66olU52RDxyFGNbVhZVt/wgH0Qt7TR8+vcJb3ly/XNw=;
        b=Chny3x/cSXeP0mwCPYeoyZmOQ4/+30fZj5LMsnPpywWvyrM1gb9GmaJo9BGWTUm+KO
         1SXiBWwgPuDHq9rpCPAZQgKzjMuHHNPE5e3rIXHLA0S9v40U2YDZ056FWBcWNGEVLi/0
         Ow8yIpb67pFosmBrk7vhmav00ccvrklOfUjr9tBJXAgFGfkVvO48SL+EHfrg7t07q7s/
         QmtdxVJf3JM97UKdek4tvThX0mezJh4IjIj7xqOILS9dGN2vdssa40gV/DaLfaytlP5b
         fSQAGDfNDq0UoLvARLOITHEFKIKjI3IfRrbg9cJKgJ7Ta+P8VPcFUmK+TCSZfgCiO+b2
         tqng==
In-Reply-To: <20131003001157.GA17386@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Sure, let me deal with the printf first and then I will take a look at
debugf. BTW, before I jump to printf, can I ask you to push the last
patch I've sent, just want to avoid painful merge after with it, since
it does move some printf around a bit.

On Wed, Oct 2, 2013 at 5:11 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Oct 02, 2013 at 05:04:50PM -0700, Ildar Muslukhov wrote:
>  > How about cleaning up source from all the printf and converting them
>  > to the output? I am willing to do that, since would like to have more
>  > control over logging and output.
>
> yeah, worth doing. Careful though, some of the printf's happen before we've opened
> the log files.
>
> Sort of related: At some point I think debugf needs to log to a separate debug log file.
>
>         Dave
>
