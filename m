From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 6/8] msgrcv() and msgsnd() IPC_NOWAIT msgflg
Date: Sun, 30 Jun 2013 22:33:10 +0300
Message-ID: <1372620792-16384-7-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=FAmxGJJjARlydUshIW8aVzIVj19J9vLI1hnmkd6rgNc=;
        b=qntXLa25yP4gd4Sft4fiE/bkPPWPemdsTE4ctK+NzU48HEXk2qQ49C49FsUJtQfVZZ
         DrbSrMyknlfYdy4UmqF290Tvlll2nJXVvTFkh+EGNsnmsjfqiEOBovPItEc4Ntg+qiu1
         h8865O0y/7K4uzh3C193cwgx2lvGmzuXPzXvPm9Kgti4WpCacmfmUTspnH16EOjNmHiz
         lomNSRfHC93D27sRULEuoquvL9ctc3I2pATyQWUI5rcM40l+2WFQ1xy9pX5e690tXk9p
         jzNZcnh2+m2yyHNMI9TqfnYuMVovhu4Fah787Z5E1LKhbx6EKlDkwYG4b9UV/4xVVzqU
         cH5w==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 syscalls/msgrcv.c | 4 ++--
 syscalls/msgsnd.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/syscalls/msgrcv.c b/syscalls/msgrcv.c
index b730ba6..2200472 100644
--- a/syscalls/msgrcv.c
+++ b/syscalls/msgrcv.c
@@ -17,7 +17,7 @@ struct syscall syscall_msgrcv = {
 	.arg5name = "msgflg",
 	.arg5type = ARG_LIST,
 	.arg5list = {
-		.num = 3,
-		.values = { MSG_NOERROR, MSG_EXCEPT, MSG_COPY },
+		.num = 4,
+		.values = { MSG_NOERROR, MSG_EXCEPT, MSG_COPY, IPC_NOWAIT },
 	},
 };
diff --git a/syscalls/msgsnd.c b/syscalls/msgsnd.c
index 132336b..3e3a91d 100644
--- a/syscalls/msgsnd.c
+++ b/syscalls/msgsnd.c
@@ -16,7 +16,7 @@ struct syscall syscall_msgsnd = {
 	.arg4name = "msgflg",
 	.arg4type = ARG_LIST,
 	.arg4list = {
-		.num = 3,
-		.values = { MSG_NOERROR, MSG_EXCEPT, MSG_COPY },
+		.num = 4,
+		.values = { MSG_NOERROR, MSG_EXCEPT, MSG_COPY, IPC_NOWAIT },
 	},
 };
-- 
1.8.1.4
