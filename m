From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: stack smash detected bug
Date: Fri, 4 Oct 2013 10:11:04 -0700
Message-ID: <CAEGbLtuA81sypq9i2AUyEY89jErdLv6pk_ceaKFSggqBFDFsfQ@mail.gmail.com>
References: <CAEGbLtsV-FUm0Q8NiGyiTscDVUOfqYxz=9Dncv3xFgAb6b6saw@mail.gmail.com>
	<20131004152934.GA22724@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=ae2XgRmFH6OrgKt6iG1Wi90Q2DGssHI8F6W4E5QiL30=;
        b=YSgFio6bpd6I5hw8mesTPKs2Abc1PGH1ugHP/MDM5M0paI2Mn/ThcBsDNBZ8Z1u3gk
         4aYVR89T6ULkWWcZFKxRqn0snJyndUbVD6AstKO0UCA0HIdQB2unANLnGC3xao9GhjN5
         rrgXgbpC3R4Kt7ZZNM2enn+zRnt5OeC1yMxoYfdr6H54m1HnO2CW3VzuekzT/e49EstZ
         5C6V+cgV4coYVN7S4Lm5/dsTPvsWCgZKgE7PKNX4D5+p9zsx4HhQrA53ZbY9wAAmtoo8
         c+6Nk4mfx3HRpOP8kGm5OYNYbiJlICm+bWwwN0Z2LTG3Zl4Ip7Ig880b7Me5jNGYvSWF
         dCwQ==
In-Reply-To: <20131004152934.GA22724@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

Here is an example that causes the crash, it is obviously longer that 512 ascii:
[child0:1607] [31] utimensat(dfd=^[[1;36m497
, filename=^[[1;36m".//proc/4/task/4/cpusetd%s%d%d%d%d%s%s%s%d%d%s%d%d%d%d%s%s%d
%s%s%d%s%d%s%s%d%d%s%d%d%d%d%s%d%d%s%s%s%d%s%d%d%s%d%d%s%d%s%d%s%d%d%d%s%s%s%s%s
%d%s%s%d%s%d%d%d%d%d%s%d%s%s%d%s%d%d%d%d%d%d%s%d%d%s%s%s%d%d%d%d%d%d%s%s%d%s%s%d
%s%s%s%s%d%s%d%d%d%d%d%d%s%s%d%s%d%d%s%d%d%s%s%d%s%d%d%d%s%s%d%s%d%s%d%s%s%d%s%s
%d%d%s%s%s%s%s%d%s%d%d%d%s%s%d%s%s%d%s%s%d%s%d%d%s%d%s%d%d%s%s%d%s%d%d%d%s%s%d%s
%s%s%s%d%d%s%s%d%d%d%s%d%d%s%d%s%s%d%s%s%s%d%s%d%d%s%d%s%d%s%d%s%d%s%d%d%s%s%d%s
%d%s%s%d%d%s%s%s%s%d%d%d%d%d%d%d%s%s%s%d%d%d%s%d%s%s%d%d%s%s%s%s%d%d%s%s%d%d%d%s
%d%s%d%d%s%d%d%d%s%s%d%s%s%d%s%s%s%d%s%d%s%s%s%s%s%d%d%s%d%s%s%d%d%s%d%s%s%d%s%s
%d%d%d%s%d%d%d%s%d%d%d%s%s%s%d%d%d%s%d%d%d%s%s%d%d%s%s%s%d%d%d%d%d%s%s%d%s%d%d%s
%d%d%d%s%s%d%s%s%s%s%d%s%d%s%s%d%d%d%d%d%s%d%d%s%s%d%d%d%d%d%s%d%d%s%s%s%d%d%s%s
%d%s%s%d%d%d%s%d%s%s%s%d%s%s%s%s%s%s%s%s%s%s%s%s%d%d%s%d%s%d%d%s%s%s%s%s%s%d%s%d
%s%d%d%s%d%d%d%s%s%s%s%s%d%d%d%s%s%s%s%d%s%s%s%d%d%d%s%d%s%s%d%d%s%s%s%s%s%s%s%d
%s%d%s%s%d%d%d%s%s%d%s%s%s%d%s%d%s%
[child1:1608] [0] setreuid(ruid=0x400000000000000,
euid=0xffffffffffffffff) [child1:1608] = -1 (Operation not permitted)

On Fri, Oct 4, 2013 at 8:29 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Oct 03, 2013 at 06:53:08PM -0700, Ildar Muslukhov wrote:
>  > Hi,
>  >
>  > I've been looking through the strange behavior today, where I am
>  > getting lots of "stack smashing detected" and found that the most
>  > probable place is the mkcall function. Here is the call stack:
>  > [0x440545] (stack check related calls)
>  > [0x44050e] (stack check related calls)
>  > [0x408db4]<-stack canary check
>  > [0x412709]<-call mkcall
>  > [0x402228]
>  > [0x405586]
>  > [0x40185a]
>  > [0x412b44]
>  > [0x401db1]<-main()
>  >
>  > After looking into the code in mkcall:
>  > >long mkcall(int childno)
>  > >{
>  > >        unsigned long olda1, olda2, olda3, olda4, olda5, olda6;
>  > >        unsigned int call = shm->syscallno[childno];
>  > >        unsigned long ret = 0;
>  > >        int errno_saved;
>  > >        char string[512], *sptr;
>  > ...
>  > I suspect that string[512] is the issue. The simple tests confirms
>  > that assumption (I've just commented out the block of color_arg
>  > function calls that fill the buffer with parameter values).
>
> If that's getting overrun, I'm really curious what the string is,
> because that should only be holding a single line of text.
> Even with all the ansi codes it should be plenty.
>
>         Dave
>
