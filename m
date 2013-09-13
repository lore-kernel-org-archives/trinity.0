From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] add parameter to explicitly select 32 or 64 bit variant of
 syscalls
Date: Fri, 13 Sep 2013 15:30:58 -0700
Message-ID: <52339222.2090403@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        bh=bl9yhOyQGWdoOHq7t8GHuxxRfnCdwKsnHNBR+OPm2BE=;
        b=LyhgSe3B4bTLKf9z8iDmAJcefS2EMcha3ywbatu+8LnoAjJa3yg64o02WRP4q58LSg
         Qq9lRo6goPe/duLXkce5PT4sPvFc+N5pX9IeR/vSvpXpaFnneBMKtkvUo/zO+/YC+eSN
         YDDUsNK4nfLKgByfj5/c+MC93f7p1CtV7vsRmy71o+itHmCZihpwkFnkVY4C1agWo0eG
         KnTTTewM/bKGprqc6EQz9b6xbmw8PGOEMFU6oNu9vrmWYCy427pipMfICxJT0XaIiIww
         e5tZsin216iGe328RrFRjYkRMBDxNbZ1kP3YP2Fz34fp8Rke/fZK/c0RnRNHFOv036rQ
         BUHQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: trinity@vger.kernel.org, davej@redhat.com

This patch enables explicit selection of 32 or 64 bit version of 
syscall(s) via parameter.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
  README           |  4 +++-
  include/params.h |  4 ++++
  params.c         | 22 ++++++++++++++++--
  tables.c         | 71 
+++++++++++++++++++++++++++++++++++++++++++++++++++-----
  4 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/README b/README
