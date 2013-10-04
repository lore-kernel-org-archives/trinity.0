From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Fix to broken random selection of syscalls.
Date: Fri, 4 Oct 2013 11:29:41 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310041127580.20432@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=F8511Yr8dWr2dnZ/nk4HcePzjZt7RjlqSAG+XNuyHMM=;
        b=mR5OmkW18Orpp2Ah/QXHc5znwuBJnan4lqYhKNMIV3KItSfILDi1FwmbK6PxIJJwFb
         4U5hZdxIJINlhhebqtaQ9eqzm3b1CXqvsL+Vn0Qn6rZLPZnjoT7ygyX4Zn+3EOqdTJug
         QBkr3j+M7BjhzDTiqPJkthpWuWb0vcUPZpjQVnErCrHnINm0kluBnysADBWmuoMRfvAz
         uv08Z4V+cF0d5IzjKvLBg305cWrQ26gEfSiKyFC8syZqgh4XRqa/oIA52o8cqUVQpD6b
         o1jacToFk2zS+onnxooNAg6w4OEGYZqqwPU5VQVmncRS+1PMP6enLvV+0nZawPtKT2tE
         sCsA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch fixes random selection of system calls, introduced in the 
earlier commit.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 tables.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tables.c b/tables.c
index f41ffac..618d742 100644
--- a/tables.c
+++ b/tables.c
@@ -15,6 +15,8 @@
 #include "log.h"
 #include "shm.h"
 
+#define NOTFOUND (unsigned int)-1
+
 const struct syscalltable *syscalls;
 const struct syscalltable *syscalls_32bit;
 const struct syscalltable *syscalls_64bit;
@@ -813,9 +815,7 @@ void disable_non_net_syscalls(void)
 void enable_random_syscalls(void)
 {
 	unsigned int i;
-	unsigned int call, call32, call64, callnotfound;
-
-	callnotfound = (unsigned int)-1;
+	unsigned int call, call32, call64;
 
 	if (random_selection_num == 0) {
 		printf("-r 0 syscalls ? what?\n");
@@ -840,8 +840,8 @@ void enable_random_syscalls(void)
 
 retry:
 		if (biarch == TRUE) {
-			call64 = callnotfound;
-			call32 = callnotfound;
+			call64 = NOTFOUND;
+			call32 = NOTFOUND;
 
 			//Search for 64 bit version
 			if (do_64_arch) {
@@ -853,11 +853,11 @@ retry:
 					if (is_syscall_net_related(syscalls_64bit, call64) == FALSE)
 						goto retry;
 
-				if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED)
+				if ((syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED) || (syscalls_64bit[call64].entry->active_number != 0))
 					goto try32bit;
 
 				//If we got so far, then active it.
-				toggle_syscall_biarch_n(i, syscalls_64bit, TRUE, do_64_arch, TRUE,
+				toggle_syscall_biarch_n(call64, syscalls_64bit, TRUE, do_64_arch, TRUE,
 							&activate_syscall64, 64, syscalls_64bit[call64].entry->name);
 			}
 try32bit:
@@ -867,35 +867,35 @@ try32bit:
 				if (do_64_arch) {
 					call32 = search_syscall_table(syscalls_32bit, max_nr_32bit_syscalls, syscalls_64bit[call64].entry->name);
 					if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED)
-						call64 = callnotfound; //mark as not found in order not to increment i.
+						call64 = NOTFOUND; //mark as not found in order not to increment i.
 				} else {
 					call32 = rand() % max_nr_32bit_syscalls;
 				}
 
 				if (validate_specific_syscall_silent(syscalls_32bit, call32) == FALSE) {
-					if (call64 == callnotfound)
+					if (call64 == NOTFOUND)
 						goto retry;
 					else
 						continue;
 				}
 
 				if (no_files == TRUE)
-					if (is_syscall_net_related(syscalls_64bit, call64) == FALSE) {
-						if (call64 == callnotfound)
+					if (is_syscall_net_related(syscalls_32bit, call32) == FALSE) {
+						if (call64 == NOTFOUND)
 							goto retry;
 						else
 							continue;
 					}
 
-				if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED) {
-					if (call64 == callnotfound)
+				if ((syscalls_32bit[call32].entry->flags & TO_BE_DEACTIVATED) || (syscalls_32bit[call32].entry->active_number != 0)) {
+					if (call64 == NOTFOUND)
 						goto retry;
 					else
 						continue;
 				}
 
 				//If we got so far, then active it.
-				toggle_syscall_biarch_n(i, syscalls_32bit, TRUE, do_32_arch, TRUE,
+				toggle_syscall_biarch_n(call32, syscalls_32bit, TRUE, do_32_arch, TRUE,
 							&activate_syscall32, 32, syscalls_32bit[call32].entry->name);
 			}
 
-- 
1.8.4
