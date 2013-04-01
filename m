From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 9/9] Build syscalls/ia64/*.c
Date: Mon,  1 Apr 2013 21:58:39 +0300
Message-ID: <1364842720-24127-9-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=tcryrKOkpf5nZjOj3gOfbelbUj7j7hdwo12yR2CpFA4=;
        b=ZLKEnyyVePa6ak5w2UxOb+679QcYe0R/dZCUPjpC5xnVusIsqz6IUq3iTP/UHlLgoY
         Q/SoRKFlswLnZKw+MvVUfdv0nnqi+J2QaoBFn5QrXKVriW8DowM5hQjNQhQ7f5vroO23
         Zi+MAIOBnChQXgNExYJ4+cZY35UERMMOYM81S0XF2lOhqtopqW2TqN7SNZie5mjdjczS
         /0Ppy7q3YUXsw8w/bnmJpqoaO349KPHvHWQ512uoBxQ6tiYJyAU+gMGloYqkOPuqxc+w
         t95Zbsa6pA4f/PL1SG/+kKSPWxqOQQdy0WD7nR6Nd1umfbUaMBhFNkoh1pa3YmMuuTFh
         iJiw==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 1320eb0..2b57963 100644
--- a/Makefile
+++ b/Makefile
@@ -35,6 +35,7 @@ test:
 MACHINE		= $(shell $(CC) -dumpmachine)
 SYSCALLS_ARCH	= $(shell case "$(MACHINE)" in \
 		  (sh*) echo syscalls/sh/*.c ;; \
+		  (ia64*) echo syscalls/ia64/*.c ;; \
 		  esac)
 
 HEADERS		= $(patsubst %.h,%.h,$(wildcard *.h)) $(patsubst %.h,%.h,$(wildcard syscalls/*.h)) $(patsubst %.h,%.h,$(wildcard ioctls/*.h))
-- 
1.7.9.5
