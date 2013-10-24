From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/4] log: Add BUG_ON helper
Date: Fri, 25 Oct 2013 01:39:26 +0400
Message-ID: <1382650768-30954-3-git-send-email-gorcunov@gmail.com>
References: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p5/kwS8z4Z47Z+YTrNOn47QxA2l27e7I0099VjBJwGo=;
        b=flDpDqvRAMaTTVZWKTjftMufwk86difDh/xqzUlavSkdQqtkdKYxxMld2Fkagn/u0i
         8ZjULLjc2J1GGS8vuJxBZQ2kMv6lEmSgJ8QHddDDFudaxVsLMUFHWzUCSJS4K8qNfDOn
         DlLEpWy5P55eQw5uEz+/tuk1sNv5ekYSgQ5tSYMWe3NDnZd+xWKfVSZ6xlbh4FB6QEKo
         CVC0aYNsw5OiTLa6Hc8gJiVexMdyspC93EAOk3kELrJHFMBXaWJ/En1rxgwF/kRfynhP
         RLtjrwP7go/pM93Q0jsmt4BgkMEKCryI3Eh7RNV70WldHZOiSlGhZoOjGYQaQLDqKSmS
         DRfg==
In-Reply-To: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

We will use it in sockets creating routine.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
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
