From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 6/7] trinity: Add support for copy_file_range svc
Date: Tue,  6 Feb 2018 09:02:28 +0100
Message-ID: <20180206080229.27721-6-tmricht@linux.vnet.ibm.com>
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

Add support for s390x (64 bit) and s390 (31 bit)
support for system call copy_file_range.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h  | 2 +-
 include/syscalls-s390x.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index f53e5289..027a9fcd 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -386,7 +386,7 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_recvmsg },
 	{ .entry = &syscall_shutdown },
 	{ .entry = &syscall_mlock2 },
-	{ .entry = &syscall_ni_syscall },	/* TODO: copy_file_range svc */
+	{ .entry = &syscall_copy_file_range },
 	{ .entry = &syscall_preadv2 },
 	{ .entry = &syscall_pwritev2 },
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_guarded_storage svc */
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index f62c6fab..a3e26181 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -386,7 +386,7 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_recvmsg },
 	{ .entry = &syscall_shutdown },
 	{ .entry = &syscall_mlock2 },
-	{ .entry = &syscall_ni_syscall },	/* TODO: copy_file_range svc */
+	{ .entry = &syscall_copy_file_range },
 	{ .entry = &syscall_preadv2 },
 	{ .entry = &syscall_pwritev2 },
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_guarded_storage svc */
-- 
2.14.3
