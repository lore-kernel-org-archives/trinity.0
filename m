From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] modify_ldt: initialize scratch
Date: Mon, 20 Jan 2014 21:15:35 +0100
Message-ID: <1390248935-22801-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, jirislaby@gmail.com

From: Jiri Slaby <jirislaby@gmail.com>

We store a pointer in the scratch area, but only conditionally. Hence
there can be an uninitialized value which causes problems in the
tear-down path:
*** Error in `trinity': double free or corruption (!prev):
0x0000000002484530 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x740af)[0x7f2a66eb60af]
/lib64/libc.so.6(+0x798de)[0x7f2a66ebb8de]
/lib64/libc.so.6(+0x7a5e6)[0x7f2a66ebc5e6]
trinity[0x40abc8]
trinity[0x40dabc]
trinity[0x40338a]
trinity[0x40704c]
trinity[0x402c47]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x7f2a66e63b15]
trinity[0x402f13]
---
 syscalls/modify_ldt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/syscalls/modify_ldt.c b/syscalls/modify_ldt.c
index de9cbbe..c0cac1a 100644
--- a/syscalls/modify_ldt.c
+++ b/syscalls/modify_ldt.c
@@ -18,6 +18,7 @@ static void sanitise_modify_ldt(int childno)
 	void *ldt;
 	//struct user_desc *desc;
 
+	shm->scratch[childno] = 0;
 	switch (shm->a1[childno]) {
 	case 0:
 		/* read the ldt into the memory pointed to by ptr.
-- 
1.8.5.2
