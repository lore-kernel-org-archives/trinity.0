From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 2/2] Mark perf_event_open() with IGNORE_ENOSYS
Date: Mon, 26 May 2014 22:32:02 +1000
Message-ID: <1401107522-21239-2-git-send-email-mpe@ellerman.id.au>
References: <1401107522-21239-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1401107522-21239-1-git-send-email-mpe@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

At the very least specifying PERF_SAMPLE_STACK_USER will return ENOSYS
on arches that don't implement it.
---
 syscalls/perf_event_open.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index d6c404c..0fe64ce 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -1316,5 +1316,5 @@ struct syscallentry syscall_perf_event_open = {
 	},
 	.sanitise = sanitise_perf_event_open,
 	.init = init_pmus,
-	.flags = NEED_ALARM,
+	.flags = NEED_ALARM | IGNORE_ENOSYS,
 };
-- 
1.9.1
