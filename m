From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH 4/6] wired in output function instead of printf (and some missing outputstd)
Date: Tue,  8 Oct 2013 14:26:53 -0700
Message-ID: <1381267615-9826-4-git-send-email-ildarm@google.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ow2369N0u/R1nrO74gTsxQpmgC2TAbJcbltC1Znb8fM=;
        b=bAd5aOM+KD1G4bKWFLpIw0E80sXsOntOq7Z7NBuihLAP6c7s8zSJlx24I8kvHS8NDf
         7YTcuBMfgY4Kx8r85M627iL+lNBrXjPSdwf2KdttD3uKj/Vkkd1giH7t/sVf8lCWbQ62
         kg04OU2UY+iWexXHZdHb9ECdQt54r0msezDzTjSj7CnHWP0DPDVp7bzdGnq5417Vvrok
         RO5Jd/b9me4SeCgUJp3wtJN6GPhESF/54/7ISfHjxLTt84nqPa00UsGueKMyS2VWCaln
         nHPAkUfV0wturxc5bF1j2OMDCeuj+RD4nIaNH/quMaaXNUjUX6LvDPn0B97etg+5wMTY
         gCWw==
In-Reply-To: <1381267615-9826-1-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com, Ildar Muslukhov <ildarm@google.com>

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 children/random-syscalls.c |  9 ++-------
 net/protocols.c            |  4 ++--
 pids.c                     |  2 +-
 seed.c                     |  7 +++++--
 sockets.c                  | 10 +++++-----
 tables.c                   | 34 +++++++++++++++++-----------------
 trinity.c                  |  8 ++++----
 watchdog.c                 |  8 ++++----
 8 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 8f8d770..553586d 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -76,7 +76,6 @@ extern int sigwas;
 
 int child_random_syscalls(int childno)
 {
-	pid_t pid = getpid();
 	int ret;
 	unsigned int syscallnr;
 
@@ -139,14 +138,10 @@ int child_random_syscalls(int childno)
 
 		if (syscalls_todo) {
 			if (shm->total_syscalls_done >= syscalls_todo) {
-				output(0, "[%d] shm->total_syscalls_done (%d) >= syscalls_todo (%d)\n",
-					pid, shm->total_syscalls_done,syscalls_todo);
+				output(0, "Reached maximum syscall count (todo = %d, done = %d), exiting...\n",
+					syscalls_todo, shm->total_syscalls_done);
 				shm->exit_reason = EXIT_REACHED_COUNT;
 			}
-
-			if (shm->total_syscalls_done == syscalls_todo)
-				printf("[%d] Reached maximum syscall count %ld\n",
-					pid, shm->total_syscalls_done);
 		}
 
 		ret = mkcall(childno);
diff --git a/net/protocols.c b/net/protocols.c
index 3cec507..891acfe 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -77,7 +77,7 @@ void find_specific_proto(const char *protoarg)
 		for (i = 0; i < ARRAY_SIZE(protocols); i++) {
 			if (strcmp(protoarg, protocols[i].name) == 0) {
 				specific_proto = protocols[i].proto;
-				printf("Proto %s = %d\n", protoarg, specific_proto);
+				output(2, "Proto %s = %d\n", protoarg, specific_proto);
 				break;
 			}
 		}
@@ -98,5 +98,5 @@ void find_specific_proto(const char *protoarg)
 		exit(EXIT_FAILURE);
 	}
 
-	printf("Using protocol %s (%u) for all sockets\n", protocols[i].name, protocols[i].proto);
+	output(2, "Using protocol %s (%u) for all sockets\n", protocols[i].name, protocols[i].proto);
 }
diff --git a/pids.c b/pids.c
index 100bc69..a2005c1 100644
--- a/pids.c
+++ b/pids.c
@@ -98,7 +98,7 @@ void pids_init(void)
 		outputerr("Couldn't read pid_max from proc\n");
 	}
 
-	printf("[init] Using pid_max = %d\n", pidmax);
+	output(0, "Using pid_max = %d\n", pidmax);
 }
 
 int pid_is_valid(pid_t pid)
