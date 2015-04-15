From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] DRM dumb buffer file descriptors
Date: Wed, 15 Apr 2015 22:39:20 +0300
Message-ID: <1429126760-32714-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=b9961gyKQCk1SlNVO1FQmP4tnFNnT7FqLStFLV6/H0I=;
        b=nFpS0908lPJZiPJQjVI3P0LphDhBIwQZmv07ezhvUFwG1qcpJrqM4D2oZSCKtBPEXY
         eiytEtf6NRwd94oZifdVHtoSvgwviG2WfhOxOkOu9LEP1bFBjdDRBgUkGGx6mPoM92wl
         ZhUVsxhuD6MQhLb5gQKV2Ns1FfLE6WOptH/ABwe5NumKOUmPvL+Qv4lmFmsMbcre/8cm
         Qheqjqz6aRZ9p0G0s51esMy2e41hMgPbhf66KxRy6bzdee4k7OP6zQ9/c9xabD/ZRfNo
         qfqA42KDUbiqMcsDkm1/+Fk1ZhL/A6SE64a2SlYKqmCgyuRcm6InX6rFQAW63OE+3gWq
         6pLA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Use the DRM_IOCTL_MODE_CREATE_DUMB ioctl to make "dumb" buffers; then use
the DRM_IOCTL_PRIME_HANDLE_TO_FD ioctl to get file descriptors.
---
 fd-drm.c          | 143 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fds.c             |   1 +
 include/drm_fds.h |   6 +++
 include/shm.h     |   2 +
 params.c          |   2 +-
 5 files changed, 153 insertions(+), 1 deletion(-)
 create mode 100644 fd-drm.c
 create mode 100644 include/drm_fds.h

diff --git a/fd-drm.c b/fd-drm.c
new file mode 100644
index 0000000..7772c6a
--- /dev/null
+++ b/fd-drm.c
@@ -0,0 +1,143 @@
+/* DRM FDs */
+
+#include "config.h"
+#include "fd.h"
+#include "log.h"
+#include "memfd.h"
+#include "net.h"
+#include "params.h"
+#include "pids.h"
+#include "random.h"
+#include "sanitise.h"
+#include "shm.h"
+#include "compat.h"
+#include "trinity.h"
+
+static unsigned fd_count;
+
+#ifdef USE_DRM
+
+#include <dirent.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <drm/drm.h>
+
+static int create_dumb(__unused__ int fd)
+{
+#if defined(DRM_IOCTL_MODE_CREATE_DUMB) && defined(DRM_IOCTL_PRIME_HANDLE_TO_FD)
+	struct drm_mode_create_dumb create;
+	struct drm_prime_handle handle_to_fd;
+
+	memset(&create, 0, sizeof(create));
+	create.height = 1 << RAND_RANGE(0, 10);
+	create.width = 1 << RAND_RANGE(0, 10);
+	create.bpp = 32;
+
+	if (ioctl(fd, DRM_IOCTL_MODE_CREATE_DUMB, &create) < 0) {
+		return -1;
+	}
+
+	memset(&handle_to_fd, 0, sizeof(handle_to_fd));
+	handle_to_fd.handle = create.handle;
+	if (RAND_BOOL())
+		handle_to_fd.flags = DRM_CLOEXEC;
+
+	if (ioctl(fd, DRM_IOCTL_PRIME_HANDLE_TO_FD, &handle_to_fd) < 0) {
+		return -1;
+	}
+
+	return handle_to_fd.fd;
+#else
+	return -1;
+#endif
+}
+
+static int open_drm_fds(void)
+{
+	unsigned int i;
+	int fd, dfd;
+	DIR *dir;
+	struct dirent *entry;
+	char buf[128];
+
+	dir = opendir("/dev/dri/");
+	if (!dir)
+		goto done;
+
+	// Open all /dev/dri/*, and try to make FDs from each of them.
+	while (1) {
+		entry = readdir(dir);
+		if (!entry)
+			break;
+
+		if (strcmp(entry->d_name, ".") == 0 ||
+		    strcmp(entry->d_name, "..") == 0)
+			continue;
+
+		snprintf(buf, sizeof(buf), "/dev/dri/%s", entry->d_name);
+		buf[sizeof(buf)-1] = '\0';
+
+		fd = open(buf, O_RDWR);
+		if (fd < 0) {
+			continue;
+		}
+		shm->drm_fds[fd_count++] = fd;
+
+		if (fd_count >= MAX_DRM_FDS)
+			break;
+
+		dfd = create_dumb(fd);
+		if (dfd < 0) {
+			continue;
+		}
+		shm->drm_fds[fd_count++] = dfd;
+
+		if (fd_count >= MAX_DRM_FDS)
+			break;
+	}
+
+	if (dir)
+		closedir(dir);
+
+	for (i = 0; i < MAX_DRM_FDS; i++) {
+		if (shm->drm_fds[i] > 0) {
+			output(2, "fd[%d] = drm\n", shm->drm_fds[i]);
+		}
+	}
+
+done:
+	if (fd_count == 0)
+		drm_fd_provider.enabled = FALSE;
+
+	return TRUE;
+}
+
+#else
+
+static int open_drm_fds(void) { return TRUE; }
+
+#endif /* USE_DRM */
+
+static int get_rand_drm_fd(void)
+{
+	// We should not be called when fd_count is zero, but avoid div-by-zero
+	// just in case.
+	if (fd_count > 0)
+		return shm->drm_fds[rand() % fd_count];
+	else
+		return -1;
+}
+
+struct fd_provider drm_fd_provider = {
+	.name = "drm",
+	.enabled = TRUE,
+	.open = &open_drm_fds,
+	.get = &get_rand_drm_fd,
+};
diff --git a/fds.c b/fds.c
index fbb2bba..a3a70f9 100644
--- a/fds.c
+++ b/fds.c
@@ -56,6 +56,7 @@ void setup_fd_providers(void)
 	add_to_prov_list(&timerfd_fd_provider);
 	add_to_prov_list(&testfile_fd_provider);
 	add_to_prov_list(&memfd_fd_provider);
