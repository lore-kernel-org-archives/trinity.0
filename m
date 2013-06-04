From: "Ciochina, TudorX M" <tudorx.m.ciochina@intel.com>
Subject: [PATCH 1/1] feature: adding network support to trinity
Date: Tue, 4 Jun 2013 12:58:20 +0000
Message-ID: <AB5A800CF38D9A4E81CFBDA2E4743FE301AF5D51@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <trinity-owner@vger.kernel.org>
Content-Language: en-US
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: "trinity@vger.kernel.org" <trinity@vger.kernel.org>
Cc: "Maxim, Costel" <costel.maxim@intel.com>

I propose a patch, which adds a client and a server to trinity to be able send the arguments of syscall() over TCP. The server logs the inbound data to a header like file. The reason for this is to replicate the bugs found by trinity.

Thanks,
Tudor

---
 network.c | 228 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 network.h |  24 +++++++
 params.c  |  26 ++++++-
 syscall.c |   4 ++
 trinity.c |   7 ++
 5 files changed, 288 insertions(+), 1 deletion(-)

diff --git a/network.c b/network.c
index e69de29..f0869b0 100644
--- a/network.c
+++ b/network.c
@@ -0,0 +1,228 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <signal.h>
+#include <time.h>
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/ioctl.h>
+
+#include <arpa/inet.h>
+
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+
+#include "params.h"
+#include "network.h"
+
+struct network_s *network;
+
+FILE *raw_syscalls_file;
+
+void create_tcp_socket(void) {
+
+	int return_value;
+
+	int flag = 1;
+
+	network = (struct network_s *) malloc(sizeof(struct network_s));
+	if (network == NULL ) {
+		perror("create_tcp_socket() network malloc() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	network->network_port = logserver_port;
+	if (network_server == TRUE) {
+		network->network_address = NULL;
+	} else {
+		network->network_address = logserver_address;
+	}
+
+	network->server = (struct sockaddr_in *) malloc(sizeof(struct sockaddr_in));
+	if (network->server == NULL ) {
+		perror("create_tcp_socket() network->server malloc() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	network->server->sin_family = AF_INET;
+	if (network_server == TRUE) {
+		network->server->sin_addr.s_addr = INADDR_ANY;
+	} else {
+		network->server->sin_addr.s_addr = inet_addr(network->network_address);
+	}
+	network->server->sin_port = htons(network->network_port);
+
+	network->connected_socketfd = socket(AF_INET, SOCK_STREAM, 0);
+	if (network->connected_socketfd == -1) {
+		perror("create_tcp_socket() socket() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	return_value = setsockopt(network->connected_socketfd, IPPROTO_TCP,
+			TCP_NODELAY, (char *) &flag, sizeof(int));
+	if (return_value == -1) {
+		perror("create_tcp_socket() setsockopt() failed");
+		exit(EXIT_FAILURE);
+	}
+}
+
+void create_client(void) {
+
+	int return_value;
+
+	create_tcp_socket();
+
+	printf("creating client\n");
+
+	return_value = connect(network->connected_socketfd,
+			(struct sockaddr_in *) network->server, sizeof(*network->server));
+	if (return_value == -1) {
+		(void) close(network->connected_socketfd);
+		perror("create_client() connect() failed");
+		exit(EXIT_FAILURE);
+	}
+}
+
+void signal_handler() {
+	int return_value;
+
+	printf("\n");
+	printf("ctrl-c caught\n");
+
+	fprintf(raw_syscalls_file, "%s", "{0, 0LU, 0LU, 0LU, 0LU, 0LU, 0LU} }; \n");
+	fprintf(raw_syscalls_file, "%s", "#endif /* RAW_SYSCALLS_H_ */ \n");
+
+	printf("flushing streams\n");
+	return_value = fflush(raw_syscalls_file);
+	if (return_value == EOF)
+		perror("signal_handler() fflush() failed");
+
+	printf("closing file\n");
+	return_value = fclose(raw_syscalls_file);
+	if (return_value == EOF)
+		perror("signal_handler() fclose() failed");
+
+	printf("closing socket\n");
+	return_value = close(network->connected_socketfd);
+	if (return_value == -1)
+		perror("signal_handler() close() failed");
+
+	printf("freeing memory\n");
+	free(network->server);
+	free(network);
+	exit(EXIT_SUCCESS);
+}
+
+void create_server(void) {
+
+	int return_value;
+	int listening_socketfd;
+
+	int buffer_length = 256;
+	char buffer[buffer_length];
+
+	socklen_t client_size;
+	time_t current_time;
+
+	char raw_syscalls_filename[64];
+
+	struct sockaddr_in *client;
+
+	struct sigaction ctrl_c_Handler;
+	ctrl_c_Handler.sa_handler = signal_handler;
+	sigemptyset(&ctrl_c_Handler.sa_mask);
+	ctrl_c_Handler.sa_flags = 0;
+
+	sigaction(SIGINT, &ctrl_c_Handler, NULL );
+
+	create_tcp_socket();
+
+	printf("server is listening on %d\n", network->network_port);
+
+	return_value = bind(network->connected_socketfd,
+			(struct sockaddr_in*) network->server, sizeof(*network->server));
+	if (return_value == -1) {
+		perror("create_server() bind() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	return_value = listen(network->connected_socketfd, SOMAXCONN);
+	if (return_value == -1) {
+		perror("create_server() bind() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	client = (struct sockaddr_in*) malloc(sizeof(struct sockaddr_in));
+	if (client == NULL ) {
+		perror("create_server() client malloc() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	current_time = time(NULL );
+	sprintf(raw_syscalls_filename, "%s_%d.%c", "raw_syscalls",
+			(int) current_time, 'h');
+	raw_syscalls_file = fopen(raw_syscalls_filename, "a");
+	if (raw_syscalls_file == NULL ) {
+		perror("create_server() fopen() failed");
+	}
+	fprintf(raw_syscalls_file, "%s", "#ifndef RAW_SYSCALLS_H_ \n");
+	fprintf(raw_syscalls_file, "%s", "#define RAW_SYSCALLS_H_ \n");
+	fprintf(raw_syscalls_file, "%s", "unsigned long raw_syscalls[][7] = { \n");
+
+	client_size = sizeof(*client);
+	listening_socketfd = accept(network->connected_socketfd,
+			(struct sockaddr_in *) client, &client_size);
+	if (listening_socketfd == -1) {
+		perror("create_server() accept() failed");
+		exit(EXIT_FAILURE);
+	}
+
+	while (1) {
+		return_value = read(listening_socketfd, buffer, buffer_length);
+		if (return_value == -1) {
+			return_value = close(listening_socketfd);
+			if (return_value == -1)
+				perror("create_server() close() failed");
+			perror("create_client() read() failed");
+			exit(EXIT_FAILURE);
+		}
+
+		fprintf(raw_syscalls_file, "%s", buffer);
+		return_value = fflush(raw_syscalls_file);
+		if (return_value == EOF) {
+			perror("create_server() fflush() failed");
+			exit(EXIT_FAILURE);
+		}
+		memset(buffer, 0, buffer_length);
+	}
+}
+
+void send_away(int nr, unsigned long a1, unsigned long a2, unsigned long a3,
+		unsigned long a4, unsigned long a5, unsigned long a6) {
+
+	ssize_t return_value;
+	int ret;
+
+	useconds_t usec = 1000;
+
+	int buffer_length = 256;
+	char buffer[buffer_length];
+
+	sprintf(buffer, "{%d, %luLU, %luLU, %luLU, %luLU, %luLU, %luLU},\n", nr, a1, a2, a3, a4, a5, a6);
+	return_value = write(network->connected_socketfd, buffer, buffer_length);
+	if (return_value == -1) {
+		perror("send_away() write() buffer failed");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(buffer, 0, buffer_length);
+
+	ret = usleep(usec);
+	if (ret == -1) {
+		perror("send_away() usleep() failed");
+		exit(EXIT_FAILURE);
+	}
+}
diff --git a/network.h b/network.h
index e69de29..2a96353 100644
--- a/network.h
+++ b/network.h
@@ -0,0 +1,24 @@
+#ifndef NETWORK_H_
+#define NETWORK_H_
+
+extern bool network_client;
+extern bool network_server;
+extern bool list;
+extern char *logserver_address;
+extern int logserver_port;
+
+void create_tcp_socket(void);
+void create_client(void);
+void signal_handler();
+void create_server(void);
+void send_away(int, unsigned long, unsigned long, unsigned long, unsigned long,
+		unsigned long, unsigned long);
+
+struct network_s {
+	char* network_address;
+	int network_port;
+	int connected_socketfd;
+	struct sockaddr_in *server;
+};
+
+#endif /* NETWORK_H_ */
diff --git a/params.c b/params.c
index c2c3f70..ef7a927 100644
--- a/params.c
+++ b/params.c
@@ -42,6 +42,12 @@ char *specific_proto_optarg;
 
 char *victim_path;
 
+bool network_client = FALSE;
+bool network_server = FALSE;
+bool list = FALSE;
+char *logserver_address = NULL;
+int logserver_port = 0;
+
 static void usage(void)
 {
 	fprintf(stderr, "%s\n", progname);
@@ -59,6 +65,11 @@ static void usage(void)
 	fprintf(stderr, " --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
 	fprintf(stderr, " --verbose,-v: increase output verbosity.\n");
 	fprintf(stderr, " --victims,-V: path to victim files.\n");
+	fprintf(stderr, "Network mode\n");
+	fprintf(stderr, " --client,-t <ip>:<port>: send the output in real-time to a log server\n");
+	fprintf(stderr, " --server,-e <port>: use trinity as a log server\n");
+	fprintf(stderr, "	./trinity -t 192.168.100.1:12345\n");
+	fprintf(stderr, "	./trinity -e 12345\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, " -c#: target specific syscall (takes syscall name as parameter).\n");
 	fprintf(stderr, " -N#: do # syscalls then exit.\n");
@@ -84,6 +95,8 @@ static const struct option longopts[] = {
 	{ "quiet", no_argument, NULL, 'q' },
 	{ "syslog", no_argument, NULL, 'S' },
 	{ "victims", required_argument, NULL, 'V' },
+	{ "client", required_argument, NULL, 't' },
+	{ "server", required_argument, NULL, 'e' },
 	{ "verbose", no_argument, NULL, 'v' },
 	{ NULL, 0, NULL, 0 } };
 
@@ -92,7 +105,7 @@ void parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt_long(argc, argv, "c:C:dDg:hIl:LN:mnP:pqr:s:SV:vx:", longopts, NULL)) != -1) {
+	while ((opt = getopt_long(argc, argv, "c:C:dDg:hIl:LN:mnP:pqr:s:SV:vx:t:e:", longopts, NULL)) != -1) {
 		switch (opt) {
 		default:
 			if (opt == '?')
@@ -208,6 +221,17 @@ void parse_args(int argc, char *argv[])
 			do_exclude_syscall = TRUE;
 			toggle_syscall(optarg, FALSE);
 			break;
+
+		case 't':
+			network_client = TRUE;
+			logserver_address = strtok(optarg, ":");
+			logserver_port = atoi(strtok(NULL, ":"));
+			break;
+
+		case 'e':
+			network_server = TRUE;
+			logserver_port = atoi(optarg);
+			break;
 		}
 	}
 	if (quiet_level > MAX_LOGLEVEL)
diff --git a/syscall.c b/syscall.c
index 61431f2..4a9a60c 100644
--- a/syscall.c
+++ b/syscall.c
@@ -22,6 +22,7 @@
 #include "params.h"
 #include "maps.h"
 #include "trinity.h"
+#include "network.h"
 
 #define __syscall_return(type, res) \
 	do { \
@@ -84,6 +85,9 @@ static unsigned long do_syscall(int childno, int *errno_saved)
 
 	errno = 0;
 
+	if( network_client == TRUE )
+		send_away(nr, a1, a2, a3, a4, a5, a6);
+
 	if (shm->do32bit[childno] == FALSE)
 		ret = syscall(nr, a1, a2, a3, a4, a5, a6);
 	else
diff --git a/trinity.c b/trinity.c
index 0b88150..197c181 100644
--- a/trinity.c
+++ b/trinity.c
@@ -32,6 +32,7 @@
 #include "syscall.h"
 #include "ioctls.h"
 #include "config.h"	// for VERSION
+#include "network.h"
 
 char *progname = NULL;
 
@@ -170,6 +171,12 @@ int main(int argc, char* argv[])
 
 	setup_shm_postargs();
 
+	if (network_client == TRUE)
+		create_client();
+
+	if (network_server == TRUE)
+		create_server();
+
 	if (logging == TRUE)
 		open_logfiles();
--
