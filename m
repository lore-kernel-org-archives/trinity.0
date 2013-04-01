From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 6/9] Dummy PTRACE_GETFPREGS and PTRACE_SETFPREGS for IA64
Date: Mon,  1 Apr 2013 21:58:36 +0300
Message-ID: <1364842720-24127-6-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=DLiqwWVz2yAMsmwIlZCc0KdxhxYOnabvnzQYLXbdPoI=;
        b=DoCB+Q/a6/qq+MDkxIH56LIowqE3JOyiS13Kyd9xZfsbXjZQBV42a0j0IviOQqbiiz
         TbNCe8ReU2hCspXtkR7+/skwjOPhJ+fZPbesfv/MJdXYyyq3dK7cUV1i39+n9gIXdWNd
         t2Rn76giM7muKv/qiW4ld683M/vsmQAxWwpJ7xrTkfcIie6KoNTpc8JLhPn9qjBOEAk6
         /i9zZB5schkED+uicBmfNXdoo7ioQNuYOt+GWmvZOU0g+k5ICSq6YE6qS72Mk8uz0jk0
         /ZtFIyNFp/uS+/Ijy7l3NRWXXg/bVXwOo0Y7DfXDk2TcjaMMQmn8OlcGF14o5NeLtXkw
         yeHA==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

---
 include/arch-ia64.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/arch-ia64.h b/include/arch-ia64.h
index 3068516..f193c56 100644
--- a/include/arch-ia64.h
+++ b/include/arch-ia64.h
@@ -10,3 +10,6 @@
 
 // for __IA64_UL_CONST we need to include:
 #include <asm/types.h>
+
+#define PTRACE_GETFPREGS	0
+#define PTRACE_SETFPREGS	0
-- 
1.7.9.5
