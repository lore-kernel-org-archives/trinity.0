From: Jiri Slaby <jslaby@suse.com>
Subject: [PATCH] compat.h: define CLOCK_MONOTONIC_RAW
Date: Tue, 30 Jun 2015 12:01:01 +0200
Message-ID: <1435658461-3198-1-git-send-email-jslaby@suse.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Jiri Slaby <jslaby@suse.com>

It is not defined on older distros yet.

Signed-off-by: Jiri Slaby <jslaby@suse.com>
---
 include/compat.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index ce465632c250..589beac75510 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -1018,6 +1018,9 @@ struct kvm_get_htab_fd {
 #endif
 
 /* time.h */
+#ifndef CLOCK_MONOTONIC_RAW
+#define CLOCK_MONOTONIC_RAW 4
+#endif
 #ifndef CLOCK_BOOTTIME
 #define CLOCK_BOOTTIME 7
 #endif
-- 
2.4.3
