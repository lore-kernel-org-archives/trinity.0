From: Thomas Richter <tmricht@linux.vnet.ibm.com>
Subject: [PATCH 3/7] trinity: Add support for preadv2/pwritev2 svcs
Date: Tue,  6 Feb 2018 09:02:25 +0100
Message-ID: <20180206080229.27721-3-tmricht@linux.vnet.ibm.com>
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
support for system calls preadv2 and pwritev2.

Signed-off-by: Thomas Richter <tmricht@linux.vnet.ibm.com>
---
 include/syscalls-s390.h  | 4 ++--
 include/syscalls-s390x.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index 83613edf..1ca1a0fe 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -387,8 +387,8 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_shutdown },
 	{ .entry = &syscall_ni_syscall },	/* TODO: mlock2 svc */
 	{ .entry = &syscall_ni_syscall },	/* TODO: copy_file_range svc */
-	{ .entry = &syscall_ni_syscall },	/* TODO: preadv2 svc */
-	{ .entry = &syscall_ni_syscall },	/* TODO: pwritev2 svc */
+	{ .entry = &syscall_preadv2 },
+	{ .entry = &syscall_pwritev2 },
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_guarded_storage svc */
 	{ .entry = &syscall_ni_syscall },	/* TODO: statx svc */
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_sthyi svc */
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index 333d649c..6c546e1b 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -387,8 +387,8 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_shutdown },
 	{ .entry = &syscall_ni_syscall },	/* TODO: mlock2 svc */
 	{ .entry = &syscall_ni_syscall },	/* TODO: copy_file_range svc */
-	{ .entry = &syscall_ni_syscall },	/* TODO: preadv2 svc */
-	{ .entry = &syscall_ni_syscall },	/* TODO: pwritev2 svc */
+	{ .entry = &syscall_preadv2 },
+	{ .entry = &syscall_pwritev2 },
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_guarded_storage svc */
 	{ .entry = &syscall_ni_syscall },	/* TODO: statx svc */
 	{ .entry = &syscall_ni_syscall },	/* TODO: s390_sthyi svc */
-- 
2.14.3
