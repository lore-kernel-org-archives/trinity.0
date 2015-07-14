From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] Add POLL_BUSY_LOOP symbol for older distros.
Date: Tue, 14 Jul 2015 11:25:55 -0700
Message-ID: <1436898355-25252-1-git-send-email-vlee@twopensource.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

From: Vinson Lee <vlee@twitter.com>

POLL_BUSY_LOOP is not available until Linux 3.11.

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 2eb8691..5451870 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -1029,3 +1029,6 @@ struct kvm_get_htab_fd {
 #ifndef POLLFREE
 #define POLLFREE 0x4000
 #endif
+#ifndef POLL_BUSY_LOOP
+#define POLL_BUSY_LOOP 0x8000
+#endif
-- 
1.7.9.5
