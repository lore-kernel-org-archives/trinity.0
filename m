From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 4/4] Sanity check the syscall number in print_syscall_name()
Date: Sat,  1 Jun 2013 21:46:18 +1000
Message-ID: <1370087178-23439-4-git-send-email-michael@ellerman.id.au>
References: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

In case it's out of bounds, causing us to segfault.

---

My watchdog was crashing because of this a while back. I can't actually
reproduce the crash with current trinity, but it's still possible
AFAICS.
---
 tables.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tables.c b/tables.c
index 3ba70c9..7be1ae9 100644
--- a/tables.c
+++ b/tables.c
@@ -574,14 +574,25 @@ try_64bit:
 const char * print_syscall_name(unsigned int callno, bool is32bit)
 {
 	const struct syscalltable *table;
+	unsigned int max;
 
-	if (biarch == FALSE)
-		return syscalls[callno].entry->name;
+	if (biarch == FALSE) {
+		max = max_nr_syscalls;
+		table = syscalls;
+	} else {
+		if (is32bit == FALSE) {
+			max = max_nr_64bit_syscalls;
+			table = syscalls_64bit;
+		} else {
+			max = max_nr_32bit_syscalls;
+			table = syscalls_32bit;
+		}
+	}
 
-	if (is32bit == FALSE)
-		table = syscalls_64bit;
-	else
-		table = syscalls_32bit;
+	if (callno >= max) {
+		printf("Bogus syscall number in %s (%u)\n", __func__, callno);
+		return "invalid-syscall";
+	}
 
 	return table[callno].entry->name;
 }
-- 
1.7.10.4
