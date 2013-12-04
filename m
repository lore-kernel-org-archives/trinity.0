From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Fixes incorrect syscall indices for shmat and shmctl in
 X86_64 arch.
Date: Tue, 3 Dec 2013 16:44:46 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312031641330.30422@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=XS4loeT4q8KEwSNEmMWWYwqYvvei2s33C9fCqc8exhw=;
        b=h2+i1BElGss35XH2E5ESQ+5F86H0RKZ5jM5b9qfPnWf2vCQsMjm+M5SKOYc++yEYVj
         OksIIRVOoZDq7l5c+FQ+X+0DVc8+DjCuGw+VuB/Q4ju+XgPrQlmnx31bAW1KrY22KGUE
         0gbj2dP1JwOVwnjxdOIEnuWmSOZjSJXX0TpAzrHcDSsxqT6rTBLEiur2eZwJduX6AGKA
         Qs+fIr7vf8uMEjprVXTOqRPeODBowc4oajF2P53NzsKbaJDHEWDE/zFeiQ/o4SVgGsZj
         qtcf3xIS4X6hMhxEx+pkgM7gHGbKt2s/UDC2IHf3CP+v0rVPDhsEmm3IyimAt2n1mTfo
         z2fg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch fixes incorrect indices for shmat (should be #30) and shmctl 
(should be #31).

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/syscalls-x86_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/syscalls-x86_64.h b/include/syscalls-x86_64.h
index 9ceb65c..23c2166 100644
--- a/include/syscalls-x86_64.h
+++ b/include/syscalls-x86_64.h
@@ -38,8 +38,8 @@ struct syscalltable syscalls_x86_64[] = {
 	{ .entry = &syscall_mincore },
 	{ .entry = &syscall_madvise },
 	{ .entry = &syscall_shmget },
-	{ .entry = &syscall_shmctl },
 	{ .entry = &syscall_shmat },
+	{ .entry = &syscall_shmctl },
 	{ .entry = &syscall_dup },
 	{ .entry = &syscall_dup2 },
 	{ .entry = &syscall_pause },
-- 
1.8.4.1
