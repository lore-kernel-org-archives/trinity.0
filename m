From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH 3/6] refactored output function
Date: Tue, 15 Oct 2013 10:07:23 -0700
Message-ID: <CAEGbLtvbREAxgQJL1bqMB-9NE3r=AkVEuT85XHFs3EQb7xJNfg@mail.gmail.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
	<1381267615-9826-3-git-send-email-ildarm@google.com>
	<20131010182037.GA7939@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=T+mt9U3/+rRgJEf52p0ABvcc6/p36ynXxRuhgfXI+ok=;
        b=jSNwwMtz9RrHYj31a5p704sMBToxrcswAIhiPidIX9Xifjf9uzE9ImGJ7xGHwTn9YB
         XdWSei+JAk+0ObxijTvmFNg939Y52AyFJTlGIqrNrOIKaSWU7oUgm5lysh5UmeaLB1Pl
         W1v2wGPuEikgZvAtOJq0cJxqNTiZFJLsk3JkTV8jA6Dl9iZxw79QtwQmDPuknZ+bpaAS
         not+mwm+TDI7m8YEWhClg1G6kSpUVG1JoHIJyvAQKhaiGxyLFTozgwrJtZjqvQMZoHLo
         389qwn1PNSy75BhqcmazGuqlEaG2oj1OJLDSW4dVXOCmJaktV8DBAcEbm0NT5U4Alfd9
         99sA==
In-Reply-To: <20131010182037.GA7939@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Sorry, just noticed this one.

I added it just for robustness in future, as the buffered output was
also working till the point when it got overflown. This way buffer
won't be overflown.

-Ildar

On Thu, Oct 10, 2013 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
> Since applying this patch, coverity is picking up an out of bounds write.
> It looks like it can't happen, but I'm wondering why this code was
> done this way..
>
> hand-editted diff for clarity:
>
>  >      /* copy buffer, sans ANSI codes */
>  >      len = strlen(outputbuf);
>  > -    for (i = 0, j = 0; i < len; i++) {
>  > +    for (i = 0, j = 0; (i < len) && (i + 2 < BUFSIZE) && (j < BUFSIZE); i++) {
>  >              if (outputbuf[i] == ' ') {
>  >                      if (outputbuf[i + 2] == '1')
>  >                              i += 6; // ANSI_COLOUR
>  >                      else
>  >                              i += 3; // ANSI_RESET
>  >              } else {
>  >                      monobuf[j] = outputbuf[i];
>  >                      j++;
>  >              }
>  >      }
>  >      monobuf[j] = '\0';
>
> What's the intent behind this ?
> It seems redundant, as everything seems to work fine without this change.
>
>         Dave
>
