From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: "invalid open call: O_CREAT or O_TMPFILE without mode" errors
Date: Wed, 18 Nov 2015 14:49:30 +0200
Message-ID: <20151118124930.GA24208@node.shutemov.name>
References: <CAHTgTXVFGfR0an5DcQKKt7HGmUVWddogDquL-oNMHYA8zfpBAw@mail.gmail.com>
 <20150720145257.GB23521@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=x/WuS1L7qY0Wk3H1mlHHeO2/Qg2jenfmtG+3LgNfv/I=;
        b=IdKIWQ5xoncAUY2mhtMH6tMa5deD1ZiaPbDbiGdoN2LM0iH7tCaXy+cVidNReb2hKf
         FN2iIIX7QjqfxWrfKbRXW5K64byhMOO+BefdEWHg6bp/GAcsOdvBlVaEscX+7rVoq2hk
         +pInVC5bPNFcF51wBDMThkoePuu7hpc3N9i8EYf/0ScQxlutPTVOkf/zSHy710TIi5JO
         JLYN+rfLGiCT86bDTdM/LebEbgs7/wi9Ln9jvNwbHfjBtWmekDpVIiYtYnteY6xOjOpq
         JI356zA3FDoF01ZO4zeMqAJp6AYaJu+GvYWC2w7Dy7aunE3RZmHt3x4K28hFeRBrisSQ
         ZQHw==
Content-Disposition: inline
In-Reply-To: <20150720145257.GB23521@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Vinson Lee <vlee@twopensource.com>, trinity@vger.kernel.org

On Mon, Jul 20, 2015 at 10:52:57AM -0400, Dave Jones wrote:
> On Thu, Jul 16, 2015 at 04:38:21PM -0700, Vinson Lee wrote:
>  > Hi.
>  > 
>  > trinity stops running very soon after launch with invalid open call errors.
>  > 
>  > [main] Generating file descriptors
>  > [main] Added 104 filenames from /dev
>  > [main] Added 70615 filenames from /proc
>  > [main] Added 29037 filenames from /sys
>  > *** invalid open call: O_CREAT or O_TMPFILE without mode ***:
>  > ./trinity terminated
> 
> Ugh. Is that some shiny new glibc ?
> 
> Probably something like this ?
> 
> Totally untested, I don't have a lot of time right now.

There's one more source of such crashes: open_file() in fds/files.c

diff --git a/fds/files.c b/fds/files.c
index 2c7fa1ec1244..997cfea3fa18 100644
--- a/fds/files.c
+++ b/fds/files.c
@@ -321,7 +321,7 @@ retry_flags:
 
        if (RAND_BOOL()) {
                randflags = get_o_flags();
-               fd = open(filename, flags | randflags | O_NONBLOCK);
+               fd = open(filename, flags | randflags | O_NONBLOCK, 0666);
        } else {
                fd = open_with_fopen(filename, flags);
                fcntl_flags = random_fcntl_setfl_flags();
-- 
 Kirill A. Shutemov
