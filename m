From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH 2/6] wired outputstd/err functions
Date: Tue,  8 Oct 2013 14:26:51 -0700
Message-ID: <1381267615-9826-2-git-send-email-ildarm@google.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q3bx9Pi1jWXPWSOVhVWy5Y4OanNifq/8qhc2Bqg0h8Q=;
        b=WgZKgzgAJwdwSLFuU4SJUdPFaUEfwrM2RK09ud5MLWl27HXWJWgo4J86vHZ1KQe1od
         uGWNvIT+MyH8ObxqqMUgGWeSxKm8nsi1C0mdLJp5b2aG6ln5T23z1wGY4u9jLiARJlSh
         raC9bamxamVybG+3YhbWlQAO4SXVe+rVLkSXylWjqK5KY7wE3FuFyrCBJKmoqH2SJ4sJ
         zcUYzYYuBrwsiOTMF8Z4CyhVtJsPhSCiz/63NZnS1zDufd99xOzgWMngE8SWHtMGRfGv
         MEcfrf+P0eZU2/ib/6sNwpQy+qULFeQ9ejDg0xrj0GL23r69f/UVXak5zQM28iyQe0uJ
         s0YA==
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
 child.c                    |  4 +--
 children/random-syscalls.c |  2 +-
 generic-sanitise.c         |  2 +-
 ioctls/ioctls.c            | 19 +++++++-------
 log.c                      | 18 ++++++-------
 main.c                     |  8 +++---
 maps.c                     |  8 +++---
 net/protocols.c            |  7 ++---
 params.c                   | 50 ++++++++++++++++++------------------
 pids.c                     |  4 +--
 seed.c                     |  4 +--
 sockets.c                  |  6 ++---
 syscalls/perf_event_open.c |  7 ++---
 tables.c                   | 64 +++++++++++++++++++++++-----------------------
 trinity.c                  | 18 ++++++-------
 15 files changed, 112 insertions(+), 109 deletions(-)

