From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] Fix buffer overflow in output() when pid slot is not found
Date: Fri, 23 May 2014 19:09:03 +1000
Message-ID: <1400836143-22355-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

In output() we sprintf() the result of find_pid_slot(). We print the pid
slot to the buffer with %u and have space for two digits of pid slot.
find_pid_slot() potentially returns PIDSLOT_NOT_FOUND (-1), which when
printed with %u is 4294967295 - ten digits.

Fix it two ways, use snprintf() - truncated output is better than a
buffer overflow. And allocate more space in the buffer, 32 bytes is a
nice round size, and gives us space for everything.
---
 log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/log.c b/log.c
index 91b4f63..584901c 100644
--- a/log.c
+++ b/log.c
@@ -291,7 +291,7 @@ void output(unsigned char level, const char *fmt, ...)
 	char watchdog_prefix[]="[watchdog]";
 	char init_prefix[]="[init]";
 	char main_prefix[]="[main]";
-	char child_prefix[]="[childNN:1234567890]";
+	char child_prefix[32];
 
 	if (logging == FALSE && level >= quiet_level)
 		return;
@@ -311,7 +311,7 @@ void output(unsigned char level, const char *fmt, ...)
 		unsigned int slot;
 
 		slot = find_pid_slot(pid);
-		sprintf(child_prefix, "[child%u:%u]", slot, pid);
+		snprintf(child_prefix, sizeof(child_prefix), "[child%u:%u]", slot, pid);
 		prefix = child_prefix;
 	}
 
-- 
1.9.1
