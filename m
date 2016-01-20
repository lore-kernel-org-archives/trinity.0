From: Eric B Munson <emunson@akamai.com>
Subject: [PATCH] Add MCL_ONFAULT to mlockall calls
Date: Wed, 20 Jan 2016 14:51:12 -0500
Message-ID: <1453319472-8660-1-git-send-email-emunson@akamai.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; s=a1;
	t=1453319482; bh=QEXab0sARrt0LMpRcuVZjz60277gHXUS2NGOWPdMdg8=;
	l=1390; h=From:To:Cc:Date:From;
	b=QdVbRzbExiCysCTTF9pf25kuKNq0OeSb7rDULOA2Ybh0onUYyWx4OH1GEfKEG1Oj8
	 p2U5sG4/sWdqPPoe57AWit9hTm9+8sjSrkFL3pqclWNnTbPbsqw345aQp+646Rj/RV
	 03cmJphXF+An/HcF8IZINbuMHvjZEWQ2+AT9Diog=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Eric B Munson <emunson@akamai.com>, Dave Jones <davej@codemonkey.org.uk>

The new mlock2 system call was added, but it looks like the MCL_ONFAULT
flag was missed.  This is now a valid flag to pass to mlockall(), but it
must be used in conjunction with either MCL_CURRENT or MCL_FUTURE (or
both).  Also rework the way that the flags value for mlockall() is
caclulated.  It is valid to pass any combination of the MCL_* flags
except for MCL_ONFAULT alone.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
---
 syscalls/mlockall.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/syscalls/mlockall.c b/syscalls/mlockall.c
index 4485aa6..9c99424 100644
--- a/syscalls/mlockall.c
+++ b/syscalls/mlockall.c
@@ -10,20 +10,23 @@
 
 #define MCL_CURRENT     1
 #define MCL_FUTURE      2
+#define MCL_ONFAULT	4
 
 static void sanitise_mlockall(struct syscallrecord *rec)
 {
 	if (rec->a1 != 0)
 		return;
 
-	if (RAND_BOOL())
-		rec->a1 = MCL_CURRENT;
-	else
-		rec->a1 = MCL_FUTURE;
+	/*
+	 * There are two invalid bit patterns for MCL flags, 0, and MCL_ONFAULT
+	 * alone.  All other combinations should be valid.
+	 */
+	while (rec->a1 == 0 || rec->a1 == MCL_ONFAULT)
+		rec->a1 = (RAND_BYTE() & 0x07);
 }
 
 static unsigned long mlockall_flags[] = {
-	MCL_CURRENT, MCL_FUTURE,
+	MCL_CURRENT, MCL_FUTURE, MCL_ONFAULT,
 };
 
 struct syscallentry syscall_mlockall = {
-- 
1.9.1
