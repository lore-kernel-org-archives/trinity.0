From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Sanitise F_SETSIG argument to avoid SIGINT
Date: Wed, 19 Jun 2013 19:02:58 +1000
Message-ID: <1371632578-24654-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

It's possible to send ourselves a SIGINT using F_SETSIG. This is then
interpreted as a Ctrl-c from the user and trinity quits.

Avoid SIGINT, instead use 0, which switches back to the default
behaviour of sending SIGIO.
---
 syscalls/fcntl.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/syscalls/fcntl.c b/syscalls/fcntl.c
index 5d651af..e13735d 100644
--- a/syscalls/fcntl.c
+++ b/syscalls/fcntl.c
@@ -18,6 +18,7 @@
  */
 
 #include <fcntl.h>
+#include <signal.h>
 #include "random.h"
 #include "sanitise.h"
 #include "shm.h"
@@ -90,6 +91,8 @@ void sanitise_fcntl(int childno)
 
 	case F_SETSIG:
 		shm->a3[childno] = (unsigned long) rand32();
+		if (shm->a3[childno] == SIGINT)
+			shm->a3[childno] = 0; /* restore default (SIGIO) */
 		break;
 
 	case F_NOTIFY:
-- 
1.7.10.4