+	add_to_prov_list(&drm_fd_provider);
 
 	output(0, "Registered %d fd providers.\n", num_fd_providers);
 }
diff --git a/include/drm_fds.h b/include/drm_fds.h
new file mode 100644
index 0000000..3c70b33
--- /dev/null
+++ b/include/drm_fds.h
@@ -0,0 +1,6 @@
+#pragma once
+
+#include "fd.h"
+struct fd_provider drm_fd_provider;
+
+#define MAX_DRM_FDS 8
diff --git a/include/shm.h b/include/shm.h
index 16a5994..673ed1b 100644
--- a/include/shm.h
+++ b/include/shm.h
@@ -2,6 +2,7 @@
 
 #include "arch.h"
 #include "child.h"
+#include "drm_fds.h"
 #include "epoll.h"
 #include "eventfd.h"
 #include "exit.h"
@@ -61,6 +62,7 @@ struct shm_s {
 	int timerfd_fds[MAX_TIMERFD_FDS];
 	int testfile_fds[MAX_TESTFILE_FDS];
 	int memfd_fds[MAX_MEMFD_FDS];
+	int drm_fds[MAX_DRM_FDS];
 	struct socketinfo sockets[NR_SOCKET_FDS];
 	int current_fd;
 	unsigned int fd_lifetime;
diff --git a/params.c b/params.c
index 53861a5..96c737c 100644
--- a/params.c
+++ b/params.c
@@ -60,7 +60,7 @@ char server_addr[INET6_ADDRSTRLEN] = "\0";
 
 void enable_disable_fd_usage(void)
 {
-	outputerr(" --enable-fds/--disable-fds= {sockets,pipes,perf,epoll,eventfd,pseudo,timerfd,testfile,memfd}\n");
+	outputerr(" --enable-fds/--disable-fds= {sockets,pipes,perf,epoll,eventfd,pseudo,timerfd,testfile,memfd,drm}\n");
 }
 
 static void usage(void)
-- 
2.1.0