diff --git a/seed.c b/seed.c
index ac32f5b..a9c6f6a 100644
--- a/seed.c
+++ b/seed.c
@@ -50,11 +50,11 @@ unsigned int new_seed(void)
 unsigned int init_seed(unsigned int seedparam)
 {
 	if (user_set_seed == TRUE)
-		printf("Using user passed random seed: %u\n", seedparam);
+		output(0, "Using user passed random seed: %u\n", seedparam);
 	else {
 		seedparam = new_seed();
 
-		printf("Initial random seed: %u\n", seedparam);
+		output(0, "Initial random seed: %u\n", seedparam);
 	}
 
 	if (do_syslog == TRUE)
@@ -69,6 +69,9 @@ unsigned int init_seed(unsigned int seedparam)
  */
 void set_seed(unsigned int pidslot)
 {
+	pid_t pid = getpid();
+	if ((pid != watchdog_pid) && (pid != initpid) && (pid != mainpid))
+		output(0, "Setting seed: %u\n", shm->seed + (pidslot + 1));
 	srand(shm->seed + (pidslot + 1));
 	shm->seeds[pidslot] = shm->seed;
 }
diff --git a/sockets.c b/sockets.c
index 32142ba..de43d4b 100644
--- a/sockets.c
+++ b/sockets.c
@@ -190,7 +190,7 @@ static void close_sockets(void)
 		fd = shm->socket_fds[i];
 		shm->socket_fds[i] = 0;
 		if (close(fd) != 0) {
-			printf("failed to close socket.(%s)\n", strerror(errno));
+			output(1, "failed to close socket.(%s)\n", strerror(errno));
 		}
 	}
 
@@ -211,7 +211,7 @@ void open_sockets(void)
 
 	cachefile = open(cachefilename, O_RDONLY);
 	if (cachefile < 0) {
-		printf("Couldn't find socket cachefile. Regenerating.\n");
+		output(1, "Couldn't find socket cachefile. Regenerating.\n");
 		generate_sockets();
 		return;
 	}
