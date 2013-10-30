From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 1/6] log: Add BUG_ON helper
Date: Wed, 30 Oct 2013 16:15:41 +0400
Message-ID: <1383135346-31463-2-git-send-email-gorcunov@openvz.org>
References: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x2VFTcdWeVSSn8QLhOolVftsc9YMzpmg1LEiViEPW9Y=;
        b=f8Yix85ZIND/17uHi2LSDFNmWFj0AWQouMisHIll0DNf7EVtRmARCFdonmjyiFLd5m
         U20W2RRGYkhQLQ+lakBP9jmH63RB7vqMNvGmH+YvkLxE5iquOf+Pfg66CBcmVBqr1dUq
         VfM66h/WyYqCLA3/eGgOIoHr/uuFv4gAYDQl08mkvXohmQfiK9foAUMUS0rYFGA1aLyb
         xBVTbnMef3/rKmeAWTq0L5FIgM5K/rojgH6xWKXVn6r1mumsHbm8cG/g+FsqQkd7mJli
         zM/R6mDEa/eVBOH6NrvZ6giZAfFfgVqOIWWEPKD8kfGDHhC7JVl87eazKwXfRDnKw8Fm
         WoMA==
In-Reply-To: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

We will use it in sockets creating routine.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/log.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/log.h b/include/log.h
index 500353d..22ad80a 100644
--- a/include/log.h
+++ b/include/log.h
@@ -59,4 +59,6 @@ void debugf(const char *fmt, ...);
 	}\
 }
 
+#define BUG_ON(condition)	do { if ((condition)) BUG(BUGTXT); } while (0)
+
 #endif	/* _LOG_H */
-- 
1.8.3.1
