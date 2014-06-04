From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] Ignore ENOSYS from sys_msgrcv() and sys_ipc()
Date: Wed,  4 Jun 2014 16:05:29 +1000
Message-ID: <1401861929-23686-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

sys_msgrcv() and therefore also sys_ipc() can return ENOSYS when
CONFIG_CHECKPOINT_RESTORE=n. See prepare_copy() in ipc/msg.c.
---
 syscalls/ipc.c    | 1 +
 syscalls/msgrcv.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/syscalls/ipc.c b/syscalls/ipc.c
index d11d48d..ff161be 100644
--- a/syscalls/ipc.c
+++ b/syscalls/ipc.c
@@ -24,4 +24,5 @@ struct syscallentry syscall_ipc = {
 	.arg5name = "ptr",
 	.arg5type = ARG_ADDRESS,
 	.arg6name = "fifth",
+	.flags = IGNORE_ENOSYS,
 };
diff --git a/syscalls/msgrcv.c b/syscalls/msgrcv.c
index 44f11d5..2bfca90 100644
--- a/syscalls/msgrcv.c
+++ b/syscalls/msgrcv.c
@@ -21,4 +21,5 @@ struct syscallentry syscall_msgrcv = {
 		.num = 4,
 		.values = { MSG_NOERROR, MSG_EXCEPT, MSG_COPY, IPC_NOWAIT },
 	},
+	.flags = IGNORE_ENOSYS,
 };
-- 
1.9.1
