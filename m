From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Reduce the number of pages allocated in copy_syscall_table
 function.
Date: Thu, 19 Sep 2013 15:52:11 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309191549380.12867@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=Hk74V7j9bU1813000nQALs4GueaQpBngpWg+ATejm/0=;
        b=X0AcK9Q0ziN86uPKZZ/jhnkVL4zQ4VJm9pJ3kCBVRuMOr/s+r/yS2Bsqd4WkmUYPeA
         FMmCEfXTC0Rq7J3zp8im4WwsiuS28YBoUk4OfL7QgmMy3vUZKA5N9o6/k0Ki2EliczMs
         8RSKAPNFUiJW7+A3UHQfjjlihmluXdVySgFNQD+kWpgT3Dir7Aq7ALI8Pn+lGv2mYJb0
         jZLIR+LckSaJ+2yIzxd3pfNwtcUYr+L4BJSdkpeH2O8PHpWUdukZ3jrA5gD18+HhJBo7
         Fo408UArEuZgV1EcaXlR4GzeArOWrnD5buWcPLfc8PXClfPGaHsGHOD8rG+st6g/+V0A
         v/Ng==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch reduces the number of pages allocated in the copy_syscall_table 
function. 

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 tables.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/tables.c b/tables.c
index 3c78ab9..306decc 100644
--- a/tables.c
+++ b/tables.c
@@ -509,17 +509,14 @@ static struct syscalltable * copy_syscall_table(struct syscalltable *from, unsig
 	unsigned int n;
 	struct syscall *copy;
 
-	/* FIXME: Use fewer shared maps.
-	 * It's pretty sad that we use a whole page just for a copy of that struct when we
-	 * could fit dozens of them in a page.  This would cut down our /proc/$$/maps a *lot*
-	 */
+	copy = alloc_shared(nr * sizeof(struct syscall));
+	if (copy == NULL)
+		exit(EXIT_FAILURE);
+
 	for (n = 0; n < nr; n++) {
-		copy = alloc_shared(sizeof(struct syscall));
-		if (copy == NULL)
-			exit(EXIT_FAILURE);
-		memcpy(copy, from[n].entry, sizeof(struct syscall));
-		copy->number = n;
-		from[n].entry = copy;
+		memcpy(copy + n , from[n].entry, sizeof(struct syscall));
+		copy[n].number = n;
+		from[n].entry = &copy[n];
 	}
 	return from;
 }
-- 
1.8.4
