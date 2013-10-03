From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] fix to the 6e296f3a7cab6d946479e76398535f107e80ac4d commit
Date: Thu, 3 Oct 2013 15:45:21 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310031539310.11608@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=cAuRAtNupOE+4Y2WbSX6HxCc5CsT0yWAZoiG3GKBLs8=;
        b=eJIuCig6DNO1Fcm7V43UwORe2WilDEc33aPCkCPs9uH8h6l8Cn/iKC1PHIgkFGKQQS
         6i10/BxLz6qDvAyxk4LVecOYWroRfFpi2m4v6XmofjtfqARhWr75g7NqKSxgSbmkIDhm
         ZOxmj57SkxCeMFbpA0o5WCJLBiDFpIctJqJAB2vHK51TyTDtldU5sMgLcp9LD+riY1sF
         URP1xCGlv75hny6dkcdFc30NWa5fNo2boTLDaqV8fOPQDWGFhdSZ4uVVJfgNMqV5jB/S
         T3i6UxMR1Z8MRicUYbwbMr3bzTglqf6CksRSU3hvKXUpZeZU/qr619G3wu5+VfOY1AnN
         lGEQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch fixes commit 6e296f3a7cab6d946479e76398535f107e80ac4d, that is 
it adds back checks for AVOID types of syscalls and corrects syscalls 
deactivation.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 children/random-syscalls.c | 17 ++++++++++++++++-
 include/syscall.h          |  6 ++++++
 syscall.c                  | 14 +++++---------
 tables.c                   | 32 +++++++++++++++-----------------
 4 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index a04a6e1..08d2f76 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -107,7 +107,6 @@ int child_random_syscalls(int childno)
 		choose_syscall_table(childno);
 
 		if (nr_active_syscalls == 0) {
-			printf("OOPS: no syscalls enabled\n");
 			shm->exit_reason = EXIT_NO_SYSCALLS_ENABLED;
 			goto out;
 		}
@@ -118,8 +117,24 @@ int child_random_syscalls(int childno)
 		}
 
 		syscallnr = rand() % nr_active_syscalls;
+		/* If we got a syscallnr which is not actvie repeat the attempt, since another child has switched that syscall off already.*/
+		if (active_syscalls[syscallnr] == 0)
+			continue;
+
 		syscallnr = active_syscalls[syscallnr] - 1;
 
+		if (validate_specific_syscall_silent(syscalls, syscallnr) == FALSE) {
+			if (biarch == FALSE) {
+				deactivate_syscall(syscallnr);
+			} else {
+				if (shm->do32bit[childno] == TRUE)
+					deactivate_syscall32(syscallnr);
+				else
+					deactivate_syscall64(syscallnr);
+			}
+			continue;
+		}
+
 		shm->syscallno[childno] = syscallnr;
 
 		if (syscalls_todo) {
diff --git a/include/syscall.h b/include/syscall.h
index d4b5747..71486af 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -120,6 +120,12 @@ void select_syscall_tables(void);
 int search_syscall_table(const struct syscalltable *table, unsigned int nr_syscalls, const char *arg);
 void mark_all_syscalls_active(void);
 void toggle_syscall(const char *arg, bool state);
+void activate_syscall(unsigned int calln);
+void activate_syscall32(unsigned int calln);
+void activate_syscall64(unsigned int calln);
+void deactivate_syscall(unsigned int calln);
+void deactivate_syscall32(unsigned int calln);
+void deactivate_syscall64(unsigned int calln);
 void dump_syscall_tables(void);
 int setup_syscall_group(unsigned int desired_group);
 int validate_syscall_tables(void);
diff --git a/syscall.c b/syscall.c
index 2db3649..6fc6489 100644
--- a/syscall.c
+++ b/syscall.c
@@ -204,7 +204,6 @@ long mkcall(int childno)
 	unsigned long olda1, olda2, olda3, olda4, olda5, olda6;
 	unsigned int call = shm->syscallno[childno];
 	unsigned long ret = 0;
-	int call32, call64;
 	int errno_saved;
 	char string[512], *sptr;
 
@@ -323,15 +322,12 @@ skip_args:
 			syscalls[call].entry->name, call);
 
 		if (biarch == FALSE) {
-			syscalls[call].entry->flags &= ~ACTIVE;
+			deactivate_syscall(call);
 		} else {
-			call32 = search_syscall_table(syscalls_32bit, max_nr_32bit_syscalls, syscalls[call].entry->name);
-			if (call32 != -1)
-				syscalls_32bit[call32].entry->flags &= ~ACTIVE;
-
-			call64 = search_syscall_table(syscalls_64bit, max_nr_64bit_syscalls, syscalls[call].entry->name);
-			if (call64 != -1)
-				syscalls_64bit[call64].entry->flags &= ~ACTIVE;
+			if (shm->do32bit[childno] == TRUE)
+				deactivate_syscall32(call);
+			else
+				deactivate_syscall64(call);
 		}
 	}
 
