From: Markos Chandras <markos.chandras@imgtec.com>
Subject: [PATCH] syscall: Take SYSCALL_OFFSET into account
Date: Wed, 14 May 2014 12:35:38 +0100
Message-ID: <1400067338-12416-1-git-send-email-markos.chandras@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Markos Chandras <markos.chandras@imgtec.com>

MIPS and IA64 have their syscall tables starting at non-zero
offsets so take that into account when executing a sycall
otherwise trinity just fails with ENOSYS error messages.

Tested on MIPS 32/LE system.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 syscall.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/syscall.c b/syscall.c
index 968962b..a1ccb6b 100644
--- a/syscall.c
+++ b/syscall.c
@@ -79,6 +79,7 @@ static long syscall32(unsigned int call,
 static unsigned long do_syscall(int childno, int *errno_saved)
 {
 	int nr = shm->syscall[childno].nr;
+	int call = nr + SYSCALL_OFFSET;
 	unsigned long a1, a2, a3, a4, a5, a6;
 	unsigned long ret = 0;
 
@@ -99,9 +100,9 @@ static unsigned long do_syscall(int childno, int *errno_saved)
 	errno = 0;
 
 	if (shm->syscall[childno].do32bit == FALSE)
-		ret = syscall(nr, a1, a2, a3, a4, a5, a6);
+		ret = syscall(call, a1, a2, a3, a4, a5, a6);
 	else
-		ret = syscall32(nr, a1, a2, a3, a4, a5, a6);
+		ret = syscall32(call, a1, a2, a3, a4, a5, a6);
 
 	*errno_saved = errno;
 
-- 
1.9.3
