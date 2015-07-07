From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] Add POLLFREE symbol for older distros.
Date: Tue,  7 Jul 2015 14:46:06 -0700
Message-ID: <1436305566-7427-1-git-send-email-vlee@twopensource.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

From: Vinson Lee <vlee@twitter.com>

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |    5 +++++
 syscalls/poll.c  |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/compat.h b/include/compat.h
index 589beac..2eb8691 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -1024,3 +1024,8 @@ struct kvm_get_htab_fd {
 #ifndef CLOCK_BOOTTIME
 #define CLOCK_BOOTTIME 7
 #endif
+
+/* asm-generic/poll.h */
+#ifndef POLLFREE
+#define POLLFREE 0x4000
+#endif
diff --git a/syscalls/poll.c b/syscalls/poll.c
index ad97482..5b863c5 100644
--- a/syscalls/poll.c
+++ b/syscalls/poll.c
@@ -7,6 +7,7 @@
 #include "random.h"
 #include "sanitise.h"
 #include "utils.h"
+#include "compat.h"
 
 static const unsigned long poll_events[] = {
 	POLLIN, POLLPRI, POLLOUT, POLLERR,
-- 
1.7.1
