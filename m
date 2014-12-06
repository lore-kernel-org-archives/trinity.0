From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] fix syscalls-arm.h
Date: Sat,  6 Dec 2014 22:25:27 +0200
Message-ID: <1417897527-16734-1-git-send-email-tt.rantal@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=2E04STzjjbGCyyssk4uLXZ4diL/O23iGdVgxO/MUQps=;
        b=sxjleN+G1ISfHivJ4bKH1uqT4aocdM5P/Ym77vYhZ5TvnOCihrIUlUBwkF9iRDH8Nt
         Eygk90X6DM/VEQe7Ferq2s5B2AYoroUyCalphUl6Fi7ylogZIJDXcEkBRb+PAW8UCjWO
         /2X29E9dbjNWtWKmhhZSyxEITVkP0jMlIzQrbehOtchqRiQtd84qMOeyUC8I8IMszqRO
         xdE4J9mqtrnGg84ctlSu8Dd+Kio1jJJEDKNuho0NWqd2CMf8au3CB69kGvbQ+PBxWf39
         rOpGgzCQEcrpKDdVXwzhwBr7nHbLNzTcRRDudR8KMMBV31DYkNBfURGkGU8UokuAmbXZ
         asTg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantal@gmail.com>

---
 include/syscalls-arm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/syscalls-arm.h b/include/syscalls-arm.h
index ab6c738..0dad33b 100644
--- a/include/syscalls-arm.h
+++ b/include/syscalls-arm.h
@@ -388,7 +388,6 @@ struct syscalltable syscalls_arm[] = {
 /* 375 */	{ .entry = &syscall_setns },
 		{ .entry = &syscall_process_vm_readv },
 		{ .entry = &syscall_process_vm_writev },
-		{ .entry = &syscall_ni_syscall },	/* reserved for sys_kcmp */
 		{ .entry = &syscall_kcmp },
 		{ .entry = &syscall_finit_module },
 /* 380 */	{ .entry = &syscall_sched_setattr },
-- 
1.9.3
