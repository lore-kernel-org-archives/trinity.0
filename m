From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 5/6] params: Add --no_proto|-E option
Date: Wed, 30 Oct 2013 16:15:45 +0400
Message-ID: <1383135346-31463-6-git-send-email-gorcunov@openvz.org>
References: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XJ+giklbt/7RGcoPs4EOsfdgcdF2t/tUZFKj4wcugxE=;
        b=Jji3UCZudOhb8hCKVpYaWrr1Gx4tQzkdY172qJvyRCNZKVKDCy7V+w6aZNKROS4gxH
         IWPtwt6r41HtgYmxtgWRZDYOAthQZh3IsbSs4hDCY9XrDKbRGQ6XK8toLUuDx5pzlUwX
         0cVaMKTMhhudQgB4MVGIJujkXaOPNT9x6WDFY3YbcGJYbV/1HgxZwI2XkxXxBL7zndgH
         HtNjhDiHP1jKLnbKHsoug3YsEnSrTd/MYi3uTS+paosBLQxUXZq6B0h5HUsLwQVPhq6y
         4zdGnZ8gWt+H8cwcORfr8dwqjTo6oS8awSlYWVgdZKBtDbhBUDLrj5zWclhTzQmZLcbP
         ZgiA==
In-Reply-To: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

This option will track the socket families which user
prefer to exclude from testing, for example PF_PACKET
sockets and such.

Note I've had to include net.h in two files only because
TRINITY_PF_MAX is declared there. Maybe it worth to move
this constant to constants.h.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/params.h    |  2 ++
 include/protocols.h |  1 +
 net/protocols.c     | 30 ++++++++++++++++++++++++++++++
 params.c            | 11 ++++++++++-
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/params.h b/include/params.h
index 159ea60..e05727e 100644
--- a/include/params.h
+++ b/include/params.h
@@ -2,6 +2,7 @@
 #define _PARAMS_H 1
 
 #include "types.h"
+#include "net.h"
 
 #define TAINT_PROPRIETARY_MODULE        0
 #define TAINT_FORCED_MODULE             1
@@ -30,6 +31,7 @@ extern bool do_exclude_syscall;
 extern unsigned int specific_proto;
 extern bool do_specific_proto;
 extern char *specific_proto_optarg;
+extern bool no_protos[TRINITY_PF_MAX];
 extern bool dopause;
 extern bool show_syscall_list;
 extern bool show_ioctl_list;
diff --git a/include/protocols.h b/include/protocols.h
index e423a3a..e52d7c3 100644
--- a/include/protocols.h
+++ b/include/protocols.h
@@ -3,5 +3,6 @@
 
 extern const char * get_proto_name(unsigned int proto);
 extern void find_specific_proto(const char *protoarg);
+extern void parse_exclude_protos(const char *arg);
 
 #endif /* _PROTOCOLS_H */
diff --git a/net/protocols.c b/net/protocols.c
index c279476..4c50d0e 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -6,6 +6,7 @@
 #include "trinity.h"
 #include "constants.h"
 #include "protocols.h"
+#include "params.h"
 #include "net.h"
 #include "log.h"
 
@@ -101,3 +102,32 @@ void find_specific_proto(const char *protoarg)
 
 	exit(EXIT_FAILURE);
 }
+
+void parse_exclude_protos(const char *arg)
+{
+	char *_arg = strdup(arg);
+	const struct protocol *p;
+	char *tok;
+
+	if (!_arg) {
+		outputerr("No free memory\n");
+		exit(EXIT_FAILURE);
+	}
+
+	for (tok = strtok(_arg, ","); tok; tok = strtok(NULL, ",")) {
+		p = lookup_proto(tok, (unsigned int)atoi(tok));
+		if (p) {
+			BUG_ON(p->proto >= ARRAY_SIZE(no_protos));
+			no_protos[p->proto] = TRUE;
+		} else
+			goto err;
+	}
+
+	free(_arg);
+	return;
+
+err:
+	free(_arg);
+	outputerr("Protocol unknown in argument %s\n", arg);
+	exit(EXIT_FAILURE);
+}
diff --git a/params.c b/params.c
index 77dc7e4..048a1a5 100644
--- a/params.c
+++ b/params.c
@@ -10,7 +10,9 @@
 #include "random.h"
 #include "syscall.h"
 #include "log.h"
+#include "net.h"
 #include "params.h"
+#include "protocols.h"
 #include "tables.h"
 
 #define TAINT_NAME_LEN 32
@@ -27,6 +29,7 @@ unsigned int specific_proto = 0;
 unsigned int user_specified_children = 0;
 
 bool do_specific_proto = FALSE;
+bool no_protos[TRINITY_PF_MAX];
 
 bool dopause = FALSE;
 bool show_syscall_list = FALSE;
@@ -67,6 +70,7 @@ static void usage(void)
 	outputerr(" --monochrome,-m: don't output ANSI codes\n");
 	outputerr(" --no_files,-n: Only pass sockets as fd's, not files\n");
 	outputerr(" --proto,-P: specify specific network protocol for sockets.\n");
+	outputerr(" --no_proto,-E: specify network protocols to be excluded from testing.\n");
 	outputerr(" --quiet,-q: less output.\n");
 	outputerr(" --random,-r#: pick N syscalls at random and just fuzz those\n");
 	outputerr(" --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
@@ -94,6 +98,7 @@ static const struct option longopts[] = {
 	{ "monochrome", no_argument, NULL, 'm' },
 	{ "no_files", no_argument, NULL, 'n' },
 	{ "proto", required_argument, NULL, 'P' },
+	{ "no_proto", required_argument, NULL, 'E' },
 	{ "random", required_argument, NULL, 'r' },
 	{ "quiet", no_argument, NULL, 'q' },
 	{ "syslog", no_argument, NULL, 'S' },
@@ -176,7 +181,7 @@ void parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:pqr:s:T:SV:vx:", longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "a:c:C:dDg:hIl:LN:mnP:E:pqr:s:T:SV:vx:", longopts, NULL)) != -1) {
 		switch (opt) {
 		default:
 			if (opt == '?')
@@ -268,6 +273,10 @@ void parse_args(int argc, char *argv[])
 			specific_proto_optarg = optarg;
 			break;
 
+		case 'E':
+			parse_exclude_protos(optarg);
+			break;
+
 		case 'q':
 			quiet_level++;
 			break;
-- 
1.8.3.1