diff --git a/tables.c b/tables.c
index 1741723..5583ea2 100644
--- a/tables.c
+++ b/tables.c
@@ -91,17 +91,17 @@ static void activate_syscall_in_table(unsigned int calln, unsigned int *nr_activ
 	}
 }
 
-static void activate_syscall32(unsigned int calln)
+void activate_syscall32(unsigned int calln)
 {
 	activate_syscall_in_table(calln, &shm->nr_active_32bit_syscalls, syscalls_32bit, shm->active_syscalls32);
 }
 
-static void activate_syscall64(unsigned int calln)
+void activate_syscall64(unsigned int calln)
 {
 	activate_syscall_in_table(calln, &shm->nr_active_64bit_syscalls, syscalls_64bit, shm->active_syscalls64);
 }
 
-static void activate_syscall(unsigned int calln)
+void activate_syscall(unsigned int calln)
 {
 	activate_syscall_in_table(calln, &shm->nr_active_syscalls, syscalls, shm->active_syscalls);
 }
@@ -109,35 +109,33 @@ static void activate_syscall(unsigned int calln)
 static void deactivate_syscall_in_table(unsigned int calln, unsigned int *nr_active, const struct syscalltable *table, int *active_syscall)
 {
 	struct syscall *call_ptr;
+	unsigned int i;
 
 	call_ptr = table[calln].entry;
 	//Check if the call is activated already, and deactivate it only if needed
-	if (call_ptr->active_number != 0) {
-		*nr_active -= 1;
-		if (call_ptr->active_number == *nr_active) {
-			//simple case, we are in the end
-			active_syscall[*nr_active] = 0;
-		} else {
-			//in the middle
-			active_syscall[call_ptr->active_number - 1] = active_syscall[*nr_active];
-			active_syscall[*nr_active] = 0;
-		}
+	if ((call_ptr->active_number != 0) && (*nr_active > 0)) {
+		for (i = call_ptr->active_number - 1; i < *nr_active - 1; i++) {
+			active_syscall[i] = active_syscall[i + 1];
+			table[active_syscall[i] - 1].entry->active_number = i + 1;
+		}
+		//The last step is to erase the last item.
+		active_syscall[*nr_active - 1] = 0;
+		(*nr_active) -= 1;
 		call_ptr->active_number = 0;
 	}
-
 }
 
-static void deactivate_syscall32(unsigned int calln)
+void deactivate_syscall32(unsigned int calln)
 {
 	deactivate_syscall_in_table(calln, &shm->nr_active_32bit_syscalls, syscalls_32bit, shm->active_syscalls32);
 }
 
-static void deactivate_syscall64(unsigned int calln)
+void deactivate_syscall64(unsigned int calln)
 {
 	deactivate_syscall_in_table(calln, &shm->nr_active_64bit_syscalls, syscalls_64bit, shm->active_syscalls64);
 }
 
-static void deactivate_syscall(unsigned int calln)
+void deactivate_syscall(unsigned int calln)
 {
 	deactivate_syscall_in_table(calln, &shm->nr_active_syscalls, syscalls, shm->active_syscalls);
 }
-- 
1.8.4
