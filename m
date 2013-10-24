From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/4] params: Add parsing of -f|--fds option
Date: Fri, 25 Oct 2013 01:39:27 +0400
Message-ID: <1382650768-30954-4-git-send-email-gorcunov@gmail.com>
References: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8L3VeDZaJFro+trJfYvj/2bIHq90xsobqLnuOLnqy0E=;
        b=ooONTq/LZnsI3S765GDG3ycNh3QLhDKpngpw+VliDIA4MdjUM3K4OwQoMPN7VfkiBl
         26KKbPDBI6+COLbXTs4piAedLKm8hZWPnJc/KSHMcmZhfYDipvEg13zquX7NOV7JB936
         6463t3Nf0QUis78AKqFlGjFNEjoez1WBFmO/TYlyRPWcEHIXlEjolUZko9WRswehskrN
         i6yx5iP7tuLLgVxyguij5dtiZ9XQ3nzqTwwscJS/H+LgFMbJFw3y2efTrRuSezcXfK/E
         Fa+ml6XocHBeZ09yZVzdJrI7BqzELF7Znv2kyKncq/rKCIXF1v3ZxSUHXP+Qy07QNap8
         cXAQ==
In-Reply-To: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Here we introduce a trivial tokenizer to control socket
domains assignment. It might be needed to disabled some
sockets (or even all of them, if you're not interested
in testing sockets). For this sake -f|--fds option introduced.

The option takes argument in form of

	--fds sockets:[(all,)|(none,)|(PF_X,^PF_X)]

where PF_X is appropriate domain like PF_INET and such.
The prefix ^ before name means to exclude some particular
family from being tested.

Also note that all|none do overwrite previous option, this
is done in a sake of code simplicity. IOW, if

	--fds sockets:^PF_INET,all

is passed, in result all socket families are allowed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 include/net.h   |  6 +++-
 net/protocols.c | 11 +++++++
 params.c        | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/include/net.h b/include/net.h
index 4e43546..c5baaf4 100644
--- a/include/net.h
+++ b/include/net.h
@@ -1,9 +1,12 @@
 #ifndef _NET_H
 #define _NET_H 1
 
+#include <sys/types.h>
+#include <sys/socket.h>
 #include <netinet/in.h>
 
 extern unsigned int nr_sockets;
+extern char disabled_protos[PF_MAX];
 void open_sockets(void);
 void generate_sockaddr(unsigned long *addr, unsigned long *addrlen, int pf);
 
@@ -11,7 +14,8 @@ void generate_sockaddr(unsigned long *addr, unsigned long *addrlen, int pf);
 extern unsigned int specific_proto;
 const char * get_proto_name(unsigned int proto);
 void find_specific_proto(const char *protoarg);
-
+unsigned int find_proto_by_name(const char *name);
+int disable_socket(const char *domain);
 
 /* glibc headers might be older than the kernel, so chances are we know
  * about more protocols than glibc does. So we define our own PF_MAX */
diff --git a/net/protocols.c b/net/protocols.c
index 891acfe..6aedd29 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -58,6 +58,17 @@ static const struct protocol protocols[] = {
 	{ "PF_VSOCK",        40 },
 };
 
