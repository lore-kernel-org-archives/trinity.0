From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] uid: initialize nobody_uid/nobody/gid only if --dropprivs requested
Date: Tue,  1 Apr 2014 13:57:28 +0300
Message-ID: <1396349848-11537-1-git-send-email-kirill.shutemov@linux.intel.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org, Dave Jones <davej@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

I don't have nobody user in my dummy rootfs for virtual machine and
trinity stops on getpwnam("nobody").

Let's request uid/gid for nobody only if --dropprivs requested.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 trinity.c | 4 ++--
 uid.c     | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/trinity.c b/trinity.c
index dd32418411be..4d8d200c7a89 100644
--- a/trinity.c
+++ b/trinity.c
@@ -66,8 +66,6 @@ int main(int argc, char* argv[])
 
 	initpid = getpid();
 
-	init_uids();
-
 	page_size = getpagesize();
 	num_online_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	max_children = num_online_cpus;	/* possibly overridden in params. */
@@ -80,6 +78,8 @@ int main(int argc, char* argv[])
 
 	create_shm_arrays();
 
+	init_uids();
+
 	if (logging == TRUE)
 		open_logfiles();
 
diff --git a/uid.c b/uid.c
index 6a7e65a6a722..fbcf4744cb15 100644
--- a/uid.c
+++ b/uid.c
@@ -55,6 +55,9 @@ void init_uids(void)
 	orig_uid = getuid();
 	orig_gid = getgid();
 
+	if (dropprivs == FALSE)
+		return;
+
 	passwd = getpwnam("nobody");
 	if (passwd == NULL) {
 		outputerr("Error getting nobody pwent (%s)\n", strerror(errno));
-- 
1.9.1
