From: Ildar Muslukhov <ildarm@google.com>
Subject: stack smash detected bug
Date: Thu, 3 Oct 2013 18:53:08 -0700
Message-ID: <CAEGbLtsV-FUm0Q8NiGyiTscDVUOfqYxz=9Dncv3xFgAb6b6saw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=gZPj4qqCOIUYPRgmqVth54PQNmI/GeSHjU9a5Oyr4fQ=;
        b=juV6kpBADjLNGSEpnFLRu4GV9Lx5UgPPrJuGQtlm7ZLsU3LvCVcKDL7WO8JsRU1a9z
         XadR/Aq80+GbFeHAJGUJZqbNe2hIxSyADt7xlT4m95D1uZ3cdOcrHnSXjEXm0794EA94
         iUquzhN/mRa6xNGGN3WkJl62h3iME5s1hfYllS/74Oo/zqYvUeaAdvxtpFezVQiZ/Ugz
         nmy2d6CO8IE/lcfsvISwwedZZZUhoEbCRO57EYmIwnulKjqYUr2mgcFHmbad0lWODJdO
         hvHn9RPuSy3XBoFcnhSOUaMAKPfux3efp8Agh3PqMNAKtU4P5XQa8eg8LunDgbN2+HJP
         g/wA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

Hi,

I've been looking through the strange behavior today, where I am
getting lots of "stack smashing detected" and found that the most
probable place is the mkcall function. Here is the call stack:
[0x440545] (stack check related calls)
[0x44050e] (stack check related calls)
[0x408db4]<-stack canary check
[0x412709]<-call mkcall
[0x402228]
[0x405586]
[0x40185a]
[0x412b44]
[0x401db1]<-main()

After looking into the code in mkcall:
>long mkcall(int childno)
>{
>        unsigned long olda1, olda2, olda3, olda4, olda5, olda6;
>        unsigned int call = shm->syscallno[childno];
>        unsigned long ret = 0;
>        int errno_saved;
>        char string[512], *sptr;
...
I suspect that string[512] is the issue. The simple tests confirms
that assumption (I've just commented out the block of color_arg
function calls that fill the buffer with parameter values).

Will provide a patch for that tomorrow.
