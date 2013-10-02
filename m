From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Fixes weired looping in child_random_syscalls function.
Date: Wed, 2 Oct 2013 16:46:41 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310021641240.24433@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=YwEhuE1U9wEy0DJ8wFCbpcfbgPrw4iNYmyrv7Jirdr8=;
        b=aPsQ9QtDSiwByT3Pnj0huFGPWB2n1FXuRTtMVAxFUNaO6xtwGWJohEcxXJ6enAVcOw
         c2lp1Km7wSaozPtnP6d0ykJZVoAIulv9fqHkPx7w4hI99Gx5VLUi+J3JmbNT/bwIM+P4
         RPBIvjzoVMOVzTruREn7Lr6fPf8expbxzj+3xYrC6QXojutHe/ZdIz9Oa+kAaUw8UMt2
         YvcmKK+TOIqHuaIUxPg3YDjdnvUEE4Ct7AzlMNVBjZZ4rRG3qLMJeWPEvTvaQNJznnYg
         Bs4wtELhzotOBkq5JRNMW22OdAf8rMBb4e0fcPsEBgYEM05muaVFWoDziakOVdEQ6x21
         7tkQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch removes makes the loop in child_random_syscalls aware of which 
system calls are enabled, thus, avoiding unnecessary looping.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 children/random-syscalls.c |  36 ++--
 include/constants.h        |   2 +
 include/shm.h              |   8 +
 include/syscall.h          |   3 +-
 tables.c                   | 439 ++++++++++++++++++++++++---------------------
 trinity.c                  |  10 +-
 6 files changed, 277 insertions(+), 221 deletions(-)

diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 62cef3c..a04a6e1 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -22,9 +22,15 @@
  * to 'we asked to do a 32bit only syscall' and more.. Hairy.
  */
 
