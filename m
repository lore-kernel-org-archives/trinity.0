From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 0/8] misc trinity patches
Date: Sun, 30 Jun 2013 22:33:04 +0300
Message-ID: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=Gjg0ksm7l3i8KzbKhD58XYuAecTsVMh7yyW7s+jYtCY=;
        b=TS7w+MPe20nCVmQf4lIz4bEi7t+DRc16NMMN9g6Q95lNBAfZB6Hz2TZMrmc49EbWVN
         QHdtUq6DDpGknsm7m6nYzw9ljjoe9SzTDLNFl00oBNJi2U/HTKMihowhYQy950IAzcKt
         WInGMLYWa+w3Hu3Vk7nCx3yIkN0Hb7X5ghqvjT/dBgqh7O24lCo5tooiPq1NY8BDLXgP
         xqvsIovXwhJC2MzfF0VpzvF+BWxahEYSAdjiGdA7L4rxgmj+xmcABEcFU4j99CZqehCP
         wmg3/LTJRHXOLbgK2Ugfpp9twQZFFG92SDd9eLnesiv9aG52M9xu6O2Ff+9vdmZSmu1f
         KF9Q==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Hello, some fairly small trinity patches, please take a look.

Thanks,
Tommi

Tommi Rantala (8):
  Use TRINITY_PF_MAX instead of PF_MAX in syscalls/socket.c
  Fix open() result check in check_tainted()
  Avoid needless get_filename() calls in generate_pathname()
  Fix double rand() in generate_pathname()
  move perf_event.h to include/
  msgrcv() and msgsnd() IPC_NOWAIT msgflg
  ioctls/drm: add deprecated nouveau ioctls
  ioctls/vhost: VHOST_SCSI_* ioctls

 files.c                            |   5 +-
 {syscalls => include}/perf_event.h |   0
 ioctls/drm.c                       | 102 +++++++++++++++++++++++++++++++++++++
 ioctls/vhost.c                     |  15 ++++++
 main.c                             |   2 +-
 syscalls/msgrcv.c                  |   4 +-
 syscalls/msgsnd.c                  |   4 +-
 syscalls/socket.c                  |   2 +-
 8 files changed, 125 insertions(+), 9 deletions(-)
 rename {syscalls => include}/perf_event.h (100%)

-- 
1.8.1.4