@@ -229,7 +229,7 @@ void open_sockets(void)
 
 		if (do_specific_proto == TRUE) {
 			if (domain != specific_proto) {
-				printf("ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
+				output(1, "ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
 regenerate:
 				unlock_cachefile(cachefile);	/* drop the reader lock. */
 				close(cachefile);
@@ -241,7 +241,7 @@ regenerate:
 
 		fd = open_socket(domain, type, protocol);
 		if (fd < 0) {
-			printf("Cachefile is stale. Need to regenerate.\n");
+			output(1, "Cachefile is stale. Need to regenerate.\n");
 			close_sockets();
 			goto regenerate;
 		}
@@ -254,7 +254,7 @@ regenerate:
 	}
 
 	if (nr_sockets < NR_SOCKET_FDS) {
-		printf("Insufficient sockets in cachefile (%d). Regenerating.\n", nr_sockets);
+		output(1, "Insufficient sockets in cachefile (%d). Regenerating.\n", nr_sockets);
 		goto regenerate;
 	}
 
diff --git a/tables.c b/tables.c
index 07d4346..fab6675 100644
--- a/tables.c
+++ b/tables.c
@@ -52,10 +52,10 @@ static void validate_specific_syscall(const struct syscalltable *table, int call
 		return;
 
 	if (table[call].entry->flags & AVOID_SYSCALL)
-		printf("%s is marked as AVOID. Skipping\n", table[call].entry->name);
+		output(0, "%s is marked as AVOID. Skipping\n", table[call].entry->name);
 
 	if (table[call].entry->flags & NI_SYSCALL)
-		printf("%s is NI_SYSCALL. Skipping\n", table[call].entry->name);
+		output(0, "%s is NI_SYSCALL. Skipping\n", table[call].entry->name);
 }
 
 int validate_specific_syscall_silent(const struct syscalltable *table, int call)
@@ -145,12 +145,12 @@ void deactivate_syscall(unsigned int calln)
 void count_syscalls_enabled(void)
 {
 	if (biarch == TRUE) {
-		printf("[init] 32-bit syscalls: %d enabled, %d disabled.  "
+		output(0, "32-bit syscalls: %d enabled, %d disabled.  "
 			"64-bit syscalls: %d enabled, %d disabled.\n",
 			shm->nr_active_32bit_syscalls, max_nr_32bit_syscalls - shm->nr_active_32bit_syscalls,
 			shm->nr_active_64bit_syscalls, max_nr_64bit_syscalls - shm->nr_active_64bit_syscalls);
 	} else {
-		printf("Enabled %d syscalls. Disabled %d syscalls.\n",
+		output(0, "Enabled %d syscalls. Disabled %d syscalls.\n",
 			shm->nr_active_syscalls, max_nr_syscalls - shm->nr_active_syscalls);
 	}
 }
@@ -380,7 +380,7 @@ static void toggle_syscall_biarch_n(int calln, const struct syscalltable *table,
 	}
 
 	if ((arch_bits != 0) && (calln != -1))
-		printf("Marking %d-bit syscall %s (%d) as to be %sabled.\n",
+		output(0, "Marking %d-bit syscall %s (%d) as to be %sabled.\n",
 			arch_bits, arg_name, calln,
 			state ? "en" : "dis");
 }
@@ -415,7 +415,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 	}
 
 	if ((specific_syscall64 != -1) && (specific_syscall32 != -1)) {
-		printf("Marking syscall %s (64bit:%d 32bit:%d) as to be %sabled.\n",
+		output(0, "Marking syscall %s (64bit:%d 32bit:%d) as to be %sabled.\n",
 			arg_name, specific_syscall64, specific_syscall32,
 			state ? "en" : "dis");
 		clear_check_user_specified_arch(arg, &arg_name);
@@ -423,7 +423,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 	}
 
 	if (specific_syscall64 != -1) {
-		printf("Marking 64-bit syscall %s (%d) as to be %sabled.\n",
+		output(0, "Marking 64-bit syscall %s (%d) as to be %sabled.\n",
 			arg, specific_syscall64,
 			state ? "en" : "dis");
 		clear_check_user_specified_arch(arg, &arg_name);
@@ -431,7 +431,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 	}
 
 	if  (specific_syscall32 != -1) {
-		printf("Marking 32-bit syscall %s (%d) as to be %sabled.\n",
+		output(0, "Marking 32-bit syscall %s (%d) as to be %sabled.\n",
 			arg, specific_syscall32,
 			state ? "en" : "dis");
 		clear_check_user_specified_arch(arg, &arg_name);
@@ -456,7 +456,7 @@ static void toggle_syscall_n(int calln, bool state, const char *arg, const char
 		syscalls[calln].entry->flags |= TO_BE_DEACTIVATED;
 	}
 
-	printf("Marking syscall %s (%d) as to be %sabled.\n",
+	output(0, "Marking syscall %s (%d) as to be %sabled.\n",
 		arg_name, calln,
 		state ? "en" : "dis");
 }
@@ -482,14 +482,14 @@ void deactivate_disabled_syscalls(void)
 {
 	unsigned int i;
 
-	printf("Disabling syscalls marked as disabled by command line options\n");
+	output(0, "Disabling syscalls marked as disabled by command line options\n");
 
 	if (biarch == TRUE) {
 		for_each_64bit_syscall(i) {
 			if (syscalls_64bit[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls_64bit[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 				deactivate_syscall64(i);
-				printf("Marked 64-bit syscall %s (%d) as deactivated.\n",
+				output(0, "Marked 64-bit syscall %s (%d) as deactivated.\n",
 					syscalls_64bit[i].entry->name, syscalls_64bit[i].entry->number);
 			}
 		}
@@ -497,7 +497,7 @@ void deactivate_disabled_syscalls(void)
 			if (syscalls_32bit[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls_32bit[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 				deactivate_syscall32(i);
-				printf("Marked 32-bit syscall %s (%d) as deactivated.\n",
+				output(0, "Marked 32-bit syscall %s (%d) as deactivated.\n",
 					syscalls_32bit[i].entry->name, syscalls_32bit[i].entry->number);
 			}
 		}
@@ -507,7 +507,7 @@ void deactivate_disabled_syscalls(void)
 			if (syscalls[i].entry->flags & TO_BE_DEACTIVATED) {
 				syscalls[i].entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 				deactivate_syscall(i);
-				printf("Marked syscall %s (%d) as deactivated.\n",
+				output(0, "Marked syscall %s (%d) as deactivated.\n",
 					syscalls[i].entry->name, syscalls[i].entry->number);
 			}
 		}
@@ -704,19 +704,19 @@ void display_enabled_syscalls(void)
 	if (biarch == TRUE) {
 		for_each_64bit_syscall(i) {
 			if (syscalls_64bit[i].entry->flags & ACTIVE)
-				printf("64-bit syscall %d:%s enabled.\n", i, syscalls_64bit[i].entry->name);
+				output(0, "64-bit syscall %d:%s enabled.\n", i, syscalls_64bit[i].entry->name);
 		}
 
 		for_each_32bit_syscall(i) {
 			if (syscalls_32bit[i].entry->flags & ACTIVE)
-				printf("32-bit syscall %d:%s enabled.\n", i, syscalls_32bit[i].entry->name);
+				output(0, "32-bit syscall %d:%s enabled.\n", i, syscalls_32bit[i].entry->name);
 		}
 
 	} else {
 		/* non-biarch */
 		for_each_syscall(i) {
 			if (syscalls[i].entry->flags & ACTIVE)
-				printf("syscall %d:%s enabled.\n", i, syscalls[i].entry->name);
+				output(0, "syscall %d:%s enabled.\n", i, syscalls[i].entry->name);
 		}
 	}
 }
@@ -766,7 +766,7 @@ void disable_non_net_syscalls(void)
 {
 	unsigned int i;
 
-	printf("Disabling non networking related syscalls\n");
+	output(0, "Disabling non networking related syscalls\n");
 
 	if (biarch == TRUE) {
 		for_each_64bit_syscall(i) {
diff --git a/trinity.c b/trinity.c
index 8140da1..63f205c 100644
--- a/trinity.c
+++ b/trinity.c
@@ -185,7 +185,7 @@ int main(int argc, char* argv[])
 	int childstatus;
 	unsigned int i;
 
-	printf("Trinity v" __stringify(VERSION) "  Dave Jones <davej@redhat.com>\n");
+	outputstd("Trinity v" __stringify(VERSION) "  Dave Jones <davej@redhat.com>\n");
 
 	progname = argv[0];
 
@@ -200,10 +200,10 @@ int main(int argc, char* argv[])
 		exit(EXIT_FAILURE);
 
 	parse_args(argc, argv);
-	printf("Done parsing arguments.\n");
+	outputstd("Done parsing arguments.\n");
 
 	if (kernel_taint_mask != (int)0xFFFFFFFF) {
-		printf("Custom kernel taint mask has been specified: 0x%08x (%d).\n", kernel_taint_mask, kernel_taint_mask);
+		outputstd("Custom kernel taint mask has been specified: 0x%08x (%d).\n", kernel_taint_mask, kernel_taint_mask);
 	}
 
 	setup_shm_postargs();
@@ -274,7 +274,7 @@ int main(int argc, char* argv[])
 	/* Shutting down. */
 	waitpid(watchdog_pid, &childstatus, 0);
 
-	printf("\nRan %ld syscalls. Successes: %ld  Failures: %ld\n",
+	output(0, "\nRan %ld syscalls. Successes: %ld  Failures: %ld\n",
 		shm->total_syscalls_done - 1, shm->successes, shm->failures);
 
 	ret = EXIT_SUCCESS;
diff --git a/watchdog.c b/watchdog.c
index 7f9999b..268c401 100644
--- a/watchdog.c
+++ b/watchdog.c
@@ -188,7 +188,7 @@ static void check_children(void)
 
 		/* if we wrapped, just reset it, we'll pick it up next time around. */
 		if (old > (now + 3)) {
-			printf("child %d wrapped! old=%ld now=%ld\n", i, old, now);
+			output(1, "child %d wrapped! old=%ld now=%ld\n", i, old, now);
 			shm->tv[i].tv_sec = now;
 			continue;
 		}
@@ -275,7 +275,7 @@ static void watchdog(void)
 	bool watchdog_exit = FALSE;
 	int ret = 0;
 
-	printf("[watchdog] Watchdog is alive. (pid:%d)\n", watchdog_pid);
+	output(0, "Watchdog is alive. (pid:%d)\n", watchdog_pid);
 
 	prctl(PR_SET_NAME, (unsigned long) &watchdogname);
 	(void)signal(SIGSEGV, SIG_DFL);
@@ -303,9 +303,9 @@ static void watchdog(void)
 			if (shm->total_syscalls_done % 1000 == 0)
 				synclogs();
 
-			if ((quiet_level > 1) && (shm->total_syscalls_done > 1)) {
+			if (shm->total_syscalls_done > 1) {
 				if (shm->total_syscalls_done - lastcount > 10000) {
-					printf("[watchdog] %ld iterations. [F:%ld S:%ld]\n",
+					output(0, "%ld iterations. [F:%ld S:%ld]\n",
 						shm->total_syscalls_done, shm->failures, shm->successes);
 					lastcount = shm->total_syscalls_done;
 				}
-- 
1.8.4
