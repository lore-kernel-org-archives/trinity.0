From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 5/7] trinity: Add support for mlock2 svc
Date: Tue,  6 Feb 2018 09:02:27 +0100
Message-ID: <20180206080229.27721-5-tmricht@linux.vnet.ibm.com>
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
support for system call mlock2.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h  | 2 +-
 include/syscalls-s390x.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index 27fbcce1..f53e5289 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -385,7 +385,7 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_recvfrom },
 	{ .entry = &syscall_recvmsg },
 	{ .entry = &syscall_shutdown },
-	{ .entry = &syscall_ni_syscall },	/* TODO: mlock2 svc */
+	{ .entry = &syscall_mlock2 },
 	{ .entry = &syscall_ni_syscall },	/* TODO: copy_file_range svc */
 	{ .entry = &syscall_preadv2 },
 	{ .entry = &syscall_pwritev2 },
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index a3efa7db..f62c6fab 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -385,7 +385,7 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_recvfrom },
 	{ .entry = &syscall_recvmsg },
 	{ .entry = &syscall_shutdown },
-	{ .entry = &syscall_ni_syscall },	/* TODO: mlock2 svc */
+	{ .entry = &syscall_mlock2 },
 	{ .entry = &syscall_ni_syscall },	/* TODO: copy_file_range svc */
 	{ .entry = &syscall_preadv2 },
 	{ .entry = &syscall_pwritev2 },
-- 
2.14.3