+int *active_syscalls;
+unsigned int nr_active_syscalls;
+
 static void choose_syscall_table(int childno)
 {
-	if (biarch == TRUE) {
+	if (biarch == FALSE) {
+		active_syscalls = shm->active_syscalls;
+		nr_active_syscalls = shm->nr_active_syscalls;
+	} else if (biarch == TRUE) {
 
 		/* First, check that we have syscalls enabled in either table. */
 		if (validate_syscall_table_64() == FALSE) {
@@ -47,12 +53,15 @@ static void choose_syscall_table(int childno)
 				shm->do32bit[childno] = TRUE;
 		}
 
-
 		if (shm->do32bit[childno] == FALSE) {
 			syscalls = syscalls_64bit;
+			nr_active_syscalls = shm->nr_active_64bit_syscalls;
+			active_syscalls = shm->active_syscalls64;
 			max_nr_syscalls = max_nr_64bit_syscalls;
 		} else {
 			syscalls = syscalls_32bit;
+			nr_active_syscalls = shm->nr_active_32bit_syscalls;
+			active_syscalls = shm->active_syscalls32;
 			max_nr_syscalls = max_nr_32bit_syscalls;
 		}
 	}
@@ -97,28 +106,19 @@ int child_random_syscalls(int childno)
 
 		choose_syscall_table(childno);
 
-		//FIXME: This 'loop' here is pretty gross. If we're just fuzzing
-		// a few syscalls, we can spin here for quite a while.
-		// a better way would be to do something in tables.c where we construct
-		// our own syscall table just containing enabled syscalls.
-retry:
-		if (no_syscalls_enabled() == TRUE) {
+		if (nr_active_syscalls == 0) {
+			printf("OOPS: no syscalls enabled\n");
 			shm->exit_reason = EXIT_NO_SYSCALLS_ENABLED;
 			goto out;
 		}
 
-		if (shm->exit_reason != STILL_RUNNING)
+		if (shm->exit_reason != STILL_RUNNING) {
+			printf("Main is not running, exiting");
 			goto out;
+		}
 
-		syscallnr = rand() % max_nr_syscalls;
-
-		if (!(syscalls[syscallnr].entry->flags & ACTIVE))
-			goto retry;
-
-		if (validate_specific_syscall_silent(syscalls, syscallnr) == FALSE)
-			goto retry;
-
-		/* if we get here, syscallnr is finally valid */
+		syscallnr = rand() % nr_active_syscalls;
+		syscallnr = active_syscalls[syscallnr] - 1;
 
 		shm->syscallno[childno] = syscallnr;
 
diff --git a/include/constants.h b/include/constants.h
index 9ee7378..a57fd60 100644
--- a/include/constants.h
+++ b/include/constants.h
@@ -12,4 +12,6 @@
 
 #define REGENERATION_POINT 100000
 
+#define MAX_NR_SYSCALL 1024
+
 #endif	/* _CONSTANTS_H */
diff --git a/include/shm.h b/include/shm.h
index 7d26ee7..0493eb0 100644
--- a/include/shm.h
+++ b/include/shm.h
@@ -22,6 +22,14 @@ struct shm_s {
 	unsigned int seeds[MAX_NR_CHILDREN];
 	unsigned int reseed_counter;
 
+	//Indices of syscall in syscall table that are active. All indices shifted by +1. Empty index equals to 0.
+	int active_syscalls32[MAX_NR_SYSCALL];
+	int active_syscalls64[MAX_NR_SYSCALL];
+	int active_syscalls[MAX_NR_SYSCALL];
+	unsigned int nr_active_syscalls;
+	unsigned int nr_active_32bit_syscalls;
+	unsigned int nr_active_64bit_syscalls;
+
 	pid_t pids[MAX_NR_CHILDREN];
 	unsigned char child_type[MAX_NR_CHILDREN];
 
diff --git a/include/syscall.h b/include/syscall.h
index faaeafc..d4b5747 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -35,6 +35,7 @@ struct syscall {
 	int (*init)(void);
 
 	unsigned int number;
+	unsigned int active_number;
 	const char name[80];
 	const unsigned int num_args;
 	unsigned int flags;
@@ -118,7 +119,7 @@ extern bool use_64bit;
 void select_syscall_tables(void);
 int search_syscall_table(const struct syscalltable *table, unsigned int nr_syscalls, const char *arg);
 void mark_all_syscalls_active(void);
-void toggle_syscall(const char *arg, unsigned char state);
+void toggle_syscall(const char *arg, bool state);
 void dump_syscall_tables(void);
 int setup_syscall_group(unsigned int desired_group);
 int validate_syscall_tables(void);
diff --git a/tables.c b/tables.c
index 32444bc..f21d8a6 100644
--- a/tables.c
+++ b/tables.c
@@ -13,6 +13,7 @@
 #include "syscall.h"
 #include "params.h"
 #include "log.h"
+#include "shm.h"
 
 const struct syscalltable *syscalls;
 const struct syscalltable *syscalls_32bit;
@@ -69,40 +70,88 @@ int validate_specific_syscall_silent(const struct syscalltable *table, int call)
 	return TRUE;
 }
 
-void count_syscalls_enabled(void)
+static void activate_syscall_in_table(unsigned int calln, unsigned int *nr_active, const struct syscalltable *table, int *active_syscall)
 {
-	unsigned int i;
-	unsigned int ecount_32 = 0, ecount_64 = 0;
-	unsigned int dcount_32 = 0, dcount_64 = 0;
+	struct syscall *call_ptr;
 
-	if (biarch == TRUE) {
-		for_each_64bit_syscall(i) {
-			if (syscalls_64bit[i].entry->flags & ACTIVE)
-				ecount_64++;
-			else
-				dcount_64++;
+	call_ptr = table[calln].entry;
+
+	//Check if the call is activated already, and activate it only if needed
+	if (call_ptr->active_number == 0) {
+		//Sanity check
+		if ((*nr_active + 1) > MAX_NR_SYSCALL) {
+			output(0, "[tables] MAX_NR_SYSCALL needs to be increased. More syscalls than active table can fit.\n");
+			exit(EXIT_FAILURE);
 		}
 
-		for_each_32bit_syscall(i) {
-			if (syscalls_32bit[i].entry->flags & ACTIVE)
-				ecount_32++;
-			else
-				dcount_32++;
+		//save the call no
+		active_syscall[*nr_active] = calln + 1;
+		(*nr_active) += 1;
+		call_ptr->active_number = *nr_active;
+	}
+}
+
+static void activate_syscall32(unsigned int calln)
+{
+	activate_syscall_in_table(calln, &shm->nr_active_32bit_syscalls, syscalls_32bit, shm->active_syscalls32);
+}
+
+static void activate_syscall64(unsigned int calln)
+{
+	activate_syscall_in_table(calln, &shm->nr_active_64bit_syscalls, syscalls_64bit, shm->active_syscalls64);
+}
+
+static void activate_syscall(unsigned int calln)
+{
+	activate_syscall_in_table(calln, &shm->nr_active_syscalls, syscalls, shm->active_syscalls);
+}
+
+static void deactivate_syscall_in_table(unsigned int calln, unsigned int *nr_active, const struct syscalltable *table, int *active_syscall)
+{
+	struct syscall *call_ptr;
+
+	call_ptr = table[calln].entry;
+	//Check if the call is activated already, and deactivate it only if needed
+	if (call_ptr->active_number != 0) {
+		*nr_active -= 1;
+		if (call_ptr->active_number == *nr_active) {
+			//simple case, we are in the end
+			active_syscall[*nr_active] = 0;
+		} else {
+			//in the middle
+			active_syscall[call_ptr->active_number - 1] = active_syscall[*nr_active];
+			active_syscall[*nr_active] = 0;
 		}
+		call_ptr->active_number = 0;
+	}
+
+}
+
+static void deactivate_syscall32(unsigned int calln)
+{
+	deactivate_syscall_in_table(calln, &shm->nr_active_32bit_syscalls, syscalls_32bit, shm->active_syscalls32);
+}
+
+static void deactivate_syscall64(unsigned int calln)
+{
+	deactivate_syscall_in_table(calln, &shm->nr_active_64bit_syscalls, syscalls_64bit, shm->active_syscalls64);
+}
+
+static void deactivate_syscall(unsigned int calln)
+{
+	deactivate_syscall_in_table(calln, &shm->nr_active_syscalls, syscalls, shm->active_syscalls);
+}
+
+void count_syscalls_enabled(void)
+{
+	if (biarch == TRUE) {
 		printf("[init] 32-bit syscalls: %d enabled, %d disabled.  "
 			"64-bit syscalls: %d enabled, %d disabled.\n",
-			ecount_32, dcount_32, ecount_64, dcount_64);
-
+			shm->nr_active_32bit_syscalls, max_nr_32bit_syscalls - shm->nr_active_32bit_syscalls,
+			shm->nr_active_64bit_syscalls, max_nr_64bit_syscalls - shm->nr_active_64bit_syscalls);
 	} else {
-
-		/* non-biarch */
-		for_each_syscall(i) {
-			if (syscalls[i].entry->flags & ACTIVE)
-				ecount_32++;
-			else
-				dcount_32++;
-		}
-		printf("Enabled %d syscalls. Disabled %d syscalls.\n", ecount_32, dcount_32);
+		printf("Enabled %d syscalls. Disabled %d syscalls.\n",
+			shm->nr_active_syscalls, max_nr_syscalls - shm->nr_active_syscalls);
 	}
 }
 
@@ -137,58 +186,44 @@ void init_syscalls(void)
 
 bool no_syscalls_enabled(void)
 {
-	unsigned int i;
-
 	if (biarch == TRUE) {
-		for_each_64bit_syscall(i) {
-			if (syscalls_64bit[i].entry->flags & ACTIVE)
-				return FALSE;
-		}
-		for_each_32bit_syscall(i) {
-			if (syscalls_32bit[i].entry->flags & ACTIVE)
-				return FALSE;
-		}
-		return TRUE;
+		if ((shm->nr_active_32bit_syscalls == 0) && (shm->nr_active_64bit_syscalls == 0))
+			return TRUE;
+		else
+			return FALSE;
 	}
 
 	/* non-biarch */
-	for_each_syscall(i) {
-		if (syscalls[i].entry->flags & ACTIVE)
-			return FALSE;
-	}
-	return TRUE;
+	if (shm->nr_active_syscalls == 0)
+		return TRUE;
+	else
+		return FALSE;
 }
 
 int validate_syscall_table_64(void)
 {
-	unsigned int i;
+	if (shm->nr_active_64bit_syscalls == 0)
+		use_64bit = FALSE;
+	else
+		use_64bit = TRUE;
 
-	for_each_64bit_syscall(i) {
-		if (syscalls_64bit[i].entry->flags & ACTIVE) {
-			use_64bit = TRUE;
-			break;
-		}
-	}
 	return use_64bit;
 }
 
 int validate_syscall_table_32(void)
 {
-	unsigned int i;
+	if (shm->nr_active_32bit_syscalls == 0)
+		use_32bit = FALSE;
+	else
+		use_32bit = TRUE;
 
-	for_each_32bit_syscall(i) {
-		if (syscalls_32bit[i].entry->flags & ACTIVE) {
-			use_32bit = TRUE;
-			break;
-		}
-	}
 	return use_32bit;
 }
 
 /* Make sure there's at least one syscall enabled. */
 int validate_syscall_tables(void)
 {
-	unsigned int i, ret;
+	unsigned int ret;
 
 	if (biarch == TRUE) {
 		ret = validate_syscall_table_32();
@@ -197,11 +232,10 @@ int validate_syscall_tables(void)
 	}
 
 	/* non-biarch case*/
-	for_each_syscall(i) {
-		if (syscalls[i].entry->flags & ACTIVE)
-			return TRUE;
-	}
-	return FALSE;
+	if (shm->nr_active_syscalls == 0)
+		return FALSE;
+	else
+		return TRUE;
 }
 
 static void check_syscall(struct syscall *entry)
@@ -271,13 +305,19 @@ void mark_all_syscalls_active(void)
 
 	printf("Marking all syscalls as enabled.\n");
 	if (biarch == TRUE) {
-		for_each_32bit_syscall(i)
+		for_each_32bit_syscall(i) {
 			syscalls_32bit[i].entry->flags |= ACTIVE;
-		for_each_64bit_syscall(i)
+			activate_syscall32(i);
+		}
+		for_each_64bit_syscall(i) {
 			syscalls_64bit[i].entry->flags |= ACTIVE;
+			activate_syscall64(i);
+		}
 	} else {
-		for_each_syscall(i)
+		for_each_syscall(i) {
 			syscalls[i].entry->flags |= ACTIVE;
+			activate_syscall(i);
+		}
 	}
 }
 
@@ -324,7 +364,26 @@ static void clear_check_user_specified_arch(const char *arg, char **arg_name)
 	}
 }
 
-static void toggle_syscall_biarch(const char *arg, unsigned char state)
+static void toggle_syscall_biarch_n(int calln, const struct syscalltable *table, bool onlyflag, bool doflag, bool state, void (*activate)(unsigned int), int arch_bits, const char *arg_name)
+{
+	if (calln != -1) {
+		validate_specific_syscall(table, calln);
+
+		if ((state == TRUE) && onlyflag && doflag) {
+			table[calln].entry->flags |= ACTIVE;
+			(*activate)(calln);
+		} else {
+			table[calln].entry->flags |= TO_BE_DEACTIVATED;
+		}
+	}
+
+	if ((arch_bits != 0) && (calln != -1))
+		printf("Marking %d-bit syscall %s (%d) as to be %sabled.\n",
+			arch_bits, arg_name, calln,
+			state ? "en" : "dis");
+}
+
+static void toggle_syscall_biarch(const char *arg, bool state)
 {
 	int specific_syscall32 = 0;
 	int specific_syscall64 = 0;
@@ -334,30 +393,14 @@ static void toggle_syscall_biarch(const char *arg, unsigned char state)
 
 	check_user_specified_arch(arg, &arg_name, &only_64bit, &only_32bit);
 
-	specific_syscall64 = search_syscall_table(syscalls_64bit, max_nr_64bit_syscalls, arg_name);
-
 	/* If we found a 64bit syscall, validate it. */
-	if (specific_syscall64 != -1) {
-		validate_specific_syscall(syscalls_64bit, specific_syscall64);
-
-		if ((state == TRUE) && only_64bit && do_64_arch)
-			syscalls_64bit[specific_syscall64].entry->flags |= ACTIVE;
-		else
-			syscalls_64bit[specific_syscall64].entry->flags |= TO_BE_DEACTIVATED;
-	}
+	specific_syscall64 = search_syscall_table(syscalls_64bit, max_nr_64bit_syscalls, arg_name);
+	toggle_syscall_biarch_n(specific_syscall64, syscalls_64bit, only_64bit, do_64_arch, state, &activate_syscall64, 0, arg_name);
 
 	/* Search for and validate 32bit */
 	specific_syscall32 = search_syscall_table(syscalls_32bit, max_nr_32bit_syscalls, arg_name);
-	if (specific_syscall32 != -1) {
-		validate_specific_syscall(syscalls_32bit, specific_syscall32);
+	toggle_syscall_biarch_n(specific_syscall32, syscalls_32bit, only_32bit, do_32_arch, state, &activate_syscall32, 0, arg_name);
 
-		if ((state == TRUE) && only_32bit && do_32_arch)
-			syscalls_32bit[specific_syscall32].entry->flags |= ACTIVE;
-		else
-			syscalls_32bit[specific_syscall32].entry->flags |= TO_BE_DEACTIVATED;
-	}
-
-	clear_check_user_specified_arch(arg, &arg_name);
 
 	if ((!only_32bit) && (!only_64bit)) {
 		printf("No idea what architecture for syscall (%s) is.\n", arg);
@@ -369,11 +412,11 @@ static void toggle_syscall_biarch(const char *arg, unsigned char state)
 		exit(EXIT_FAILURE);
 	}
 
-	/* biarch? */
 	if ((specific_syscall64 != -1) && (specific_syscall32 != -1)) {
 		printf("Marking syscall %s (64bit:%d 32bit:%d) as to be %sabled.\n",
-			arg, specific_syscall64, specific_syscall32,
+			arg_name, specific_syscall64, specific_syscall32,
 			state ? "en" : "dis");
+		clear_check_user_specified_arch(arg, &arg_name);
 		return;
 	}
 
@@ -381,6 +424,7 @@ static void toggle_syscall_biarch(const char *arg, unsigned char state)
 		printf("Marking 64-bit syscall %s (%d) as to be %sabled.\n",
 			arg, specific_syscall64,
 			state ? "en" : "dis");
+		clear_check_user_specified_arch(arg, &arg_name);
 		return;
 	}
 
@@ -388,11 +432,34 @@ static void toggle_syscall_biarch(const char *arg, unsigned char state)
 		printf("Marking 32-bit syscall %s (%d) as to be %sabled.\n",
 			arg, specific_syscall32,
 			state ? "en" : "dis");
+		clear_check_user_specified_arch(arg, &arg_name);
 		return;
 	}
+
+}
+
+static void toggle_syscall_n(int calln, bool state, const char *arg, const char *arg_name)
+{
+	if (calln == -1) {
+		printf("No idea what syscall (%s) is.\n", arg);
+		exit(EXIT_FAILURE);
+	}
+
+	validate_specific_syscall(syscalls, calln);
+
+	if (state == TRUE) {
+		syscalls[calln].entry->flags |= ACTIVE;
+		activate_syscall(calln);
+	} else {
+		syscalls[calln].entry->flags |= TO_BE_DEACTIVATED;
+	}
+
+	printf("Marking syscall %s (%d) as to be %sabled.\n",
+		arg_name, calln,
+		state ? "en" : "dis");
 }
 
-void toggle_syscall(const char *arg, unsigned char state)
+void toggle_syscall(const char *arg, bool state)
 {
 	int specific_syscall = 0;
 	char * arg_name = NULL;
@@ -405,22 +472,8 @@ void toggle_syscall(const char *arg, unsigned char state)
 	/* non-biarch case. */
 	check_user_specified_arch(arg, &arg_name, NULL, NULL); //We do not care about arch here, just to get rid of arg flags.
 	specific_syscall = search_syscall_table(syscalls, max_nr_syscalls, arg_name);
+	toggle_syscall_n(specific_syscall, state, arg, arg_name);
 	clear_check_user_specified_arch(arg, &arg_name);
-
-	if (specific_syscall == -1) {
-		printf("No idea what syscall (%s) is.\n", arg_name);
-		exit(EXIT_FAILURE);
-	}
-
-	validate_specific_syscall(syscalls, specific_syscall);
-
-	if (state == TRUE)
-		syscalls[specific_syscall].entry->flags |= ACTIVE;
-	else
-		syscalls[specific_syscall].entry->flags |= TO_BE_DEACTIVATED;
-
-	printf("Marking syscall %s (%d) as to be %sabled.\n", arg, specific_syscall,
-		state ? "en" : "dis");
 }
 
 void deactivate_disabled_syscalls(void)
@@ -433,6 +486,7 @@ void deactivate_disabled_syscalls(void)
 		for_each_64bit_syscall(i) {
 			if (syscalls_64bit[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls_64bit[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
+				deactivate_syscall64(i);
 				printf("Marked 64-bit syscall %s (%d) as deactivated.\n",
 					syscalls_64bit[i].entry->name, syscalls_64bit[i].entry->number);
 			}
@@ -440,6 +494,7 @@ void deactivate_disabled_syscalls(void)
 		for_each_32bit_syscall(i) {
 			if (syscalls_32bit[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls_32bit[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
+				deactivate_syscall32(i);
 				printf("Marked 32-bit syscall %s (%d) as deactivated.\n",
 					syscalls_32bit[i].entry->name, syscalls_32bit[i].entry->number);
 			}
@@ -449,6 +504,7 @@ void deactivate_disabled_syscalls(void)
 		for_each_syscall(i) {
 			if (syscalls[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
+				deactivate_syscall(i);
 				printf("Marked syscall %s (%d) as deactivated.\n",
 					syscalls[i].entry->name, syscalls[i].entry->number);
 			}
@@ -515,6 +571,7 @@ static struct syscalltable * copy_syscall_table(struct syscalltable *from, unsig
 	for (n = 0; n < nr; n++) {
 		memcpy(copy + n , from[n].entry, sizeof(struct syscall));
 		copy[n].number = n;
+		copy[n].active_number = 0;
 		from[n].entry = &copy[n];
 	}
 	return from;
@@ -565,94 +622,48 @@ void select_syscall_tables(void)
 
 }
 
-
 int setup_syscall_group(unsigned int group)
 {
-	struct syscalltable *newsyscalls;
-	struct syscalltable *newsyscalls32;
-	struct syscalltable *newsyscalls64;
-
 	unsigned int i;
-	int count = 0, j = 0;
 
 	if (biarch == TRUE) {
 		for_each_32bit_syscall(i) {
 			if (syscalls_32bit[i].entry->group == group)
-				count++;
+				activate_syscall32(i);
 		}
 
-		if (count == 0) {
+		if (shm->nr_active_32bit_syscalls == 0) {
 			printf("No 32-bit syscalls in group\n");
-			goto try_64bit;
-		}
-
-		newsyscalls32 = malloc(count * sizeof(struct syscalltable));
-		if (newsyscalls32 == NULL)
-			return FALSE;
-
-		for_each_32bit_syscall(i) {
-			if (syscalls_32bit[i].entry->group == group)
-				newsyscalls32[j++].entry = syscalls_32bit[i].entry;
+		} else {
+			printf("Found %d 32-bit syscalls in group\n", shm->nr_active_32bit_syscalls);
 		}
 
-		max_nr_32bit_syscalls = count;
-		syscalls_32bit = newsyscalls32;
-
-		printf("Found %d 32-bit syscalls in group\n", max_nr_32bit_syscalls);
-
-try_64bit:
 		/* now the 64 bit table*/
-		count = 0, j = 0;
-
 		for_each_64bit_syscall(i) {
 			if (syscalls_64bit[i].entry->group == group)
-				count++;
+				activate_syscall64(i);
 		}
 
-		if (count == 0) {
+		if (shm->nr_active_64bit_syscalls == 0) {
 			printf("No 64-bit syscalls in group\n");
 			return FALSE;
+		} else {
+			printf("Found %d 64-bit syscalls in group\n", shm->nr_active_64bit_syscalls);
 		}
 
-		newsyscalls64 = malloc(count * sizeof(struct syscalltable));
-		if (newsyscalls64 == NULL)
-			return FALSE;
-
-		for_each_64bit_syscall(i) {
-			if (syscalls_64bit[i].entry->group == group)
-				newsyscalls64[j++].entry = syscalls_64bit[i].entry;
-		}
-
-		max_nr_64bit_syscalls = count;
-		syscalls_64bit = newsyscalls64;
-		printf("Found %d 64-bit syscalls in group\n", max_nr_32bit_syscalls);
-
 	} else {
 		/* non-biarch case. */
-
 		for_each_syscall(i) {
 			if (syscalls[i].entry->group == group)
-				count++;
+				activate_syscall(i);
 		}
 
-		if (count == 0) {
+		if (shm->nr_active_syscalls == 0) {
 			printf("No syscalls found in group\n");
 			return FALSE;
+		} else {
+			printf("Found %d syscalls in group\n", shm->nr_active_syscalls);
 		}
-
-		newsyscalls = malloc(count * sizeof(struct syscalltable));
-		if (newsyscalls == NULL)
-			exit(EXIT_FAILURE);
-
-		for_each_syscall(i) {
-			if (syscalls[i].entry->group == group)
-				newsyscalls[j++].entry = syscalls[i].entry;
-		}
-
-		max_nr_syscalls = count;
-		syscalls = newsyscalls;
-
-		printf("Found %d syscalls in group\n", max_nr_syscalls);
 	}
 
 	return TRUE;
@@ -684,16 +695,6 @@ const char * print_syscall_name(unsigned int callno, bool is32bit)
 	return table[callno].entry->name;
 }
 
-// FIXME: in the biarch=TRUE case, we ignore 32bit for now
-static const char * lookup_name(unsigned int num)
-{
-	if (biarch == TRUE) {
-		return syscalls_64bit[num].entry->name;
-	}
-
-	return syscalls[num].entry->name;
-}
-
 void display_enabled_syscalls(void)
 {
 	unsigned int i;
@@ -761,7 +762,6 @@ static bool is_syscall_net_related(const struct syscalltable *table, unsigned in
 
 void disable_non_net_syscalls(void)
 {
-	const char *syscallname;
 	unsigned int i;
 
 	printf("Disabling non networking related syscalls\n");
@@ -773,8 +773,8 @@ void disable_non_net_syscalls(void)
 
 			if (syscalls_64bit[i].entry->flags & ACTIVE) {
 				if (is_syscall_net_related(syscalls_64bit, i) == FALSE) {
-					syscallname = lookup_name(i);
-					toggle_syscall_biarch(syscallname, FALSE);
+					toggle_syscall_biarch_n(i, syscalls_64bit, FALSE, do_64_arch, FALSE,
+								&activate_syscall64, 64, syscalls_64bit[i].entry->name);
 				}
 			}
 		}
@@ -785,8 +785,8 @@ void disable_non_net_syscalls(void)
 
 			if (syscalls_32bit[i].entry->flags & ACTIVE) {
 				if (is_syscall_net_related(syscalls_32bit, i) == FALSE) {
-					syscallname = syscalls_32bit[i].entry->name;
-					toggle_syscall_biarch(syscallname, FALSE);
+					toggle_syscall_biarch_n(i, syscalls_32bit, FALSE, do_32_arch, FALSE,
+								&activate_syscall32, 32, syscalls_32bit[i].entry->name);
 				}
 			}
 		}
@@ -799,8 +799,7 @@ void disable_non_net_syscalls(void)
 
 			if (syscalls[i].entry->flags & ACTIVE) {
 				if (is_syscall_net_related(syscalls, i) == FALSE) {
-					syscallname = lookup_name(i);
-					toggle_syscall(syscallname, FALSE);
+					toggle_syscall_n(i, FALSE, syscalls[i].entry->name, syscalls[i].entry->name);
 				}
 			}
 		}
@@ -814,8 +813,9 @@ void disable_non_net_syscalls(void)
 void enable_random_syscalls(void)
 {
 	unsigned int i;
-	const char *syscallname;
-	unsigned int call, call32, call64;
+	unsigned int call, call32, call64, callnotfound;
+
+	callnotfound = (unsigned int)-1;
 
 	if (random_selection_num == 0) {
 		printf("-r 0 syscalls ? what?\n");
@@ -823,7 +823,7 @@ void enable_random_syscalls(void)
 	}
 
 	if (biarch == TRUE) {
-		if (random_selection_num > max_nr_64bit_syscalls) {
+		if ((random_selection_num > max_nr_64bit_syscalls) && do_64_arch) {
 			printf("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_64bit_syscalls);
 			exit(EXIT_FAILURE);
 		}
@@ -840,26 +840,67 @@ void enable_random_syscalls(void)
 
 retry:
 		if (biarch == TRUE) {
-			call64 = rand() % max_nr_64bit_syscalls;
-			syscallname = lookup_name(call64);
-			call32 = search_syscall_table(syscalls_32bit, max_nr_32bit_syscalls, syscallname);
-
-			if (validate_specific_syscall_silent(syscalls_64bit, call64) == FALSE)
-				goto retry;
-			if (validate_specific_syscall_silent(syscalls_32bit, call32) == FALSE)
-				goto retry;
+			call64 = callnotfound;
+			call32 = callnotfound;
 
-			if (no_files == TRUE) {
-				if (is_syscall_net_related(syscalls_64bit, call64) == FALSE)
-					goto retry;
-				if (is_syscall_net_related(syscalls_32bit, call32) == FALSE)
+			//Search for 64 bit version
+			if (do_64_arch) {
+				call64 = rand() % max_nr_64bit_syscalls;
+				if (validate_specific_syscall_silent(syscalls_64bit, call64) == FALSE)
 					goto retry;
+
+				if (no_files == TRUE)
+					if (is_syscall_net_related(syscalls_64bit, call64) == FALSE)
+						goto retry;
+
+				if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED)
+					goto try32bit;
+
+				//If we got so far, then active it.
+				toggle_syscall_biarch_n(i, syscalls_64bit, TRUE, do_64_arch, TRUE,
+							&activate_syscall64, 64, syscalls_64bit[call64].entry->name);
+			}
+try32bit:
+			//Search for 32 bit version
+			if (do_32_arch) {
+
+				if (do_64_arch) {
+					call32 = search_syscall_table(syscalls_32bit, max_nr_32bit_syscalls, syscalls_64bit[call64].entry->name);
+					if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED)
+						call64 = callnotfound; //mark as not found in order not to increment i.
+				} else {
+					call32 = rand() % max_nr_32bit_syscalls;
+				}
+
+				if (validate_specific_syscall_silent(syscalls_32bit, call32) == FALSE) {
+					if (call64 == callnotfound)
+						goto retry;
+					else
+						continue;
+				}
+
+				if (no_files == TRUE)
+					if (is_syscall_net_related(syscalls_64bit, call64) == FALSE) {
+						if (call64 == callnotfound)
+							goto retry;
+						else
+							continue;
+					}
+
+				if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED) {
+					if (call64 == callnotfound)
+						goto retry;
+					else
+						continue;
+				}
+
+				//If we got so far, then active it.
+				toggle_syscall_biarch_n(i, syscalls_32bit, TRUE, do_32_arch, TRUE,
+							&activate_syscall32, 32, syscalls_32bit[call32].entry->name);
 			}
 
-			if (syscalls_64bit[call64].entry->flags & TO_BE_DEACTIVATED)
-				goto retry;
-			if (syscalls_32bit[call32].entry->flags & TO_BE_DEACTIVATED)
-				goto retry;
+
+
 
 		} else {
 			call = rand() % max_nr_syscalls;
@@ -875,9 +916,7 @@ retry:
 			if (syscalls[call].entry->flags & TO_BE_DEACTIVATED)
 				goto retry;
 
-			syscallname = lookup_name(call);
+			toggle_syscall_n(call, FALSE, syscalls[call].entry->name, syscalls[call].entry->name);
 		}
-
-		toggle_syscall(syscallname, TRUE);
 	}
 }
diff --git a/trinity.c b/trinity.c
index a72484e..73627cf 100644
--- a/trinity.c
+++ b/trinity.c
@@ -69,6 +69,13 @@ static int create_shm(void)
 
 	memset(shm->pids, EMPTY_PIDSLOT, sizeof(shm->pids));
 
+	shm->nr_active_syscalls = 0;
+	shm->nr_active_32bit_syscalls = 0;
+	shm->nr_active_64bit_syscalls = 0;
+	memset(shm->active_syscalls, 0, sizeof(shm->active_syscalls));
+	memset(shm->active_syscalls32, 0, sizeof(shm->active_syscalls32));
+	memset(shm->active_syscalls64, 0, sizeof(shm->active_syscalls64));
+
 	/* Overwritten later in setup_shm_postargs if user passed -s */
 	shm->seed = new_seed();
 
@@ -105,7 +112,7 @@ static int munge_tables(void)
 	/* By default, all syscall entries will be disabled.
 	 * If we didn't pass -c, -x or -r, mark all syscalls active.
 	 */
-	if ((do_specific_syscall == FALSE) && (do_exclude_syscall == FALSE) && (random_selection == FALSE))
+	if ((do_specific_syscall == FALSE) && (do_exclude_syscall == FALSE) && (random_selection == FALSE) && (desired_group == GROUP_NONE))
 		mark_all_syscalls_active();
 
 	if (desired_group != GROUP_NONE) {
@@ -123,7 +130,6 @@ static int munge_tables(void)
 	if (do_exclude_syscall == TRUE) {
 		if (random_selection == FALSE)
 			mark_all_syscalls_active();
-
 		deactivate_disabled_syscalls();
 	}
 
-- 
1.8.4
