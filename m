From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 1/2] Fix build break when SYS_memfd_create doesn't exist
Date: Wed, 10 Sep 2014 14:26:53 +1000
Message-ID: <1410323214-23324-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

In memfd_create() if SYS_memfd_create is not defined then uname and
flag are unused and gcc complains.
---
 fd-memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fd-memfd.c b/fd-memfd.c
index 2d16427a2b40..583d8ed1f373 100644
--- a/fd-memfd.c
+++ b/fd-memfd.c
@@ -17,8 +17,9 @@
 #include "sanitise.h"
 #include "shm.h"
 #include "compat.h"
+#include "trinity.h"
 
-static int memfd_create(const char *uname, unsigned int flag)
+static int memfd_create(__unused__ const char *uname, __unused__ unsigned int flag)
 {
 #ifdef SYS_memfd_create
 	return syscall(SYS_memfd_create, uname, flag);
-- 
1.9.1
