From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 0/2] misc fixes
Date: Sat, 27 Jul 2013 17:35:14 +0300
Message-ID: <1374935716-26961-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=Iox0ySq2MnXZjnK1h05tG5S824SlUybrtftcyJM7GR8=;
        b=M8GAuqYiyh+RiNZbHc1uziFXF1b4bwEomJxRO/wJl6V7DTky+I9JAPd2UO6nlioqEL
         rbx+CrxFnovPzoS2FdCeGCenVN12WuH2aUmqe6zNwM8innUhTIQj1GEDx4Oq3iYXZtdF
         7nzXyqrVSilhEuZonpuR461cOtA0/U5OfjXlVhGhfpBJYcjqHOyZYlCHjAmX8eHCw/qP
         Bq94VcMR+rwOGdZ7p8yo1+h5fruSdmjZpy/PEwQPqYWwbFloLfurbI8gqGMccyGt7WOg
         RPqP5qkmIChVlgo4nWAk1gqZNkoFKt29vA9cl9X86mdwxQpTFf0pI/DqGXy2CE8ez7uU
         5CVA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Greetings, two small trinity fixes this time.

Tommi Rantala (2):
  Fix child crash when disabling some syscalls on biarch
  Do not busy loop child processes on startup

 main.c    |  3 ++-
 syscall.c | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.8.1.2