diff --git a/child.c b/child.c
index e52fbab..e203aeb 100644
--- a/child.c
+++ b/child.c
@@ -50,7 +50,7 @@ static void reenable_coredumps(void)
 	prctl(PR_SET_DUMPABLE, TRUE);
 
 	if (setrlimit(RLIMIT_CORE, &oldrlimit) != 0) {
-		printf("[%d] Error restoring rlimits to cur:%d max:%d (%s)\n",
+		outputerr("[%d] Error restoring rlimits to cur:%d max:%d (%s)\n",
 			getpid(),
 			(unsigned int) oldrlimit.rlim_cur,
 			(unsigned int) oldrlimit.rlim_max,
@@ -72,7 +72,7 @@ static void set_make_it_fail(void)
 
 	if (write(fd, buf, 1) == -1) {
 		if (errno != EPERM)
-			printf("writing to /proc/self/make-it-fail failed! (%s)\n", strerror(errno));
+			outputerr("writing to /proc/self/make-it-fail failed! (%s)\n", strerror(errno));
 		else
 			shm->do_make_it_fail = TRUE;
 	}
diff --git a/children/random-syscalls.c b/children/random-syscalls.c
index 08d2f76..8f8d770 100644
--- a/children/random-syscalls.c
+++ b/children/random-syscalls.c
@@ -112,7 +112,7 @@ int child_random_syscalls(int childno)
 		}
 
 		if (shm->exit_reason != STILL_RUNNING) {
-			printf("Main is not running, exiting");
+			outputerr("Main is not running, exiting");
 			goto out;
 		}
 
diff --git a/generic-sanitise.c b/generic-sanitise.c
index a2fe9ad..e64f3dd 100644
--- a/generic-sanitise.c
+++ b/generic-sanitise.c
@@ -91,7 +91,7 @@ static unsigned long handle_arg_range(unsigned int call, unsigned int argnum)
 	}
 
 	if (high == 0) {
-		printf("%s forgets to set hirange!\n", syscalls[call].entry->name);
+		outputerr("%s forgets to set hirange!\n", syscalls[call].entry->name);
 		BUG("Fix syscall definition!\n");
 		return 0;
 	}
diff --git a/ioctls/ioctls.c b/ioctls/ioctls.c
index 76cf550..e43bc3c 100644
--- a/ioctls/ioctls.c
+++ b/ioctls/ioctls.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 
 #include "trinity.h"	// ARRAY_SIZE
+#include "log.h"
 #include "files.h"
 #include "shm.h"
 #include "ioctls.h"
@@ -20,7 +21,7 @@ void register_ioctl_group(const struct ioctl_group *grp)
 		return;
 
 	if (grps_cnt == ARRAY_SIZE(grps)) {
-		fprintf(stderr, "WARNING: please grow IOCTL_GROUPS_MAX.\n");
+		outputerr("WARNING: please grow IOCTL_GROUPS_MAX.\n");
 		return;
 	}
 
@@ -100,24 +101,24 @@ void dump_ioctls(void)
 
 	for (i=0; i < grps_cnt; ++i) {
 		if (grps[i]->name)
-			printf("- %s:\n", grps[i]->name);
+			outputerr("- %s:\n", grps[i]->name);
 		else if (grps[i]->devtype) {
 			if (grps[i]->devtype == DEV_MISC)
-				printf("- misc devices");
+				outputerr("- misc devices");
 			else if (grps[i]->devtype == DEV_CHAR)
-				printf("- char devices");
+				outputerr("- char devices");
 			else if (grps[i]->devtype == DEV_BLOCK)
-				printf("- block devices");
+				outputerr("- block devices");
 			for (j=0; j < grps[i]->devs_cnt; ++j)
-				printf("%s '%s'",
+				outputerr("%s '%s'",
 					j == 0 ? "" : ",",
 					grps[i]->devs[j]);
-			printf(":\n");
+			outputerr(":\n");
 		} else
-			printf("- <unknown>:\n");
+			outputerr("- <unknown>:\n");
 
 		for (j=0; j < grps[i]->ioctls_cnt; ++j) {
-			printf("  - 0x%08x : %s\n",
+			outputerr("  - 0x%08x : %s\n",
 					grps[i]->ioctls[j].request,
 					grps[i]->ioctls[j].name ? : "");
 		}
diff --git a/log.c b/log.c
index 144567a..1298038 100644
--- a/log.c
+++ b/log.c
@@ -22,7 +22,7 @@ void open_logfiles(void)
 	unlink(logfilename);
 	mainlogfile = fopen(logfilename, "a");
 	if (!mainlogfile) {
-		printf("## couldn't open logfile %s\n", logfilename);
+		outputerr("## couldn't open logfile %s\n", logfilename);
 		exit(EXIT_FAILURE);
 	}
 
@@ -31,7 +31,7 @@ void open_logfiles(void)
 		unlink(logfilename);
 		shm->logfiles[i] = fopen(logfilename, "a");
 		if (!shm->logfiles[i]) {
-			printf("## couldn't open logfile %s\n", logfilename);
+			outputerr("## couldn't open logfile %s\n", logfilename);
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -73,12 +73,12 @@ static FILE * find_logfile_handle(void)
 		if (i != PIDSLOT_NOT_FOUND)
 			return shm->logfiles[i];
 
-		printf("[%d] ## Couldn't find logfile for pid %d\n", getpid(), pid);
+		outputerr("## Couldn't find logfile for pid %d\n", pid);
 		dump_pid_slots();
-		printf("## Logfiles for pids: ");
+		outputerr("## Logfiles for pids: ");
 		for_each_pidslot(j)
-			printf("%p ", shm->logfiles[j]);
-		printf("\n");
+			outputerr("%p ", shm->logfiles[j]);
+		outputerr("\n");
 	}
 	return NULL;
 }
@@ -108,7 +108,7 @@ void synclogs(void)
 	for_each_pidslot(i) {
 		ret = fflush(shm->logfiles[i]);
 		if (ret == EOF) {
-			printf("## logfile flushing failed! %s\n", strerror(errno));
+			outputerr("## logfile flushing failed! %s\n", strerror(errno));
 			continue;
 		}
 
@@ -116,7 +116,7 @@ void synclogs(void)
 		if (fd != -1) {
 			ret = fsync(fd);
 			if (ret != 0)
-				printf("## fsyncing logfile %d failed. %s\n", i, strerror(errno));
+				outputerr("## fsyncing logfile %d failed. %s\n", i, strerror(errno));
 		}
 	}
 
@@ -172,7 +172,7 @@ void output(unsigned char level, const char *fmt, ...)
 	va_end(args);
 
 	if (n < 0) {
-		printf("## Something went wrong in output() [%d]\n", n);
+		outputerr("## Something went wrong in output() [%d]\n", n);
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/main.c b/main.c
index ec2978d..0a1eba7 100644
--- a/main.c
+++ b/main.c
@@ -109,7 +109,7 @@ static void fork_children(void)
 		/* Find a space for it in the pid map */
 		pidslot = find_pid_slot(EMPTY_PIDSLOT);
 		if (pidslot == PIDSLOT_NOT_FOUND) {
-			printf("## Pid map was full!\n");
+			outputerr("## Pid map was full!\n");
 			dump_pid_slots();
 			exit(EXIT_FAILURE);
 		}
@@ -137,7 +137,7 @@ static void fork_children(void)
 				ret = pid_alive(mainpid);
 				if (ret != 0) {
 					shm->exit_reason = EXIT_SHM_CORRUPTION;
-					printf(BUGTXT "parent (%d) went away!\n", mainpid);
+					outputerr(BUGTXT "parent (%d) went away!\n", mainpid);
 					sleep(20000);
 				}
 			}
@@ -236,7 +236,7 @@ static void handle_child(pid_t childpid, int childstatus)
 			if (slot == PIDSLOT_NOT_FOUND) {
 				/* If we reaped it, it wouldn't show up, so check that. */
 				if (shm->last_reaped != childpid) {
-					printf("## Couldn't find pid slot for %d\n", childpid);
+					outputerr("## Couldn't find pid slot for %d\n", childpid);
 					shm->exit_reason = EXIT_LOST_PID_SLOT;
 					dump_pid_slots();
 				}
@@ -407,7 +407,7 @@ void do_main_loop(void)
 		while (pidmap_empty() == FALSE)
 			handle_children();
 
-		printf("Bailing main loop. Exit reason: %s\n", decode_exit(shm->exit_reason));
+		outputerr("Bailing main loop. Exit reason: %s\n", decode_exit(shm->exit_reason));
 		_exit(EXIT_SUCCESS);
 	}
 
diff --git a/maps.c b/maps.c
index 18b9bcb..c5d739b 100644
--- a/maps.c
+++ b/maps.c
@@ -39,7 +39,7 @@ static struct map * alloc_map(void)
 
 	newmap = malloc(sizeof(struct map));
 	if (!newmap) {
-		printf("Couldn't allocate maps list!\n");
+		outputerr("Couldn't allocate maps list!\n");
 		exit(EXIT_FAILURE);
 	}
 	memset(newmap, 0, sizeof(struct map));
@@ -70,7 +70,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 
 	fd = open("/dev/zero", O_RDWR);
 	if (fd < 0) {
-		printf("open /dev/zero failure. %s\n", strerror(errno));
+		outputerr("open /dev/zero failure. %s\n", strerror(errno));
 		exit(EXIT_FAILURE);
 	}
 
@@ -97,7 +97,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 	tmpmap->ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_SHARED, fd, 0);
 
 	if (tmpmap->ptr == MAP_FAILED) {
-		printf("mmap /dev/zero failure\n");
+		outputerr("mmap /dev/zero failure\n");
 		exit(EXIT_FAILURE);
 	}
 
@@ -105,7 +105,7 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 
 	tmpmap->name = malloc(80);
 	if (!tmpmap->name) {
-		fprintf(stderr, "malloc() failed in %s().", __func__);
+		outputerr("malloc() failed in %s().", __func__);
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/net/protocols.c b/net/protocols.c
index f42b762..3cec507 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -6,6 +6,7 @@
 #include "trinity.h"
 #include "constants.h"
 #include "net.h"
+#include "log.h"
 
 struct protocol {
 	const char *name;
@@ -89,10 +90,10 @@ void find_specific_proto(const char *protoarg)
 	}
 
 	if (i > TRINITY_PF_MAX) {
-		printf("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
+		outputerr("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
 		for (i = 0; i < ARRAY_SIZE(protocols); i++)
-			printf("%s ", protocols[i].name);
-		printf("\n");
+			outputerr("%s ", protocols[i].name);
+		outputerr("\n");
 
 		exit(EXIT_FAILURE);
 	}
diff --git a/params.c b/params.c
index 552742e..cde8684 100644
--- a/params.c
+++ b/params.c
@@ -54,28 +54,28 @@ bool kernel_taint_param_occured = FALSE;
 
 static void usage(void)
 {
-	fprintf(stderr, "%s\n", progname);
-	fprintf(stderr, " --children,-C: specify number of child processes\n");
-	fprintf(stderr, " --exclude,-x: don't call a specific syscall\n");
-	fprintf(stderr, " --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
-	fprintf(stderr, " --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. \n");
-	fprintf(stderr, " --list,-L: list all syscalls known on this architecture.\n");
-	fprintf(stderr, " --ioctls,-I: list all ioctls.\n");
-	fprintf(stderr, " --logging,-l: (off=disable logging).\n");
-	fprintf(stderr, " --monochrome,-m: don't output ANSI codes\n");
-	fprintf(stderr, " --no_files,-n: Only pass sockets as fd's, not files\n");
-	fprintf(stderr, " --proto,-P: specify specific network protocol for sockets.\n");
-	fprintf(stderr, " --quiet,-q: less output.\n");
-	fprintf(stderr, " --random,-r#: pick N syscalls at random and just fuzz those\n");
-	fprintf(stderr, " --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
-	fprintf(stderr, " --verbose,-v: increase output verbosity.\n");
-	fprintf(stderr, " --victims,-V: path to victim files.\n");
-	fprintf(stderr, " --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.");
-	fprintf(stderr, "\n");
-	fprintf(stderr, " -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
-	fprintf(stderr, " -N#: do # syscalls then exit.\n");
-	fprintf(stderr, " -p:  pause after syscall.\n");
-	fprintf(stderr, " -s#: use # as random seed.\n");
+	outputerr("%s\n", progname);
+	outputerr(" --children,-C: specify number of child processes\n");
+	outputerr(" --exclude,-x: don't call a specific syscall\n");
+	outputerr(" --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
+	outputerr(" --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. \n");
+	outputerr(" --list,-L: list all syscalls known on this architecture.\n");
+	outputerr(" --ioctls,-I: list all ioctls.\n");
+	outputerr(" --logging,-l: (off=disable logging).\n");
+	outputerr(" --monochrome,-m: don't output ANSI codes\n");
+	outputerr(" --no_files,-n: Only pass sockets as fd's, not files\n");
+	outputerr(" --proto,-P: specify specific network protocol for sockets.\n");
+	outputerr(" --quiet,-q: less output.\n");
+	outputerr(" --random,-r#: pick N syscalls at random and just fuzz those\n");
+	outputerr(" --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
+	outputerr(" --verbose,-v: increase output verbosity.\n");
+	outputerr(" --victims,-V: path to victim files.\n");
+	outputerr(" --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.");
+	outputerr("\n");
+	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
+	outputerr(" -N#: do # syscalls then exit.\n");
+	outputerr(" -p:  pause after syscall.\n");
+	outputerr(" -s#: use # as random seed.\n");
 	exit(EXIT_SUCCESS);
 }
 
@@ -148,7 +148,7 @@ static void toggle_taint_flag_by_name(char *beg, char *end) {
 	else if (strcmp(name,"OOT_MODULE") == 0)
 		toggle_taint_flag(TAINT_OOT_MODULE);
 	else {
-		printf("Unrecognizable kernel taint flag \"%s\".\n", name);
+		outputerr("Unrecognizable kernel taint flag \"%s\".\n", name);
 		exit(EXIT_FAILURE);
 	}
 }
@@ -181,7 +181,7 @@ void parse_args(int argc, char *argv[])
 			if (opt == '?')
 				exit(EXIT_FAILURE);
 			else
-				printf("opt:%c\n", opt);
+				outputstd("opt:%c\n", opt);
 			return;
 
 		case '\0':
@@ -273,7 +273,7 @@ void parse_args(int argc, char *argv[])
 
 		case 'r':
 			if (do_exclude_syscall == TRUE) {
-				printf("-r needs to be before any -x options.\n");
+				outputerr("-r needs to be before any -x options.\n");
 				exit(EXIT_FAILURE);
 			}
 			random_selection = 1;
diff --git a/pids.c b/pids.c
index dd33d72..100bc69 100644
--- a/pids.c
+++ b/pids.c
@@ -54,7 +54,7 @@ void dump_pid_slots(void)
 		sptr += sprintf(sptr, "\n");
 	}
 	*sptr = '\0';
-	printf("%s", string);
+	outputerr("%s", string);
 }
 
 static pid_t pidmax;
@@ -95,7 +95,7 @@ void pids_init(void)
 #else
 		pidmax = 32768;
 #endif
-		printf("Couldn't read pid_max from proc\n");
+		outputerr("Couldn't read pid_max from proc\n");
 	}
 
 	printf("[init] Using pid_max = %d\n", pidmax);
diff --git a/seed.c b/seed.c
index 802d587..ac32f5b 100644
--- a/seed.c
+++ b/seed.c
@@ -19,7 +19,7 @@ unsigned int seed = 0;
 
 static void syslog_seed(int seedparam)
 {
-	fprintf(stderr, "Randomness reseeded to %u\n", seedparam);
+	outputerr("Randomness reseeded to %u\n", seedparam);
 	openlog("trinity", LOG_CONS|LOG_PERROR, LOG_USER);
 	syslog(LOG_CRIT, "Randomness reseeded to %u\n", seedparam);
 	closelog();
@@ -86,7 +86,7 @@ void reseed(void)
 	shm->reseed_counter = 0;
 
 	if (getpid() != mainpid) {
-		output(0, "Reseeding should only happen from parent!\n");
+		outputerr("Reseeding should only happen from parent!\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/sockets.c b/sockets.c
index c2037c9..32142ba 100644
--- a/sockets.c
+++ b/sockets.c
@@ -116,7 +116,7 @@ static void generate_sockets(void)
 
 	cachefile = creat(cachefilename, S_IWUSR|S_IRUSR);
 	if (cachefile < 0) {
-		printf("Couldn't open cachefile for writing! (%s)\n",
+		outputerr("Couldn't open cachefile for writing! (%s)\n",
 			strerror(errno));
 		exit(EXIT_FAILURE);
 	}
@@ -152,14 +152,14 @@ static void generate_sockets(void)
 				buffer[2] = st.protocol;
 				n = write(cachefile, &buffer, sizeof(int) * 3);
 				if (n == -1) {
-					printf("something went wrong writing the cachefile!\n");
+					outputerr("something went wrong writing the cachefile!\n");
 					exit(EXIT_FAILURE);
 				}
 
 				if (nr_to_create == 0)
 					goto done;
 			} else {
-				//printf("Couldn't open family:%d (%s)\n", st.family, get_proto_name(st.family));
+				//outputerr("Couldn't open family:%d (%s)\n", st.family, get_proto_name(st.family));
 			}
 skip:
 
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index dfcec77..468357a 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -15,6 +15,7 @@
 #include "compat.h"
 #include "maps.h"
 #include "shm.h"
+#include "log.h"
 
 #define SYSFS "/sys/bus/event_source/devices/"
 
@@ -97,7 +98,7 @@ static int parse_format(char *string, int *field_type, unsigned long long *mask)
 			if (string[i]=='-') break;
 			if (string[i]==',') break;
 			if ((string[i]<'0') || (string[i]>'9')) {
-				fprintf(stderr,"Unknown format char %c\n",string[i]);
+				outputerr("Unknown format char %c\n", string[i]);
 				return -1;
 			}
 			firstnum*=10;
@@ -119,7 +120,7 @@ static int parse_format(char *string, int *field_type, unsigned long long *mask)
 				if (string[i]=='-') break;
 				if (string[i]==',') break;
 				if ((string[i]<'0') || (string[i]>'9')) {
-					fprintf(stderr,"Unknown format char %c\n",string[i]);
+					outputerr("Unknown format char %c\n", string[i]);
 					return -1;
 				}
 				secondnum*=10;
@@ -238,7 +239,7 @@ static int parse_generic(int pmu, char *value,
 				if (value[ptr]==',') break;
 				if (! ( ((value[ptr]>='0') && (value[ptr]<='9'))
                    			|| ((value[ptr]>='a') && (value[ptr]<='f'))) ) {
-					fprintf(stderr,"Unexpected char %c\n",value[ptr]);
+					outputerr("Unexpected char %c\n", value[ptr]);
 				}
 				temp*=base;
 				if ((value[ptr]>='0') && (value[ptr]<='9')) {
diff --git a/tables.c b/tables.c
index 618d742..07d4346 100644
--- a/tables.c
+++ b/tables.c
@@ -245,7 +245,7 @@ static void check_syscall(struct syscall *entry)
 	if (entry->num_args > 0) {				\
 		if (entry->num_args > NUMARGS) {		\
 			if (entry->ARGNAME == NULL)  {		\
-				printf("arg %d of %s has no name\n", ARGNUM, entry->name);      \
+				outputerr("arg %d of %s has no name\n", ARGNUM, entry->name);      \
 				exit(EXIT_FAILURE);		\
 			}					\
 		}						\
@@ -265,7 +265,7 @@ static void check_syscall(struct syscall *entry)
 	if (entry->num_args > 0) {				\
 		if (entry->num_args > NUMARGS) {		\
 			if (entry->ARGTYPE == ARG_UNDEFINED) {	\
-				printf("%s has an undefined argument type for arg1 (%s)!\n", entry->name, entry->ARGNAME);	\
+				outputerr("%s has an undefined argument type for arg1 (%s)!\n", entry->name, entry->ARGNAME);	\
 			}					\
 		}						\
 	}							\
@@ -303,7 +303,7 @@ void mark_all_syscalls_active(void)
 {
 	unsigned int i;
 
-	printf("Marking all syscalls as enabled.\n");
+	outputstd("Marking all syscalls as enabled.\n");
 	if (biarch == TRUE) {
 		if (do_32_arch)
 			for_each_32bit_syscall(i) {
@@ -346,7 +346,7 @@ static void check_user_specified_arch(const char *arg, char **arg_name, bool *on
 				*only_64bit = FALSE;
 				*only_32bit = TRUE;
 			} else {
-				printf("Unknown bit width (%s). Choose 32, or 64.\n", arg);
+				outputerr("Unknown bit width (%s). Choose 32, or 64.\n", arg);
 				exit(EXIT_FAILURE);
 			}
 		}
@@ -405,12 +405,12 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 
 
 	if ((!only_32bit) && (!only_64bit)) {
-		printf("No idea what architecture for syscall (%s) is.\n", arg);
+		outputerr("No idea what architecture for syscall (%s) is.\n", arg);
 		exit(EXIT_FAILURE);
 	}
 
 	if ((specific_syscall64 == -1) && (specific_syscall32 == -1)) {
-		printf("No idea what syscall (%s) is.\n", arg);
+		outputerr("No idea what syscall (%s) is.\n", arg);
 		exit(EXIT_FAILURE);
 	}
 
@@ -443,7 +443,7 @@ static void toggle_syscall_biarch(const char *arg, bool state)
 static void toggle_syscall_n(int calln, bool state, const char *arg, const char *arg_name)
 {
 	if (calln == -1) {
-		printf("No idea what syscall (%s) is.\n", arg);
+		outputerr("No idea what syscall (%s) is.\n", arg);
 		exit(EXIT_FAILURE);
 	}
 
@@ -517,9 +517,9 @@ void deactivate_disabled_syscalls(void)
 static void show_state(unsigned int state)
 {
 	if (state)
-		printf("Enabled");
+		outputstd("Enabled");
 	else
-		printf("Disabled");
+		outputstd("Disabled");
 }
 
 void dump_syscall_tables(void)
@@ -527,31 +527,31 @@ void dump_syscall_tables(void)
 	unsigned int i;
 
 	if (biarch == TRUE) {
-		printf("32-bit syscalls: %d\n", max_nr_32bit_syscalls);
-		printf("64-bit syscalls: %d\n", max_nr_64bit_syscalls);
+		outputstd("32-bit syscalls: %d\n", max_nr_32bit_syscalls);
+		outputstd("64-bit syscalls: %d\n", max_nr_64bit_syscalls);
 
 		for_each_32bit_syscall(i) {
-			printf("32-bit entrypoint %d %s : ", syscalls_32bit[i].entry->number, syscalls_32bit[i].entry->name);
+			outputstd("32-bit entrypoint %d %s : %s", syscalls_32bit[i].entry->number, syscalls_32bit[i].entry->name);
 			show_state(syscalls_32bit[i].entry->flags & ACTIVE);
 			if (syscalls_32bit[i].entry->flags & AVOID_SYSCALL)
-				printf(" AVOID");
-			printf("\n");
+				outputstd(" AVOID");
+			outputstd("\n");
 		}
 		for_each_64bit_syscall(i) {
-			printf("64-bit entrypoint %d %s : ", syscalls_64bit[i].entry->number, syscalls_64bit[i].entry->name);
+			outputstd("64-bit entrypoint %d %s : ", syscalls_64bit[i].entry->number, syscalls_64bit[i].entry->name);
 			show_state(syscalls_64bit[i].entry->flags & ACTIVE);
 			if (syscalls_64bit[i].entry->flags & AVOID_SYSCALL)
-				printf(" AVOID");
-			printf("\n");
+				outputstd(" AVOID");
+			outputstd("\n");
 		}
 	} else {
-		printf("syscalls: %d\n", max_nr_syscalls);
+		outputstd("syscalls: %d\n", max_nr_syscalls);
 		for_each_syscall(i) {
-			printf("%d %s : ", syscalls[i].entry->number, syscalls[i].entry->name);
+			outputstd("%d %s : ", syscalls[i].entry->number, syscalls[i].entry->name);
 			show_state(syscalls[i].entry->flags & ACTIVE);
 			if (syscalls[i].entry->flags & AVOID_SYSCALL)
-				printf(" AVOID");
-			printf("\n");
+				outputstd(" AVOID");
+			outputstd("\n");
 		}
 	}
 }
@@ -635,9 +635,9 @@ int setup_syscall_group(unsigned int group)
 		}
 
 		if (shm->nr_active_32bit_syscalls == 0) {
-			printf("No 32-bit syscalls in group\n");
+			outputstd("No 32-bit syscalls in group\n");
 		} else {
-			printf("Found %d 32-bit syscalls in group\n", shm->nr_active_32bit_syscalls);
+			outputstd("Found %d 32-bit syscalls in group\n", shm->nr_active_32bit_syscalls);
 		}
 
 		/* now the 64 bit table*/
@@ -647,10 +647,10 @@ int setup_syscall_group(unsigned int group)
 		}
 
 		if (shm->nr_active_64bit_syscalls == 0) {
-			printf("No 64-bit syscalls in group\n");
+			outputstd("No 64-bit syscalls in group\n");
 			return FALSE;
 		} else {
-			printf("Found %d 64-bit syscalls in group\n", shm->nr_active_64bit_syscalls);
+			outputstd("Found %d 64-bit syscalls in group\n", shm->nr_active_64bit_syscalls);
 		}
 
 	} else {
@@ -661,10 +661,10 @@ int setup_syscall_group(unsigned int group)
 		}
 
 		if (shm->nr_active_syscalls == 0) {
-			printf("No syscalls found in group\n");
+			outputstd("No syscalls found in group\n");
 			return FALSE;
 		} else {
-			printf("Found %d syscalls in group\n", shm->nr_active_syscalls);
+			outputstd("Found %d syscalls in group\n", shm->nr_active_syscalls);
 		}
 	}
 
@@ -690,7 +690,7 @@ const char * print_syscall_name(unsigned int callno, bool is32bit)
 	}
 
 	if (callno >= max) {
-		printf("Bogus syscall number in %s (%u)\n", __func__, callno);
+		outputstd("Bogus syscall number in %s (%u)\n", __func__, callno);
 		return "invalid-syscall";
 	}
 
@@ -818,23 +818,23 @@ void enable_random_syscalls(void)
 	unsigned int call, call32, call64;
 
 	if (random_selection_num == 0) {
-		printf("-r 0 syscalls ? what?\n");
+		outputerr("-r 0 syscalls ? what?\n");
 		exit(EXIT_FAILURE);
 	}
 
 	if (biarch == TRUE) {
 		if ((random_selection_num > max_nr_64bit_syscalls) && do_64_arch) {
-			printf("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_64bit_syscalls);
+			outputerr("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_64bit_syscalls);
 			exit(EXIT_FAILURE);
 		}
 	} else {
 		if (random_selection_num > max_nr_syscalls) {
-			printf("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_syscalls);
+			outputerr("-r val %d out of range (1-%d)\n", random_selection_num, max_nr_syscalls);
 			exit(EXIT_FAILURE);
 		}
 	}
 
-	printf("Enabling %d random syscalls\n", random_selection_num);
+	outputerr("Enabling %d random syscalls\n", random_selection_num);
 
 	for (i = 0; i < random_selection_num; i++) {
 
diff --git a/trinity.c b/trinity.c
index 73627cf..8140da1 100644
--- a/trinity.c
+++ b/trinity.c
@@ -99,7 +99,7 @@ static void setup_shm_postargs(void)
 		shm->max_children = sysconf(_SC_NPROCESSORS_ONLN);
 
 	if (shm->max_children > MAX_NR_CHILDREN) {
-		printf("Increase MAX_NR_CHILDREN!\n");
+		outputerr("Increase MAX_NR_CHILDREN!\n");
 		exit(EXIT_FAILURE);
 	}
 }
@@ -145,8 +145,8 @@ static int munge_tables(void)
 		display_enabled_syscalls();
 
 	if (validate_syscall_tables() == FALSE) {
-		printf("No syscalls were enabled!\n");
-		printf("Use 32bit:%d 64bit:%d\n", use_32bit, use_64bit);
+		outputstd("No syscalls were enabled!\n");
+		outputstd("Use 32bit:%d 64bit:%d\n", use_32bit, use_64bit);
 		return FALSE;
 	}
 
@@ -230,17 +230,17 @@ int main(int argc, char* argv[])
 
 	if (getuid() == 0) {
 		if (dangerous == TRUE) {
-			printf("DANGER: RUNNING AS ROOT.\n");
-			printf("Unless you are running in a virtual machine, this could cause serious problems such as overwriting CMOS\n");
-			printf("or similar which could potentially make this machine unbootable without a firmware reset.\n\n");
-			printf("ctrl-c now unless you really know what you are doing.\n");
+			outputstd("DANGER: RUNNING AS ROOT.\n");
+			outputstd("Unless you are running in a virtual machine, this could cause serious problems such as overwriting CMOS\n");
+			outputstd("or similar which could potentially make this machine unbootable without a firmware reset.\n\n");
+			outputstd("ctrl-c now unless you really know what you are doing.\n");
 			for (i = 10; i > 0; i--) {
-				printf("Continuing in %d seconds.\r", i);
+				outputstd("Continuing in %d seconds.\r", i);
 				(void)fflush(stdout);
 				sleep(1);
 			}
 		} else {
-			printf("Don't run as root (or pass --dangerous if you know what you are doing).\n");
+			outputstd("Don't run as root (or pass --dangerous if you know what you are doing).\n");
 			exit(EXIT_FAILURE);
 		}
 	}
-- 
1.8.4
