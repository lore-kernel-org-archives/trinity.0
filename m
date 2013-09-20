From: Ildar Muslukhov <ildarm@google.com>
Subject: Rerun with the same seed
Date: Fri, 20 Sep 2013 14:57:35 -0700
Message-ID: <CAEGbLtsx-FSELoi3tccK3xixfDBBhfOzZjyiC5uFqpf5vEo_vw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=OIStrbLnJSPAt65m/wVQIzAwclZiqFokfPlGsF09oo0=;
        b=AB6Wmq7m5D4fP7Bi4jo6ECacu49PbJJwqovgXi+kMQG+5i+AW7yqxkrwxcwkp3tHBq
         7hbOI7JBB59MD9bQ2SJ1GTBmFoI5RxUyrS3HNzkj8QLIgqnTwFYpyA7zh/3uKy9G8glB
         QjSQdo8VH3QvDodu2ZAEOP3CEU1Vy/IhSBww0ozsBm5jROlQVL82cvEigZbEld5dqLTo
         YDMfLMRR94SZNqjkHP4W4VSXZt3XJnuGcVyq2e10Y7WAETfIC1BRsDmfXpMSFyhgXp9T
         +af26jKM2cThX6tBxg1t5vA1U44kTpm0WxEkTSp4OX9urvZVM+0SMO8cSktjoMRZvPFJ
         lCmw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>

OK, I've run trinity for one known bug in 2.6 in perf_event_open it it
seems to me that reproduciblity is not an issue for one child process.
They both runs start in sync and end in sycn precisely. But apparently
more than one child causes all child to go out of sync from the
beginning, i.e., even the very first call in each child is called with
different parameters. Will look into it during the next week.

-Ildar
