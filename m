From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: stack smash detected bug
Date: Fri, 4 Oct 2013 10:30:34 -0700
Message-ID: <CAEGbLtschqGS2Gwr=tsvPimKqwSg02kiJsRmde8CSWPBcd3Q7g@mail.gmail.com>
References: <CAEGbLtsV-FUm0Q8NiGyiTscDVUOfqYxz=9Dncv3xFgAb6b6saw@mail.gmail.com>
	<20131004152934.GA22724@redhat.com>
	<CAEGbLtuA81sypq9i2AUyEY89jErdLv6pk_ceaKFSggqBFDFsfQ@mail.gmail.com>
	<20131004171709.GA28371@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=BY2tmdMIj5X1rNDkX+qeOTvSvobcGesO8yEt7Z05dGc=;
        b=bsX2xkvABmfmh5gfnPA6kvtQJMPi3N1hOmY25gYHYlkTgWyY97Rl0WasqudCxWgQk2
         IaqrYcj3dOmwi11eTYI45jNsyuyDzyCu7o2MwuyqUMItKnMfw9d24l5PazcrCsrLR6hf
         EV2t/5omech1Q7YKO8IrFPPRbWw/hYDzy3GR2glVlaQ+nzQVnAqALhGxNXxd9zJvjRa5
         k2KOxSyg2fXXcbHG7/AMBC2CoMZN/zjUa8hF1ZARctz1Qs8biSOlzcsJL8W3agomGxTZ
         LNifkVc1x2WZuhPREJCyh1yk1xxGfMYQA8CDEY97gjQcmIwG/IFTbMDOgMtWoOlwJez/
         hi5g==
In-Reply-To: <20131004171709.GA28371@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

I would rather avoid buffers completely and output directly, I am
planing to take care of it in my "log cleanup" patch that we discussed
before.

On Fri, Oct 4, 2013 at 10:17 AM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Oct 04, 2013 at 10:11:04AM -0700, Ildar Muslukhov wrote:
>  > Here is an example that causes the crash, it is obviously longer that 512 ascii:
>  > [child0:1607] [31] utimensat(dfd=^[[1;36m497
>  > , filename=^[[1;36m".//proc/4/task/4/cpusetd%s%d%d%d%d%s%s%s%d%d%s%d%d%d%d%s%s%d
>  > %s%s%d%s%d%s%s%d%d%s%d%d%d%d%s%d%d%s%s%s%d%s%d%d%s%d%d%s%d%s%d%s%d%d%d%s%s%s%s%s
>  > %d%s%s%d%s%d%d%d%d%d%s%d%s%s%d%s%d%d%d%d%d%d%s%d%d%s%s%s%d%d%d%d%d%d%s%s%d%s%s%d
>  > %s%s%s%s%d%s%d%d%d%d%d%d%s%s%d%s%d%d%s%d%d%s%s%d%s%d%d%d%s%s%d%s%d%s%d%s%s%d%s%s
>  > %d%d%s%s%s%s%s%d%s%d%d%d%s%s%d%s%s%d%s%s%d%s%d%d%s%d%s%d%d%s%s%d%s%d%d%d%s%s%d%s
>  > %s%s%s%d%d%s%s%d%d%d%s%d%d%s%d%s%s%d%s%s%s%d%s%d%d%s%d%s%d%s%d%s%d%s%d%d%s%s%d%s
>  > %d%s%s%d%d%s%s%s%s%d%d%d%d%d%d%d%s%s%s%d%d%d%s%d%s%s%d%d%s%s%s%s%d%d%s%s%d%d%d%s
>  > %d%s%d%d%s%d%d%d%s%s%d%s%s%d%s%s%s%d%s%d%s%s%s%s%s%d%d%s%d%s%s%d%d%s%d%s%s%d%s%s
>  > %d%d%d%s%d%d%d%s%d%d%d%s%s%s%d%d%d%s%d%d%d%s%s%d%d%s%s%s%d%d%d%d%d%s%s%d%s%d%d%s
>  > %d%d%d%s%s%d%s%s%s%s%d%s%d%s%s%d%d%d%d%d%s%d%d%s%s%d%d%d%d%d%s%d%d%s%s%s%d%d%s%s
>  > %d%s%s%d%d%d%s%d%s%s%s%d%s%s%s%s%s%s%s%s%s%s%s%s%d%d%s%d%s%d%d%s%s%s%s%s%s%d%s%d
>  > %s%d%d%s%d%d%d%s%s%s%s%s%d%d%d%s%s%s%s%d%s%s%s%d%d%d%s%d%s%s%d%d%s%s%s%s%s%s%s%d
>  > %s%d%s%s%d%d%d%s%s%d%s%s%s%d%s%d%s%
>  > [child1:1608] [0] setreuid(ruid=0x400000000000000,
>  > euid=0xffffffffffffffff) [child1:1608] = -1 (Operation not permitted)
>
> Ah, of course.. the pathname mangler. Oops.
>
> This perhaps ?
>
>         Dave
>
> diff --git a/syscall.c b/syscall.c
> index 80f5a34..94d2f1b 100644
> --- a/syscall.c
> +++ b/syscall.c
> @@ -222,9 +222,11 @@ long mkcall(int childno)
>         unsigned int call = shm->syscallno[childno];
>         unsigned long ret = 0;
>         int errno_saved;
> -       char string[512], *sptr;
> +       char *string, *sptr;
>         uid_t olduid = getuid();
>
> +       string = malloc(page_size);
> +
>         shm->regenerate++;
>
>         sptr = string;
> @@ -318,6 +320,9 @@ skip_args:
>
>         output(2, "%s\n", string);
>
> +       free(string);
> +
> +
>         if (dopause == TRUE)
>                 sleep(1);
>
