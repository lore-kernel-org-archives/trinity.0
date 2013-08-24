From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Avoid do_rt_tgsigqueueinfo kernel warning.
Date: Fri, 23 Aug 2013 19:10:18 -0700
Message-ID: <1377310218-12590-1-git-send-email-vlee@freedesktop.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

From: Vinson Lee <vlee@twitter.com>

trinity regularly hits the following kernel warning, which doesn't
appear to be an actual kernel bug, and stops running.

WARNING: at kernel/signal.c:2955 do_rt_tgsigqueueinfo+0x42/0x5c()
Call Trace:
 [<ffffffff8104920c>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8104923e>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810591eb>] do_rt_tgsigqueueinfo+0x42/0x5c
 [<ffffffff81059257>] sys_rt_tgsigqueueinfo+0x52/0x5f
 [<ffffffff814df4a9>] system_call_fastpath+0x16/0x1b

This patch sanitizes rt_tgsigqueueinfo arguments to avoid triggering the
above warning.

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 syscalls/rt_tgsigqueueinfo.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/syscalls/rt_tgsigqueueinfo.c b/syscalls/rt_tgsigqueueinfo.c
index e48515e..5167f74 100644
--- a/syscalls/rt_tgsigqueueinfo.c
+++ b/syscalls/rt_tgsigqueueinfo.c
@@ -2,7 +2,24 @@
  * SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
 	 siginfo_t __user *, uinfo)
  */
+#include <stdlib.h>
+#include <signal.h>
+
 #include "sanitise.h"
+#include "shm.h"
+
+static void sanitise_rt_tgsigqueueinfo(int childno)
+{
+	pid_t tgid = shm->a1[childno];
+	pid_t pid = shm->a2[childno];
+	siginfo_t * uinfo = (siginfo_t *)shm->a4[childno];
+
+	if (pid > 0 && tgid > 0 && uinfo->si_code == SI_TKILL) {
+		do {
+			uinfo->si_code = rand();
+		} while (uinfo->si_code == SI_TKILL);
+	}
+}
 
 struct syscall syscall_rt_tgsigqueueinfo = {
 	.name = "rt_tgsigqueueinfo",
@@ -13,4 +30,5 @@ struct syscall syscall_rt_tgsigqueueinfo = {
 	.arg3name = "sig",
 	.arg4name = "uinfo",
 	.arg4type = ARG_ADDRESS,
+	.sanitise = sanitise_rt_tgsigqueueinfo,
 };
-- 
1.8.1.2
