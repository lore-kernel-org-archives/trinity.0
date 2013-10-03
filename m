From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] fixes arch selection parameter
Date: Thu, 3 Oct 2013 16:09:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1310031607440.6681@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=8+dnApLw5Sou86VzYpQYVrYCqIk6hBrs6udFji8tW/M=;
        b=Nb1brzCm9/zKyr9+UEKzwrW3LtYCqFM6jM5URNWUAhUmimxMO3DJ4RUW7pn45j7tZO
         hC6uGfsQtQHcwQLwo4yT6PMXzerAx9CMzg9BhRr9VudcG9hcEz9aew8Z/41un5fEG9L1
         tRkouNxlhGii66J8NMR/AAQLPdDFwyu12EkQr+wlJlHYggb4g11bzhwrQJ739mM0lG8F
         9ieMnNa/uxIILMTuZBolhNtsvc9CBeeer+nshaB9FZzY616jAthvJdVmT/Jp+PSwun6g
         fj86q8mPYywv5AkYZHitr18BywilgIXTTSiZh8BRIyiMEo9sfRy0Ntzygo5Rje8bgwyp
         IWPg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch fixes arch (-a) selection parameter when applied to all 
syscall.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 tables.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tables.c b/tables.c
index 1741723..fa7cb63 100644
--- a/tables.c
+++ b/tables.c
@@ -305,14 +305,16 @@ void mark_all_syscalls_active(void)
 
 	printf("Marking all syscalls as enabled.\n");
 	if (biarch == TRUE) {
-		for_each_32bit_syscall(i) {
-			syscalls_32bit[i].entry->flags |= ACTIVE;
-			activate_syscall32(i);
-		}
-		for_each_64bit_syscall(i) {
-			syscalls_64bit[i].entry->flags |= ACTIVE;
-			activate_syscall64(i);
-		}
+		if (do_32_arch)
+			for_each_32bit_syscall(i) {
+				syscalls_32bit[i].entry->flags |= ACTIVE;
+				activate_syscall32(i);
+			}
+		if (do_64_arch)
+			for_each_64bit_syscall(i) {
+				syscalls_64bit[i].entry->flags |= ACTIVE;
+				activate_syscall64(i);
+			}
 	} else {
 		for_each_syscall(i) {
 			syscalls[i].entry->flags |= ACTIVE;
-- 
1.8.4