+unsigned int find_proto_by_name(const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(protocols); i++) {
+		if (!strcmp(protocols[i].name, name))
+			return protocols[i].proto;
+	}
+	return -1u;
+}
+
 const char * get_proto_name(unsigned int proto)
 {
 	unsigned int i;
diff --git a/params.c b/params.c
index 77dc7e4..f2b31a3 100644
--- a/params.c
+++ b/params.c
@@ -5,6 +5,7 @@
 #include <getopt.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/socket.h>
 
 #include "trinity.h"	// progname
 #include "random.h"
@@ -12,6 +13,7 @@
 #include "log.h"
 #include "params.h"
 #include "tables.h"
+#include "net.h"
 
 #define TAINT_NAME_LEN 32
 
@@ -53,6 +55,13 @@ int kernel_taint_initial = 0;
 int kernel_taint_mask = 0xFFFFFFFF;
 bool kernel_taint_param_occured = FALSE;
 
+/*
+ * Some socket domains might be disabled in command line,
+ * track the option here, probably worth to convert to
+ * bitmap.
+ */
+char disabled_protos[PF_MAX];
+
 static void usage(void)
 {
 	outputerr("%s\n", progname);
@@ -64,6 +73,7 @@ static void usage(void)
 	outputerr(" --kernel_taint, -T: controls which kernel taint flags should be considered, for more details refer to README file. \n");
 	outputerr(" --list,-L: list all syscalls known on this architecture.\n");
 	outputerr(" --logging,-l: (off=disable logging).\n");
+	outputerr(" --fds,-f: controls which kind of sockets and files to use.\n");
 	outputerr(" --monochrome,-m: don't output ANSI codes\n");
 	outputerr(" --no_files,-n: Only pass sockets as fd's, not files\n");
 	outputerr(" --proto,-P: specify specific network protocol for sockets.\n");
@@ -91,6 +101,7 @@ static const struct option longopts[] = {
 	{ "list", no_argument, NULL, 'L' },
 	{ "ioctls", no_argument, NULL, 'I' },
 	{ "logging", required_argument, NULL, 'l' },
+	{ "fds", required_argument, NULL, 'f' },
 	{ "monochrome", no_argument, NULL, 'm' },
 	{ "no_files", no_argument, NULL, 'n' },
 	{ "proto", required_argument, NULL, 'P' },
@@ -172,11 +183,86 @@ static void process_taint_arg(char *taintarg) {
 	toggle_taint_flag_by_name(beg,end);
 }
 
+static void parse_fds(char *arg)
+{
+	enum {
+		FDS_NONE,
+		FDS_SOCKET,
+	} context = FDS_NONE;
+	char *p = strdup(arg);
+	char *tok;
+
+	if (!p) {
+		outputerr("No memory to parse %s\n", arg);
+		exit(EXIT_FAILURE);
+	}
+
+	/*
+	 * We're expecting here the following format,
+	 * but our parser is a way more greedy and simplier:
+	 * spaces, semicolons and commas are all separators.
+	 *
+	 * 	sockets:[(all,)|(none,)(PF_X,^PF_X)]
+	 *
+	 * note, we're context dependant -- by default all sockets
+	 * are enabled, if you need to disable a particular socket,
+	 * the "^PF_" prefix should be passed. But if you need only
+	 * a few sockets to be enabled then it must be "none,PF_X,PF_X".
+	 *
+	 * It might be not that convenient to type but easier to parse ;-)
+	 */
+	for (tok = strtok(p, " :,"); tok; tok = strtok(NULL, " :,")) {
+		if (strcmp(tok, "sockets") == 0) {
+			context = FDS_SOCKET;
+			continue;
+		}
+
+		switch (context) {
+		case FDS_SOCKET:
+			if (strcmp(tok, "all") == 0) {
+				memset(disabled_protos, 'n', sizeof(disabled_protos));
+			} else if (strcmp(tok, "none") == 0) {
+				memset(disabled_protos, 'y', sizeof(disabled_protos));
+			} else if (strncmp(tok, "PF_", 3) == 0 ||
+				   strncmp(tok, "^PF_", 4) == 0) {
+				int neg = tok[0] == '^';
+				unsigned int proto;
+
+
+				proto = find_proto_by_name(&tok[neg]);
+				if (proto == -1u)
+					goto err;
+				else if (proto > ARRAY_SIZE(disabled_protos))
+					BUG_ON(1);
+				else {
+					if (neg)
+						disabled_protos[proto] = 'y';
+					else
+						disabled_protos[proto] = 'n';
+				}
+			}
+			break;
+		case FDS_NONE:
+		default:
+			outputerr("Unknown context.\n");
+			goto err;
+		}
+	}
+
+	free(p);
+	return;
+
+err:
+	free(p);
+	outputerr("Unrecognizable option in \"%s\".\n", arg);
+	exit(EXIT_FAILURE);
+}
+
 void parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:pqr:s:T:SV:vx:", longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIlf:LN:mnP:pqr:s:T:SV:vx:", longopts, NULL)) != -1) {
 		switch (opt) {
 		default:
 			if (opt == '?')
@@ -240,6 +326,10 @@ void parse_args(int argc, char *argv[])
 				logging = 0;
 			break;
 
+		case 'f':
+			parse_fds(optarg);
+			break;
+
 		case 'L':
 			show_syscall_list = TRUE;
 			break;
-- 
1.8.3.1
