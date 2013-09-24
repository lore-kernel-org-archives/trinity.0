From: Ildar Muslukhov <ildarm@google.com>
Subject: [Patch suggestion] Probability flag for 32 bit syscalls
Date: Tue, 24 Sep 2013 11:36:53 -0700
Message-ID: <CAEGbLtsPpimeDotO09H7Lqm0p=RKmaX1DR05Mu60=c9fazacCA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=bu1HWCaz2ILBTjA+7aV2dKNfLvVTnAB4R3Zh0BerTKc=;
        b=lYGOy8uzlx90s11b0S6ZPm8r2IuUjMJteWGJUU3+X7lOdjAsg8UQYDLI4R+TPLspjw
         LUzzOz13ie05ioAKAhpwZpSSz0VgkmC6/y7F1kLu2lHbSvjzprZAGjP9mPprXcbPcaxj
         CIUexa4z6HtP15raWwhaO3Bg9DReWbNogwIgcTuA2RjLpFbdQMm2lHS/ZJh/spMiue7+
         1/hcfdaL28YiXTD6YvuWgiZrlZeyTiV8DK04EDOX4CMC00jrxLEWGZ730Nw5NU7C4dsF
         RYvMCG8DvKSZQs3RtgZbQ+rsZ+Z0JgTQOFu3Ts8TP51Ut/3+V5uCDxZLde/XcgyuM5nq
         IOCg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>

Hi everyone,

In the children/random-syscalls.c file (function choose_syscall_table)
there is a FIXME section that right now disables 32 bit version of
syscall if a 64 bit version is present and enabled.

// FIXME: I forgot why this got disabled. Revisit.
//                      if (rand() % 100 < 10)
//

Just want to clear this one out. Should it be a command line
parameter? Something like -P 50 (for 50% probability, lets say of 32
bit). If so, what should be a default behaviour when the parameter is
not present 50/50 or 0/100 as it is right now.

-Ildar