index 3999c42..05a1ec3 100644
--- a/README
+++ b/README
@@ -100,7 +100,9 @@ tmp directory. (Handy for cleaning up any garbage 
named files; just rm -rf tmp a
           what maps got set up etc. Does make things go considerably 
faster however,
           as it no longer fsync()'s after every syscall

---ioctls/-I will dump all available ioctls.
+ --ioctls/-I will dump all available ioctls.
+
+ --arch/-a Explicit selection of 32 or 64 bit variant of system calls.

  #######################################################################

diff --git a/include/params.h b/include/params.h
index 6fe7d29..53776bd 100644
--- a/include/params.h
+++ b/include/params.h
@@ -7,6 +7,10 @@
  void parse_args(int argc, char *argv[]);

  extern bool debug;
+
+extern bool do_32_arch;
+extern bool do_64_arch;
+
  extern bool do_specific_syscall;
  extern bool do_exclude_syscall;
  extern unsigned int specific_proto;
diff --git a/params.c b/params.c
index e266c18..3c0ae0a 100644
--- a/params.c
+++ b/params.c
@@ -17,6 +17,9 @@ bool debug = FALSE;
  bool do_specific_syscall = FALSE;
  bool do_exclude_syscall = FALSE;

+bool do_32_arch = TRUE;
+bool do_64_arch = TRUE;
+
  unsigned int specific_proto = 0;
  unsigned int user_specified_children = 0;

@@ -60,8 +63,9 @@ static void usage(void)
  	fprintf(stderr, " --syslog,-S: log important info to syslog. (useful 
if syslog is remote)\n");
  	fprintf(stderr, " --verbose,-v: increase output verbosity.\n");
  	fprintf(stderr, " --victims,-V: path to victim files.\n");
+	fprintf(stderr, " --arch, -a: selects syscalls for the specified 
architecture (32 or 64). Both by default.");
  	fprintf(stderr, "\n");
-	fprintf(stderr, " -c#: target specific syscall (takes syscall name as 
parameter).\n");
+	fprintf(stderr, " -c#,@: target specific syscall (takes syscall name 
as parameter and @ as architecture. No @ defaults to both archs.).\n");
  	fprintf(stderr, " -N#: do # syscalls then exit.\n");
  	fprintf(stderr, " -p:  pause after syscall.\n");
  	fprintf(stderr, " -s#: use # as random seed.\n");
@@ -86,6 +90,7 @@ static const struct option longopts[] = {
  	{ "syslog", no_argument, NULL, 'S' },
  	{ "victims", required_argument, NULL, 'V' },
  	{ "verbose", no_argument, NULL, 'v' },
+	{ "arch", required_argument, NULL, 'a' },
  	{ NULL, 0, NULL, 0 } };


@@ -93,7 +98,7 @@ void parse_args(int argc, char *argv[])
  {
  	int opt;

-	while ((opt = getopt_long(argc, argv, 
"c:C:dDg:hIl:LN:mnP:pqr:s:SV:vx:", longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, 
"a:c:C:dDg:hIl:LN:mnP:pqr:s:SV:vx:", longopts, NULL)) != -1) {
  		switch (opt) {
  		default:
  			if (opt == '?')
@@ -111,6 +116,19 @@ void parse_args(int argc, char *argv[])
  			toggle_syscall(optarg, TRUE);
  			break;

+		case 'a':
+			/* One of the architectures selected*/
+			do_32_arch = FALSE;
+			do_64_arch = FALSE;
+			if (strcmp(optarg, "64") == 0)
+				do_64_arch = TRUE;
+			else if (strcmp(optarg, "32") == 0)
+				do_32_arch = TRUE;
+			else
+				exit(EXIT_FAILURE);
+
+			break;
+
  		case 'C':
  			user_specified_children = strtoll(optarg, NULL, 10);
  			break;
diff --git a/tables.c b/tables.c
index 59969c3..2803ce8 100644
--- a/tables.c
+++ b/tables.c
@@ -281,34 +281,89 @@ void mark_all_syscalls_active(void)
  	}
  }

+static void check_user_specified_arch(const char *arg, char **arg_name, 
bool *only_64bit, bool *only_32bit)
+{
+	//Check if the arch is specified
+	char *arg_arch = strstr(arg,",");
+	unsigned long size = 0;
+
+	if (arg_arch  != NULL) {
+		size = (unsigned long)arg_arch - (unsigned long)arg;
+		*arg_name = malloc(size + 1);
+		if (*arg_name == NULL)
+			exit(EXIT_FAILURE);
+		(*arg_name)[size] = 0;
+		memcpy(*arg_name, arg, size);
+
+		//identify architecture
+		if ((only_64bit != NULL) && (only_32bit != NULL)) {
+			if ((strcmp(arg_arch + 1, "64") == 0)) {
+				*only_64bit = TRUE;
+				*only_32bit = FALSE;
+			} else if ((strcmp(arg_arch + 1,"32") == 0)) {
+				*only_64bit = FALSE;
+				*only_32bit = TRUE;
+			} else {
+				printf("No idea what architecture for syscall (%s) is.\n", arg);
+				exit(EXIT_FAILURE);
+			}
+		}
+	} else {
+		*arg_name = (char*)arg;//castaway const.
+ 	}
+
+
+}
+
+static void clear_check_user_specified_arch(const char *arg, char 
**arg_name)
+{
+	//Release memory only if we have allocated it
+	if (((char *)arg) != *arg_name) {
+		free(*arg_name);
+		*arg_name = NULL;
+	}
+}
+
  static void toggle_syscall_biarch(const char *arg, unsigned char state)
  {
  	int specific_syscall32 = 0;
  	int specific_syscall64 = 0;
+	char *arg_name = NULL;
+	bool only_32bit = TRUE;
+	bool only_64bit = TRUE;

-	specific_syscall64 = search_syscall_table(syscalls_64bit, 
max_nr_64bit_syscalls, arg);
+	check_user_specified_arch(arg, &arg_name, &only_64bit, &only_32bit);
+
+	specific_syscall64 = search_syscall_table(syscalls_64bit, 
max_nr_64bit_syscalls, arg_name);

  	/* If we found a 64bit syscall, validate it. */
  	if (specific_syscall64 != -1) {
  		validate_specific_syscall(syscalls_64bit, specific_syscall64);

-		if (state == TRUE)
+		if ((state == TRUE) && only_64bit && do_64_arch)
  			syscalls_64bit[specific_syscall64].entry->flags |= ACTIVE;
  		else
  			syscalls_64bit[specific_syscall64].entry->flags |= TO_BE_DEACTIVATED;
  	}

  	/* Search for and validate 32bit */
-	specific_syscall32 = search_syscall_table(syscalls_32bit, 
max_nr_32bit_syscalls, arg);
+	specific_syscall32 = search_syscall_table(syscalls_32bit, 
max_nr_32bit_syscalls, arg_name);
  	if (specific_syscall32 != -1) {
  		validate_specific_syscall(syscalls_32bit, specific_syscall32);

-		if (state == TRUE)
+		if ((state == TRUE) && only_32bit && do_32_arch)
  			syscalls_32bit[specific_syscall32].entry->flags |= ACTIVE;
  		else
  			syscalls_32bit[specific_syscall32].entry->flags |= TO_BE_DEACTIVATED;
  	}

+	clear_check_user_specified_arch(arg, &arg_name);
+
+	if ((!only_32bit) && (!only_64bit)) {
+		printf("No idea what architecture for syscall (%s) is.\n", arg);
+		exit(EXIT_FAILURE);
+	}
+
  	if ((specific_syscall64 == -1) && (specific_syscall32 == -1)) {
  		printf("No idea what syscall (%s) is.\n", arg);
  		exit(EXIT_FAILURE);
@@ -340,6 +395,7 @@ static void toggle_syscall_biarch(const char *arg, 
unsigned char state)
  void toggle_syscall(const char *arg, unsigned char state)
  {
  	int specific_syscall = 0;
+	char * arg_name = NULL;

  	if (biarch == TRUE) {
  		toggle_syscall_biarch(arg, state);
@@ -347,9 +403,12 @@ void toggle_syscall(const char *arg, unsigned char 
state)
  	}

  	/* non-biarch case. */
-	specific_syscall = search_syscall_table(syscalls, max_nr_syscalls, arg);
+	check_user_specified_arch(arg, &arg_name, NULL, NULL); //We do not 
care about arch here, just to get rid of arg flags.
+	specific_syscall = search_syscall_table(syscalls, max_nr_syscalls, 
arg_name);
+	clear_check_user_specified_arch(arg, &arg_name);
+
  	if (specific_syscall == -1) {
-		printf("No idea what syscall (%s) is.\n", arg);
+		printf("No idea what syscall (%s) is.\n", arg_name);
  		exit(EXIT_FAILURE);
  	}

-- 
1.8.4
