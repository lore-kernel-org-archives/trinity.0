From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 5/9] Fix double .arg3name assignment in syscalls/ia64/perfmonctl.c
Date: Mon,  1 Apr 2013 21:58:35 +0300
Message-ID: <1364842720-24127-5-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=igwRrtCA3EpKCaxKNMmP81WEGK4QSzhXcJ67Jgz8Dto=;
        b=QEdJBkVN5SLY+7PrgrSkka7QgmWoYUViTlZeqN8lsia8/5nQSiLwmOJe69i4fMAdqc
         qiiWxXif4+1va6mT+cn1G1GSEBgRci9QIsoQ4If1Sx3+nYHScCA6EFyrQT5WyGS9RKqU
         sgPoJ8+ovl86vFGPLGhhRGtWCytj5u7RwlJ8tnaX0eC1uguqUcvJvIEdUU+GtoCVgFEW
         BOd/TC+zOii4ZiP/JKJzxrY5GqVIqIkVRUomSE44UvLdam22hgi53FSK6W5NzdTpb6QY
         +xl4Nxv2NHXmpktLYfha8TB9udRbCAHkXm0ukU4cFZmSIIMiGFNn+iYePn0lIeGkEDYM
         LzbA==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

---
 syscalls/ia64/perfmonctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/syscalls/ia64/perfmonctl.c b/syscalls/ia64/perfmonctl.c
index 6b50003..0ee538c 100644
--- a/syscalls/ia64/perfmonctl.c
+++ b/syscalls/ia64/perfmonctl.c
@@ -36,6 +36,6 @@ struct syscall syscall_perfmonctl = {
 	},
 	.arg3name = "arg",
 	.arg3type = ARG_ADDRESS,
-	.arg3name = "count",
+	.arg4name = "count",
 };
 
-- 
1.7.9.5
