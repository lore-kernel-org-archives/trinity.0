From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 1/2] Fix child crash when disabling some syscalls on biarch
Date: Sat, 27 Jul 2013 17:35:15 +0300
Message-ID: <1374935716-26961-2-git-send-email-tt.rantala@gmail.com>
References: <1374935716-26961-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=WFuhLvy7xzJTH66BKoSoNGakN0U9MbG1gwhBJ7/zkFc=;
        b=djv4PHlBkDz3QmFCfgA1qGPZPJ4Lg2pCElS1NXQ6xXzJ/150LNZ6ugnhe8aYVmQce8
         CEFQDC+ZKHJQIOrD4SD1Zidh4wPgiFW/fwvAmaBVXMmLmLdXmHW32HbHfqxINv+aoDpo
         vUlSukweEtA6QgtKf/yLeyJD/5KqoL0CVn5fySQfZ7UAGi8s8vChOTKcPs40aqZfWgxL
         WIAxPSWJgP+kY98aUL2Vxq4fGwZA8X6GVfboTUBIr0c0HkpyiWKJ8nFx2PAIw1fxIWqu
         S3A+PDDNhjGlZCvFTA3RnsVpWhcVDMd7J7dSxWi5kMXBOhJJ8k0uxahI24+VGG/HIYVy
         +teA==
In-Reply-To: <1374935716-26961-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Check if search_syscall_table() fails and returns -1. This avoids
crashing the child processes, that I was seeing on x86-64 with the
msgrcv() syscall.
---
 syscall.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/syscall.c b/syscall.c
index dc93b64..866ac71 100644
--- a/syscall.c
+++ b/syscall.c
@@ -112,8 +112,8 @@ long mkcall(int childno)
 {
 	unsigned long olda1, olda2, olda3, olda4, olda5, olda6;
 	unsigned int call = shm->syscallno[childno];
-	unsigned int call32, call64;
 	unsigned long ret = 0;
+	int call32, call64;
 	int errno_saved;
 	char string[512], *sptr;
 
@@ -292,10 +292,12 @@ args_done:
 			syscalls[call].entry->flags &= ~ACTIVE;
 		} else {
 			call32 = search_syscall_table(syscalls_32bit, max_nr_32bit_syscalls, syscalls[call].entry->name);
-			syscalls_32bit[call32].entry->flags &= ~ACTIVE;
+			if (call32 != -1)
+				syscalls_32bit[call32].entry->flags &= ~ACTIVE;
+
 			call64 = search_syscall_table(syscalls_64bit, max_nr_64bit_syscalls, syscalls[call].entry->name);
-			syscalls_64bit[call64].entry->flags &= ~ACTIVE;
-			output(1, "Disabled syscalls 32bit:%d 64bit:%d\n", call32, call64);
+			if (call64 != -1)
+				syscalls_64bit[call64].entry->flags &= ~ACTIVE;
 		}
 	}
 
-- 
1.8.1.2
