From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH] fix off-by-one in dump_childnos()
Date: Sun, 16 Apr 2017 22:35:21 +0300
Message-ID: <CA+ydwtoMbPVFhoD+A3od_DMWAn2+QUG0AP=-AuRZ6uo2zRSjBw@mail.gmail.com>
References: <20170416182914.24457-1-tt.rantala@gmail.com> <20170416183431.axmhqtnea3ebjiek@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Qz77Kb9/ECoHJuaa2TtHIspl7KX1Cuo1KJM7T/TF6pM=;
        b=hGS72vNWBNo5d1ML2gTH98yHKcaJgallw+QFacFvzKIIKhskOg/yTc/nfXUz35sDzX
         gj15dEZCnwg8tt6zIlottSkOOXfQfEUAL4G0qPzQPywkHac5bZwhQhh2znOIno9vo7qg
         jN6AcWQtD/7TqHVLOHxjOkM+v8eLIZyaqcYxtvDjjdyfFa1LypvpzPEm03w5EPCoLPpv
         pgYfYEwWR10cufW9cCAuGUdVPL/p+dThrZ2wE6z/EoU82jbxPJG7B2N3iQuHmq/VKJKo
         tr4IiaCmGrjYhHBlWhSk3K4MTRjeaKcb1skWmOChL+Is1eksWs6PmNaI8ZF+7V8d55k7
         KZvw==
In-Reply-To: <20170416183431.axmhqtnea3ebjiek@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

2017-04-16 21:34 GMT+03:00 Dave Jones <davej@codemonkey.org.uk>:
> On Sun, Apr 16, 2017 at 09:29:14PM +0300, Tommi Rantala wrote:
>  > Fixes a segfault:
>  >
>  >   ## pids: (60 active)
>  >   0-7: 0 0 0 0 0 0 0 0
>  >   8-15: 0 0 0 0 0 0 0 0
>  >   16-23: 0 0 0 0 0 0 0 0
>  >   24-31: 0 0 0 0 0 0 0 0
>  >   32-39: 0 11081 11082 11083 11084 11085 11086 11087
>  >   40-47: 11088 11089 11090 11091 11093 11094 11095 11096
>  >   48-55: 11097 11098 11099 11100 11101 11102 0 0
>  >   Segmentation fault
>
> Applied.  If you're seeing that though, that's indicative of a bigger
> problem (that we corrupted the pid table, or lost track of a child proc.).

Yea, I believe it was just about to exit anyways after the debug output.

> I've not seen that happen in about a year, does it happen often for you?

I was testing trinity in some minimal busybox & qemu environment, and
saw it a few times.
Now that I try it again, cannot reproduce the segfault anymore...

All the trinity processes have read-write access to the pids[] array?
So any one of them could corrupt the memory...?

-Tommi
