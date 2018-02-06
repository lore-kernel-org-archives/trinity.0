From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 7/7] trinity: Add support for readdir svc
Date: Tue,  6 Feb 2018 09:02:29 +0100
Message-ID: <20180206080229.27721-7-tmricht@linux.vnet.ibm.com>
References: <20180206080229.27721-1-tmricht@linux.vnet.ibm.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20180206080229.27721-1-tmricht@linux.vnet.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org, davej@codemonkey.org.uk
Cc: brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Thomas Richter <tmricht@linux.vnet.ibm.com>

Add support for system call readdir on s390 (31 bit).

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index 027a9fcd..682d2030 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -96,7 +96,7 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_uselib },
 	{ .entry = &syscall_swapon },
 	{ .entry = &syscall_reboot },
-	{ .entry = &syscall_ni_syscall },	/* TODO: readdir systemcall */
+	{ .entry = &syscall_oldreaddir },
 	{ .entry = &syscall_mmap },		/* old_mmap */
 	{ .entry = &syscall_munmap },
 	{ .entry = &syscall_truncate },
-- 
2.14.3
