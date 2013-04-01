From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 4/9] Include asm/perfmon.h for the PFM_* constants in syscalls/ia64/perfmonctl.c
Date: Mon,  1 Apr 2013 21:58:34 +0300
Message-ID: <1364842720-24127-4-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=mXCdmjOyK/nrdaMcd6R+leg5tD3zr+XiDRZu48ueZ+k=;
        b=ob7NG3F/BBErC2KzEX+3cYuQGp4rMhfDQLhmhLifKQVmIuXnH+fTjLZlzJszky7vwZ
         7T/33EtqUq6wtrXpcqliOhfTYeJW2dpE018oOYodkDTF7iewm4V2irmz+t1nxoJdSkOD
         d+BYa97P5QAjxKixGkcu3L+N9UK0Yhe5GVDSfR25gStbyCbn0R5H027NiELVTRZqmMGF
         tj9dy8+zjg9ihkE9OQT5Z4eI4ea8dnpQbLeCynCkXJ3zuDOcMWHLqB/F6h8anIgzuGDW
         ICu71/Rh1QiZLGFf8y3zJRuvdMGMtsJ5jow0XYLEfYprvSlCUa7Ag7sFtW2psNtk7gsw
         UUog==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

---
 syscalls/ia64/perfmonctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/syscalls/ia64/perfmonctl.c b/syscalls/ia64/perfmonctl.c
index c1f156b..6b50003 100644
--- a/syscalls/ia64/perfmonctl.c
+++ b/syscalls/ia64/perfmonctl.c
@@ -2,6 +2,8 @@
     sys_perfmonctl (int fd, int cmd, void __user *arg, int count)
  */
 
+#include <unistd.h>
+#include <asm/perfmon.h>
 
 #ifndef PFM_CREATE_EVTSETS
 #define PFM_CREATE_EVTSETS 0
-- 
1.7.9.5
