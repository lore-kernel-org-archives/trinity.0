From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] Update powerpc syscall list to match v3.15-rc7
Date: Mon, 26 May 2014 22:32:39 +1000
Message-ID: <1401107559-23635-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

---
 include/syscalls-ppc.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/syscalls-ppc.h b/include/syscalls-ppc.h
index 3ef88a7..0798595 100644
--- a/include/syscalls-ppc.h
+++ b/include/syscalls-ppc.h
@@ -333,4 +333,38 @@ struct syscalltable syscalls_ppc[] = {
 	{ .entry = &syscall_preadv },
 	{ .entry = &syscall_pwritev },
 	{ .entry = &syscall_rt_tgsigqueueinfo },
+	{ .entry = &syscall_fanotify_init },
+	{ .entry = &syscall_fanotify_mark },
+	{ .entry = &syscall_prlimit64 },
+	{ .entry = &syscall_socket },
+	{ .entry = &syscall_bind },
+	{ .entry = &syscall_connect },
+	{ .entry = &syscall_listen },
+	{ .entry = &syscall_accept },
+	{ .entry = &syscall_getsockname },
+	{ .entry = &syscall_getpeername },
+	{ .entry = &syscall_socketpair },
+	{ .entry = &syscall_send },
+	{ .entry = &syscall_sendto },
+	{ .entry = &syscall_recv },
+	{ .entry = &syscall_recvfrom },
+	{ .entry = &syscall_shutdown },
+	{ .entry = &syscall_setsockopt },
+	{ .entry = &syscall_getsockopt },
+	{ .entry = &syscall_sendmsg },
+	{ .entry = &syscall_recvmsg },
+	{ .entry = &syscall_recvmmsg },
+	{ .entry = &syscall_accept4 },
+	{ .entry = &syscall_name_to_handle_at },
+	{ .entry = &syscall_open_by_handle_at },
+	{ .entry = &syscall_clock_adjtime },
+	{ .entry = &syscall_syncfs },
+	{ .entry = &syscall_sendmmsg },
+	{ .entry = &syscall_setns },
+	{ .entry = &syscall_process_vm_readv },
+	{ .entry = &syscall_process_vm_writev },
+	{ .entry = &syscall_finit_module },
+	{ .entry = &syscall_kcmp },
+	{ .entry = &syscall_sched_setattr },
+	{ .entry = &syscall_sched_getattr },
 };
-- 
1.9.1
